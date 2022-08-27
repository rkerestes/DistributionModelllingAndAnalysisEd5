%Distribution System Modelling and Analysis, Example 8.7
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

%Setting transformer ratings, 
kVA_rated = [100;50;50]; 
VH_rated = [7200;7200;7200];
VX_rated = [240;240;240];
Zt_pu = [0.01+j*0.04;0.015+j*0.035;0.015+j*0.035];


%Calculating the transformer base and impedance in ohms
Zbase = VX_rated.^2./(kVA_rated*1000);
Zt = diag(Zt_pu.*Zbase);
Ztab = Zt(1,1);
Ztbc = Zt(2,2);

%Turns ratio matrices for voltage and current, for open-wye open-delta
nt = 7200/240;
AV = nt*[1 0 0;0 1 0;0 0 0];
AI = 1/nt*[1 0 0;0 1 0;0 0 1];

%Generalized matrix calculations
at = AV*Dv;
bt = AV*[Ztab 0 0;0 0 -Ztbc;0 0 0];
dt = 1/nt*[1 0 0;0 0 -1;0 0 0]

%Calculating BV and Ztabc matrices
BV = 1/nt*[1 0 0;0 1 0;-1 -1 0];
Ztabc = [Ztab 0 0;0 0 -Ztbc;-Ztab 0 Ztbc];

At = W*BV;
Bt = W*Ztabc;

%%% Ending copied code from example 8.3 %%%

%Initializing power flow program variables
Start = [0;0;0];
Tol=0.000001;
VLL = 12470;
VM = 240

%Loading the voltages from example 8.3
VLLABC = [VLL*exp(j*30*deg);VLL*exp(j*-90*deg);VLL*exp(j*150*deg)];

%Initializing currents and voltages
Iabc = Start;
Vold = Start;

VLGABC = W*VLLABC;

%Running the power flow program
for n = 1:1:200
    VLNabc = At*VLGABC-Bt*Iabc;
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

%Calculating voltage ubalance
Vavg = mean(abs(VLLabc));
dV = abs(Vavg-abs(VLLabc));
Vunbalance = max(dV)/Vavg*100;

    vprint(VLNabc,'VLNabc')
    vprint(VLLabc,'VLLabc')
    iprint(Iabc,'Iabc')
    iprint(IABC,'IABC')
    fprintf(['\nThe solution took a total of %.0f iterations to converge, and ' ...
        'the system voltage unbalance is %.3f%%\n\n'],n,Vunbalance)

