%Distribution System Modelling and Analysis, Example 6.8
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(6,6);
deg = pi/180;

%Loading phase impedance and admittance matrices from examples 4.4 and 5.2
%respectively
load('zabc_0404.mat')
load('yabc_0502.mat')

dist = 10;

Zabc = zabc*dist;
Yabc = yabc*10^-6*dist; 

Z11 = Zabc(1:1:3,1:1:3)
Z12 = Zabc(1:1:3,4:1:6)
Z21 = Zabc(4:1:6,1:1:3)
Z22 = Zabc(4:1:6,4:1:6)

ZX = Z11-Z12-Z21+Z22
Zeq = (Z11-Z12)*ZX^-1*(Z22-Z12)+Z12

VR = [13280*exp(j*-33.1*deg);14040*exp(j*-151.7*deg);14147*exp(j*86.5*deg)];
S1 = [1450*exp(j*acos(0.95));1150*exp(j*acos(0.90));1750*exp(j*acos(0.85))];
S2 = [1320*exp(j*acos(0.9));1700*exp(j*acos(0.85));1360*exp(j*acos(0.95))];
S = S1+S2;
IR = conj(S*1000./VR);

VS = VR+Zeq*IR

[VS_mag,VS_phase] = rec2pol(VS);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',VS_mag(1),VS_phase(1))
fprintf('[VS] =\t\t%.1f < %.1f\t volts \n',VS_mag(2),VS_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',VS_mag(3),VS_phase(3))

