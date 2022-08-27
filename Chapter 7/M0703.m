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

%Per unit calculations for two winding transformer connection 
Ybase_two_wind = kVAxfmr*1000/V1_rated^2;
Ypu_two_wind = Ym/Ybase_two_wind;

fprintf('\n\nTwo winding per unit calculations:\n\n')
fprintf('Ybase = %.3f\n',Ybase_two_wind)
fprintf('Ypu = %.6f-j%.6f\n',real(Ypu_two_wind),imag(Ypu_two_wind))

%Calculating the turns ratio
nt = V1_rated/V2_rated;

%Per unit calculations for autotransformer connection 
kVAauto = (1+nt)*kVAxfmr;
Vs_auto = V1_rated;
VL_auto = V1_rated+V2_rated;

Ybase_auto = kVAauto*1000/Vs_auto^2;
Ypu_auto = Ym/Ybase_auto;

fprintf('\n\nAutotransformer per unti calculations:\n\n')
fprintf('Ybase = %.4f\n',Ybase_auto)
fprintf('Ypu = %.6f-j%.6f\n',real(Ypu_auto),imag(Ypu_auto))

%Calculating the ratio between the two methods
ratio = abs(Ypu_auto)/abs(Ypu_two_wind)
