%Distribution System Modelling and Analysis, Example 8.3
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
Di = [1 0 -1;-1 1 0;0 -1 1];

%Defining the load power ratings
kVADabc = [100;50;50]; PF = [0.9;0.8;0.8];
SDabc = kVADabc.*exp(j.*acos(PF));

%Setting transformer ratings
kVA_rated = [100;50;50]; 
VH_rated = [7200;7200;7200];
VX_rated = [240;240;240];
Zt_pu = [0.01+j*0.04;0.015+j*0.035;0.015+j*0.035];

%Calculating the transformer base and impedance in ohms
Zbase = VX_rated.^2./(kVA_rated*1000);
Ztabc = diag(Zt_pu.*Zbase);
nt = 7200/240;
L =1/3*[1 -1 0;1 2 0;-2 -1 0];
AV = nt*U;
AI = 1/nt*U;
ZNtabc = Ztabc*AI^-1;


dt = AI*L;
at = AV*Dv;
bt = AV*ZNtabc*dt;
ct = zeros(3,3);
At = W*AV^-1;
Bt = W*ZNtabc*dt;

%Defining line-to-line load voltages
VLLabc = [240;240*exp(j*-120*deg);240*exp(j*+120*deg)];

%Calculating delta load currents:
IDabc = conj(SDabc.*1000./VLLabc);
iprint(IDabc,'IDabc')

%Converting to line currents:
Iabc = Di*IDabc;
iprint(Iabc,'Iabc')

%Compute equivalent line-to-neutral voltages
VLNabc = W*VLLabc;
vprint(VLNabc,'VLNabc')

%COm;uting primary voltages:
VLNABC = at*VLNabc+bt*Iabc;
vprint(VLNABC,'VLNABC')

VLLABC = Dv*VLNABC;
vprint(VLLABC,'VLLABC')

%Calculating the primary currrents:
IABC = dt*Iabc;
iprint(IABC,'IABC')

%Calculating transformer power
ST = VLNABC.*conj(IABC)/1000;
sprint(ST,'ST')
PF = cos(angle(ST));