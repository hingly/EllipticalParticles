function plot_stress_strain_init(struct,f)

MacroStrain = struct.step.macro_var.MacroStrain;
MacroStress = struct.step.macro_var.MacroStress;

figure(f);
hold on;
plot(MacroStrain(1)*100,MacroStress(1),'*','markersize',1);
title('Macroscopic stress strain response');
xlabel('Strain 11 [%]');
ylabel('Stress [MPa]');




