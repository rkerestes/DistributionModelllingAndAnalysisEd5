%Distribution System Modelling and Analysis, Example 7.5
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3);

%Regulator ratings
Vs_rated = 2400;
NPT = Vs_rated/120;
Irated  = 5000/(sqrt(3)*4.16);

%Sicne Irated is just under 700 amps, we will set the CT primary current
%rating to 700 amps
Iprimary = 700;
CT = Iprimary/5;

%Defining the impedance to the load center 
R = 0.3;
X = 0.9;

%Caculating the compensator setting in volts
Rprime = R*Iprimary/NPT;
Xprime = X*Iprimary/NPT;

%Defining voltqage regulation settings
Vreg_base = 120;
Vset = 120;
band = 2;
Vrange_pct = 10; %+/- this range for possible voltage regulation
numSteps = 32;

%Calculating volts per tap step
stepPct = ((2*Vrange_pct/100)/numSteps)
Vstep = stepPct*Vreg_base;


%Calculating compensator impedance values in ohms
Rohms = Rprime/5;
Xohms = Xprime/5;

%Defining the load ratings
SL_rated = 2500;
VL_rated = 4.16e3;
pfL_rated = 0.9;

%Calculating the line current 
Iline = SL_rated*1000/(sqrt(3)*VL_rated)*exp(-j*acos(pfL_rated));
[Iline_mag,Iline_phase] = rec2pol(Iline);

fprintf('Line Current:')
fprintf('\n\nIline = %.2f < %.2f A\n\n',Iline_mag,Iline_phase)

%Calculating the compensator current
Icomp = Iline/CT;
[Icomp_mag,Icomp_phase] = rec2pol(Icomp);

fprintf('Compensator Current:')
fprintf('\n\nIcomp = %.2f < %.2f A\n\n',Icomp_mag,Icomp_phase)

%Compenstator voltage
Vreg = (VL_rated/sqrt(3))/NPT;
[Vreg_mag,Vreg_phase] = rec2pol(Vreg);

fprintf('Compensator input voltage:')
fprintf('\n\nVreg = %.2f < %.2f A\n\n',Vreg_mag,Vreg_phase)

%Compensator voltage drop
Vdrop = Icomp*(Rohms+j*Xohms);

[Vdrop_mag,Vdrop_phase] = rec2pol(Vdrop);

fprintf('Compensator voltage drop:')
fprintf('\n\nVdrop = %.2f < %.2f A\n\n',Vdrop_mag,Vdrop_phase)

%Calculating voltage across relay
VR = Vreg-Vdrop;

[VR_mag,VR_phase] = rec2pol(VR);

fprintf('Voltage across relay:')
fprintf('\n\nVR = %.2f < %.2f A\n\n',VR_mag,VR_phase)

%Calculating tap position
tap = ((Vset-band/2)-VR_mag)/Vstep;
tap = round(tap);

fprintf('Tap position:')
fprintf('\n\nTap = %.0f ',tap)
if sign(tap)
    fprintf('raise position\n\n')
else
    fprintf('lower position\n\n')
end

if sign(tap)
    ar = 1-stepPct*tap;
else
    ar = 1+stepPct*tap;
end

%Calculating the generalized constants
a = ar;
b = 0;
c = 0;
d = 1/ar;

fprintf('The generalized constants are:\n\n')
fprintf('a = %.4f\n',a)
fprintf('b = 0\n')
fprintf('c = 0\n')
fprintf('d = %.4f\n\n',d)

