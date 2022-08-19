%Distribution System Modelling and Analysis, Example 3.7
%Written by William Kersting and Robert Kerestes
clear

%Loading the phase impedance matrix from Example 3.1
load('zline_0301.mat')
zline = round(zline,3)

j = sqrt(-1);

Length = 5000; E = 7200;  SL = 5000*exp(j*acos(0.85)); SC = -j*2400;

%Calculate the total line impedance:

Zline = zline*Length/5280;


%Initializing variables

Tol = 0.0001;
Error = 1000;
IL = 0;
IC = 0;
VL_old = 0;


for n = 1:1:10
    
    %Compute the load voltage using last iteration current:
    VL = E - Zline*(IL+IC);
    [VL_old_mag,VL__old_phase] = rec2pol(VL_old);
    [VL_mag,VL_phase] = rec2pol(VL);


    %Calculating error
    Error = abs(VL_mag-VL_old_mag)/E;
        
        if Error < Tol
            
            break
            
        end

    %Compute the load current and cap current using last iteration voltage:
    IL= conj(SL*1000/VL);
    IC = conj(SC*1000/VL);
    
    %Updating voltage
    VL_old = VL;

end

Is = IL;

%Computing voltage drop
Vdrop = (E-VL_mag)/E*100;

%Computing power delivered by source
Ss = E*conj(Is);

[IC_mag,IC_phase] = rec2pol(IC);
[IL_mag,IL_phase] = rec2pol(IL);
[VL_mag,VL_phase] = rec2pol(VL);

fprintf('VL = %.1f < %.2f volts \n\n',VL_mag,VL_phase)
fprintf('IL = %.1f < %.2f amps \n\n',IL_mag,IL_phase)
fprintf('IC = %.1f < %.2f amps \n\n',IC_mag,IC_phase)
fprintf('Error = %.5f\n\n',Error)
fprintf('Vrop = %.2f %%\n\n',Vdrop)


