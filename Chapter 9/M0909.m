%Distribution System Modelling and Analysis, Example 9.9
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
t = 1/sqrt(3)*exp(j*30*deg);
T = [1 0 0;0 conj(t) 0;0 0 t];


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
Ym = 1/Zm;
%%%%%%%%%%%%%%%%%%%%%%%%%% End Example 9.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VLLabc = [480*exp(j*0*deg);490*exp(j*-121.37*deg);475*exp(j*118.26*deg)];
Vsabc = W*VLLabc;
load('Isabc_M0903.mat')
load('Vrabc_M0903.mat')

Zs012 = [0 0 0;0 Zs 0;0 0 Zs];
Zr012 = [0 0 0;0 Zr 0;0 0 Zr];
Ym012 = [0 0 0;0 Ym 0;0 0 Ym];
s1 = 0.035;
s2 = 2 - s1;
s12 = [s1;s2];

Zrabc = A*Zr012*A^-1;
Zsabc = A*Zs012*A^-1;
Ymabc = A*Ym012*A^-1;

%Generalized constants
Amabc = U + Zsabc*Ymabc;
Bmabc = Zsabc + Zrabc + Zsabc*Ymabc*Zrabc;
Cmabc = Ymabc;
Dmabc = U + Ymabc*Zrabc;

Ethabc = (Amabc-Bmabc*Dmabc^-1*Cmabc)*Vrabc;
vprint(Ethabc,'Ethabc')

Zthabc = Bmabc*Dmabc^-1;

EthLLabc = Dv*Ethabc;
vprint(EthLLabc,'EthLLabc')

ZthLL = Dv*Zthabc;

VmLLabc = EthLLabc + ZthLL*Isabc;
vprint(VmLLabc,'VmLLabc')