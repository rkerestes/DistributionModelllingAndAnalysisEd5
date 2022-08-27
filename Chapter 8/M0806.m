%Distribution System Modelling and Analysis, Example 8.6
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

%Turns ratio matrices for voltage and current
nt = 7200/240;
AV = nt*U;
AI = 1/nt*U;

%Setting the grounding impedance
Zg = 5;
ZG = Zg*ones(3,3);

%Calculating the F and G matrices 
F = [1 0 -1;-1 1 0;nt*Ztabc(1,1)+3/nt*Zg nt*Ztabc(2,2)+3/nt*Zg nt*Ztabc(3,3)+3/nt*Zg];
G = F^-1

%Calculating the G1 and G2 matrices
G1 = [G(1,3) G(1,3) G(1,3);G(2,3) G(2,3) G(2,3);G(3,3) G(3,3) G(3,3)];
G2 = [G(1:1:3,1:1:2) zeros(3,1)]

%Calculating the xt and dt matrices
xt = AI*G1;
dt = AI*G2;

%Calculating the X1 matrix
X1 = Ztabc*AI^-1+AV^-1*ZG;

%Calculating the At and Bt matrices
At = W*(AV^-1-X1*xt);
Bt = W*X1*dt;


% at = AV*Dv;
% bt = AV*ZNtabc*dt;


%Initializing power flow program variables
Start = [0;0;0];
Tol=0.000001;
VM = 12470;


%Loading the voltages from example 8.3
VLLABC = [VM*exp(j*30*deg);VM*exp(j*-90*deg);VM*exp(j*150*deg)];

%Defining the load power ratings
kVADabc = [100;50;50]; PF = [0.9;0.8;0.8];
SDabc = kVADabc.*exp(j.*acos(PF));


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
    IABC = xt*VLNABC+dt*Iabc;
end 


%Calculating voltage ubalance
Vavg = mean(abs(VLLabc));
dV = abs(Vavg-abs(VLLabc));
Vunbalance = max(dV)/Vavg*100;

%Calculating ground current
Ig = -sum(IABC);




    vprint(VLNabc,'VLNabc')
    vprint(VLLabc,'VLLabc')
    iprint(Iabc,'Iabc')
    iprint(IABC,'IABC')
    iprint(Ig,'Ig')
    fprintf(['\nThe solution took a total of %.0f iterations to converge, and ' ...
        'the system voltage unbalance is %.3f%%\n\n'],n,Vunbalance)

