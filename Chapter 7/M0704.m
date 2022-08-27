%Distribution System Modelling and Analysis, Example 7.4
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);
U = eye(3,3);

%Regulator ratings
Vs_rated = 2400;
NPT = Vs_rated/120;
Irated  = 5000/(sqrt(3)*4.16);

%Sicne Irated is just under 700 amps, we will set the CT primary current
%rating to 700 amps
Iprimary = 700;
CT = Iprimary/5;

%Defining the impedance to the load center 
R = 0.3;
X = 0.9;

%Caculating the compensator setting in volts
Rprime = R*Iprimary/NPT;
Xprime = X*Iprimary/NPT;

fprintf('Compensator Settings:')
fprintf('\n\nR''+ jX'' = %.1f + j%.1f V\n\n',Rprime,Xprime )


%Calculating compensator impedance values in ohms
Rohms = Rprime/5;
Xohms = Xprime/5;


fprintf('Compensator Resistance and Reactance:')
fprintf('\n\nR + jX = %.1f + j%.1f ohms\n\n',Rohms,Xohms )