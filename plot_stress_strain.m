function plot_stress_strain(struct)

MacroStrain = struct.step.macro_var.MacroStrain;
MacroStress = struct.step.macro_var.MacroStress;



figure(2);
plot(MacroStrain(1)*100,MacroStress(1),'*','markersize',1);

%figure(2);
%closedellipse = [ellipse ellipse(1)];
%closedffxy = [ffxy ffxy(1)];
%deformed = closedellipse + scale*closedffxy;
%plot(deformed,'r')


