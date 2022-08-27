%Distribution System Modelling and Analysis, Example 8.2
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

%Defining the constant power load
kVA = [1700;1200;1500], PF = [0.9;0.85;0.95];

SL = kVA.*exp(j.*acos(PF))
sprint(SL,'SL')

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

%Initializing power flow program variables
Start = [0;0;0]
ELLABC = [115e3*exp(j*0*deg);115e3*exp(j*-120*deg);115e3*exp(j*120*deg)]
Tol=0.000001;
VM = 12.47e3/sqrt(3);

%Initializing currents and voltages
Iabc = Start;
Iload_abc = Start;
Vold = Start;
ELNABC = W*ELLABC;

%Running the power flow program
for n = 1:1:200
    V2LNabc = At*ELNABC-Bt*Iabc;
    V3LNabc = Aline*V2LNabc-Bline*Iload_abc;
    Iload_abc = conj(SL.*1000./V3LNabc);
    Error = abs(V3LNabc-Vold)/VM;
        if max(Error) < Tol
            break 
        end 
    Vold = V3LNabc;
    Iabc = dline*Iload_abc;
    IABC = dt*Iabc;
end 

    Vload120 = V3LNabc*120/7200;


vprint(V3LNabc,'V3LNabc')
vprint(Vload120,'V120abc')
vprint(V2LNabc,'V2LNabc')
iprint(Iabc,'Iabc')
iprint(IABC,'IABC')
fprintf('\nThe solution took a total of %.0f iterations to converge\n\n',n)

%Adjusting taps
Tap = round(abs(119-abs(Vload120))./0.75);
fprintf('The calculated tap settings are:\n\n')
tapprint(Tap)
Vload120_test = Vload120.*(1+0.00625.*Tap);

%Incredmenting phase b by 1 because it is still too low
Tap(2) = Tap(2)+1;

aR = 1-0.00625*Tap;
Areg = U.*1./aR;
dreg = Areg;
Breg =zeros(3,3)

%Initializing regulator current
Ireg = Start;

%Initializing currents and voltages
Iabc = Start;
Iload_abc = Start;
Vold = Start;
ELNABC = W*ELLABC;

%Running the power flow program
for n = 1:1:200
    VRabc = At*ELNABC-Bt*Ireg;
    V2LNabc = Areg*VRabc-Breg*Iabc;
    V3LNabc = Aline*V2LNabc-Bline*Iabc;
    Iabc = conj(SL.*1000./V3LNabc);
    Error = abs(V3LNabc-Vold)/VM;
        if max(Error) < Tol
            break 
        end 
    Vold = V3LNabc;
    Ireg = dreg*Iabc;
    IABC = dt*Ireg;
end 

Vload120 = V3LNabc*120/7200;

fprintf('With the voltage regulator tap positions set to %.0f, %.0f, and %.0f\n')
fprintf('the new voltages and currents are:\n\n')
vprint(V3LNabc,'V3LNabc')
vprint(Vload120,'V120abc')
vprint(V2LNabc,'V2LNabc')
iprint(Iabc,'Iabc')
iprint(IABC,'IABC')
fprintf('\nThe solution took a total of %.0f iterations to converge\n\n',n)

