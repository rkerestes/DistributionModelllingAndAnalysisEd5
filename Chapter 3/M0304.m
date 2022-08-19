%Distribution System Modelling and Analysis, Example 3.4
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

Zline = [0.1739+j*0.3564;0.1449+j*0.3970;0.1159+j*0.2376;0.2028+j*0.4158]
ZL = [99999;75+j*45;50+j*22.5;45+j*25;80+j*42.5]

Vs = 7200; 

V = [7200;7200;7200;7200;7200]
IL = zeros(5,1)
I = zeros(5,1)

for i = 5:-1:2
    
    IL(i)  = V(i)/ZL(i)
    I(i-1) = I(i)+IL(i)
    V(i-1) = V(i)+Zline(i-1)*I(i-1)
    
end 

Ratio = Vs/V(1)

V = V*Ratio;
I = I*Ratio;
IL = IL*Ratio;


%Compute the load current using last iteration voltage:
[V_mag,V_phase] = rec2pol(V)
[Iline_mag,Iline_phase] = rec2pol(I)
[IL_mag,IL_phase] = rec2pol(IL)

Vrop = abs(V_mag(1)-V_mag(5))/V_mag(1)*100