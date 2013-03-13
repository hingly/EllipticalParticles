function circle_testing_100


epsilon = 1e-5;

% -------------------------
%        INPUT
%==========================

% Required parameters
material.plstrain = 1;
material.cohscale = 1;

post.scale = 1;

loads.NumModes = 40;
loads.NumRestarts = 10;

geom.NumPoints = 100;


% Chosen parameters for testing
c1list = [100];
%c2list = [100 200 500];
c2list = [100];
%flist = [0.1 0.2 0.3 0.4 0.5]; 
flist = [0.4];
aspectlist = [1];
ratiolist = [-1];
%anglelist = [0 15 30 45 60 75]*pi/180;
anglelist = [0];
lambdalist = [0.01];

for c1 = c1list
  for c2 = c2list
    for f = flist      
      for angle = anglelist       
        for ratio = ratiolist
          for aspect = aspectlist
            for lambda = lambdalist

              
              if abs(ratio) < epsilon
                rationame = 'uni';
              elseif abs(ratio - 0.5) < epsilon
                rationame = 'half';
              elseif abs(ratio - 1) < epsilon
                rationame = 'equi';
              elseif abs(ratio + 0.5) < epsilon
                rationame = 'neghalf';
              elseif abs(ratio + 1) < epsilon
                rationame = 'shear';  
              end
              
              loads.SigmaBarRatio = ratio;
              loads.AppliedLoadAngle = angle;
              
              material.sigmax = 1;
              material.delopen = 1;
              material.lambda_e = lambda;
              material.nu_m = 0.3;

              geom.f = f; 

              loads.timesteps = 191;
              loads.MinimumStrain = 0.001;

              % Proportional parameters
              R = c1*material.delopen;
              geom.a = R;
              geom.b = R/aspect;
              material.E_m = c2*material.sigmax;
              loads.LoadFactor = 20;
              
              loads.SigmaBar1 = 1;  
              
              inputdata.loads = loads;
              inputdata.material = material;
              inputdata.geom = geom;
              inputdata.post = post;

              filename = strcat(['Ellipse_run/ellipse_c1_' num2str(c1) ...
                                 '_c2_' num2str(c2) '_f_' num2str(f*100) ...
                                 '_angle_' num2str(angle) '_aspect_' ...
                                 num2str(aspect) '_lambda_e_' num2str(lambda*1000) '_ratio_' ...
                                 rationame])
              
              jsonname = strcat([filename '.json']);
              json = savejson('',inputdata,jsonname);
              
              ellipse2011(filename);
              
              
            end
          end
        end
      end
    end
  end
end
