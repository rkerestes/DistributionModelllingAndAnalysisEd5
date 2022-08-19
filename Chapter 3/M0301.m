%Distribution System Modelling and Analysis, Example 3.1
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);

%Defining the phase conductor data
phase.GMR = 0.0244;
phase.resistance = 0.306;

%Defining the spacings between conductors

Dab = 2.5; Dbc = 4.5; Dca = 7;

%Computing the equivalent spacing

Deq = (Dab*Dbc*Dca)^(1/3);

%Using equation 3.4
            
zline = phase.resistance+j*0.12134*log(Deq/phase.GMR);


disp('The equivalent spacing in feet is')
display(Deq)

disp('The line impedance in ohms/mile for this line is')
display(zline)