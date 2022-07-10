%Distribution System Modelling and Analysis, Example 2.4
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
load('kVA_rated_0201.mat')

system_kW = [transpose(lineMaxDiv);transpose(maxDiv)];
system_kvar = system_kW*tan(acos(pf));

S12 = 92.5/(pf)*exp(j*acos(pf));
[S12_mag,S12_phase] = rec2pol(S12);

fprintf('Metered demand at N1:\n\n')
fprintf('\tS12 = %.1f + j%.1f = %.1f < %.2f kVA\n\n',real(S12),imag(S12),S12_mag,S12_phase)

AF = S12/sum(kVA_rated);
[AF_mag,AF_phase] = rec2pol(AF);
fprintf('Allocation factor: \n\n')
fprintf('\tAF = %.4f < %.2f\n\n',AF_mag,AF_phase)

ST1 = AF*kVA_rated(1);
[ST1_mag,ST1_phase] = rec2pol(ST1);
ST2 = AF*kVA_rated(2);
[ST2_mag,ST2_phase] = rec2pol(ST2);
ST3 = AF*kVA_rated(3);
[ST3_mag,ST3_phase] = rec2pol(ST3);

fprintf('Transformer Demands: \n\n')
fprintf('\tST1 = %.1f + j%.1f = %.1f < %.2f kVA\n\n',real(ST1),imag(ST1),ST1_mag,ST1_phase)
fprintf('\tST2 = %.1f + j%.1f = %.1f < %.2f kVA\n\n',real(ST2),imag(ST2),ST2_mag,ST2_phase)
fprintf('\tST3 = %.1f + j%.1f = %.1f < %.2f kVA\n\n',real(ST3),imag(ST3),ST3_mag,ST3_phase)

%Calculating the line flows
S12 = ST1+ST2+ST3;
S23 = ST2+ST3;
S34 = ST3;

fprintf('Line Flows: \n\n')
fprintf('\tS12 = %.1f + j%.1f kVA\n\n',real(S12),imag(S12))
fprintf('\tS23 = %.1f + j%.1f kVA\n\n',real(S23),imag(S23))
fprintf('\tS34 = %.1f + j%.1f kVA\n\n',real(S34),imag(S34))

%Initializing system variables
system_kVA = [real(S12) imag(S12);real(S23) imag(S23);real(S34) imag(S34);real(ST1) imag(ST1);real(ST2) imag(ST2);real(ST3) imag(ST3)];
V1 = 2400;

%Calculating transformer high side impedances
T1.Zhigh = (T1.Zpctrated/100)*T1.VHrated^2/(T1.kVArated*1000)*exp(j*T1.Zanglerated*pi/180);
T2.Zhigh = (T2.Zpctrated/100)*T2.VHrated^2/(T2.kVArated*1000)*exp(j*T2.Zanglerated*pi/180);
T3.Zhigh = (T3.Zpctrated/100)*T3.VHrated^2/(T3.kVArated*1000)*exp(j*T3.Zanglerated*pi/180);



%Calculating line impedances
feet = 1/5280; %converts feet to miles fo impedance calcs
dist12 = 5000*feet;
dist23 = 500*feet;
dist34 = 750*feet;
Z12 = zline*dist12;
Z23 = zline*dist23;
Z34 = zline*dist34;


fprintf('\n\nLine Voltages:\n\n')
%Current in N1-N2:
I12 = conj((system_kVA(1,1)+j*system_kVA(1,2))*1000/V1);
[I12_mag,I12_phase] = rec2pol(I12);


%Voltage at N2:
V2 = V1-Z12*I12;
[V2_mag,V2_phase] = rec2pol(V2);
fprintf('\tV2 = %.1f < %.2f volts\n\n',V2_mag,V2_phase)

%Current flowing through T1:
It1 = conj((system_kVA(4,1)+j*system_kVA(4,2))*1000/V2);
[It1_mag,It1_phase] = rec2pol(It1);


%High side T1 voltage:
VT1 = V2-T1.Zhigh*It1;
[VT1_mag,VT1_phase] = rec2pol(VT1);


%Low side T1 voltage:
VlowT1 = VT1*T1.VLrated/T1.VHrated;
[VlowT1_mag ,VlowT1_phase] = rec2pol(VlowT1 );
fprintf('\tVlowT1  = %.1f < %.2f volts\n\n',VlowT1_mag,VlowT1_phase)

%Calculating line segment N2-N3 to transformer 2

%Current in N2-N3:
I23 = conj((system_kVA(2,1)+j*system_kVA(2,2))*1000/V2);
[I23_mag,I23_phase] = rec2pol(I23);


%Voltage at N3:
V3 = V2-Z23*I23;
[V3_mag,V3_phase] = rec2pol(V3);
fprintf('\tV3 = %.1f < %.2f volts\n\n',V3_mag,V3_phase)

%Current flowing through T2:
It2 = conj((system_kVA(5,1)+j*system_kVA(5,2))*1000/V3);
[It2_mag,It2_phase] = rec2pol(It2);


%High side T2 voltage:
VT2 = V3-T2.Zhigh*It2;
[VT2_mag,VT2_phase] = rec2pol(VT2);


%Low side T2 voltage:
VlowT2 = VT2*T2.VLrated/T1.VHrated;
[VlowT2_mag ,VlowT2_phase] = rec2pol(VlowT2);
fprintf('\tVlowT2  = %.1f < %.2f volts\n\n',VlowT2_mag,VlowT2_phase)

%Calculating line segment N3-N4 to transformer 3

%Current in N3-N4:
I34 = conj((system_kVA(3,1)+j*system_kVA(3,2))*1000/V3);
[I34_mag,I34_phase] = rec2pol(I34);


%Voltage at N3:
V4 = V3-Z34*I34;
[V4_mag,V4_phase] = rec2pol(V4);
fprintf('\tV4 = %.1f < %.2f volts\n\n',V4_mag,V4_phase)

%Current flowing through T3:
It3 = conj((system_kVA(6,1)+j*system_kVA(6,2))*1000/V4);
[It3_mag,It3_phase] = rec2pol(It3);


%High side T2 voltage:
VT3 = V4-T3.Zhigh*It3;
[VT3_mag,VT3_phase] = rec2pol(VT3);


%Low side T2 voltage:
VlowT3 = VT3*T3.VLrated/T3.VHrated;
[VlowT3_mag ,VlowT3_phase] = rec2pol(VlowT3);
fprintf('\tVlowT3  = %.1f < %.2f volts\n\n',VlowT3_mag,VlowT3_phase)

%Calculating voltage drop from N1-VT3
Vdrop = (V1-VT3_mag)/V1*100;
fprintf('Voltage drop from N1 to the high side of T3:\n\n')
fprintf('\tVdrop = %.4f %%\n\n',Vdrop)