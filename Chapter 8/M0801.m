%Distribution System Modelling and Analysis, Example 8.1
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
Di = [1 -1 0;0 1 -1;-1 0 1];

load('zabc_0401.mat')
L = 10000/5280;
Zline_abc = zabc*L

%Calculating the generalized line matrices
aline = U;
bline = Zline_abc;
cline = zeros(3,3);
dline = U;
Aline = U;
Bline = Zline_abc;

%Setting transformer ratings
kVA_rated = 5000; 
VH_rated = 115e3;
VX_rated = 12.47e3;
Zt_pu = 0.085*exp(j*85*deg);

%Calculating transformer impedance
Zbase = VX_rated^2/(kVA_rated*1000);
Zt = Zt_pu*Zbase;
Ztabc = [Zt 0 0;0 Zt 0;0 0 Zt]

%Defining the unbalanced constant impedance load
Zload_abc = [12+j*6 0 0;0 13+j*4 0;0 0 14+j*5]

VLLABC = [115000;116500*exp(j*-115.5*deg);123538*exp(j*121.7*deg)]
vprint(VLLABC,'VLLABC')

%Determining the transformer generalized matrices
nt = VH_rated/(VX_rated/sqrt(3));
AV = nt*[0 1 0;0 0 1;1 0 0];
AI = 1/nt*[1 0 0;0 1 0;0 0 1]
at = AV*W;
bt = at*Ztabc;
dt = Di*AI
At = AV^-1*Dv
Bt = Ztabc

%Calculating the idea transformer voltages
Vtabc = AV^-1*VLLABC;
vprint(Vtabc,'Vtabc')

%Calculating load currents by making use of linear system
Zeqabc = Ztabc+Zline_abc+Zload_abc;
Iabc = Zeqabc^-1*Vtabc;
iprint(Iabc,'Iabc')

%Determining line-to-ground voltages at the load in volts on a 120 volt
%base.
Vload_abc = Zload_abc*Iabc;
vprint(Vload_abc,'Vload_abc')

Vload120 = Vload_abc*120/(12.47e3/sqrt(3));
vprint(Vload120,'Vload120')

VLGabc = aline*Vload_abc+bline*Iabc;
vprint(VLGabc,'VLGabc')

%Performing the backwards sweep
VLNABC = at*VLGabc+bt*Iabc;
vprint(VLNABC,'VLNABC')

VLLABC = Dv*VLNABC;
vprint(VLLABC,'VLLABC')

%Using forward sweep to calculate transofmer low side voltage
VLGabc = At*VLNABC-Bt*Iabc;
vprint(VLGabc,'VLGabc')
