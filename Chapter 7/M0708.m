%Distribution System Modelling and Analysis, Example 7.8
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];

%Defining the line to line voltage at Node S
VLL_ABC = 12.47e3*[1;exp(j*-120*deg);exp(j*120*deg)];
VLN_ABC = W*VLL_ABC;

%Defining the unbalanced load complex powers
SL = [2500*exp(j*acos(0.9));2000*exp(j*acos(0.85));1500*exp(j*acos(0.95))];

%Loading the primitive impedance matrix from example 0401. The first three
%rows and columns of this matrix represent a three wire line
load("zprim_0401.mat")
z = zprim(1:1:3,1:1:3);
dist = 10000;
Z = dist/5280*z;

%Generalized line constants
aline = U;
bline = Z;
cline = zeros(3,3);
dline = U;
Aline = aline^-1;
Bline = aline^-1*bline;

%Selecting PT and CT ratios
NPT = 12470/120;
CTp = 500;
CTs = 5;
CT = CTp/CTs;

%Performing power flow study to determine compensator settings

%Setting regulator to nonimal
ar = ones(3,1);
aLL = [ar(1,1) 0 0;0 ar(2,1) 0;-ar(1,1) -ar(2,1) 0];
ALL = [1/ar(1,1) 0 0;0 1/ar(2,1) 0;-1/ar(1,1) -1/ar(2,1) 0];

areg = W*aLL*Dv;
breg = zeros(3,3);
creg = zeros(3,3);
dreg = [1/ar(1,1) 0 0;-1/ar(1,1) 0 -1/ar(2,1);0 0 1/ar(2,1)];
Areg = W*ALL*Dv;
Breg = zeros(3,3);

%Running the ladder technique again with the regulator at nominal
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old_LN = Start;
Vload_abc_old_LL = Dv*Vload_abc_old_LN;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc_LN = Areg*VLN_ABC-Breg*Iabc;
    Vload_abc_LN = Aline*Vreg_abc_LN-Bline*Iabc;
    Vload_abc_LL = Dv*Vload_abc_LN;
    ID_abc = conj((SL*1000)./Vload_abc_LL);
    Iabc = DI*ID_abc;
    Error = abs(abs(Vload_abc_LL)-abs(Vload_abc_old_LL))/(kVLN*1000);

    if max(Error) < Tol
        break
    end
    
    Vreg_abc_LL = Dv*Vreg_abc_LN;
    Vload_abc_old_LL = Vload_abc_LL;
    V120 = Vload_abc_LL/NPT;
    IABC = dreg*Iabc;

end


fprintf('\n\nLoad Center Voltages:\n\n')
vprint(V120,'V120_LL')

fprintf('Line currents:\n\n')
iprint(Iabc,'Iabc')

%Calculating equivalent impedances
Zeqa = (Vreg_abc_LL(1)-Vload_abc_LL(1))/Iabc(1)
Zeqc = (-Vreg_abc_LL(2)+Vload_abc_LL(2))/Iabc(3)

%Calculating compensator settings in volts
Rab = real(Zeqa)*CTp/NPT;
Xab = imag(Zeqa)*CTp/NPT;
Rcb = real(Zeqc)*CTp/NPT;
Xcb = imag(Zeqc)*CTp/NPT;

%Calculating compensator voltages
Vcomp_ab = Vreg_abc_LL(1)/NPT;
vprint(Vcomp_ab,'Vcomp_ab')
Vcomp_cb = -Vreg_abc_LL(2)/NPT;
vprint(Vcomp_cb,'Vcomp_cb')
Icomp_a = Iabc(1)/CT;
iprint(Icomp_a,'Icomp_a')
Icomp_c = Iabc(3)/CT;
iprint(Icomp_c,'Icomp_c')

%Calculating compensator ohms
Rab_ohm = Rab/CTs;
Xab_ohm = Xab/CTs;
Rcb_ohm = Rcb/CTs;
Xcb_ohm = Xcb/CTs;

%Calculating relay voltages
Vrelay_ab = Vcomp_ab - (Rab_ohm+j*Xab_ohm)*Icomp_a;
vprint(Vrelay_ab,'Vrelay_ab')
Vrelay_cb = Vcomp_cb - (Rcb_ohm+j*Xcb_ohm)*Icomp_c;
vprint(Vrelay_cb,'Vrelay_cb')

%Defining voltqage regulation settings
Vreg_base = 120;
Vset = 120;
band = 2;
Vrange_pct = 10; %+/- this range for possible voltage regulation
numSteps = 32;

