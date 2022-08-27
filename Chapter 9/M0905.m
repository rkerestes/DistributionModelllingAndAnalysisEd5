%Distribution System Modelling and Analysis, Example 9.5
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);
U = eye(3,3);
deg = pi/180;
feet = 1/5280;
W = 1/3*[2 1 0;0 2 1;1 0 2];
Dv = [1 -1 0;0 1 -1;-1 0 1];
DI = [1 0 -1;-1 1 0;0 -1 1];
a = exp(j*120*deg);
A = [1 1 1;1 a^2 a;1 a a^2];
t = 1/sqrt(3)*exp(j*30*deg);
T = [1 0 0;0 conj(t) 0;0 0 t];


%%%%%%%%%%%%%%%%%%%%%%%%%% From Example 9.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VLLabc = [480*exp(j*0*deg);490*exp(j*-121.37*deg);475*exp(j*118.26*deg)];
vprint(VLLabc,'VLLabc')

Isabc = [110*exp(j*-55*deg);126.6*exp(j*179.7*deg);109.8*exp(j*54.6*deg)];

Vavg = mean(abs(VLLabc));
vmagprint(Vavg,'Vavg')

devv = abs(abs(VLLabc)-Vavg);
Vunbalance = max(devv)/Vavg*100;

fprintf('The voltage unbalance for this motor is %.2f %%\n\n',Vunbalance)

Iavg = mean(abs(Isabc));
imagprint(Iavg,'Iavg')

devi = abs(abs(Isabc)-Iavg);
Iunbalance = max(devi)/Iavg*100;

fprintf('The current unbalance for this motor is %.2f %%\n\n',Iunbalance)