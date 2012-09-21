function test_ellipse2011_circle


epsilon = 1e-5;

c1 = 50;
c2 = 100;
NumPoints = 100;
lambda_e = 0.1;
delopen = 1;
R = c1*delopen;
sigmax = 1;
E = c2*sigmax;
nu = 0.3;
kappa = 3+4*nu;
mu = E/(2*(1+nu));


pointsvector=ones(1,NumPoints);

% Create u-N curve for comparison
N1a = (4*mu*lambda_e*delopen + 2*R*sigmax)/(R*(kappa+1));
N1b = (4*mu*delopen)/(R*(kappa+1));
N1c = 2*N1b;
lineys = [0 N1a N1b N1c];
linexs = [0 lambda_e*delopen delopen delopen*2];

%figure(1);
%plot(linexs, lineys,'b-');
%hold on;

[loads,displacement,cohesive,soln] =  ...
    ellipse2011('ellipse_circle_test.json');

xs=zeros(1,loads.timesteps);
ys=zeros(1,loads.timesteps);
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
                      'for timestep ' num2str(tt)]);
  assert(allequal(imag(displacement.farfield(tt,:)), zerovec, epsilon), ...
                  ['Farfield displacement not correct for timestep ' ...
                   num2str(tt)]);
  
  xs(tt)=real(displacement.total(tt,1));
  ys(tt)=N1;  
 
end
 % plot(xs, ys,'rx');
  epsilon2=1e-5;  
  distances = points_to_lines(xs, ys, linexs, lineys)
  assert(allequal(distances, zeros(size(distances)), epsilon), ...
         ['Incorrect pair displacement-force pair generated']);
  
  error('not finished yet');