%Calculating volts per tap step
stepPct = ((2*Vrange_pct/100)/numSteps);
Vstep = stepPct*Vreg_base;

%Calculating new tap position
Vlow = Vset-band/2;
tap_ab = round((Vlow -abs(Vrelay_ab))/Vstep);
tap_cb = round((Vlow -abs(Vrelay_cb))/Vstep);
fprintf('\nTap Settings:\n\n')
fprintf('Tap ab = %.0f\n',tap_ab)
fprintf('Tap cb = %.0f\n',tap_cb)

%Calculating regulator ratio
ar_ab = 1-stepPct*tap_ab;
ar_cb = 1-stepPct*tap_cb;

%Setting regulator to tap position
ar = ones(3,1);
aLL = [ar_ab 0 0;0 ar_cb 0;-ar_ab -ar_cb 0];
ALL = [1/ar_ab 0 0;0 1/ar_cb 0;-1/ar_ab -1/ar_cb 0];

areg = W*aLL*Dv;
breg = zeros(3,3);
creg = zeros(3,3);
dreg = [1/ar_ab 0 0;-1/ar_ab 0 -1/ar_cb;0 0 1/ar_cb];
Areg = W*ALL*Dv;
Breg = zeros(3,3);

%Running the ladder technique again with the regulator at taps
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
Vload_abc_old_LN = Start;
Vload_abc_old_LL = Dv*Vload_abc_old_LN;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    Vreg_abc_LN = Areg*VLN_ABC-Breg*Iabc;
    Vload_abc_LN = Aline*Vreg_abc_LN-Bline*Iabc;
    Vload_abc_LL = Dv*Vload_abc_LN;
    ID_abc = conj((SL*1000)./Vload_abc_LL);
    Iabc = DI*ID_abc;
    Error = abs(abs(Vload_abc_LL)-abs(Vload_abc_old_LL))/(kVLN*1000);

    if max(Error) < Tol
        break
    end
    
    Vreg_abc_LL = Dv*Vreg_abc_LN;
    Vload_abc_old_LL = Vload_abc_LL;
    V120 = Vload_abc_LL/NPT;
    IABC = dreg*Iabc;

end

fprintf('With regulators set to tap settings:\n\n')
fprintf('\n\nLoad Center Line to Line Voltages:\n\n')
vprint(Vreg_abc_LL,'VR_LL')

fprintf('\n\nLoad Center Voltages:\n\n')
vprint(V120,'V120_LL')

fprintf('Line currents:\n\n')
iprint(Iabc,'Iabc')

fprintf('Source currents:\n\n')
iprint(IABC,'IABC')

%Calculating compensator voltages
Vcomp_ab = Vreg_abc_LL(1)/NPT;
vprint(Vcomp_ab,'Vcomp_ab')
Vcomp_cb = -Vreg_abc_LL(2)/NPT;
vprint(Vcomp_cb,'Vcomp_cb')
Icomp_a = Iabc(1)/CT;
iprint(Icomp_a,'Icomp_a')
Icomp_c = Iabc(3)/CT;
iprint(Icomp_c,'Icomp_c')

%Calculating relay voltages
Vrelay_ab = Vcomp_ab - (Rab_ohm+j*Xab_ohm)*Icomp_a;
vprint(Vrelay_ab,'Vrelay_ab')
Vrelay_cb = Vcomp_cb - (Rcb_ohm+j*Xcb_ohm)*Icomp_c;
vprint(Vrelay_cb,'Vrelay_cb')



