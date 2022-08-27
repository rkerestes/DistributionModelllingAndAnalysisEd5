%Distribution System Modelling and Analysis, Example 8.4
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
Di = [1 0 -1;-1 1 0;0 -1 1];



%%% Reusing code from example 8.3 to calculate the generalized matrices %%%
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
%%% Ending copied code from example 8.3 %%%

%Initializing power flow program variables
Start = [0;0;0];
Tol=0.000001;
VM = 240;


%Loading the voltages from example 8.3
load('VLLABC_0803.mat')

%Initializing currents and voltages
Iabc = Start;
Vold = Start;

VLNABC = W*VLLABC;

%Running the power flow program
for n = 1:1:200
    VLNabc = At*VLNABC-Bt*Iabc;
    VLLabc = Dv*VLNabc;
    IDabc = conj(SDabc*1000./VLLabc);
    Error = abs(VLLabc-Vold)/VM;
        if max(Error) < Tol
            break 
        end 
    Vold = VLLabc;
    Iabc = Di*IDabc;
    IABC = dt*Iabc;
end 

    vprint(VLNabc,'VLNabc')
    vprint(VLLabc,'VLLabc')
    iprint(Iabc,'Iabc')
    iprint(IABC,'IABC')
    fprintf('\nThe solution took a total of %.0f iterations to converge\n\n',n)

