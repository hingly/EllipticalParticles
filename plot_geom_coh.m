function plot_geom_coh(struct, f, scale, scalecoh)

close all;
ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;
ffxy = struct.step.displacement.farfield_xy;
lambda = struct.step.cohesive.lambda_xy;
beta = struct.geom.beta;

xy1=exp(i*beta);

if ~exist('scale', 'var')
  scale = 1;
end

if ~exist('scalecoh', 'var')
  scalecoh = 1;
end



figure(f)
axis equal;
%axis([-100 100 -100 100])
hold on;
closedellipse = [ellipse ellipse(1)];
closeddispxy = [dispxy dispxy(1)];
deformed = closedellipse + scale*closeddispxy;
plot(closedellipse, 'b', 'Linewidth', 2);
plot(deformed,'r')

figure(f+1)
axis equal;
%axis([-100 100 -100 100])
hold on;
closedellipse = [ellipse ellipse(1)];
closedlambda = [lambda lambda(1)];
closedxy1 = [xy1 xy1(1)];
lambdaplot = closedellipse + scalecoh*closedlambda;
xyplot = closedellipse + scalecoh*closedxy1;
plot(closedellipse, 'b', 'Linewidth', 2);
plot(xyplot,'r', 'Linewidth', 1);
plot(lambdaplot, 'k', 'Linewidth', 2);

% figure(2);
% axis equal;
% hold on;
% closedellipse = [ellipse ellipse(1)];
% closedffxy = [ffxy ffxy(1)];
% deformed = closedellipse + scale*closedffxy;
% plot(deformed,'r')
% plot(closedellipse, 'b', 'Linewidth', 2);
% plot(deformed,'r')
% legend('Undeformed shape', 'Deformed shape','Location', 'NorthWest')
% xlabel('x')
% ylabel('y')