% % Resetting regulator matrices 
% 
% for i = 1:1:3
% 
%     if sign(tap(i,1))
% 
%         ar(i,1) = 1-stepPct*tap(i,1);
%     else
%         ar(i,1) = 1+stepPct*tap(i,1);
%     end
% 
% end 
% 
% %Generalized constants
% areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
% breg = zeros(3,3);
% creg = zeros(3,3);
% dreg = areg^-1;
% Areg = areg^-1;
% Breg = zeros(3,3);
% 
% %Running the ladder technique again with the updated tap settings
% EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
% Start = [0;0;0];
% Tol = 0.00001;
% 
% Iabc = Start;
% Vload_abc_old = Start;
% kVLN = 12.47/sqrt(3);
% 
% for n = 1:1:200
%     
%     Vreg_abc = Areg*EABC-Breg*Iabc;
%     Vload_abc = Aline*Vreg_abc-Bline*Iabc;
%     Iabc = conj((SL*1000)./Vload_abc);
%     Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);
% 
%     if max(Error) < Tol
%         break
%     end
% 
%     Vload_abc_old = Vload_abc;
%     V120 = Vload_abc/NPT;
%     IABC = dreg*Iabc;
% 
% end
% 
% Vout = Areg*EABC;
% Iout = dreg^-1*IABC; 
% Vreg = Vout/NPT;
% Icomp = Iout/CT;
% Vrelay = Vreg - Zcomp*Icomp;
% vprint(Vrelay,'Vrelay')
% 
% fprintf('\nRelay voltages:\n\n')
% vprint(Vrelay,'Vrelay')
% fprintf('\nUpdated load voltages on 120 volt base:\n\n')
% vprint(V120,'V120')
% 
% 
% %Running again with a new voltage setpoint of 122 volts
% 
% %Resetting generalized constants
% ar = ones(3,1);
% areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
% breg = zeros(3,3);
% creg = zeros(3,3);
% dreg = areg^-1;
% Areg = areg^-1;
% Breg = zeros(3,3);
% 
% %Running the ladder technique again with the regulator 
% EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
% Start = [0;0;0];
% Tol = 0.00001;
% 
% Iabc = Start;
% Vload_abc_old = Start;
% kVLN = 12.47/sqrt(3);
% 
% for n = 1:1:200
%     
%     Vreg_abc = Areg*EABC-Breg*Iabc;
%     Vload_abc = Aline*Vreg_abc-Bline*Iabc;
%     Iabc = conj((SL*1000)./Vload_abc);
%     Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);
% 
%     if max(Error) < Tol
%         break
%     end
% 
%     Vload_abc_old = Vload_abc;
%     V120 = Vload_abc/NPT;
%     IABC = dreg*Iabc;
% 
% end
% 
% Zcomp = (R+j*X)/5;
% Vout = Areg*EABC;
% Iout = dreg^-1*IABC;
% 
% 
% %Compensator voltages and currents
% Vreg = Vout/NPT;
% Icomp = Iout/CT;
% 
% %Calculating relay voltage
% Zcomp = [Zcomp 0 0;0 Zcomp 0;0 0 Zcomp];
% Vrelay = Vreg - Zcomp*Icomp;
% 
% %Defining new voltqage regulation settings
% Vset = 122;
% 
% %Calculating new tap position
% Vlow = Vset-band/2;
% tap = round((Vlow -abs(Vrelay))/Vstep);
% fprintf('\nChanging voltage setpoint to 122 volts:\n\n')
% fprintf('\nNew tap Settings:\n\n')
% fprintf('Tap a = %.0f\n',tap(1))
% fprintf('Tap b = %.0f\n',tap(2))
% fprintf('Tap c = %.0f\n\n',tap(3))
% 
% % Resetting regulator matrices 
% 
% for i = 1:1:3
% 
%     if sign(tap(i,1))
% 
%         ar(i,1) = 1-stepPct*tap(i,1);
%     else
%         ar(i,1) = 1+stepPct*tap(i,1);
%     end
% 
% end 
% 
% %Generalized constants
% areg = [ar(1,1) 0 0;0 ar(2,1) 0;0 0 ar(3,1)];
% breg = zeros(3,3);
% creg = zeros(3,3);
% dreg = areg^-1;
% Areg = areg^-1;
% Breg = zeros(3,3);
% 
% %Running the ladder technique again with the updated tap settings
% EABC = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
% Start = [0;0;0];
% Tol = 0.00001;
% 
% Iabc = Start;
% Vload_abc_old = Start;
% kVLN = 12.47/sqrt(3);
% 
% for n = 1:1:200
%     
%     Vreg_abc = Areg*EABC-Breg*Iabc;
%     Vload_abc = Aline*Vreg_abc-Bline*Iabc;
%     Iabc = conj((SL*1000)./Vload_abc);
%     Error = abs(abs(Vload_abc)-abs(Vload_abc_old))/(kVLN*1000);
% 
%     if max(Error) < Tol
%         break
%     end
% 
%     Vload_abc_old = Vload_abc;
%     V120 = Vload_abc/NPT;
%     IABC = dreg*Iabc;
% 
% end
% 
% Vout = Areg*EABC;
% Iout = dreg^-1*IABC; 
% Vreg = Vout/NPT;
% Icomp = Iout/CT;
% Vrelay = Vreg - Zcomp*Icomp;
% 
% fprintf('\nNew load voltages:\n\n')
% vprint(V120,'V120')
% fprintf('\nNew relay voltages:\n\n')
% vprint(Vrelay,'Vrelay')
% 
% 
% 
% 
