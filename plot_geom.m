function plot_geom(struct)

ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;
scale = struct.post.scale;


figure(1)
axis equal;
hold on;
closedellipse = [ellipse ellipse(1)];
closeddispxy = [dispxy dispxy(1)];
deformed = closedellipse + scale*closeddispxy;
plot(closedellipse, 'b', 'Linewidth', 2);
plot(deformed,'r')
%title('Deformation of ellipse under far-field loading: N1=10, N2=5, omega=pi/3')
legend('Undeformed shape', 'Deformed shape','Location', 'NorthWest')
xlabel('x')
ylabel('y')

