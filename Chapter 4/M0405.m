%Distribution System Modelling and Analysis, Example 4.5
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

%Defining the concentric neutral conductor data for the first line
cn.GMRc = 0.0171;
cn.rc = 0.41;
cn.GMRs = 0.00208;
cn.rs = 14.8722;
cn.dod = 1.29;
cn.ds = 0.0641;
cn.k = 13;
cn.ncond = 6;

%Defining additional neutral data
neutral.ncond = 0; %There is no additional neutral for this example

R = (cn.dod-cn.ds)/24;

fprintf('R =  ')
fprintf('\n')
disp(R)

GMRcn = (cn.GMRs*cn.k*R^(cn.k-1))^(1/cn.k);

fprintf('GMRcn =  ')
fprintf('\n')
disp(GMRcn)

rcn = cn.rs/cn.k;

fprintf('rcn =  ')
fprintf('\n')
disp(rcn)

ncond = cn.ncond+neutral.ncond;

%Initializing matrix sizes
r = zeros(ncond,1);
D = zeros(ncond,ncond);
zprim = zeros(ncond,ncond);

%Defining the distance vector d
d = [0+j*0;0.5+j*0;1+j*0;0+j*R;0.5+j*R;1+j*R];

%Defining the resistance vector r
for i = 1:1:ncond
    
    if i <= cn.ncond/2 
        
        r(i) = cn.rc;
    
    elseif i > cn.ncond/2 && i <= cn.ncond
        
        r(i) = rcn;
        
    else 
        
        r(i) = neutral.resistance;
        
    end 
        
end

 
%Calculating the inpedance matrix D
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        if i == k && i <= cn.ncond/2 
            
            D(i,k) = cn.GMRc;
            
        elseif i == k && i > cn.ncond/2 && i <= cn.ncond
            
            D(i,k) = GMRcn;
            
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
for i = 1:1:cn.ncond/2

    for k = 1:1:cn.ncond/2
        
        zij(i,k) = zprim(i,k);
    
    end
    
end

for i = 1:1:cn.ncond/2
    
   for k = 1:1:cn.ncond/2+neutral.ncond
    
    zin(i,k) = zprim(i,cn.ncond/2+k);
    
    end
    
end

for i = 1:1:cn.ncond/2+neutral.ncond
    
   for k = 1:1:cn.ncond/2
    
    znj(i,k) = zprim(cn.ncond/2+i,k);
    
    end
    
end

for i = 1:1:cn.ncond/2+neutral.ncond
    
   for k = 1:1:cn.ncond/2+neutral.ncond
       
    znn(i,k) = zprim(cn.ncond/2+i,cn.ncond/2+k);

   end
   
end

%Performing the Kron reduction
zabc = zij-zin*znn^-1*znj;

%Calculating the neutral transformation matrix 
tn = -(znn^-1*znj);

%Performing the sequence transformation
at = exp(j*2*pi/3);
As = [1 1 1;1 at^2 at;1 at at^2];
z012 =  As^-1*zabc*As;

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
disp('[znj] = [zin]')
fprintf('\n')
disp('[znn] = ')
fprintf('\n')
disp(znn)

disp('The "Kron" reduced phase impedance matrix in ohms/mile is ')
fprintf('\n')
disp('[zabc] = ')
fprintf('\n')
disp(zabc)

disp('The sequence impedance matrix in ohms/mile is ')
fprintf('\n')
disp('[z012] = ')
fprintf('\n')
disp(z012)

