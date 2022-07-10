%Distribution System Modelling and Analysis, Example 2.3
%Written by William Kersting and Robert Kerestes

clear
clc
j = sqrt(-1);

V1 = 2400;

%Defining system variables
pf = 0.9;
zline = 0.3+j*0.6;

%Defining transformer rating structs

%T1 ratings:            %T2 ratings:            %T3ratings:
T1.kVArated = 25;       T2.kVArated = 37.5;     T3.kVArated = 50;
T1.VHrated = 2400;      T2.VHrated = 2400;      T3.VHrated = 2400;
T1.VLrated = 240;       T2.VLrated = 240;       T3.VLrated = 240;
T1.Zpctrated = 1.8;     T2.Zpctrated = 1.9;     T3.Zpctrated = 2.0;
T1.Zanglerated = 40;    T2.Zanglerated = 45;    T3.Zanglerated = 50;    

%Loading max diversified demands calculated in example 2.1
load('lineMaxDiv_0201.mat')
load('maxDiv_0201.mat')

system_kW = [transpose(lineMaxDiv);transpose(maxDiv)];
system_kvar = system_kW*tan(acos(pf));

system_kVA =[system_kW system_kvar];

SysTab = array2table(round(system_kVA,1),'VariableNames',{'kW','kvar'},'RowNames',{'N1-N2','N2-N3','N3-N4','T1','T2','T3'});

fprintf('\n\nSystem Demands:\n\n\n')
disp(SysTab)

%Calculating transformer high side impedances
T1.Zhigh = (T1.Zpctrated/100)*T1.VHrated^2/(T1.kVArated*1000)*exp(j*T1.Zanglerated*pi/180);
T2.Zhigh = (T2.Zpctrated/100)*T2.VHrated^2/(T2.kVArated*1000)*exp(j*T2.Zanglerated*pi/180);
T3.Zhigh = (T3.Zpctrated/100)*T3.VHrated^2/(T3.kVArated*1000)*exp(j*T3.Zanglerated*pi/180);

fprintf('\n\nTransformer 1 ratings:\n\n')
disp(T1)

fprintf('\n\nTransformer 2 ratings:\n\n')
disp(T2)

fprintf('\n\nTransformer 3 ratings:\n\n')
disp(T3)

%Calculating line impedances
feet = 1/5280; %converts feet to miles fo impedance calcs
dist12 = 5000*feet;
dist23 = 500*feet;
dist34 = 750*feet;
Z12 = zline*dist12;
Z23 = zline*dist23;
Z34 = zline*dist34;

fprintf('Line impedances:\n\n')
fprintf('N1-N2: \t Z12 = %.4f+j%.4f ohms\n\n',real(Z12),imag(Z12))
fprintf('N2-N3: \t Z23 = %.4f+j%.4f ohms\n\n',real(Z23),imag(Z23))
fprintf('N3-N4: \t Z34 = %.4f+j%.4f ohms\n\n',real(Z34),imag(Z34))

%Calculating line segment N1-N2 to transformer 1

%Current in N1-N2:
I12 = conj((system_kVA(1,1)+j*system_kVA(1,2))*1000/V1);
[I12_mag,I12_phase] = rec2pol(I12);
fprintf('Current flowing through segment N1-N2:\n\n')
fprintf('\tI12 = %.1f < %.2f amps\n\n',I12_mag,I12_phase)

%Voltage at N2:
V2 = V1-Z12*I12;
[V2_mag,V2_phase] = rec2pol(V2);
fprintf('Voltage at N2:\n\n')
fprintf('\tV2 = %.1f < %.2f volts\n\n',V2_mag,V2_phase)

%Current flowing through T1:
It1 = conj((system_kVA(4,1)+j*system_kVA(4,2))*1000/V2);
[It1_mag,It1_phase] = rec2pol(It1);
fprintf('Current flowing through T1:\n\n')
fprintf('\tIt1 = %.1f < %.2f amps\n\n',It1_mag,It1_phase)

%High side T1 voltage:
VT1 = V2-T1.Zhigh*It1;
[VT1_mag,VT1_phase] = rec2pol(VT1);
fprintf('Voltage at the high side of T1:\n\n')
fprintf('\tVT1 = %.1f < %.2f volts\n\n',VT1_mag,VT1_phase)

