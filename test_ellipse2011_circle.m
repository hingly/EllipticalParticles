function test_ellipse2011_circle

epsilon = 1e-5;
plotflag = true;

% -------------------------
%        INPUT
%==========================

% Chosen parameters for testing
c1list = [50]
%c1list = [20 50 100];
c2list = [100];
flist = [0.4];


for c1 = c1list
  for c2 = c2list
    for f = flist
      
      disp(['geometry ratio = ' num2str(c1) ' material ratio = ' ...
            num2str(c2) ' volume fraction = ' num2str(f)]);
      
      material.sigmax = 1;
      material.delopen = 1;
      material.lambda_e = 0.1;
      material.nu_m = 0.3;
      
      geom.f = f;

      loads.timesteps = 10;
      loads.MinimumStrain = 0.001;
      
      % Proportional parameters
      R = c1*material.delopen;
      geom.a = R;
      geom.b = R;
      material.E_m = c2*material.sigmax;
      loads.LoadFactor = loads.timesteps;

      % Required parameters
      material.plstrain = 1;
      material.cohscale = 1;

      post.scale = 1;

      loads.SigmaBarRatio = 1;
      loads.AppliedLoadAngle = 0;
      loads.NumModes = 10;
      loads.NumRestarts = 2;

      geom.NumPoints = 20;


      % Write data to structure for JSON
      data.material = material;
      data.loads = loads;
      data.geom = geom;
      data.post = post;

      % Write input file for testing
      json = savejson('',data,'ellipse_circle_test.json');


      %----------------------------------
      %    PRE-PROCESSING
      %==================================

      % Simplified data for check quantities
      E = material.E_m;
      nu = material.nu_m;                        
      kappa = 3+4*nu;
      mu = E/(2*(1+nu));
      delopen = material.delopen;
      sigmax = material.sigmax;
      lambda_e = material.lambda_e;

      pointsvector=ones(1,geom.NumPoints);

      % Create u-N curve for comparison
      N1a = (4*mu*lambda_e*delopen + 2*R*sigmax)/(R*(kappa+1));
      N1b = (4*mu*delopen)/(R*(kappa+1));
      N1c = 2*N1b;
      lineys = [0 N1a N1b N1c];
      linexs = [0 lambda_e*delopen delopen delopen*2];

      if plotflag
        figure(1);
        plot(linexs, lineys,'b-');
        hold on;
      end

      %-----------------------------
      %      RUN CODE
      %=============================

      ellipse2011('ellipse_circle_test.json');

      %-----------------------------
      %    POST-PROCESSING
      %=============================


      output = loadjson('ellipse_circle_test_output.json');
      
      cohesive = output.cohesive;
      loads = output.loads;
      macro_var = output.macro_var;
      displacement = output.displacement;
      potential = output.potential;
      percentage = output.percentage;
      soln = output.soln;
      material = output.material;
      geom = output.geom;
      
      

      xs = zeros(1,loads.timesteps);
      ys = zeros(1,loads.timesteps);
      Tn = zeros(1,loads.timesteps);
      checkstrain = zeros(1,loads.timesteps);

      lambda = cohesive.lambda(:,1);

      for tt=1:loads.timesteps
        
        %----------------------------------------------
        % Check displacement due to far-field loading
        %==============================================
        
        N1 = macro_var.Sigma_m(tt,1);
        N2 = macro_var.Sigma_m(tt,2);
        N3 = macro_var.Sigma_m(tt,3);
        
        assert(allequal(N1,N2,epsilon), ['N2 not equal to N1 for timestep ' ...
                            num2str(tt) ', N1 = ' num2str(N1) ' N2 = ' ...
                            num2str(N2) ' f = ' num2str(geom.f)  ...
                            ' c1 = ' num2str(c1) ' c2 = ' num2str(c2)]);
        assert(N3<epsilon, ['N3 not equal to zero for timestep ' num2str(tt)]); 
        
        
        farfieldcheck = R*N1*(kappa + 1)/(4*mu);
        farfieldcheck = farfieldcheck*pointsvector;
        zerovec = 0*pointsvector;
        
        assert(allequal(real(displacement.farfield(tt,:)), farfieldcheck, ...
                        epsilon), ['Farfield displacement not correct ' ...
                            'for timestep ' num2str(tt) ' --- calculated ' ...
                            'farfield displacement of ' num2str(real(displacement.farfield(tt,1))) ...
                            ' vs check displacement of ' num2str(farfieldcheck(1)) ]);
        assert(allequal(imag(displacement.farfield(tt,:)), zerovec, epsilon), ...
               ['Farfield displacement not correct for timestep ' ...
                num2str(tt) ' --- calculated farfield shear displacement of '...
                num2str(imag(displacement.farfield(tt,1))) ...
                ' vs check displacement of 0']);
        
        % Calculate Tn for known displacement and lambda
        if lambda(tt) <= material.lambda_e
          Tn(tt) = material.sigmax/(material.lambda_e * material.delopen) ...
                   * real(displacement.total(tt,1));
        elseif lambda(tt) <= 1
          Tn(tt) = material.sigmax/(1-material.lambda_e)...
                   *(1 - real(displacement.total(tt,1))/material.delopen);
        else
          Tn(tt) = 0;
        end
        
        
        % Compare Tn with calculated traction
        assert(allequal(real(cohesive.traction(tt,1)), Tn(tt), epsilon), ...
               ['Incorrect traction calculated --- we have ' ...
                num2str(real(cohesive.traction(tt,1))) ' instead of ' ...
                num2str(Tn(tt)) ' for timestep ' num2str(tt)]);
        
        %---------------------------------------------
        % Check that Fourier modes are correct
        %=============================================
        
        
        for jj=1:loads.NumModes+1
          modenum = 2*(jj - 1) - loads.NumModes;
          if modenum~=0
            assert(soln.sk(tt,jj) < epsilon, ['All modes other than s_0 ' ...
                                'should be zero.  We have s_' num2str(jj) ...
                                ' = ' num2str(soln.sk(tt,jj)) ' for timestep ' ...
                                num2str(tt)])
          else
            assert(allequal(soln.sk(tt,jj), Tn(tt), epsilon), ['s_0 should ' ...
                                'be equal to Tn.  We have s_0 = ' ...
                                num2str(soln.sk(tt,jj)) ' and Tn = ' ...
                                num2str(Tn(tt)) ' for timestep ' num2str(tt)])
          end
        end
        
        
        
        % Prepare for u-N curve
        xs(tt)=real(displacement.total(tt,1));
        ys(tt)=N1;  
        
        
        %---------------------------------------
        %    CHECK FOR STRAIN
        %======================================
        
        checkstrain(tt) = (1 + nu)*(1 - 2*nu)/E*(1 - geom.f)*N1 + ...
            geom.f/R*real(displacement.total(tt,1));
        
        assert(allequal(checkstrain(tt), macro_var.MacroStrain(tt,1), epsilon), ...
               ['Macroscopic strain is not calculated correctly.  Should ' ...
                'have e_11 = ' num2str(checkstrain(tt)) ' but calculated ' ...
                'strain is ' num2str(macro_var.MacroStrain(tt,1)) ...
                ' for timestep ' num2str(tt)]); 
        
      end

      %--------------------------------------------
      % Check that points lie on correct u-N curve
      %============================================
      if plotflag
        plot(xs, ys,'kx');
      end
      
      epsilon2=1e-5;  
      distances = points_to_lines(xs, ys, linexs, lineys);
      assert(allequal(distances, zeros(size(distances)), epsilon), ...
             ['Incorrect displacement-force pair generated']);
      
    end
  end  
end
