function plot_deformed(struct)

ellipse = struct.geom.ellipse;
dispxy = struct.step.displacement.total_xy;

if ~exist('struct.post.scale', 'var')
  struct.post.scale = 100;
end
scale = struct.post.scale;


scale = struct.post.scale;

ffxy = struct.step.displacement.farfield_xy;


figure(1);
closedellipse = [ellipse ellipse(1)];
closeddispxy = [dispxy dispxy(1)];
deformed = closedellipse + scale*closeddispxy;
plot(deformed,'r')



%figure(2);
%closedellipse = [ellipse ellipse(1)];
%closedffxy = [ffxy ffxy(1)];
%deformed = closedellipse + scale*closedffxy;
%plot(deformed,'r')
