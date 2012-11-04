function plot_geom(struct, scale)

ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;
ffxy = struct.step.displacement.farfield_xy;


if ~exist('scale', 'var')
  scale = 1;
end



figure(1)
axis equal;
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
% %title('Deformation of ellipse under far-field loading: N1=10, N2=5, omega=pi/3')
% legend('Undeformed shape', 'Deformed shape','Location', 'NorthWest')
% xlabel('x')
% ylabel('y')