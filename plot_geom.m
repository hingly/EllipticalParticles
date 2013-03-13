function plot_geom(struct, f, scale)

ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;
ffxy = struct.step.displacement.farfield_xy;


if ~exist('scale', 'var')
  scale = 1;
end



figure(f)
axis equal;
axis([-50 50 -50 50])
hold on;
closedellipse = [ellipse ellipse(1)];
closeddispxy = [dispxy dispxy(1)];
deformed = closedellipse + scale*closeddispxy;
plot(closedellipse, 'b', 'Linewidth', 2);
plot(deformed,'r')




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