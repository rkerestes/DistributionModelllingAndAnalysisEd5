%Distribution System Modelling and Analysis, Example 9.3
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];
a = exp(j*120*deg);
A = [1 1 1;1 a^2 a;1 a a^2];


%%%%%%%%%%%%%%%%%%%%%%%%%% From Example 9.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Machine ratings
kVA = 150; VLL = 480; Pfw = 3.25;
Zs_pu = 0.0651+j*0.1627;
Zr_pu = 0.0553+j*0.1139;
Zm_pu = j*4.069;

kVA1 = kVA/3;
kVLL = 480/1000;
kVLN = kVLL/sqrt(3);

%Calculating base valeuds for Y connection
IYbase = kVA1/kVLN;
ZYbase = kVLN*1000/IYbase;

%Calculating Y connected impedance in ohms
Zs = Zs_pu*ZYbase;
Zr = Zr_pu*ZYbase;
Zm = Zm_pu*ZYbase;

%Calculating base valeuds for detla connection
IDbase = kVA1/kVLL;
ZDbase = kVLL*1000/IDbase;

%Calculating Y connected impedance in ohms
ZDs = Zs_pu*ZDbase;
ZDr = Zr_pu*ZDbase;
ZDm = Zm_pu*ZDbase;

Ym = 1/Zm;
%%%%%%%%%%%%%%%%%%%%%%%%%% End Example 9.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s1 = 0.035;
s2 = 2 - s1;

s12 = [s1;s2];
RL12 = real(Zr).*(1-s12)./s12;
Zs12 = [Zs;Zs];
Zr12 = [Zr;Zr];
Zm12 = [Zm;Zm];
Zin12 = Zs12+(Zm12.*(Zr12+RL12))./(Zm12+Zr12+RL12);

VLLabc = [480*exp(j*0*deg);490*exp(j*-121.37*deg);475*exp(j*118.26*deg)];
vprint(VLLabc,'VLLabc')

Vsabc = W*VLLabc;
vprint(Vsabc,'Vsabc')

Vs012 = A^-1*Vsabc;
vprint(Vs012,'Vs012')

Vs12 = Vs012(2:1:3);
vprint(Vs12,'Vs12')

Is12 = Vs12./Zin12;
iprint(Is12,'Is12')

Vm12 = Vs12 - Zs12.*Is12;
vprint(Vm12,'Vm12')

Im12 = Vm12./Zm12;
iprint(Im12,'Im12')

Ir12 = Is12 - Im12;
iprint(Ir12,'Ir12')

Is012 = [0;Is12];
Ir012 = [0;Ir12];

Isabc = A*Is012;
iprint(Isabc,'Isabc')

Irabc = A*Ir012;
iprint(Irabc,'Irabc')

Vr12 = Ir12.*RL12;
vprint(Vr12,'Vr12')

Vr012 = [0;Vr12];
vprint(Vr012,'Vr012')

Vrabc = A*Vr012;
vprint(Vrabc,'Vrabc')

Ssabc = Vsabc.*conj(Isabc)/1000;
sprint(Ssabc,'Ssabc')

Sstotal = sum(Ssabc);
sprint(Sstotal,'Sstotal')

Srabc = Vrabc.*conj(Irabc)/1000;
sprint(Srabc,'Srabc')

Srtotal = sum(Srabc);
sprint(Srtotal,'Srtotal')

Ploss = real(Sstotal)-real(Srtotal);
pprint(Ploss,'Ploss')
