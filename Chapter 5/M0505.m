%Distribution System Modelling and Analysis, Example 5.5
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

%Defining the phase conductor data for the first line
cn1.GMRc = 0.0171;
cn1.dc = 0.567;
cn1.rc = 0.41;
cn1.GMRs = 0.00208;
cn1.rs = 14.8722;
cn1.dod = 1.29;
cn1.ds = 0.0641;
cn1.k = 13;
cn1.ncond = 6;

%Defining the phase conductor data for the second line
cn2.GMRc = 0.0171;
cn2.dc = 0.567;
cn2.rc = 0.41;
cn2.GMRs = 0.00208;
cn2.rs = 14.8722;
cn2.dod = 1.29;
cn2.ds = 0.0641;
cn2.k = 13;
cn2.ncond = 6;

%Defining the neutral conductor data
neutral.GMR = 0.01579;
neutral.dn = 0.522;
neutral.r = 0.303;
neutral.ncond = 1;

% Calculating conductor radii
RDc1 = cn1.dc/2;
RDs1 = cn1.ds/2;
RDc2 = cn2.dc/2;
RDs2 = cn2.ds/2;

% Calculating radii to concentric neutrals
R1 = (cn1.dod-cn1.ds)/24;
R2 = (cn2.dod-cn2.ds)/24;

% Converting radii to inches
R1 = R1*12;
R2 = R2*12;

%Initializing matrix sizes
yabc = zeros(cn1.ncond/2+cn2.ncond/2,cn1.ncond/2+cn2.ncond/2);

%Calculating the primitive impedance matrix
for i = 1:1:cn1.ncond/2

    for k = 1:1:cn1.ncond/2
       
        if i == k
            
            yabc(i,k) = j*77.3619/(log(R1/RDc1)-1/cn1.k*log(cn1.k*RDs1/R1));
            
        else
            
            yabc(i,k) = 0;
            
        end
          
    end
    
end

%Calculating the primitive impedance matrix
for i = cn1.ncond/2+1:1:cn1.ncond/2+cn2.ncond

    for k = cn1.ncond/2+1:1:cn1.ncond/2+cn2.ncond
       
        if i == k
            
            yabc(i,k) = j*77.3619/(log(R2/RDc2)-1/cn2.k*log(cn2.k*RDs2/R2));
            
        else
            
            yabc(i,k) = 0;
            
        end
          
    end
    
end

fprintf('R1 =  ')
fprintf('\n')
disp(R1)

fprintf('RDc =  ')
fprintf('\n')
disp(RDc1)

fprintf('RDs =  ')
fprintf('\n')
disp(RDs1)

fprintf('yc =  ')
fprintf('\n')
disp(yabc(1,1))

fprintf('The phaes admittance matrix is ')
fprintf('[yabc] =  ')
fprintf('\n')
disp(yabc)

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

