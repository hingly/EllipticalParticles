function plot_deformed(struct)

ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;
scale = struct.post.scale;

figure(1);
closedellipse = [ellipse ellipse(1)];
closeddispxy = [dispxy dispxy(1)];
deformed = closedellipse + scale*closeddispxy;
plot(deformed,'r')
%title('Deformation of ellipse under far-field loading: N1=10, N2=5, omega=pi/3')

