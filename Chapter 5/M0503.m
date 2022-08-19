%Distribution System Modelling and Analysis, Example 5.3
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

%Defining the concentric neutral conductor data for the first line
cn.GMRc = 0.0171;
cn.rc = 0.41;
cn.diameter = 0.567;
cn.GMRs = 0.00208;
cn.rs = 14.8722;
cn.dod = 1.29;
cn.ds = 0.0641;
cn.k = 13;
cn.ncond = 6;

%Defining additional neutral data
neutral.ncond = 0; %There is no additional neutral for this example

R = (cn.dod-cn.ds)/24;
% Converting to inches
R = R*12;

RDc = cn.diameter/2;
RDs = cn.ds/2;

fprintf('R =  ')
fprintf('\n')
disp(R)

ncond = cn.ncond+neutral.ncond;

%Defining matrix sizes
yabc = zeros(cn.ncond/2,cn.ncond/2);

%Calculating the primitive impedance matrix
for i = 1:1:cn.ncond/2

    for k = 1:1:cn.ncond/2
       
        if i == k
            
            yabc(i,k) = j*77.3619/(log(R/RDc)-1/cn.k*log(cn.k*RDs/R));
            
        else
            
            yabc(i,k) = 0;
            
        end
          
    end
    
end

fprintf('The phase admittance for the three-phase line is \n\n')
disp('[yabc] = ')
fprintf('\n')
disp(yabc)

