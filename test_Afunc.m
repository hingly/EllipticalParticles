function test_Afunc

epsilon = 1e-10;
thetalist = [0 pi/10 pi/7 pi/5 pi/3 pi/2 3*pi/4];

% For a circle
m = 0;

for theta = thetalist
  [A1, A2] = Afunc(m, theta);
  assert(A1==1, ['A1 not calculated correctly for m = ' num2str(m) ...
                 ' and theta = ' num2str(theta)]);
  A2_check=exp(i*theta);
  assert(allequal(A2, A2_check, epsilon), ...
         ['A2 not calculated correctly for m = ' num2str(m) ...
          ' and theta = ' num2str(theta)]);
end

% for another shape

error('not finished yet');