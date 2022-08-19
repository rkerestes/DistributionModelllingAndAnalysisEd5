%Distribution System Modelling and Analysis, Example 5.1
%Written by William Kersting and Robert Kerestes
j = sqrt(-1);
f = 60;

%Defining the phase conductor data
phase.GMR = 0.0244;
phase.resistance = 0.306;
phase.diameter = 0.721;
phase.ncond = 3;

%Defining the neutral conductor data
neutral.GMR = 0.00814;
neutral.resistance = 0.592;
neutral.diameter = 0.563;
neutral.ncond = 1;

ncond = phase.ncond+neutral.ncond;

%Initializing matrix sizes
r = zeros(ncond,1);
S = zeros(ncond,ncond);
Pprim = zeros(ncond,ncond);
Dshunt = zeros(ncond,ncond);

%Defining the conductor coordinates
d1 = 0+j*29; d2 = 2.5+j*29; d3 = 7+j*29; d4 = 4+j*25;

%Defining the distance vector d
d = [d1;d2;d3;d4];

%Calculating the inpedance matrix D
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        if i == k && i <= ncond -1
            
            Dshunt(i,k) = phase.diameter/24;
            
        elseif i == k && i > ncond - 1
            
            Dshunt(i,k) = neutral.diameter/24;
            
        else
            
            Dshunt(i,k) = abs(d(i) - d(k));
            
        end
        
    end
    
end

%Calculating the image distance matrix S
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        S(i,k) = abs(d(i)-conj(d(k)));
        
    end
    
end

%Calculating the primitive potential coefficient matrix
for i = 1:1:ncond

    for k = 1:1:ncond
            
            Pprim(i,k) = 11.17689*log(S(i,k)/Dshunt(i,k));  
    end
    
end

%Partitioning Pprim
for i = 1:1:ncond-1

    for k = 1:1:ncond - 1
        
        Pij(i,k) = Pprim(i,k);
    
    end
    
end

for i = 1:1:ncond-1
    
    Pin(i,1) = Pprim(i,4);
    
end

for k = 1:1:ncond-1
    
    Pnj(1,k) = Pprim(4,k);
    
end

Pnn = Pprim(4,4);

%Performing the Kron reduction
Pabc = Pij-Pin*Pnn^-1*Pnj;

%Calculating the phase capacitance matrix
Cabc = Pabc^-1;

%Calculating the shunt admittance matrix
yabc = j*2*pi*f*Cabc;

disp('The image distance matrix in feet for this line is')
display(S)

disp('The primitive impedance matrix in mile/microfarad for this line is')
display(Pprim)

disp('The "Kron" reduced phase potential coefficient matrix in mile/microfarad is ')
display(Pabc)

disp('The phase capacitance matrix in microfarads/mile is ')
display(Cabc)

disp('The shunt admittance matrix in microsiemens/mile is ')
disp(yabc)

% disp('The neutral transformation matrix is')
% display(tn)
% 
% disp('The sequence impedance matrix in ohms/mile is')
% display(z012)