%Distribution System Modelling and Analysis, Example 6.1
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3)

%Loading the phase impedance matrix from Example 4.1
load('zabc_0401.mat')

%Loading the phase admittance matrix from Example 5.1
load('yabc_0501.mat')

%Line length in miles 
length = 10000/5280;

Zabc =zabc*length;
Yabc = yabc*length*10^-6;

a = U+1/2*Zabc*Yabc;
b = Zabc;
c = Yabc+1/4*Yabc*Zabc*Yabc;
d = a;


fprintf('[Zabc] =  ')
fprintf('\n\n')
disp(Zabc)

fprintf('[Yabc] =  ')
fprintf('\n\n')
disp(Yabc*10^6)

fprintf('[a] =  ')
fprintf('\n\n')
disp(round(a,4))

fprintf('[b] =  ')
fprintf('\n\n')
disp(b)

fprintf('[c] =  ')
fprintf('\n\n')
disp(round(c,4))

fprintf('[d] =  ')
fprintf('\n\n')
disp(round(d,4))

fprintf('[a]1,1 =  ')
fprintf('\n\n')
format long
disp(a(1,1))

fprintf('[c]1,1 =  ')
fprintf('\n\n')
format long
disp(c(1,1))

format default

% Part 2, solving for source voltages and currents

% Defining balanced load voltages and complex powers
Vabcm = [12.47e3/sqrt(3);12.47e3/sqrt(3)*exp(j*-120*pi/180);12.47e3/sqrt(3)*exp(j*120*pi/180)];
Sload = 6000e3*exp(j*acos(0.9));
Sabcm = [Sload/3;Sload/3;Sload/3];
Iabcm = conj(Sabcm./Vabcm);
[Iabcm_mag, Iabcm_phase] = rec2pol(Iabcm);
Vabcn = a*Vabcm+b*Iabcm;
[Vabcn_mag, Vabcn_phase] = rec2pol(Vabcn);

fprintf('The load current magnitudes are ')
fprintf('\n\n')
disp(Iabcm_mag)

fprintf('The load current angles are ')
fprintf('\n\n')
disp(Iabcm_phase)

fprintf('The source voltage magnitudes are ')
fprintf('\n\n')
disp(Vabcn_mag)

fprintf('The source voltage angles are ')
fprintf('\n\n')
disp(Vabcn_phase)

% Part 3, determining voltage unbalance
Vabcn_ave = mean(Vabcn_mag);
dV = abs([Vabcn_ave;Vabcn_ave;Vabcn_ave]-Vabcn_mag);
Vunbalance = max(dV)/Vabcn_ave*100;

fprintf('Vaverage =  ')
fprintf('\n\n')
disp(Vabcn_ave)

fprintf('dV =  ')
fprintf('\n\n')
disp(dV)

fprintf('Vunbalance =  ')
fprintf('\n\n')
disp(Vunbalance)

fprintf('[Vabc]n pu =  ')
fprintf('\n\n')
disp(Vabcn_mag/(12.47e3/sqrt(3)))

% Part 4, comparing line currents
Iabcn = c*Vabcm+d*Iabcm;
[Iabcn_mag, Iabcn_phase] = rec2pol(Iabcn);

fprintf('The source current magnitudes are ')
fprintf('\n\n')
disp(Iabcn_mag)

fprintf('The source current angles are ')
fprintf('\n\n')
disp(Iabcn_phase)