%Low side T1 voltage:
VlowT1 = VT1*T1.VLrated/T1.VHrated;
[VlowT1_mag ,VlowT1_phase] = rec2pol(VlowT1 );
fprintf('Voltage at the low side of T1:\n\n')
fprintf('\tVlowT1  = %.1f < %.2f volts\n\n',VlowT1_mag,VlowT1_phase)

%Calculating line segment N2-N3 to transformer 2

%Current in N2-N3:
I23 = conj((system_kVA(2,1)+j*system_kVA(2,2))*1000/V2);
[I23_mag,I23_phase] = rec2pol(I23);
fprintf('Current flowing through segment N2-N3:\n\n')
fprintf('\tI23 = %.1f < %.2f amps\n\n',I23_mag,I23_phase)

%Voltage at N3:
V3 = V2-Z23*I23;
[V3_mag,V3_phase] = rec2pol(V3);
fprintf('Voltage at N3:\n\n')
fprintf('\tV3 = %.1f < %.2f volts\n\n',V3_mag,V3_phase)

%Current flowing through T2:
It2 = conj((system_kVA(5,1)+j*system_kVA(5,2))*1000/V3);
[It2_mag,It2_phase] = rec2pol(It2);
fprintf('Current flowing through T2:\n\n')
fprintf('\tIt2 = %.1f < %.2f amps\n\n',It2_mag,It2_phase)

%High side T2 voltage:
VT2 = V3-T2.Zhigh*It2;
[VT2_mag,VT2_phase] = rec2pol(VT2);
fprintf('Voltage at the high side of T2:\n\n')
fprintf('\tVT2 = %.1f < %.2f volts\n\n',VT2_mag,VT2_phase)

%Low side T2 voltage:
VlowT2 = VT2*T2.VLrated/T1.VHrated;
[VlowT2_mag ,VlowT2_phase] = rec2pol(VlowT2);
fprintf('Voltage at the low side of T2:\n\n')
fprintf('\tVlowT2  = %.1f < %.2f volts\n\n',VlowT2_mag,VlowT2_phase)

%Calculating line segment N3-N4 to transformer 3

%Current in N3-N4:
I34 = conj((system_kVA(3,1)+j*system_kVA(3,2))*1000/V3);
[I34_mag,I34_phase] = rec2pol(I34);
fprintf('Current flowing through segment N3-N4:\n\n')
fprintf('\tI34 = %.1f < %.2f amps\n\n',I34_mag,I34_phase)

%Voltage at N3:
V4 = V3-Z34*I34;
[V4_mag,V4_phase] = rec2pol(V4);
fprintf('Voltage at N4:\n\n')
fprintf('\tV4 = %.1f < %.2f volts\n\n',V4_mag,V4_phase)

%Current flowing through T3:
It3 = conj((system_kVA(6,1)+j*system_kVA(6,2))*1000/V4);
[It3_mag,It3_phase] = rec2pol(It3);
fprintf('Current flowing through T3:\n\n')
fprintf('\tIt3 = %.1f < %.2f amps\n\n',It3_mag,It3_phase)

%High side T2 voltage:
VT3 = V4-T3.Zhigh*It3;
[VT3_mag,VT3_phase] = rec2pol(VT3);
fprintf('Voltage at the high side of T3:\n\n')
fprintf('\tVT3 = %.1f < %.2f volts\n\n',VT3_mag,VT3_phase)

%Low side T2 voltage:
VlowT3 = VT3*T3.VLrated/T3.VHrated;
[VlowT3_mag ,VlowT3_phase] = rec2pol(VlowT3);
fprintf('Voltage at the low side of T3:\n\n')
fprintf('\tVlowT3  = %.1f < %.2f volts\n\n',VlowT3_mag,VlowT3_phase)

%Calculating voltage drop from N1-VT3
Vdrop = (V1-VT3_mag)/V1*100;
fprintf('Voltage drop from N1 to the high side of T3:\n\n')
fprintf('\tVdrop = %.4f %%\n\n',Vdrop)