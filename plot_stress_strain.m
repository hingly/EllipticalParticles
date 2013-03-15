function plot_stress_strain(struct, f, marker)

MacroStrain = struct.step.macro_var.MacroStrain;
MacroStress = struct.step.macro_var.MacroStress;

figure(f);
hold on;
plot(MacroStrain(1)*100, MacroStress(1), marker, 'markersize', 2);


