%Distribution System Modelling and Analysis, Example 10.1
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];

%Defining the line impedances
ZeqS = [0.1520+j*0.5353 0.0361+j*0.3225 0.0361+j*0.2752;...
        0.0361+j*0.3225 0.1520+j*0.5353 0.0361+j*0.2955;...
        0.0361+j*0.2752 0.0361+j*0.2955 0.1520+j*0.5353];

ZeqL = [0.2166+j*0.5140 0.0738+j*0.2375 0.0727+j*0.1823;...
        0.0738+j*0.2375 0.2209+j*0.4963 0.0748+j*0.2006;...
        0.0727+j*0.1823 0.0748+j*0.2006 0.2185+j*0.5043];

%Defining the transformer ratings
kVA = 6000;
kVLLS = 12.47;
kVLLL = 4.16;
Zpu = 0.01+j*0.06;

%Defining the load ratings
pfa = 0.85;
pfb = 0.9;
pfc = 0.95;
kVAa = 750;
kVAb = 900;
kVAc = 1100;
Sa = kVAa*exp(j*acos(pfa));
Sb = kVAb*exp(j*acos(pfb));
Sc = kVAc*exp(j*acos(pfc));

%Calculating the coefficient matrices for the lines
A1 = U;
B1 = ZeqS;
d1 = U;

A2 = U;
B2 = ZeqL;
d2 = U;

%Calculating the coefficient matrix for the transformer
Ztlow = Zpu*(kVLLL^2*1000/kVA)
Ztabc = Ztlow*U;
kVLNL = kVLLL/sqrt(3)
nt = kVLLS/kVLNL
At = 1/nt*[1 0 -1;-1 1 0;0 -1 1];
Bt = Ztabc;
dt = 1/nt*[1 -1 0;0 1 -1;-1 0 1]

%Defining the load as a vector
S4 = [Sa;Sb;Sc]

%Defining the sourec voltage
ELLS = [12470*exp(j*pi/6);12470*exp(j*-pi/2);12470*exp(j*5*pi/6)]
ELNS = 1/sqrt(3)*[12470*exp(j*0);12470*exp(j*-2*pi/3);12470*exp(j*2*pi/3)]

vprint(ELLS,'ELLs')
vprint(ELNS,'ELNs')

%Starting the LIT
start = [0;0;0]

Iabc = start
IABC = start 
Vold = start
VM = 4160/sqrt(3)
tol = 0.0001

for n = 1:1:200
    VLN2 = A1*ELNS-B1*IABC;
    VLN3 = At*VLN2-Bt*Iabc;
    VLN4 = A2*VLN3-B2*Iabc;

    error = abs(abs(VLN4)-abs(Vold))/VM;

    if max(error) < tol 
        break 
    end

    Iabc = conj(S4*1000./VLN4);
    Vold = VLN4;
    IABC = dt*Iabc;
    
end 

V4120 = abs(VLN4/VM*120);
vmagprint(V4120,'V4_120')

