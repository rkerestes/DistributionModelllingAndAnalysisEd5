%Distribution System Modelling and Analysis, Example 3.6
%Written by William Kersting and Robert Kerestes
clear

%Loading the phase impedance matrix from Example 3.1
load('zline_0301.mat')

j = sqrt(-1);

Length = 5000; E = 7200;  SL = 5000*exp(j*acos(0.85));

%Calculate the total line impedance:

Zline = zline*Length/5280;


%Initializing variables

Tol = 0.0001;
Error = 1000;
IL = 0;
VL_old = 0;


for n = 1:1:10
    
    %Compute the load voltage using last iteration current:
    VL = E - Zline*IL;
    [VL_old_mag,VL__old_phase] = rec2pol(VL_old);
    [VL_mag,VL_phase] = rec2pol(VL);


    %Calculating error
    Error = abs(VL_mag-VL_old_mag)/E;
        
        if Error < Tol
            
            break
            
        end

    %Compute the load current using last iteration voltage:
    IL= conj(SL*1000/VL);
    
    %Updating voltage
    VL_old = VL;

end

Is = IL;

%Computing voltage drop
Vdrop = (E-VL_mag)/E*100;

%Computing power delivered by source
Ss = E*conj(Is);

%Compute the load current using last iteration voltage:
Error;
[IL_mag,IL_phase] = rec2pol(IL);
[VL_mag,VL_phase] = rec2pol(VL);

fprintf('VL = %.1f < %.2f volts \n\n',VL_mag,VL_phase)
fprintf('IL = %.1f < %.2f amps \n\n',IL_mag,IL_phase)
fprintf('Error = %.5f\n\n',Error)
fprintf('Vrop = %.2f %%\n\n',Vdrop)
fprintf('Ssource = %.0f +j%.0f kVA\n\n',real(Ss)/1000,imag(Ss)/1000)


