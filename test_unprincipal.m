function test_unprincipal

epsilon=1e-5;
alpha=[0  pi/8 pi/4 3*pi/8 pi/2 5*pi/8 3*pi/4 7*pi/8 pi -pi/8 -pi/4  ...
       -3*pi/8 -pi/2 -5*pi/8 -3*pi/4 -7*pi/8 -pi];
a=0.14645;
b=0.85355;
c=0.35355;


% Test for S1=1, S2=0
S1=1;
S2=0;

for ii=1:length(alpha)
  [s11(ii), s22(ii), s12(ii)] = unprincipal(S1, S2, alpha(ii));
end

s11_check=[1  b  0.5  a  0  a  0.5  b  1  b  0.5 ...
            a  0  a  0.5  b  1];
s22_check=[0  a  0.5  b  1  b  0.5  a  0  a  0.5 ...
            b  1  b  0.5  a  0];
s12_check=[0  c  0.5  c  0 -c -0.5 -c  0 -c -0.5 ...
           -c  0  c  0.5  c  0];

assert(allequal(s11, s11_check, epsilon), ...
       's11 is not calculating correctly --- s1=1, s2=0');
assert(allequal(s22, s22_check, epsilon), ...
       's22 is not calculating correctly --- s1=1, s2=0');
assert(allequal(s12, s12_check, epsilon), ...
       's12 is not calculating correctly --- s1=1, s2=0');


% Test for S1=1, S2=1
S1=1;
S2=1;

for ii=1:length(alpha)
  [s11(ii), s22(ii), s12(ii)] = unprincipal(S1, S2, alpha(ii));
end

s11_check=[1  1  1  1  1  1  1  1  1  1  1 ...
            1  1  1  1  1  1];
s22_check=[1  1  1  1  1  1  1  1  1  1  1 ...
            1  1  1  1  1  1];
s12_check=[0  0  0  0  0  0  0  0  0  0  0 ...
            0  0  0  0  0  0];

assert(allequal(s11, s11_check, epsilon), ...
       's11 is not calculating correctly --- s1=1, s2=1');
assert(allequal(s22, s22_check, epsilon), ...
       's22 is not calculating correctly --- s1=1, s2=1');
assert(allequal(s12, s12_check, epsilon), ...
       's12 is not calculating correctly --- s1=1, s2=1');

% Test for S1=0, S2=1
S1=0;
S2=1;

for ii=1:length(alpha)
  [s11(ii), s22(ii), s12(ii)] = unprincipal(S1, S2, alpha(ii));
end


s11_check=[0  a  0.5  b  1  b  0.5  a  0  a  0.5 ...
            b  1  b  0.5  a  0];
s22_check=[1  b  0.5  a  0  a  0.5  b  1  b  0.5 ...
            a  0  a  0.5  b  1];
s12_check=[0 -c -0.5 -c  0  c  0.5  c  0  c  0.5 ...
            c  0 -c -0.5 -c  0];

assert(allequal(s11, s11_check, epsilon), ...
       's11 is not calculating correctly --- s1=0, s2=1');
assert(allequal(s22, s22_check, epsilon), ...
       's22 is not calculating correctly --- s1=0, s2=1');
assert(allequal(s12, s12_check, epsilon), ...
       's12 is not calculating correctly --- s1=0, s2=1');

