function test_principal

epsilon1=1e-10;
epsilon2=1e-3;

s11=[0 1  1 -1 -1  1  1 -1 -1  1  1 -1 -1  1  0  1  0];
s22=[0 1 -1  1 -1  1 -1  1 -1  1 -1  1 -1  0  1  0  1];
s12=[1 0  0  0  0 -1 -1 -1 -1  1  1  1  1  1  1 -1 -1];

for ii=1:length(s11)
  [S1(ii), S2(ii), alpha(ii)] = principal(s11(ii), s22(ii), s12(ii));
end


S1_check=[1 1 1 1 -1 2 sqrt(2) sqrt(2) 0 2 sqrt(2) sqrt(2) 0 ...
          (1+sqrt(5))/2 (1+sqrt(5))/2 (1+sqrt(5))/2 (1+sqrt(5))/2];
S2_check=[-1 1 -1 -1 -1 0 -sqrt(2) -sqrt(2) -2 0 -sqrt(2) -sqrt(2) ...
          -2 (1-sqrt(5))/2 (1-sqrt(5))/2 (1-sqrt(5))/2 (1-sqrt(5))/2];
alpha_check=[pi/4 0 0 pi/2 0 -pi/4 -pi/8 -3*pi/8 -pi/4 pi/4 pi/8 ...
            3*pi/8 pi/4 0.553 1.017 -0.553 -1.017];

assert(allequal(S1, S1_check, epsilon1), ...
       'S1 is not calculated correctly');

assert(allequal(S2, S2_check, epsilon1), ...
       'S1 is not calculated correctly');

assert(allequal(alpha, alpha_check, epsilon2), ...
       'alpha is not calculated correctly');
