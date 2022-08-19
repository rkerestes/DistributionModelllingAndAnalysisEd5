%Distribution System Modelling and Analysis, Example 6.5
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

a = U+Zabc*Yabc/2;

% Rounding to four decimal places
a = round(a,4)
a11 = a(1:1:3,1:1:3)
a12 = a(1:1:3,4:1:6)
a21 = a(4:1:6,1:1:3)
a22 = a(4:1:6,4:1:6)

b = Zabc;
b11 = b(1:1:3,1:1:3)
b12 = b(1:1:3,4:1:6)
b21 = b(4:1:6,1:1:3)
b22 = b(4:1:6,4:1:6)

c = Yabc+1/4*Yabc*Zabc*Yabc
c11 = c(1:1:3,1:1:3)
c12 = c(1:1:3,4:1:6)
c21 = c(4:1:6,1:1:3)
c22 = c(4:1:6,4:1:6)

d = a;

A = a^-1;
A11 = A(1:1:3,1:1:3)
A12 = A(1:1:3,4:1:6)
A21 = A(4:1:6,1:1:3)
A22 = A(4:1:6,4:1:6)

B = a^-1*b;
B11 = B(1:1:3,1:1:3)
B12 = B(1:1:3,4:1:6)
B21 = B(4:1:6,1:1:3)
B22 = B(4:1:6,4:1:6)

%Defining the load currents
IR1 = [102.6*exp(j*-20.4*deg);82.1*exp(j*-145.2*deg);127.8*exp(j*85.2*deg)];
IR2 = [94.4*exp(j*-27.4*deg);127.4*exp(j*-152.5*deg);100.2*exp(j*99.8*deg)];

%Defining source voltage
VS1 = 14400*[1;exp(j*-120*deg);exp(j*120*deg)];
VS2 = VS1;

VS = [VS1;VS2];
IR = [IR1;IR2];

VR = A*VS-B*IR;
VR1 = VR(1:1:3,1)
VR2 = VR(4:1:6,1)

[VR1_mag,VR1_phase] = rec2pol(VR1);
[VR2_mag,VR2_phase] = rec2pol(VR2);

fprintf('\n\n')
fprintf('Line 1:\n\n')
fprintf('\t\t%.0f < %.1f\n',VR1_mag(1),VR1_phase(1))
fprintf('[VR1] =\t\t%.0f < %.1f\t volts \n',VR1_mag(2),VR1_phase(2))
fprintf('\t\t%.0f < %.1f\n\n',VR1_mag(3),VR1_phase(3))

fprintf('\n\n')
fprintf('Line 2:\n\n')
fprintf('\t\t%.0f < %.1f\n',VR2_mag(1),VR2_phase(1))
fprintf('[VR2] =\t\t%.0f < %.1f\t volts \n',VR2_mag(2),VR2_phase(2))
fprintf('\t\t%.0f < %.1f\n\n',VR2_mag(3),VR2_phase(3))