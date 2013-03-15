function percentage = calculate_percentages(geom, material, cohesive, displacement)

epsilon = 1e-10;

% Calculate percentages per integration point and per length of interface
R = geom.R;
m = geom.m; 
NumPoints = geom.NumPoints;
theta = geom.theta;

lambda_e = material.lambda_e;
lambda_max = cohesive.lambda_max;
loading = cohesive.loading;

U=real(displacement.total);


% incremental angle
dtheta=2*pi/NumPoints;          

%conversion from incremental angle to incremental length on circumference
dS = R*dtheta*sqrt(1 - 2*m*cos(2*theta)+m^2);  
total_length = sum(dS);
fract_dS = dS/total_length*100;
fract_pct = 100/NumPoints;

% Function to count elements which satisfy condition
count = @(condition) [sum(condition)*fract_pct, sum(fract_dS(condition))];

% Check that there are no bad lambdas
assert(~any(lambda_max < 0), 'Bad lambda_max!');

% Calculate the percentages
percentage.undamaged = count(lambda_max >= 0 & lambda_max <= lambda_e);
percentage.damaged = count(lambda_max > lambda_e & lambda_max < 1);
percentage.failed = count(lambda_max >= 1);
percentage.unloading = count(~loading);
percentage.compression = count(U < 0);

total_damage = percentage.undamaged + percentage.damaged + ...
    percentage.failed;
damage_compare = [100 100];

assert(allequal(total_damage,damage_compare,epsilon), ...
       'Damage percentages do not add up to total of 1 / total_length');
