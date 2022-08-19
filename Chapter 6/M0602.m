%Distribution System Modelling and Analysis, Example 6.2
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
Dv = [1 -1 0;0 1 -1;-1 0 1];

%Loading the phase impedance matrix from Example 4.1
load('zabc_0401.mat')

%Loading the neutral transformation matrix from Example 4.1
load('tn_0401.mat')

%Line length in miles 
length = 10000/5280;

Zabc =zabc*length;

VLGn = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];
Iabcn = [249.97*exp(j*-24.5*deg);277.56*exp(j*-145.8*deg);305.54*exp(j*95.2*deg)];


a = U;
b = Zabc;
c = zeros(3,3);
d = a;
A = a;
B = b;

% Calculating load currents
Iabcm = Iabcn;

%Calculating load voltages
VLGm = A*VLGn-B*Iabcm;
[VLGm_mag,VLGm_phase] = rec2pol(VLGm);

%Calculating line to line voltages
VLLm = Dv*VLGm;
[VLLm_mag,VLLm_phase] = rec2pol(VLLm);

%Calculating average load voltage
Vaverage = mean(VLGm_mag);

%Calculating voltage unbalance at the load
dVi = abs(Vaverage*ones(3,1)-VLGm_mag);
Vunbalance = max(dVi/Vaverage)*100;

%Calculating the complex power of the load
Sabcm = 1/1000*(VLGm.*conj(Iabcm));

%Calculating the neutral current
In = tn*Iabcm;
[In_mag,In_phase] = rec2pol(In);

%Calculating the ground current
Ig = -(sum(Iabcm)+In);
[Ig_mag,Ig_phase] = rec2pol(Ig);

fprintf('\n\n')
fprintf('\t\t%.2f < %.2f\n',VLGm_mag(1),VLGm_phase(1))
fprintf('[VLG]m =\t%.2f < %.2f\t volts \n',VLGm_mag(2),VLGm_phase(2))
fprintf('\t\t%.2f < %.2f\n',VLGm_mag(3),VLGm_phase(3))

fprintf('\n\n')
fprintf('\t\t%.2f < %.2f\n',VLLm_mag(1),VLLm_phase(1))
fprintf('[VLL]m =\t%.2f < %.2f\t volts \n',VLLm_mag(2),VLLm_phase(2))
fprintf('\t\t%.2f < %.2f\n',VLLm_mag(3),VLLm_phase(3))

fprintf('\n\n')
fprintf('Vaverage = \t%.2f \tvolts \n',Vaverage)

fprintf('\n\n')
fprintf('\t\t%.2f\n',dVi(1))
fprintf('dVi =\t\t%.2f\t volts\n',dVi(2))
fprintf('\t\t%.2f\n',dVi(3))

fprintf('\n\n')
fprintf('Vunbalance = \t%.4f \t%% \n',Vunbalance)

fprintf('\n\n')
fprintf('\t\t%.2f + j%.2f\n',real(Sabcm(1)),imag(Sabcm(1)))
fprintf('[Sabc]m =\t%.2f + j%.2f\t kW+jkvar\n',real(Sabcm(2)),imag(Sabcm(2)))
fprintf('\t\t%.2f + j%.2f\n',real(Sabcm(3)),imag(Sabcm(3)))

fprintf('\n\n')
fprintf('[In] = \t\t%.2f < %.2f \tamps \n',In_mag,In_phase)

fprintf('\n\n')
fprintf('[Ig] = \t\t%.2f < %.2f \tamps \n',Ig_mag,Ig_phase)