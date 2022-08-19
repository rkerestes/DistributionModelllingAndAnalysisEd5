%Distribution System Modelling and Analysis, Example 4.6
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

% Defining resistivity of copper at 20 degrees celsius
rhom20 = 1.7721e-8;

%Defining the concentric neutral conductor data for the first line
ts.dt = 0.89;
ts.GMRc = 0.0111;
ts.rc = 0.97;
ts.T = 5;
ts.ncond = 2;

%Defining additional neutral data
neutral.r = 0.607;
neutral.GMR = 0.0113;
neutral.ncond = 1; 

ncond = ts.ncond+neutral.ncond;

rshield = 4.7963e4/(pi*ts.T*(1000*ts.dt-ts.T));
% Commenting out an alternate version of rshield below
% rshield_alt = ts.rho/(pi*((ts.dt/2-ts.T/1000)*0.0254)^2)*1609.34

GMRshield = (ts.dt/2-ts.T/1000)/12;

%Initializing matrix sizes
r = zeros(ncond,1);
D = zeros(ncond,ncond);
zprim = zeros(ncond,ncond);

% Defining the distance vector d, conductors and tape shield are given the 
% same coordinates
d = [0+j*0;0+j*0;3/12+j*0];

% Defining the distance from the conductor to the tape shield
Dcs = (ts.dt/2 - ts.T/2000)/12;


% Defining the resistance vector r
for i = 1:1:ncond
    
    if i <= ts.ncond/2 
        
        r(i) = ts.rc;
    
    elseif i > ts.ncond/2 && i <= ts.ncond
        
        r(i) = rshield;
        
    else 
        
        r(i) = neutral.r;
        
    end 
        
end

 
% Calculating the inpedance matrix D
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        if i == k && i <= ts.ncond/2 
            
            D(i,k) = ts.GMRc;
            
        elseif i == k && i > ts.ncond/2 && i <= ts.ncond
            
            D(i,k) = GMRshield;
            
        elseif i == k && i > ts.ncond
            
            D(i,k) = neutral.GMR;
            
        elseif abs(d(i)-d(k)) == 0 %Checks conductor to tape shield dist

            D(i,k) = Dcs;

        else 
            
            D(i,k) = abs(d(i) - d(k));
            
        end
        
    end
    
end

% Calculating the primitive impedance matrix
for i = 1:1:ncond

    for k = 1:1:ncond
       
        if i == k
            
            zprim(i,k) = r(i)+0.0953+j*0.12134*(log(1/D(i,k))+7.93402);
            
        else
            
            zprim(i,k) = 0.0953+j*0.12134*(log(1/D(i,k))+7.93402);
            
        end
          
    end
    
end


% Partitioning Zprim
for i = 1:1:ts.ncond/2

    for k = 1:1:ts.ncond/2
        
        zij(i,k) = zprim(i,k);
    
    end
    
end

for i = 1:1:ts.ncond/2
    
   for k = 1:1:ts.ncond/2+neutral.ncond
    
    zin(i,k) = zprim(i,ts.ncond/2+k);
    
    end
    
end

for i = 1:1:ts.ncond/2+neutral.ncond
    
   for k = 1:1:ts.ncond/2
    
    znj(i,k) = zprim(ts.ncond/2+i,k);
    
    end
    
end

for i = 1:1:ts.ncond/2+neutral.ncond
    
   for k = 1:1:ts.ncond/2+neutral.ncond
       
    znn(i,k) = zprim(ts.ncond/2+i,ts.ncond/2+k);

   end
   
end

% Performing the Kron reduction
zabc = zij-zin*znn^-1*znj;
zabc = [0 0 0;0 zabc 0;0 0 0]

% Calculating the neutral transformation matrix 
tn = -(znn^-1*znj);

% Performing the sequence transformation
% at = exp(j*2*pi/3);
% As = [1 1 1;1 at^2 at;1 at at^2];
% z012 =  As^-1*zabc*As;

disp('rshield = ') 
fprintf('\n')
disp(rshield)

disp('GMRshield = ') 
fprintf('\n')
disp(GMRshield)

fprintf('The distance from conductor to tape shield is\n\n')
disp('D12 = ') 
fprintf('\n')
disp(Dcs)


fprintf('The distance matrix is ')
disp('D = ') 
fprintf('\n')
disp(D)

 
fprintf('The primitive impedance matrix in ohms/mile for this line is ')
disp('zprim = ')
fprintf('\n')
disp(zprim)

disp('In partioned form, the submatrices in ohms/mile are')
fprintf('\n')
disp('[zij] = ')
fprintf('\n')
disp(zij)
disp('[zin] = ')
fprintf('\n')
disp(zin)
disp('[znj] = ')
fprintf('\n')
disp(znj)
disp('[znn] = ')
fprintf('\n')
disp(znn)

disp('The "Kron" reduced phase impedance matrix in ohms/mile is ')
fprintf('\n')
disp('[zabc] = ')
fprintf('\n')
disp(zabc)

% disp('The sequence impedance matrix in ohms/mile is ')
% fprintf('\n')
% disp('[z012] = ')
% fprintf('\n')
% disp(z012)
% 
