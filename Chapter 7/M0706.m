%Distribution System Modelling and Analysis, Example 7.6
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3);

%Regulator ratings
Vs_rated = 2400;
NPT = 2400/120;
Irated  = 2500/(sqrt(3)*4.16);

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
stepPct = ((2*Vrange_pct/100)/numSteps);
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

%Calculating the compensator current
Icomp = Iline/CT;
[Icomp_mag,Icomp_phase] = rec2pol(Icomp);

%Compenstator voltage
Vreg = (VL_rated/sqrt(3))/NPT;
[Vreg_mag,Vreg_phase] = rec2pol(Vreg);

%Compensator voltage drop
Vdrop = Icomp*(Rohms+j*Xohms);

[Vdrop_mag,Vdrop_phase] = rec2pol(Vdrop);

%Calculating voltage across relay
VR = Vreg-Vdrop;
[VR_mag,VR_phase] = rec2pol(VR);

%Calculating tap position
tap = ((Vset-band/2)-VR_mag)/Vstep;
tap = round(tap);

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

%Calculations for problem 7.6
%Setting the substation voltage equal to nominal values
Vs = VL_rated/sqrt(3);
Is = Iline;

%Calculating the actual voltages and currents on the load side of the
%regulator
VL = Vs/a;
[VL_mag,VL_phase] = rec2pol(VL);
IL = Is/d;
[IL_mag,IL_phase] = rec2pol(IL);

fprintf('Regulator load side voltages and currents:\n\n')
fprintf('VL = %.1f < %.2f V\n',VL_mag,VL_phase)
fprintf('IL = %.1f < %.2f A\n',IL_mag,IL_phase)

%Calculating the actual voltage at the load center
VLC = VL -IL*(R+j*X);
[VLC_mag,VLC_phase] = rec2pol(VLC);

fprintf('\nLoad center voltage:\n\n')
fprintf('VLC = %.1f < %.2f V\n',VLC_mag,VLC_phase)

VLC120 = VLC_mag/NPT;

fprintf('\nConverting to 120 V base:\n\n ')
fprintf('VLC_120 = %.2f V\n\n', VLC120)

%Calculating the compensator circuit values
Vreg = VL/NPT;
[Vreg_mag,Vreg_phase] = rec2pol(Vreg);

Icomp = IL/CT;
[Icomp_mag,Icomp_phase] = rec2pol(Icomp);


fprintf('\nCompensator circuit values:\n\n')
fprintf('Vreg = %.1f < %.2f V\n',Vreg_mag,Vreg_phase)
fprintf('Icomp = %.1f < %.2f A\n',Icomp_mag,Icomp_phase)


