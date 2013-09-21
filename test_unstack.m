function test_unstack

% Number of loadsteps
NumSteps = 3;

% Tolerance of error
epsilon = 1e-10;

struct_out_0.Sigma_p=zeros(NumSteps, 3);
struct_out_2.Sigma_p=zeros(NumSteps, 3);
struct_check.Sigma_p = [3 2 1 ; 4 3 2 ; 5 4 3 ];
struct_check.Eps_int = [-1 -2 -3; -2 -3 -4; -3 -4 -5];

% Test for zero modes
NumModes = 0;
vector_in = [4 2 3 2 1  -1 -2 -3; ...
                3 -5 4 3 2  -2 -3 -4; ...
                0 1 5 4 3  -3 -4 -5];
struct_check.sk = [4+2i; 3-5i; i];

for tt=1:NumSteps
  struct_out_0 = unstack(vector_in(tt,:), NumModes, tt, struct_out_0);
end


assert(allequal(struct_check.Sigma_p, struct_out_0.Sigma_p,epsilon), ...
       'Sigma_p not unstacked correctly for NumModes=0');
assert(allequal(struct_check.Eps_int, struct_out_0.Eps_int,epsilon), ...
       'Sigma_p not unstacked correctly for NumModes=0');
assert(allequal(struct_check.sk, struct_out_0.sk,epsilon), ...
       'Sigma_p not unstacked correctly for NumModes=0');


% Test for two modes
NumModes = 2;
vector_in=[4 3 1 2 -1 2 3 2  1 -1 -2 -3; ...
             3 0 2 -5 0 6 4 3 2 -2 -3 -4; ...
             0 -1 2 1 -1 1 5 4 3 -3 -4 -5];
struct_check.sk =[4+2i 3-i 1+2i; 3-5i 0 2+6i; i -1-i 2+i];

for tt=1:NumSteps
  struct_out_2 = unstack(vector_in(tt,:), NumModes, tt, struct_out_2);
end


assert(allequal(struct_check.Sigma_p, struct_out_2.Sigma_p,epsilon), ...
       'Sigma_p not unstacked correctly for NumModes=2');
assert(allequal(struct_check.Eps_int, struct_out_2.Eps_int,epsilon), ...
       'Sigma_p not unstacked correctly for NumModes=2');
assert(allequal(struct_check.sk, struct_out_2.sk,epsilon), ...
       'Sigma_p not unstacked correctly for NumModes=2');
