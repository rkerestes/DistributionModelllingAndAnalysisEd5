%Distribution System Modelling and Analysis, Example 9.11
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];

%Defining the transformer impedances and admittance
Zpu = 0.038*exp(j*55*deg);


%Defining the transformer ratings
V1_rated = 2400;
V2_rated = 240;
kVA_rated = 25;

%Calculating the turns ratio
nt = V1_rated/V2_rated;

%Caculating the equivalent impedance referred to the low side
Zbase = V2_rated^2/(kVA_rated*1000);
Zt = Zpu*Zbase;

%Calculating the generalized constants
a = nt;
b = nt*Zt;
c = 0;
d = 1/nt;
A = 1/nt;
B = Zt;

%Line ratings and impedance model for a 4 AWG copper cable
GMR = 0.00663;
R = 1.503;
zline = R+0.0953+j*0.12134*(log(1/GMR)+7.93402);
dist = 100;
Zline = zline*dist*feet;

%Operating voltage on the low side of the transformer
Et = V2_rated;

%Setting the ZIP real power coefficients
kpp = -0.1773;
kzp = 0.1824;
kip = 0.9949;

%Setting the ZIP reactive power coeficients
kpq = 4.993;
kzq = 8.917;
kiq = -12.91;

%Power factor correction circuitry maintains power factor of 95%
pf = 0.95;
Vrated = 240;
Irated = 42;

%Calculating the ZIP powers
Sload = 10/0.9*exp(j*acos(0.9));
sprint(Sload,'Sload')

%Charging kVA
Schg= Vrated*Irated*exp(j*acos(pf))/1000;
sprint(Schg,'Schg')
Pchg = real(Schg);
Qchg = imag(Schg);

PPchg = Pchg*kpp;
PZchg = Pchg*kzp;
PIchg = Pchg*kip;


QZchg = Qchg*kzq;
QIchg = Qchg*kiq;
QPchg = Qchg*kpq;

SPchg = PPchg+j*QPchg;
SZchg = PZchg+j*QZchg;
SIchg = PIchg+j*QIchg;

SP = Sload + SPchg;
sprint(SP,'SP')
SZ = SZchg;
sprint(SZ,'SZ')
SI = SIchg;
sprint(SI,'SI')


%Assume nominal voltage
Vchg = 240;
delta = angle(Vchg);

Ipq = conj(SP*1000/Vchg);
iprint(Ipq,'Ipq')

Zchg = Vchg^2/conj(SZ*1000);

Ichg_i_mag = abs(SI*1000)/Vchg;
imagprint(Ichg_i_mag,'Ichg_i_mag')
pf_i = PIchg/abs(SI);

%initializing variables
start = 0;
Vchg_old = start;
Itotal = start;
tol = 0.001;

for n = 1:1:5
    Vchg = Et - (Zt+Zline)*Itotal;
    Ipq = conj(SP*1000/Vchg);
    Ichg_i = Ichg_i_mag*exp(j*(angle(Vchg)+acos(pf_i)));
    Ichg_z = Vchg/Zchg;
    Itotal = Ipq+Ichg_z+Ichg_i;
    iprint(Ipq,'Ipq')
    iprint(Ichg_i,'Ichg_i')
    iprint(Ichg_z,'Ichg_z')
    iprint(Itotal,'Ichg')
    vprint(Vchg,'Vchg')
    Error = abs(abs(Vchg)-abs(Vchg_old))/Et;
    if tol > Error 
        break
    end
    Vchg_old = Vchg;

end 


iprint(Ipq,'Ipq')
iprint(Ichg_i,'Ichg_i')
iprint(Ichg_z,'Ichg_z')
iprint(Itotal,'Ichg')
vprint(Vchg,'Vchg')

Vrop = (abs(V2_rated)-abs(Vchg))/V2_rated*100

Sxfmr = abs(Itotal)*abs(Et);
fprintf('Sxfmr = \n\n')
disp(Sxfmr/1000)

