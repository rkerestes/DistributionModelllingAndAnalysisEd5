%Distribution System Modelling and Analysis, Example 4.7
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

%Defining the phase conductor data for the first line
cn1.GMRc = 0.0171;
cn1.rc = 0.41;
cn1.GMRs = 0.00208;
cn1.rs = 14.8722;
cn1.dod = 1.29;
cn1.ds = 0.0641;
cn1.k = 13;
cn1.ncond = 6;

%Defining the phase conductor data for the second line
cn2.GMRc = 0.0171;
cn2.rc = 0.41;
cn2.GMRs = 0.00208;
cn2.rs = 14.8722;
cn2.dod = 1.29;
cn2.ds = 0.0641;
cn2.k = 13;
cn2.ncond = 6;

%Defining the neutral conductor data
neutral.GMR = 0.01579;
neutral.r = 0.303;
neutral.ncond = 1;

ncond = cn1.ncond+cn2.ncond+neutral.ncond;

R1 = (cn1.dod-cn1.ds)/24;
R2 = R1;

GMRcn1 = (cn1.GMRs*cn1.k*R1^(cn1.k-1))^(1/cn1.k);
GMRcn2 = GMRcn1;

rcn1 = cn1.rs/cn1.k;
rcn2 = rcn1;


%Initializing matrix sizes
r = zeros(ncond,1);
D = zeros(ncond,ncond);
zprim = zeros(ncond,ncond);

%Defining the distance vector d
d = [0+j*0;4/12+j*0;8/12+j*0;4/12+j*-10/12;0+j*-10/12;8/12+j*-10/12;0+j*R1;4/12+j*R1;8/12+j*R1;4/12+j*(R2-10/12);0+j*(R2-10/12);8/12+j*(R2-10/12);10/12+j*-5/12];

%Defining the r vector r
for i = 1:1:ncond
    
    if i <= cn1.ncond/2 
        
        r(i) = cn1.rc;
    
    elseif i > cn1.ncond/2 && i <= cn1.ncond/2+cn2.ncond/2
        
        r(i) = cn2.rc;

    elseif i > cn1.ncond/2+cn2.ncond/2 && i <= cn1.ncond+cn2.ncond/2
        
        r(i) = rcn1;

    elseif i > cn1.ncond+cn2.ncond/2 && i <= cn1.ncond+cn2.ncond
        
        r(i) = rcn2;
        
    else 
        
        r(i) = neutral.r;
        
    end 
        
end

 
%Calculating the inpedance matrix D
for i = 1:1:ncond
    
    for k = 1:1:ncond
        
        if i == k && i <= cn1.ncond/2 
            
            D(i,k) = cn1.GMRc;

        elseif i == k && i > cn1.ncond/2 && i <= cn1.ncond/2+cn2.ncond/2
            
            D(i,k) = cn2.GMRc;

        elseif i == k && i > cn1.ncond/2+cn2.ncond/2 && i <= cn1.ncond+cn2.ncond/2
            
            D(i,k) = GMRcn1;

        elseif i == k && i > cn1.ncond+cn2.ncond/2 && i <= cn1.ncond+cn2.ncond
            
            D(i,k) = GMRcn2;
            
        elseif i == k && i > cn1.ncond+cn2.ncond && i <= ncond
            
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
for i = 1:1:cn1.ncond/2+cn2.ncond/2

    for k = 1:1:cn1.ncond/2+cn2.ncond/2
        
        zij(i,k) = zprim(i,k);
    
    end
    
end

for i = 1:1:cn1.ncond/2+cn2.ncond/2
    
   for k = 1:1:cn1.ncond/2+cn2.ncond/2+neutral.ncond
    
    zin(i,k) = zprim(i,cn1.ncond/2+cn2.ncond/2+k);
    
    end
    
end

for i = 1:1:cn1.ncond/2+cn2.ncond/2+neutral.ncond
    
   for k = 1:1:cn1.ncond/2+cn2.ncond/2
    
    znj(i,k) = zprim(cn1.ncond/2+cn2.ncond/2+i,k);
    
    end
    
end

for i = 1:1:cn1.ncond/2+cn2.ncond/2+neutral.ncond
    
   for k = 1:1:cn1.ncond/2+cn2.ncond/2+neutral.ncond
       
    znn(i,k) = zprim(cn1.ncond/2+cn2.ncond/2+i,cn1.ncond/2+cn2.ncond/2+k);

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

fprintf('R1 =  ')
fprintf('\n')
disp(R1)

fprintf('GMRcn1 =  ')
fprintf('\n')
disp(GMRcn1)

fprintf('rcn =  ')
fprintf('\n')
disp(rcn1)

fprintf('The distance matrix is ')
disp('D = ') 
fprintf('\n')
disp(D)

fprintf('The partitioned phase impedance matrices are \n\n')
disp('[z11abc] = ') 
fprintf('\n')
disp(z11abc)

disp('[z12abc] = ') 
fprintf('\n')
disp(z12abc)

disp('[z21abc] = ') 
fprintf('\n')
disp(z21abc)

disp('[z22abc] = ') 
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

