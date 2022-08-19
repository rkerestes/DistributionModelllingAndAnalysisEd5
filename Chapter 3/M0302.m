%Distribution System Modelling and Analysis, Example 3.2
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);

%The line impedance from Example 3.1 is
zline = 0.30600 + 0.627158i;

%Entering the line length, line-to-neutral voltage.
%and load impedance
Length = 5000; E = 7200;  Zload = 8+j*6;

%Calculate the total line impedance:
Zline = zline*Length/5280;


%Calculate the total current:

IL = E/(Zline+Zload);
[IL_mag,IL_phase] = rec2pol(IL)

%Compute the load voltage:
VL = E - Zline*IL;
vprint(VL,'VL')

%Compute the percent voltage drop
Drop_percent = (E-abs(VL))/E*100