%Distribution System Modelling and Analysis, Example 4.1
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);

%Defining the phase conductor data
phase.GMR = 0.0244;
phase.resistance = 0.306;
phase.ncond = 3;

%Defining the neutral conductor data
neutral.GMR = 0.00814;
neutral.resistance = 0.592;
neutral.ncond = 1;

ncond = phase.ncond+neutral.ncond;

%Initializing matrix sizes
r = zeros(ncond,1);
D = zeros(ncond,ncond);
zprim = zeros(ncond,ncond);

%Defining the distance vector d

d1 = 2.5+j*29; d2 = 7+j*29; d3 = 0+j*29; d4 = 4+j*25;

d = [d1;d2;d3;d4];

%Defining the resistance vector r
for i = 1:1:ncond
    
    if i <= ncond -1 
        
        r(i) = phase.resistance;
    
    else
        
        r(i) = neutral.resistance;
        
    end 
        
end

%Calculating the inpedance matrix D
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        if i == k && i <= ncond -1
            
            D(i,k) = phase.GMR;
            
        elseif i == k && i > ncond - 1
            
            D(i,k) = neutral.GMR;
            
        else
            
            D(i,k) = abs(d(i) - d(k));
            
        end
        
    end
    
end

%Calculating the primitive impedance matrix
for i = 1:1:ncond

    for k = 1:1:ncond
       
        if i == k
            
            zprim(i,k) = r(i)+0.0953+j*0.12134*(log(1/D(i,k))+7.93402);
            
        else
            
            zprim(i,k) = 0.0953+j*0.12134*(log(1/D(i,k))+7.93402);
            
        end
          
    end
    
end

%Partitioning Zprim
for i = 1:1:phase.ncond

    for k = 1:1:phase.ncond
        
        zij(i,k) = zprim(i,k);
    
    end
    
end

for i = 1:1:phase.ncond

    for k = 1:1:neutral.ncond
    
        zin(i,k) = zprim(i,k+phase.ncond);

    end
    
end

for i = 1:1:neutral.ncond

    for k = 1:1:phase.ncond
        
        znj(i,k) = zprim(i+phase.ncond,k);
    
    end

end

for i = 1:1:neutral.ncond

    for k = 1:1:neutral.ncond
        
        znn = zprim(i+phase.ncond,k+phase.ncond);

    end

end

%Performing the Kron reduction
zabc = zij-zin*znn^-1*znj;

%Calculating the neutral transformation matrix 
tn = -(znn^-1*znj)

fprintf('The distance matrix is\n')
fprintf('\n')
disp('D = ') 
fprintf('\n')
disp(D)

fprintf('The primitive impedance matrix in ohms/mile is\n')
fprintf('\n')
disp('[z] = ') 
fprintf('\n')
disp(zprim)

fprintf('In partioned form, the submatrices in ohms/mile are\n')
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

fprintf('The "Kron" reduced phase impedance matrix in ohms/mile is\n ')
fprintf('\n')
disp('[zabc] = ') 
fprintf('\n')
disp(zabc)

fprintf('The neutral transformation matrix is\n')
fprintf('\n')
disp('[tn] = ') 
fprintf('\n')
disp(tn)