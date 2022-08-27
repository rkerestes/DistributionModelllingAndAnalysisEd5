%Distribution System Modelling and Analysis, Example 9.10
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
Di = [1 0 -1;-1 1 0;0 -1 1];
a = exp(j*120*deg);
A = [1 1 1;1 a^2 a;1 a a^2];
t = 1/sqrt(3)*exp(j*30*deg);
T = [1 0 0;0 conj(t) 0;0 0 t];

%Trasformer ratings and impedance model
kVAt = 50; VHt = 7200; VXt = 480; Ztpu = 0.011+j*0.018;
nt = 7200/480;

Zbase_low = VXt^2/(kVAt*1000);
Zt = Ztpu*Zbase_low;
Ztabc = [Zt 0 0;0 Zt 0;0 0 Zt];

AI = 1/nt*U;
AV = nt*U;

%Line impedance model
Zlabc = [0.1140+j*0.4015 0.0271+j*0.2974 0.0271+j*0.2735;0.0271+j*0.2974...
         0.1140+j*0.4015 0.0271+j*0.2974;0.0271+j*0.2735 0.0271+j*0.2974...
         0.1140+j*0.4015]

%Machine ratings and impedance model
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

Zs012 = [0 0 0;0 Zs 0;0 0 Zs];
Zr012 = [0 0 0;0 Zr 0;0 0 Zr];
Ym012 = [0 0 0;0 Ym 0;0 0 Ym];
s1 = 0.035;
s2 = 2 - s1;
s12 = [s1;s2];

Zrabc = A*Zr012*A^-1;
Zsabc = A*Zs012*A^-1;
Ymabc = A*Ym012*A^-1;

VLLABC = [12470*exp(j*0*deg);11850*exp(j*-118.0*deg);12537*exp(j*123.4*deg)];
VLNABC = W*VLLABC;

Vsabc = [258.1*exp(j*-58.3*deg);259.9*exp(j*-179.0*deg);250.8*exp(j*59.9*deg)];
Vrabc = [224.9*exp(j*-68.3*deg);225.7*exp(j*171.6*deg);227.1*exp(j*51.6*deg)];
Isabc = [118.9*exp(j*-85.7*deg);106.6*exp(j*143.2*deg);94.1*exp(j*35.6*deg)];
Irabc = [110.4*exp(j*-67.3*deg);92.2*exp(j*163.6*deg);88.6*exp(j*58.8*deg)];

Srabc = sum(Vrabc.*conj(Irabc)/1000)


%Generalized constants
Amabc = U + Zsabc*Ymabc;
Bmabc = Zsabc + Zrabc + Zsabc*Ymabc*Zrabc;
Cmabc = Ymabc;
Dmabc = U + Ymabc*Zrabc;

Ethabc = (Amabc-Bmabc*Dmabc^-1*Cmabc)*Vrabc;
vprint(Ethabc,'Ethabc')

Zthabc = Bmabc*Dmabc^-1;


Vsabc = Ethabc + Zthabc*Isabc;
vprint(Vsabc,'Vsabc')

EthABC = AV*Dv*Ethabc;
vprint(EthABC,'EthABC')

IABC = AI*Isabc;
iprint(IABC,'IABC')

Zeqabc = Zthabc+Zlabc
ZthABC = AV*(Dv*Zeqabc*Di+Zthabc)*AI^-1

VLNABC = EthABC + ZthABC*IABC;
vprint(VLNABC,'VLNABC')
