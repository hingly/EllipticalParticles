function test_Afunc_ellipse

epsilon = 1e-10;
thetalist = [0 pi/10 pi/7 pi/5 pi/3 pi/2 3*pi/4];

% For a line
m = 1;

for theta = thetalist

  if sin(theta) > epsilon

    [A1, A2] = Afunc(m, theta);
  

    A1check = (1 - exp(2*i*theta))/(2*sin(theta));
  
    assert(allequal(A1, A1check, epsilon), ...
           ['A1 not calculated correctly for m = ' num2str(m) ...
            ' and theta = ' num2str(theta)]);
    A2_check=2*cos(theta)/(1 - exp(2*i*theta));
    assert(allequal(A2, A2_check, epsilon), ...
           ['A2 not calculated correctly for m = ' num2str(m) ...
            ' and theta = ' num2str(theta)]);
    
  end
  
end

% Intermediate
m = 1/2;

for theta = thetalist
  [A1, A2] = Afunc(m, theta);
  
  A1check = (2 - exp(2*i*theta))/sqrt(5 - 4*cos(2*theta));
  
  assert(allequal(A1, A1check, epsilon), ...
         ['A1 not calculated correctly for m = ' num2str(m) ...
          ' and theta = ' num2str(theta)]);
  
  A2_check=(2*exp(i*theta)+ exp(-i*theta))/(2 - exp(2*i*theta));
  assert(allequal(A2, A2_check, epsilon), ...
         ['A2 not calculated correctly for m = ' num2str(m) ...
          ' and theta = ' num2str(theta)]);
end

