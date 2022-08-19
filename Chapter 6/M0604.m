%Distribution System Modelling and Analysis, Example 6.4
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3);
deg = pi/180;

%Loading the b matrix from example 6.1
load('b_0601.mat')


%Computing the approximate A and B matrices
A = U;
B = b;


%Defining the unbalanced load complex powers
SL = [2500*exp(j*acos(0.9));2000*exp(j*acos(0.85));1500*exp(j*acos(0.95))];

%Defining the source voltages
Eabc = 12.47e3/sqrt(3)*[1;exp(j*-120*deg);exp(j*120*deg)];

%Initializing variables
Start = [0;0;0];
Tol = 0.00001;

Iabc = Start;
VLGm_old = Start;
kVLN = 12.47/sqrt(3);

for n = 1:1:200
    
    VLGm = A*Eabc-B*Iabc;
    Iabc = conj((SL*1000)./VLGm);
    Error = abs(abs(VLGm)-abs(VLGm_old))/(kVLN*1000);

    if max(Error) < Tol
        break
    end

    VLGm_old = VLGm;

end

[VLGm_mag,VLGm_phase] = rec2pol(VLGm);
[Iabc_mag,Iabc_phase] = rec2pol(Iabc);

fprintf('\n\n')
fprintf('Total iterations = %.0f \n',n)


fprintf('\n\n')
fprintf('\t\t%.2f < %.2f\n',VLGm_mag(1),VLGm_phase(1))
fprintf('[VLG]m =\t%.2f < %.2f\t volts \n',VLGm_mag(2),VLGm_phase(2))
fprintf('\t\t%.2f < %.2f\n\n',VLGm_mag(3),VLGm_phase(3))


fprintf('\t\t%.2f < %.2f\n',Iabc_mag(1),Iabc_phase(1))
fprintf('[Iabc] =\t%.2f < %.2f\t amps \n',Iabc_mag(2),Iabc_phase(2))
fprintf('\t\t%.2f < %.2f\n',Iabc_mag(3),Iabc_phase(3))