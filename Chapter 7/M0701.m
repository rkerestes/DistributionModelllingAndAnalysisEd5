%Distribution System Modelling and Analysis, Example 7.1
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3)

%Defining the transformer impedances and admittance
Z1 = 0.612 + j*1.2;
Z2 = 0.0061 + j*0.0115;
Ym = 1.92e-4 - j*8.52e-4;

%Defining the transformer ratings
V1_rated = 2400;
V2_rated = 240;
kVA_rated = 75;

%Calculating the turns ratio
nt = V1_rated/V2_rated;

%Caculating the equivalent impedance referred to the low side
Zt = Z2+Z1/nt^2;

%Calculating the generalized constants
a = nt;
b = nt*Zt;
c = nt*Ym;
d = nt*(Ym*Zt+1/nt^2);
A = 1/nt;
B = Zt;

fprintf('Generalized Constants:')
fprintf('\n\na = %.0f\n\n',a)
fprintf('\n\nb = %.4f + j%.4f ohms\n\n',real(b),imag(b))
fprintf('\n\nc = %.4f - j%.4f S\n\n',real(c),abs(imag(c)))
fprintf('\n\nd = %.4f - j%.4f\n\n',real(d),abs(imag(d)))
fprintf('\n\nA = %.1f\n\n',A)
fprintf('\n\nB = %.4f + j%.4f ohms\n\n',real(B),imag(B))

%Defining the load voltage and current
pf_L = 0.9; %load power factor
VL = V2_rated;
I2 = kVA_rated*1000/V2_rated*exp(-j*acos(pf_L));
[I2_mag,I2_phase] = rec2pol(I2);
fprintf('\n\nI2 = %.1f < %.2f amps\n\n',I2_mag,I2_phase)


%Calculating the sending end voltag and current
Vs = a*VL+b*I2;
Is = c*VL+d*I2;

[Vs_mag,Vs_phase] = rec2pol(Vs);
[Is_mag,Is_phase] = rec2pol(Is);

fprintf('\n\nSending end voltage and current:\n\n')
fprintf('\n\nVs = %.1f < %.2f volts\n\n',Vs_mag,Vs_phase)
fprintf('\n\nIs = %.1f < %.2f amps\n\n',Is_mag,Is_phase)


%Check by using the computed sending end voltage and cu
VL_check = A*Vs-B*I2;
[VL_check_mag,VL_check_phase] = rec2pol(VL_check);

fprintf('\n\nChecking using sending end voltage and load current:\n\n')
fprintf('\n\nVL = %.1f < %.2f volts\n\n',VL_check_mag,VL_check_phase)

%Calculating per-unit impedance and admittance
Z2base = V2_rated^2/(kVA_rated*1000);
Zt_pu = Zt/Z2base;
[Zt_pu_mag,Zt_pu_phase] = rec2pol(Zt_pu);

Y1base = (kVA_rated*1000)/V1_rated^2;
Ym_pu = Ym/Y1base;
[Ym_pu_mag,Ym_pu_phase] = rec2pol(Ym_pu);

fprintf('\n\nPer-unit impedance and admittance:\n\n')
fprintf('\n\nZt_pu = %.4f < %.2f pu\n\n',Zt_pu_mag,Zt_pu_phase)
fprintf('\n\nYm_pu = %.4f-j%.4f pu\n\n',real(Ym_pu),abs(imag(Ym_pu)))

