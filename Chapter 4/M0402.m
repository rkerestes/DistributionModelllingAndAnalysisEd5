%Distribution System Modelling and Analysis, Example 4.2
%Written by William Kersting and Robert Kerestes
clear

%Loading the phase impedance matrix from Example 4.1
load('zabc_0401.mat')

j = sqrt(-1);

length = 5000;
Zabc = zabc*length/5280;

Tol = 0.0001;
start = [0;0;0];

Iabc = start;
Vold = start;
error = start;
Vdrop = start;

SL = [5000e3*exp(j*acos(0.85));5000e3*exp(j*acos(0.85));5000e3*exp(j*acos(0.85))];
Es = [12.47e3/sqrt(3);12.47e3/sqrt(3)*exp(-j*2*pi/3);12.47e3/sqrt(3)*exp(j*2*pi/3)];

for n = 1:1:30
    
    VLabc = Es-Zabc*Iabc;
    
    for i = 1:1:3
        error(i) = abs(abs(VLabc(i))-abs(Vold(i)));
    end
    
    Err = max(error);
    if Err < Tol
        break
    end
    
    Vold = VLabc;
    
    for i = 1:1:3
        
        Iabc(i) = SL(i)/VLabc(i);
        
    end
    
    for i = 1:1:3
        
        Vdrop(i) = abs(abs(Es(i))-abs(VLabc(i)))/abs(Es(i));
        
    end
    
end

[VLabc_mag, VLabc_phase] = rec2pol(VLabc);
[Iabc_mag, Iabc_phase] = rec2pol(Iabc);

display(n)
display(VLabc_mag)
display(VLabc_phase)
display(Iabc_mag)
display(Iabc_phase)
display(Vdrop)



