%Distribution System Modelling and Analysis, Example 4.3
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
Zpu1 = 0.03324+j*0.13392;
Zpu0 = 0.10796+j*0.40539;

MVAbase = 100;
kVLLbase = 115;

Zbase = kVLLbase^2/MVAbase;
disp('The impedance base for this sytem in ohms is')
display(Zbase)

Z0 = Zpu0*Zbase;
Z1 = Zpu1*Zbase;
Z2 = Z1;

%Creating the sequence impedance matrix
Z012 = [Z0 0 0;0 Z1 0;0 0 Z2];

disp('The sequence impedance matrix for this sytem in ohms is')
display(Z012)

%Performing the phase transformation
at = exp(j*2*pi/3);
As = [1 1 1;1 at^2 at;1 at at^2];
Zabc =  As*Z012*As^-1;

disp('The phase impedance matrix for this sytem in ohms is')
display(Zabc)