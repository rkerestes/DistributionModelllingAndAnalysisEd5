%Distribution System Modelling and Analysis, Example 9.1
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];

load('zabc_0601.mat');
dist = 10000;
Zabc = zabc*dist*feet;

%Defininig the complex powers
kVA_an = 2240; pf_an = 0.85;
kVA_bn = 2500; pf_bn = 0.95;
kVA_cn = 2000; pf_cn = 0.90;
theta_abc = [acos(pf_an);acos(pf_bn);acos(pf_cn)];

Sabc = [kVA_an*exp(j*acos(pf_an));kVA_bn*exp(j*acos(pf_bn));kVA_cn*exp(j*acos(pf_cn))];

%Defining combination load percentages
P_pct = 0.5;
Z_pct = 0.2;
I_pct = 0.3; 

%Assuming source voltages
ELNabc = 7200*[1;exp(j*-120*deg);exp(i*120*deg)];


%Setting initial current to zero
Iabc = zeros(3,1);

fprintf('\nIteration 1:\n\n')
%iteration 1
VLNabc = ELNabc - Zabc*Iabc;
delta_abc = angle(VLNabc);
vprint(VLNabc,'VLN')

%Calculating the assigned complex power for each part of the combination
%load

SP = Sabc*P_pct;
SZ = Sabc*Z_pct;
SI = Sabc*I_pct;

%Calculating individual components
IP = conj(SP*1000./VLNabc);
iprint(IP,'Ipq')

Z = abs(VLNabc).^2./conj(SZ*1000);
IZ = VLNabc./Z;
iprint(IZ,'Iz')

II_mag = abs(conj((SI*1000)./VLNabc));
II = II_mag.*exp(i*(delta_abc-theta_abc));
iprint(II,'II')

%Total load current
Iabc = IP + IZ + II;
iprint(Iabc,'Iabc')

Sabc = VLNabc.*conj(Iabc)/1000;
sprint(Sabc, 'Sabc')

fprintf('\n\nIteration 2:\n\n')
%iteration 2
VLNabc = ELNabc - Zabc*Iabc;
delta_abc = angle(VLNabc);
vprint(VLNabc,'VLN')

%Calculating individual components
IP = conj(SP*1000./VLNabc);
iprint(IP,'Ipq')

IZ = VLNabc./Z;
iprint(IZ,'Iz')

II = II_mag.*exp(i*(delta_abc-theta_abc));
iprint(II,'II')

%Total load current
Iabc = IP + IZ + II;
iprint(Iabc,'Iabc')

Sabc = VLNabc.*conj(Iabc)/1000;
sprint(Sabc, 'Sabc')