function test_stack

% Number of loadsteps
NumSteps=3;

% Tolerance of error
epsilon=1e-10;

Sigma_p=zeros(NumSteps,3);
Eps_int=zeros(NumSteps,3);

Sigma_p=[3 2 1; 4 3 2; 5 4 3];
Eps_int=[-1 -2 -3; -2 -3 -4; -3 -4 -5];


% Test for zero modes
NumModes=0;
sk = zeros(NumSteps, NumModes+1);
sk = [4+2i; 3-5i; i];

for tt=1:NumSteps
  vect_out_0(tt, :) = stack(sk(tt,:), Sigma_p(tt,:), Eps_int(tt,:));
end
vector_check = [4 2 3 2 1 -1 -2 -3; ...
                3 -5 4 3 2 -2 -3 -4; ...
                0 1 5 4 3 -3 -4 -5];
assert(allequal(vect_out_0, vector_check, epsilon), ...
       'Vector not properly stacked for NumModes=0');

% Test for two modes
NumModes = 2;
sk = zeros(NumSteps, NumModes+1);
sk = [4+2i 3-i 1+2i; 3-5i 0 2+6i; i -1-i 2+i];


for tt=1:NumSteps
  vect_out_2(tt, :) = stack(sk(tt,:), Sigma_p(tt,:), Eps_int(tt,:));
end

vector_check=[4 3 1 2 -1 2 3 2 1 -1 -2 -3; ...
             3 0 2 -5 0 6 4 3 2 -2 -3 -4; ...
             0 -1 2 1 -1 1 5 4 3 -3 -4 -5];
assert(allequal(vect_out_2, vector_check, epsilon), ...
       'Vector not properly stacked for NumModes=2');


