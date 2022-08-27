%Distribution System Modelling and Analysis, Example 9.2
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];

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

Ym = 1/Zm