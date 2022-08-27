%Distribution System Modelling and Analysis, Example 8.8
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
VH_rated = [12470;12470;12470];
VX_rated = [240;240;240];
Zt_pu = [0.01+j*0.04;0.015+j*0.035;0.015+j*0.035];

%Calculating the transformer base and impedance in ohms
Zbase = VX_rated.^2./(kVA_rated*1000);
Ztabc = diag(Zt_pu.*Zbase);

%Calculating F, G1 matrices
F = [1 0 -1;-1 1 0;Ztabc(1,1) Ztabc(2,2) Ztabc(3,3)];
G = F^-1;
G1 = [G(1:1:3,1:1:2) zeros(3,1)];

%Turns ratio matrices for voltage and current, for delta-delta
nt = 12470/240;
AV = nt*U;
AI = 1/nt*U;

%Generalized matrix calculations
at = W*AV*Dv;
bt = AV*W*Ztabc*G1;
dt = AI;
At = W*AV^-1*Dv;
Bt = W*Ztabc*G1;





%%% Ending copied code from example 8.3 %%%

%Initializing power flow program variables
Start = [0;0;0];
Tol= 0.000001;
VLL = 12470;
VM = 240;

%Loading the voltages from example 8.3
VLLABC = [VLL*exp(j*30*deg);VLL*exp(j*-90*deg);VLL*exp(j*150*deg)];

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

