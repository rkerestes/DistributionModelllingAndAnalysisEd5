%Distribution System Modelling and Analysis, Example 3.5
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

Zline = [0.1739+j*0.3564;0.1449+j*0.3970;0.1159+j*0.2376;0.2028+j*0.4158]
SL = [0;500+j*300;825+j*400;800+j*500;475+j*275]

%Initializing variables
Tol = 0.0001
start = zeros(5,1)
Vs = 7200; 

%Maximum iterations
maxit = 20;

V_old = start;
IL = start;
I = start;
V = start;
Error = 1000*ones(5,1);
Error(1) = 0;

V(1) = Vs

for n = 1:1:maxit
    
    for k = 2:1:5
    
        V(k)= V(k-1)-Zline(k-1)*I(k-1);
        Error(k) = abs(abs(V(k))-abs(V_old(k)))/Vs;
        V_old(k) = V(k);

    end
    
    Emax = max(Error);
    
    if Emax < Tol
        break
    end
    
    for i = 5:-1:2
        
        IL(i) = conj(SL(i)*1000/V(i));
        I(i-1) = IL(i)+I(i);
        
    end
end 

fprintf('Total iterations = %d',n)

%Compute the load current using last iteration voltage:
[V_mag,V_phase] = rec2pol(V)
[Iline_mag,Iline_phase] = rec2pol(I)
[IL_mag,IL_phase] = rec2pol(IL)

Vrop = abs(V_mag(1)-V_mag(5))/V_mag(1)*100