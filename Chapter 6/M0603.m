%Distribution System Modelling and Analysis, Example 6.3
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
deg = pi/180;
a = exp(j*120*deg);


%Defining short circuit currents
If3 = 5677.7*exp(j*-82.7*deg)
If1 = 4430.0*exp(j*-80.2*deg)

%Defining the nominal voltage
VLL = 115e3;
VLG = VLL/sqrt(3);

%Calculating the sequence impedances
Z1 = VLG/If3
Zeq = 3*VLG/If1
Z0 = Zeq-2*Z1

%Formulating the sequence impedance matrix
Z012 = [Z0 0 0;0 Z1 0;0 0 Z1]

%Calculating the sequence transformation matrix
As = [1 1 1;1 a^2 a;1 a a^2];

%Calculating the phase impedance matrix 
Zabc = As*Z012*As^-1


% fprintf('\n\n')
% fprintf('\t\t%.2f < %.2f\n',VLGm_mag(1),VLGm_phase(1))
% fprintf('[VLG]m =\t%.2f < %.2f\t volts \n',VLGm_mag(2),VLGm_phase(2))
% fprintf('\t\t%.2f < %.2f\n',VLGm_mag(3),VLGm_phase(3))
% 
% 
% fprintf('\n\n')
% fprintf('Vaverage = \t%.2f \tvolts \n',Vaverage)

