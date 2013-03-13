function plot_deformed(struct, f, scale)

ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;

if ~exist('scale', 'var')
  scale = 1;
end

ffxy = struct.step.displacement.farfield_xy;


figure(f);
closedellipse = [ellipse ellipse(1)];
closeddispxy = [dispxy dispxy(1)];
deformed = closedellipse + scale*closeddispxy;
plot(deformed,'r')



%figure(2);
%closedellipse = [ellipse ellipse(1)];
%closedffxy = [ffxy ffxy(1)];
%deformed = closedellipse + scale*closedffxy;
%plot(deformed,'r')
