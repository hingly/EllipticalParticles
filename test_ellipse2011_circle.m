function test_ellipse2011_circle

epsilon = 1e-5;

% Chosen parameters for testing
c1 = 50;
c2 = 100;

material.sigmax = 1;
material.delopen = 1;
material.lambda_e = 0.1;
material.nu_m = 0.3;

geom.f = 0.4; 

loads.timesteps = 1;
loads.MinimumStrain = 0.005;

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

geom.NumPoints = 20;


% Write data to structure for JSON
data.material = material;
data.loads = loads;
data.geom = geom;
data.post = post;

% Write input file for testing
json = savejson('',data,'ellipse_circle_test.json');

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

figure(1);
plot(linexs, lineys,'b-');
hold on;

% Run code
[loads,displacement,cohesive,soln] =  ...
    ellipse2011('ellipse_circle_test.json');

xs=zeros(1,loads.timesteps);
ys=zeros(1,loads.timesteps);

lambda = cohesive.lambda(1,1)

for tt=1:loads.timesteps
  N1 = loads.Sigma_m(tt,1)
  N2 = loads.Sigma_m(tt,2)
  N3 = loads.Sigma_m(tt,3)
  
  assert(allequal(N1,N2,epsilon), ['N2 not equal to N1 for timestep ' ...
                   num2str(tt)]);
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
  
  xs(tt)=real(displacement.total(tt,1));
  ys(tt)=N1;  
 
end

  plot(xs, ys,'kx');
  epsilon2=1e-5;  
  distances = points_to_lines(xs, ys, linexs, lineys)
  assert(allequal(distances, zeros(size(distances)), epsilon), ...
         ['Incorrect displacement-force pair generated']);
  
  error('not finished yet');