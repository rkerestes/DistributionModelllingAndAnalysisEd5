%Distribution System Modelling and Analysis, Example 4.4
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

%Defining the phase conductor data for the first line
phase1.GMR = 0.0244;
phase1.resistance = 0.306;
phase1.ncond = 3;

%Defining the phase conductor data for the second line
phase2.GMR = 0.0171;
phase2.resistance = 0.41;
phase2.ncond = 3;

%Defining the neutral conductor data
neutral.GMR = 0.00814;
neutral.resistance = 0.592;
neutral.ncond = 1;

ncond = phase1.ncond+phase2.ncond+neutral.ncond;

%Initializing matrix sizes
r = zeros(ncond,1);
D = zeros(ncond,ncond);
zprim = zeros(ncond,ncond);

%Defining the distance vector d

d1 = 0+j*35; d2 = 2.5 +j*35; d3 = 7+j*35;

d4 = 2.5+j*33; d5 = 7+j*33; d6 = 0+j*33;

d7 = 4+j*29;

d = [d1;d2;d3;d4;d5;d6;d7];

%Defining the resistance vector r
for i = 1:1:ncond
    
    if i <= phase1.ncond 
        
        r(i) = phase1.resistance;
    
    elseif i > phase1.ncond && i <= phase1.ncond+phase2.ncond
        
        r(i) = phase2.resistance;
        
    else 
        
        r(i) = neutral.resistance
        
    end 
        
end

 
%Calculating the inpedance matrix D
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        if i == k && i <= phase1.ncond 
            
            D(i,k) = phase1.GMR;
            
        elseif i == k && i > phase1.ncond && i <= phase1.ncond+phase2.ncond
            
            D(i,k) = phase2.GMR;
            
        elseif i == k && i > phase1.ncond+phase2.ncond
            
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


% %Partitioning Zprim
for i = 1:1:phase1.ncond+phase2.ncond

    for k = 1:1:phase1.ncond+phase2.ncond
        
        zij(i,k) = zprim(i,k);
    
    end
    
end

for i = 1:1:phase1.ncond+phase2.ncond
    
   for k = 1:1:neutral.ncond
    
    zin(i,k) = zprim(i,phase1.ncond+phase2.ncond+k);
    
    end
    
end

for i = 1:1:neutral.ncond
    
   for k = 1:1:phase1.ncond+phase2.ncond
    
    znj(i,k) = zprim(phase1.ncond+phase2.ncond+i,k);
    
    end
    
end

for i = 1:1:neutral.ncond
    
   for k = 1:1:neutral.ncond
       
    znn(i,k) = zprim(phase1.ncond+phase2.ncond+i,phase1.ncond+phase2.ncond+k);

   end
   
end

%Performing the Kron reduction
zabc = zij-zin*znn^-1*znj;

%Calculating the neutral transformation matrix 
tn = -(znn^-1*znj);

%Calculating the partitioned phase impedance matrices
z11abc = zabc(1:3,1:3);
z12abc = zabc(1:3,4:6);
z21abc = zabc(4:6,1:3);
z22abc = zabc(4:6,4:6);

fprintf('The distance matrix is ')
disp('D = ') 
fprintf('\n')
disp(D)

fprintf('The partitioned phase impedance matrices are \n\n')
disp('[z11]abc = ') 
fprintf('\n')
disp(z11abc)

disp('[z12]abc = ') 
fprintf('\n')
disp(z12abc)

disp('[z21]abc = ') 
fprintf('\n')
disp(z21abc)

disp('[z22]abc = ') 
fprintf('\n')
disp(z22abc)

% disp('The distance matrix in feet for this line is')
% display(D)
% 
% disp('The primitive impedance matrix in ohms/mile for this line is')
% display(zprim)
% 
% disp('In partioned form, the submatrices in ohms/mile are')
% display(zij)
% display(zin)
% display(znj)
% display(znn)
% 
% disp('The "Kron" reduced phase impedance matrix in ohms/mile is ')
% display(zabc)
% 
% 
% 
% disp('The neutral transformation matrix is')
% display(tn)

