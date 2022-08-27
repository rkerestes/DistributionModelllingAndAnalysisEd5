%Distribution System Modelling and Analysis, Example 7.7
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;

%%%%%%%%%%%%%%%%%%%% From Example 6.4 Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Loading the b matrix from example 6.1
load('b_0601.mat')


%Computing the approximate A and B matrices
A = U;
B = b;


%Defining the unbalanced load complex powers
SL = [2500*exp(j*acos(0.9));2000*exp(j*acos(0.85));1500*exp(j*acos(0.95))];

%Defining the source voltages
Eabc = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];

%Initializing variables
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
VLGm_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    VLGm = A*Eabc-B*Iabc;
    Iabc = conj((SL*1000)./VLGm);
    Error = abs(abs(VLGm)-abs(VLGm_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    VLGm_old = VLGm;

end
Vload_abc = VLGm;
[Vload_abc_mag,Vload_abc_phase] = rec2pol(Vload_abc);
[Iabc_mag,Iabc_phase] = rec2pol(Iabc);

%%%%%%%%%%%%%%%%%%%% From Example 6.4 Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Loading generalized matrices from Example 6.2
load('a_0602.mat')
load('b_0602.mat')

c = zeros(3,3);
d = a;
A = a^-1;
B = a^-1*b;

V120 = Vload_abc*120/(12.47e3/sqrt(3));
[V120_mag,V120_phase] = rec2pol(V120);

fprintf('On 120 volt base:\n\n')
fprintf('\t%.1f < %.2f\n',V120_mag(1),V120_phase(1))
fprintf('V120 =\t%.1f < %.2f\tV\n',V120_mag(2),V120_phase(2))
fprintf('\t%.1f < %.2f\n',V120_mag(3),V120_phase(3))

%Regulator ratings
VLN_rated = 7200;
NPT = VLN_rated/120;
Irated  = 2500/(sqrt(3)*4.16);

%Sicne Irated is just under 700 amps, we will set the CT primary current
%rating to 700 amps
CTp = 600;
CT = CTp/5;

%Defining voltqage regulation settings
Vreg_base = 120;
Vset = 120;
band = 2;
Vrange_pct = 10; %+/- this range for possible voltage regulation
numSteps = 32;

%Calculating volts per tap step
stepPct = ((2*Vrange_pct/100)/numSteps);
Vstep = stepPct*Vreg_base;

Zline_a = (Eabc(1)-Vload_abc(1))/Iabc(1);
Zline_b = (Eabc(2)-Vload_abc(2))/Iabc(2);
Zline_c = (Eabc(3)-Vload_abc(3))/Iabc(3);
Zavg = (Zline_a+Zline_b+Zline_c)/3;

fprintf('\n\nAverege Line Impedance:\n\n')
fprintf('Zaverage = %.4f+j%.4f ohms\n\n',real(Zavg),imag(Zavg))

%Calculating compensator settings
Z = Zavg*CTp/NPT;
R = round(real(Z));
X = round(imag(Z));

fprintf('Compensator Settings:\n\n')
fprintf('R + jX = %.0f + j%.0f V\n\n',R,X)

tap(1,1) = round(((Vset-band/2)-V120_mag(1))/Vstep);
tap(2,1) = round(((Vset-band/2)-V120_mag(2))/Vstep);
tap(3,1) = round(((Vset-band/2)-V120_mag(3))/Vstep);


for i = 1:1:3

    if sign(tap(i,1))

        ar(i,1) = 1-stepPct*tap(i,1);
    else
        ar(i,1) = 1+stepPct*tap(i,1);
    end

end 

%Generalized constants
areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
breg = zeros(3,3);
creg = zeros(3,3);
dreg = areg^-1;
Areg = areg^-1;
Breg = zeros(3,3);

%Setting A and B to Aline and Bline for naming sake
Aline = A;
Bline = B;

%Running the ladder technique again with the regulator 
EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc = Areg*EABC-Breg*Iabc;
    Vload_abc = Aline*Vreg_abc-Bline*Iabc;
    Iabc = conj((SL*1000)./Vload_abc);
    Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    Vload_abc_old = Vload_abc;
    V120 = Vload_abc/NPT;
    IABC = dreg*Iabc;

end

[Vload_abc_mag,Vload_abc_phase] = rec2pol(Vload_abc);
[V120_mag,V120_phase] = rec2pol(V120);
[Vreg_abc_mag,Vreg_abc_phase] = rec2pol(Vreg_abc);
[Iabc_mag,Iabc_phase] = rec2pol(Iabc);
[IABC_mag,IABC_phase] = rec2pol(IABC);


fprintf('With Taps Set:\n\n')
fprintf('\nLoad Voltage:\n\n')
fprintf('\t%.1f < %.2f\n',Vload_abc_mag(1),Vload_abc_phase(1))
fprintf('Vload =\t%.1f < %.2f\tV\n',Vload_abc_mag(2),Vload_abc_phase(2))
fprintf('\t%.1f < %.2f\n',Vload_abc_mag(3),Vload_abc_phase(3))

fprintf('\nLoad on 120 volt base:\n\n')
fprintf('\t%.1f < %.2f\n',V120_mag(1),V120_phase(1))
fprintf('V120 =\t%.1f < %.2f\tV\n',V120_mag(2),V120_phase(2))
fprintf('\t%.1f < %.2f\n',V120_mag(3),V120_phase(3))

fprintf('\nLoad Current:\n\n')
fprintf('\t%.1f < %.2f\n',Iabc_mag(1),Iabc_phase(1))
fprintf('Iabc =\t%.1f < %.2f\tA\n',Iabc_mag(2),Iabc_phase(2))
fprintf('\t%.1f < %.2f\n',Iabc_mag(3),Iabc_phase(3))

fprintf('\nRegulator Voltage:\n\n')
fprintf('\t%.1f < %.2f\n',Vreg_abc_mag(1),Vreg_abc_phase(1))
fprintf('Vreg =\t%.1f < %.2f V\n',Vreg_abc_mag(2),Vreg_abc_phase(2))
fprintf('\t%.1f < %.2f\n',Vreg_abc_mag(3),Vreg_abc_phase(3))

fprintf('\nRegulator Current:\n\n')
fprintf('\t%.1f < %.2f\n',IABC_mag(1),IABC_phase(1))
fprintf('IABC =\t%.1f < %.2f\tA\n',IABC_mag(2),IABC_phase(2))
fprintf('\t%.1f < %.2f\n',IABC_mag(3),IABC_phase(3))

fprintf('\nFinal tap Settings:\n\n')
fprintf('Tap a = %.0f\n',tap(1,1))
fprintf('Tap b = %.0f\n',tap(2,1))
fprintf('Tap c = %.0f\n\n',tap(3,1))

%Considering the compensator circuit

%Resetting generalized constants
ar = ones(3,1);
areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
breg = zeros(3,3);
creg = zeros(3,3);
dreg = areg^-1;
Areg = areg^-1;
Breg = zeros(3,3);

%Running the ladder technique again with the regulator 
EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc = Areg*EABC-Breg*Iabc;
    Vload_abc = Aline*Vreg_abc-Bline*Iabc;
    Iabc = conj((SL*1000)./Vload_abc);
    Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    Vload_abc_old = Vload_abc;
    V120 = Vload_abc/NPT;
    IABC = dreg*Iabc;

end

Zcomp = (R+j*X)/5;
Vout = Areg*EABC;
Iout = dreg^-1*IABC;
fprintf('Taps set to zero:\n\n')
vprint(Vout,'Vout')
iprint(Iout,'Iout')

%Compensator voltages and currents
Vreg = Vout/NPT;
vprint(Vreg,'Vreg')
Icomp = Iout/CT;
iprint(Icomp,'Icomp')

%Calculating relay voltage
Zcomp = [Zcomp 0 0;0 Zcomp 0;0 0 Zcomp];
Vrelay = Vreg - Zcomp*Icomp;
vprint(Vrelay,'Vrelay')

%Defining new voltqage regulation settings
Vset = 120;

%Calculating new tap position
Vlow = Vset-band/2;
tap = round((Vlow -abs(Vrelay))/Vstep)
fprintf('\nNew tap Settings:\n\n')
fprintf('Tap a = %.0f\n',tap(1))
fprintf('Tap b = %.0f\n',tap(2))
fprintf('Tap c = %.0f\n\n',tap(3))

% Resetting regulator matrices 

for i = 1:1:3

    if sign(tap(i,1))

        ar(i,1) = 1-stepPct*tap(i,1);
    else
        ar(i,1) = 1+stepPct*tap(i,1);
    end

end 

%Generalized constants
areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
breg = zeros(3,3);
creg = zeros(3,3);
dreg = areg^-1;
Areg = areg^-1;
Breg = zeros(3,3);

%Running the ladder technique again with the updated tap settings
EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc = Areg*EABC-Breg*Iabc;
    Vload_abc = Aline*Vreg_abc-Bline*Iabc;
    Iabc = conj((SL*1000)./Vload_abc);
    Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    Vload_abc_old = Vload_abc;
    V120 = Vload_abc/NPT;
    IABC = dreg*Iabc;

end

Vout = Areg*EABC;
Iout = dreg^-1*IABC; 
Vreg = Vout/NPT;
Icomp = Iout/CT;
Vrelay = Vreg - Zcomp*Icomp;
vprint(Vrelay,'Vrelay')

fprintf('\nRelay voltages:\n\n')
vprint(Vrelay,'Vrelay')
fprintf('\nUpdated load voltages on 120 volt base:\n\n')
vprint(V120,'V120')


%Running again with a new voltage setpoint of 122 volts

%Resetting generalized constants
ar = ones(3,1);
areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
breg = zeros(3,3);
creg = zeros(3,3);
dreg = areg^-1;
Areg = areg^-1;
Breg = zeros(3,3);

%Running the ladder technique again with the regulator 
EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc = Areg*EABC-Breg*Iabc;
    Vload_abc = Aline*Vreg_abc-Bline*Iabc;
    Iabc = conj((SL*1000)./Vload_abc);
    Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    Vload_abc_old = Vload_abc;
    V120 = Vload_abc/NPT;
    IABC = dreg*Iabc;

end

Zcomp = (R+j*X)/5;
Vout = Areg*EABC;
Iout = dreg^-1*IABC;


%Compensator voltages and currents
Vreg = Vout/NPT;
Icomp = Iout/CT;

%Calculating relay voltage
Zcomp = [Zcomp 0 0;0 Zcomp 0;0 0 Zcomp];
Vrelay = Vreg - Zcomp*Icomp;

%Defining new voltqage regulation settings
Vset = 122;

%Calculating new tap position
Vlow = Vset-band/2;
tap = round((Vlow -abs(Vrelay))/Vstep);
fprintf('\nChanging voltage setpoint to 122 volts:\n\n')
fprintf('\nNew tap Settings:\n\n')
fprintf('Tap a = %.0f\n',tap(1))
fprintf('Tap b = %.0f\n',tap(2))
fprintf('Tap c = %.0f\n\n',tap(3))

% Resetting regulator matrices 

for i = 1:1:3

    if sign(tap(i,1))

        ar(i,1) = 1-stepPct*tap(i,1);
    else
        ar(i,1) = 1+stepPct*tap(i,1);
    end

end 

%Generalized constants
areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
breg = zeros(3,3);
creg = zeros(3,3);
dreg = areg^-1;
Areg = areg^-1;
Breg = zeros(3,3);

%Running the ladder technique again with the updated tap settings
EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc = Areg*EABC-Breg*Iabc;
    Vload_abc = Aline*Vreg_abc-Bline*Iabc;
    Iabc = conj((SL*1000)./Vload_abc);
    Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    Vload_abc_old = Vload_abc;
    V120 = Vload_abc/NPT;
    IABC = dreg*Iabc;

end

Vout = Areg*EABC;
Iout = dreg^-1*IABC; 
Vreg = Vout/NPT;
Icomp = Iout/CT;
Vrelay = Vreg - Zcomp*Icomp;

fprintf('\nNew load voltages:\n\n')
vprint(V120,'V120')
fprintf('\nNew relay voltages:\n\n')
vprint(Vrelay,'Vrelay')



