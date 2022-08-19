%Distribution System Modelling and Analysis, Example 3.3
%Written by William Kersting and Robert Kerestes
clear

%Loading the phase impedance matrix from Example 3.1
load('zline_0301.mat')

j = sqrt(-1);

Length = 5000; E = 7200;  SL = 5000*exp(j*acos(0.85));

%Calculate the total line impedance:

Zline = zline*Length/5280;


%Initializing variables

tolerance = 0.0001;
Error = 1000;
IL_old = 0;
IS_old = IL_old;


while Error > tolerance
    
%Compute the load voltage using last iteration current:
VL_old = E - Zline*IL_old;
[VL_old_mag,VL_old_phase] = rec2pol(VL_old);

%Compute the load current using last iteration voltage:
IL_new = conj(SL*1000/VL_old);
[IL_new_mag,IL_new_phase] = rec2pol(IL_new);

%Compute the load voltage using this iteration current:
VL_new = E - Zline*IL_new;
[VL_new_mag,VL_new_phase] = rec2pol(VL_new);

%Calculating error
Error = abs(VL_new_mag-VL_old_mag)/E;

%Updating current for next interation:
IL_old = IL_new;

end

IL = IL_new;
VL = VL_new;

%Compute the load current using last iteration voltage:
Error;
[IL_mag,IL_phase] = rec2pol(IL);
[VL_mag,VL_phase] = rec2pol(VL);

fprintf('Error = %.5f\n\n',Error)
fprintf('VL = %.1f < %.2f\n\n',VL_mag,VL_phase)
fprintf('IL = %.1f < %.2f\n\n',IL_mag,IL_phase)