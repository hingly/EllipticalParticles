function generate_cases

% generate input structures
base.geom.f = 0.4;

base.loads.MinimumStrain = 0.0002;
base.loads.NumRestarts = 2;
base.loads.SigmaBar1 = 1;  
base.loads.timesteps = 100;

base.material.cohscale = 1;
base.material.delopen = 1;
base.material.nu_m = 0.3;
base.material.plstrain = 1;
base.material.sigmax = 1;

setbase = base;
setbase.name = 'outer product of testing parameters';

setbase.geom.NumPoints = 100;
setbase.loads.NumModes = 50; 
s1 = structproduct(setbase, 'geom.c1', [20 50 100], ...
                            'geom.aspect', [1 2 5 10], ...
                            'material.c2', [100 200 500], ...
                            'material.lambda_e', [0.1 0.01 0.001], ...
                            'loads.SigmaBarRatio',  [-1 -0.5 0 0.5 1.0], ...
                            'loads.AppliedLoadAngle',  [0 5 10 15 20 25 30]*pi/180);


setbase = base;
setbase.name = 'Convergence testing on NumPoints and NumModes';

setbase.geom.aspect = 2;
setbase.material.c2 = 100;
setbase.material.lambda_e = 0.01;
setbase.loads.SigmaBarRatio = 0;
s2 = structproduct(setbase, 'geom.c1', [20 50], ...
                            'geom.NumPoints', [100 200 500 1000], ...
                            'loads.AppliedLoadAngle',  [0 30]*pi/180, ...
                            'loads.NumModes', [20 50 100]);


setbase = base;
setbase.name = 'Effect of aspect ratio and particle size';
                         
setbase.geom.NumPoints = 100;
setbase.material.c2 = 100;
setbase.material.lambda_e = 0.01;
setbase.loads.SigmaBarRatio = 0;
setbase.loads.AppliedLoadAngle = 0*pi/180;
setbase.loads.NumModes = 50;
s3 = structproduct(setbase, 'geom.c1', [20 50 100], ...
                            'geom.aspect', [1 2 5 10]);



s = [s1 s2 s3];

% prune out invalid results
valids = arrayfun(@valid_input, s);

% write them to corresponding file names
for c = s(valids)
  filename = generate_case_filename(c);
  flist = fopen(c.name + '.filelist', 'a');
  %write_input(c, generate_case_filename(c));
  disp([c.name ': ' filename]);
  fprintf(flist, filename);
  fclose(flist)
end




% Chosen parameters for testing


for c1 = c1list
  for c2 = c2list
    for f = flist      
      for angle = anglelist       
        for ratio = ratiolist
          for aspect = aspectlist
            for lambda = lambdalist

              

              % Proportional parameters
              R = geom.c1*material.delopen;
              geom.a = R;
              geom.b = R/geom.aspect;
              material.E_m = material.c2*material.sigmax;
              loads.LoadFactor = loads.timesteps;
              

              
            end
          end
        end
      end
    end
  end
end