%Distribution System Modelling and Analysis, Example 6.7
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(6,6);
deg = pi/180;

%Loading phase impedance and admittance matrices from examples 4.4 and 5.2
%respectively
load('zabc_0404.mat')
load('yabc_0502.mat')

length = 10;

Zabc = zabc*length;
Yabc = yabc*10^-6*length; 



VR = [13280*exp(j*-33.1*deg);14040*exp(j*-151.7*deg);14147*exp(j*86.5*deg)];
S1 = [1450*exp(j*acos(0.95));1150*exp(j*acos(0.90));1750*exp(j*acos(0.85))];
S2 = [1320*exp(j*acos(0.9));1700*exp(j*acos(0.85));1360*exp(j*acos(0.95))];
S = S1+S2;
IR = conj(S*1000./VR);
[IR_mag,IR_phase] = rec2pol(IR);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',IR_mag(1),IR_phase(1))
fprintf('[IR] =\t\t%.1f < %.1f\t amps \n',IR_mag(2),IR_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',IR_mag(3),IR_phase(3))

a = U+Zabc*Yabc/2;

% Rounding to four decimal places
a = round(a,4);
a11 = a(1:1:3,1:1:3);
a12 = a(1:1:3,4:1:6);
a21 = a(4:1:6,1:1:3);
a22 = a(4:1:6,4:1:6);

b = Zabc;
b11 = b(1:1:3,1:1:3);
b12 = b(1:1:3,4:1:6);
b21 = b(4:1:6,1:1:3);
b22 = b(4:1:6,4:1:6);

c = Yabc+1/4*Yabc*Zabc*Yabc;
c11 = c(1:1:3,1:1:3);
c12 = c(1:1:3,4:1:6);
c21 = c(4:1:6,1:1:3);
c22 = c(4:1:6,4:1:6);

d = a;
d11 = d(1:1:3,1:1:3);
d12 = d(1:1:3,4:1:6);
d21 = d(4:1:6,1:1:3);
d22 = d(4:1:6,4:1:6);
d = a;

A = a^-1;
A11 = A(1:1:3,1:1:3);
A12 = A(1:1:3,4:1:6);
A21 = A(4:1:6,1:1:3);
A22 = A(4:1:6,4:1:6);

B = a^-1*b;
B11 = B(1:1:3,1:1:3);
B12 = B(1:1:3,4:1:6);
B21 = B(4:1:6,1:1:3);
B22 = B(4:1:6,4:1:6);

Aa = a11+a12-a21-a22
Bb = b12-b22;
Cc = b21-b22-b11+b12

IR1 = Cc^-1*(Aa*VR+Bb*IR)

[IR1_mag,IR1_phase] = rec2pol(IR1);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',IR1_mag(1),IR1_phase(1))
fprintf('[IR1] =\t\t%.1f < %.1f\t amps \n',IR1_mag(2),IR1_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',IR1_mag(3),IR1_phase(3))


IR2 = IR-IR1

[IR2_mag,IR2_phase] = rec2pol(IR2);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',IR2_mag(1),IR2_phase(1))
fprintf('[IR2] =\t\t%.1f < %.1f\t amps \n',IR2_mag(2),IR2_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',IR2_mag(3),IR2_phase(3))

VS1 = (a11+a12)*VR+b11*IR1+b12*IR2;

[VS1_mag,VS1_phase] = rec2pol(VS1);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',VS1_mag(1),VS1_phase(1))
fprintf('[VS1] =\t\t%.1f < %.1f\t volts \n',VS1_mag(2),VS1_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',VS1_mag(3),VS1_phase(3))

VS2 = (a21+a22)*VR+b21*IR1+b22*IR2;

[VS2_mag,VS2_phase] = rec2pol(VS2);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',VS2_mag(1),VS2_phase(1))
fprintf('[VS2] =\t\t%.1f < %.1f\t volts \n',VS2_mag(2),VS2_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',VS2_mag(3),VS2_phase(3))

IS1 = (c11+c12)*VR+d11*IR1+d12*IR2;

[IS1_mag,IS1_phase] = rec2pol(IS1);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',IS1_mag(1),IS1_phase(1))
fprintf('[IS1] =\t\t%.1f < %.1f\t amps \n',IS1_mag(2),IS1_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',IS1_mag(3),IS1_phase(3))

IS2 = (c21+c22)*VR+d21*IR1+d22*IR2;

[IS2_mag,IS2_phase] = rec2pol(IS2);

fprintf('\n\n')
fprintf('\t\t%.1f < %.1f\n',IS2_mag(1),IS2_phase(1))
fprintf('[IS2] =\t\t%.1f < %.1f\t amps \n',IS2_mag(2),IS2_phase(2))
fprintf('\t\t%.1f < %.1f\n\n',IS2_mag(3),IS2_phase(3))