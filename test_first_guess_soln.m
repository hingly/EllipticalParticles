function test_first_guess_soln

% Input variables
epsilon = 1e-10;

loads.timesteps = 2;
loads.NumModes = 2;
loads.DriverStrain = [1 2];

material.E_m = 100;
material.nu_m = 0.3;

geom.a = 1;

zero_timestep_matrix = zeros(loads.timesteps,3);
zero_timestep_modes=zeros(loads.timesteps, loads.NumModes+1);

soln.sk=zero_timestep_modes;          
soln.Sigma_p=zero_timestep_matrix;         
soln.Eps_int=zero_timestep_matrix;  

tt = 1;

% Case of uniaxial tension s11
testcase = 1;
loads.SigBar_xy = [1 0 0];

loads.StressRatio_22 = loads.SigBar_xy(2)/loads.SigBar_xy(1);
loads.StressRatio_12 = loads.SigBar_xy(3)/loads.SigBar_xy(1);

soln = first_guess_soln(loads, material, geom, soln);

sigmapcheck = [100 0 0];
epsintcheck = [1 0 0];

assert(allequal(geom.a/10, soln.sk(1,1),epsilon),...
       ['sk is not scaled correctly']);

assert(allequal(sigmapcheck, soln.Sigma_p(tt,:), epsilon),...
       ['Sigma_p is not correct for testcase ' num2str(testcase)]);

assert(allequal(epsintcheck, soln.Eps_int(tt,:), epsilon),...
       ['Eps_int is not correct for testcase ' num2str(testcase)]);


% Testcase of uniaxial tension s22
testcase = 2;
loads.SigBar_xy = [0 1 0];

loads.StressRatio_12_22 = loads.SigBar_xy(3)/ ...
        loads.SigBar_xy(2);

soln = first_guess_soln(loads, material, geom, soln);

sigmapcheck = [0 -1000/3.9 0];
epsintcheck = [1 -7/3 0];

assert(allequal(sigmapcheck, soln.Sigma_p(tt,:), epsilon),...
       ['Sigma_p is not correct for testcase ' num2str(testcase)]);

assert(allequal(epsintcheck, soln.Eps_int(tt,:), epsilon),...
       ['Eps_int is not correct for testcase ' num2str(testcase)]);



% Testcase of biaxial tension s11 s22
testcase = 3;
loads.SigBar_xy = [1 0.5 0];

loads.StressRatio_22 = loads.SigBar_xy(2)/loads.SigBar_xy(1);
loads.StressRatio_12 = loads.SigBar_xy(3)/loads.SigBar_xy(1);


soln = first_guess_soln(loads, material, geom, soln);

sigmapcheck = [100 50 0];
epsintcheck = [1 0.5 0];

assert(allequal(sigmapcheck, soln.Sigma_p(tt,:), epsilon),...
       ['Sigma_p is not correct for testcase ' num2str(testcase)]);

assert(allequal(epsintcheck, soln.Eps_int(tt,:), epsilon),...
       ['Eps_int is not correct for testcase ' num2str(testcase)]);



% Testcase of general loading
testcase = 4;
loads.SigBar_xy = [1 -0.5 1];

loads.StressRatio_22 = loads.SigBar_xy(2)/loads.SigBar_xy(1);
loads.StressRatio_12 = loads.SigBar_xy(3)/loads.SigBar_xy(1);

soln = first_guess_soln(loads, material, geom, soln);

sigmapcheck = [100 -50 100];
epsintcheck = [1 -0.5 1];

assert(allequal(sigmapcheck, soln.Sigma_p(tt,:), epsilon),...
       ['Sigma_p is not correct for testcase ' num2str(testcase)]);

assert(allequal(epsintcheck, soln.Eps_int(tt,:), epsilon),...
       ['Eps_int is not correct for testcase ' num2str(testcase)]);


% Testcase of general loading s11 = 0 
testcase = 5;
loads.SigBar_xy = [0 1 -1];

loads.StressRatio_12_22 = loads.SigBar_xy(3)/ ...
        loads.SigBar_xy(2);

soln = first_guess_soln(loads, material, geom, soln);

sigmapcheck = [0 -1000/3.9 1000/3.9];
epsintcheck = [1 -7/3 7/3];

assert(allequal(sigmapcheck, soln.Sigma_p(tt,:), epsilon),...
       ['Sigma_p is not correct for testcase ' num2str(testcase)]);
 
assert(allequal(epsintcheck, soln.Eps_int(tt,:), epsilon),...
       ['Eps_int is not correct for testcase ' num2str(testcase)]);



