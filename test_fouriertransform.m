function test_fouriertransform

% input
NumPoints = 24;
NumModes = 20;

epsilon = 1e-10;
epsilon2 = 1e-4;

theta = linspace(0,2*pi, NumPoints+1);
theta = theta(1:NumPoints);

% Constant force should give one mode
force = ones(1,NumPoints);

sk = fouriertransform(force, theta, NumModes);

sk_check = zeros(1, NumModes + 1);
sk_check(NumModes/2+1) = 1;

assert(allequal(sk, sk_check, epsilon), ...
       'Constant real force should return 1 non-zero mode only');

force = i*ones(1,NumPoints);

sk = fouriertransform(force, theta, NumModes);

sk_check = zeros(1,NumModes + 1);
sk_check(NumModes/2 + 1) = i;

assert(allequal(sk, sk_check, epsilon), ...
       'Constant complex force should return 1 non-zero mode only');

% Real step force

force=[1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0];

sk = fouriertransform(force, theta, NumModes);
a = 1/2;
b = (1 - (2 + sqrt(3))*i)/12;
c = (1 - i)/12;
d = (1 - (2 - sqrt(3))*i)/12;
e = (1 + (2 - sqrt(3))*i)/12;
f = (1 + i)/12;
sk_check=[0 conj(f) 0 conj(e) 0 conj(d) 0 conj(c) 0 conj(b) a b 0 c 0 d 0 e 0 f 0];
assert(allequal(sk, sk_check, epsilon2), ...
       'Real step force not transformed correctly');


% Complex step force

force=i*[1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0];

sk = fouriertransform(force, theta, NumModes);
a=i/2;
b=((2 + sqrt(3)) + i)/12;
c=(1 + i)/12;
d=((2 - sqrt(3)) + i)/12;
e = (-2 + sqrt(3) + i)/12;
f = (-1 + i)/12;
sk_check=[0 -conj(f) 0 -conj(e) 0 -conj(d) 0 -conj(c) 0 -conj(b) a b 0 c 0 d 0 e 0 f 0];
assert(allequal(sk, sk_check, epsilon2), ...
       'Complex step force not transformed correctly');




