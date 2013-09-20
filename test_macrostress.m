function test_macrostress


epsilon = 1e-10;

% Hard-coded in later tests - don't change without checking.
material.mu_m = 1;
material.nu_m = 0.3;
MacroStrain=[1 0 0];



%------------------------------
% Sigma_11 not close to zero
%==============================
loads.SigBar_xy = [1 34 -345];
loads.StressRatio_22 = 1;
loads.StressRatio_12 = 0;


% Test with zero Eps_int and non-zero Sigma_p

% Test materialterm 
Eps_int = [0 0 0];
Sigma_p = [1 1 1 1];
geom.f=0;
[MacroStress, MacroStrain,Sigma_m] = macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);
materialterm_check = 2/(1-0.3*2);
materialterm = MacroStress(1)/MacroStrain(1);
assert(allequal(materialterm_check, materialterm, epsilon), ...
       'materialterm is not calculated correctly');
MacroStress_check=[5 5 0];
MacroStrain_check=[1 1 0];

assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is notcalculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is notcalculated correctly');
assert(allequal(Sigma_m, MacroStress, epsilon), ...
       'Sigma_m is notcalculated correctly');


% Test particleterm
geom.f=0.5;
[MacroStress, MacroStrain,Sigma_m]= macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);
particleterm_check = -1/2*(1 -0.3 -0.3);
particleterm = 2*MacroStrain(1) - 2*MacroStress(1)/materialterm_check;
assert(allequal(particleterm_check, particleterm, epsilon), ...
       'particleterm is not calculatedcorrectly');
MacroStress_check=[5.5 5.5 0];
MacroStrain_check=[1 1 -0.25];
Sigma_m_check=[10 10 -1];
assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is notcalculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is notcalculated correctly');
assert(allequal(Sigma_m, Sigma_m_check, epsilon), ...
       'Sigma_m is notcalculated correctly');


% Test with non-zero Eps_int and zero Sigma_p
Eps_int = [1 1 1];
Sigma_p = [0 0 0 0];
geom.f=0.5;
[MacroStress, MacroStrain,Sigma_m]= macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);
MacroStress_check=[2.5 2.5 0];
MacroStrain_check=[1 1 0.5];
Sigma_m_check=[5 5 0];
assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is notcalculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is notcalculated correctly');
assert(allequal(Sigma_m, Sigma_m_check, epsilon), ...
       'Sigma_m is notcalculated correctly');


%--------------------------------------------
% Test for zero sigma_22, non-zero sigma_12
%============================================

geom.f = 0.5;
loads.StressRatio_22 = 0;
loads.StressRatio_12 = 1;


% Test with zero Eps_int and non-zero Sigma_p
Eps_int = [0 0 0];
Sigma_p = [1 1 1 1];

[MacroStress, MacroStrain,Sigma_m] = ...
    macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);

MacroStress_check=[22/7 0 22/7];
MacroStrain_check=[1 -4/7 37/28];
Sigma_m_check=[37/7 -1 37/7];
assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is not calculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is not calculated correctly');
assert(allequal(Sigma_m, Sigma_m_check, epsilon), ...
       'Sigma_m is not calculated correctly');


% Test with non-zero Eps_int and zero Sigma_p
Eps_int = [1 1 1];
Sigma_p = [0 0 0 0];

[MacroStress, MacroStrain,Sigma_m] = ...
    macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);
MacroStress_check=[10/7 0 10/7];
MacroStrain_check=[1 2/7 17/14];
Sigma_m_check=[20/7 0 20/7];
assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is not calculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is not calculated correctly');
assert(allequal(Sigma_m, Sigma_m_check, epsilon), ...
       'Sigma_m is not calculated correctly');



%---------------------------------
% Test for sigma_11 close to zero
%=================================

loads.SigBar_xy = [1e-10 34 -345];
loads.StressRatio_12_22 = 1;


% Test materialterm 
Eps_int = [0 0 0];
Sigma_p = [1 1 1 1];
geom.f=0;

[MacroStress, MacroStrain,Sigma_m]= macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);
MacroStress_check=[0 -20/3 -20/3];
MacroStrain_check=[1 -7/3 -10/3];
assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is not calculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is not calculated correctly');
assert(allequal(Sigma_m, MacroStress_check, epsilon), ...
       'Sigma_m is not calculated correctly');

% Test remaining terms
geom.f=0.5;

[MacroStress, MacroStrain,Sigma_m]= macrostress(MacroStrain,Sigma_p, Eps_int, loads, geom, material);
MacroStress_check=[0 -22/3 -22/3];
MacroStrain_check=[1 -8/3 -47/12];
Sigma_m_check=[-1 -47/3 -47/3];
assert(allequal(MacroStress_check, MacroStress, epsilon), ...
       'MacroStress is not calculated correctly');
assert(allequal(MacroStrain_check, MacroStrain, epsilon), ...
       'MacroStrain is not calculated correctly');
assert(allequal(Sigma_m, Sigma_m_check, epsilon), ...
       'Sigma_m is not calculated correctly');




