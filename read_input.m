function[material,geom,loads] = read_input(input_file)

% This file reads data from an input deck and puts it into structures which will be used by the rest of the program

%----------------------------------------------------
% Read input data from file
%====================================================

%input_file=inpu t('Enter the complete input filename: ','s');

fid=fopen(input_file,'r');

% Read in comment line, which does not need to be stored
dummy=sscanf(fgets(fid),'%s');
% Read in number of lines in input file - tells the for loop how
% long to continue
num_input_lines=sscanf(fgets(fid),'%i');


input_list=zeros(num_input_lines,1);
for i=1:num_input_lines
  dummy=sscanf(fgets(fid),'%s');
  input_list(i)=sscanf(fgets(fid),'%f');
end

geom.a=input_list(1);                    %       a: Ellipse major axis [mm]
geom.b=input_list(2);                    %       b: Ellipse minor axis [mm]
geom.f=input_list(3);                    %       f: Particle volume fraction [-]
geom.NumPoints=input_list(10);           %       NumPoints: number of points around the ellipse

material.E_m=input_list(4);              %       E_m: matrix Young's modulus [MPa]
material.nu_m=input_list(5);             %       nu_m: matrix Poisson's ratio [-]
material.sigmax=input_list(6);           %       sigmax: maximum cohesive strength [MPa]
material.delopen=input_list(7);          %       delopen: critical normal opening displacement [mm]
material.cohscale=input_list(8);         %       cohscale: cohesive scaling parameter [-]
material.plstrain=input_list(9);         %       plstrain: = 1 for plane strain, = 0 for plane stress

loads.NumModes=input_list(11);           %       NumModes: number of modes in the Fourier sum (must be even)
loads.SigmaBar1=input_list(12);          %       SigmaBar1: principal applied macroscopic stress
loads.SigmaBarRatio=input_list(13);      %       SigmaBarRatio: ratio of SigmaBar2 to SigmaBar1
loads.AppliedLoadAngle=input_list(14);   %       AppliedLoadAngle: angle of sigbar1 relative to major axis of ellipse
loads.timesteps=input_list(15);          %       timesteps: number of timesteps
loads.MinimumStrain=input_list(16);      %       MinimumStrain: minimum applied strain [-]

loads.LoadFactor=input_list(17);         %       LoadFactor: fraction of maxstrain/minstrain
post.ScalingParameter=input_list(18);    %	 ScalingParameter: scaling for displaced shape [-]

fclose(fid);


%---------------------------------------------------------
% Calculate additional geometric and material parameters
%=========================================================

geom.R=(geom.a+geom.b)/2.;                      % ellipse size factor
geom.m=(geom.a-geom.b)/(geom.a+geom.b);         % ellipse shape factor
geom.rho=1;                                     % radius at which we want to calculate stresses - usually 1 for the unit circle

material.mu_m=material.E_m/(2*(1+material.nu_m));       % Lame modulus
material.lambda_m= (material.E_m * material.nu_m)/((1+material.nu_m)*(1-2*material.nu_m));   % Lame modulus

if (material.plstrain==1)
    material.kappa_m= 3+ 4*material.nu_m;               % plane strain kappa
elseif (material.plstrain==0)
    material.kappa_m= (3-material.nu_m)/(1+material.nu_m);   % plane stress kappa
else
    error('variable plstrain must have a value of 0 or 1')
end

material.delslide=material.cohscale*material.delopen;   %critical sliding displacement is given by cohesive scaling parameter multiplied with critical opening displacement

material.gint=material.sigmax*material.delopen/2;       % Cohesive energy is area under curve

material.lambda_e=0.001;           %***** Should be moved to input file


