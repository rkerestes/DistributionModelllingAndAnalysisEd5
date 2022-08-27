%Distribution System Modelling and Analysis, Example 7.2
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3);

%Defining the transformer impedances and admittance
Z1 = 0.612 + j*1.2;
Z2 = 0.0061 + j*0.0115;
Ym = 1.92e-4 - j*8.52e-4;

%Defining the transformer ratings
V1_rated = 2400;
V2_rated = 240;
kVAxfmr = 75;

%Calculating the turns ratio
nt = V1_rated/V2_rated;

%Calculating autotransformer ratings
kVAauto = (1+nt)*kVAxfmr;
Vs_auto = V1_rated;
VL_auto = V1_rated+V2_rated;

fprintf('Autotransformer ratings:\n\n')
fprintf('kVAauto = %.0f\n',kVAauto)
fprintf('Vs_auto = %.0f\n',Vs_auto)
fprintf('VL_auto = %.0f\n',VL_auto)

%Caculating the equivalent impedance referred to the low side
Zt = Z2+Z1/nt^2;

%Calculating load current at rated conditions with 0.9 pf lagging
VL = VL_auto;
pfL = 0.9;
IL = kVAauto*1000/VL*exp(-j*acos(pfL));
[VL_mag,VL_phase] = rec2pol(VL);
[IL_mag,IL_phase] = rec2pol(IL);
fprintf('\n\nLoad voltage and current:\n\n')
fprintf('VL = %.1f < %.2f volts\n\n',VL_mag,VL_phase)
fprintf('IL = %.1f < %.2f amps\n\n',IL_mag,IL_phase)


%Calculating the generalized constants
a = nt/(nt+1);
b = nt/(nt+1)*Zt;
c = nt/(nt+1)*Ym;
d = nt/(nt+1)*Ym*Zt+(nt+1)/nt;
A = 1/a;
B = b/a;

fprintf('Generalized Constants:')
fprintf('\n\na = %.3f\n\n',a)
fprintf('\n\nb = %.4f + j%.4f ohms\n\n',real(b),imag(b))
fprintf('\n\nc = %.4f - j%.4f S\n\n',real(c),abs(imag(c)))
fprintf('\n\nd = %.4f + j%.0f\n\n',real(d),abs(imag(d)))
fprintf('\n\nA = %.1f\n\n',A)
fprintf('\n\nB = %.4f + j%.4f ohms\n\n',real(B),imag(B))

%Calculating the sending end voltag and current
Vs = a*VL+b*IL;
Is = c*VL+d*IL;

[Vs_mag,Vs_phase] = rec2pol(Vs);
[Is_mag,Is_phase] = rec2pol(Is);

fprintf('\n\nSending end voltage and current:\n\n')
fprintf('Vs = %.1f < %.2f volts\n\n',Vs_mag,Vs_phase)
fprintf('Is = %.1f < %.2f amps\n\n',Is_mag,Is_phase)


%Check by using the computed sending end voltage and cu
VL_check = A*Vs-B*IL;
[VL_check_mag,VL_check_phase] = rec2pol(VL_check);

fprintf('\n\nChecking using sending end voltage and load current:\n\n')
fprintf('\n\nVL = %.1f < %.2f volts\n\n',VL_check_mag,VL_check_phase)

%modifying the generalized constants so that Ym and Zt are set to zero
a_mod = a;
b_mod = 0;
c_mod = 0;
d_mod = (nt+1)/nt;

Vs_mod = a_mod*VL+b_mod*IL;
Is_mod = c_mod*VL+d_mod*IL;
[Vs_mod_mag,Vs_mod_phase] = rec2pol(Vs_mod);
[Is_mod_mag,Is_mod_phase] = rec2pol(Is_mod);

fprintf('\n\nSending end voltag and current with modified constants:\n\n')
fprintf('Vs = %.1f < %.2f volts\n\n',Vs_mod_mag,Vs_mod_phase)
fprintf('Is = %.1f < %.2f amps\n\n',Is_mod_mag,Is_mod_phase)

Errorv = (Vs_mag-Vs_mod_mag)/Vs_mag*100;
Errori = (Is_mag-Is_mod_mag)/Is_mag*100;

fprintf('\n\nError when using modified constants:\n\n')
fprintf('Voltage error = %.2f%%\n\n',Errorv)
fprintf('Current error = %.2f%%\n\n',Errori)
