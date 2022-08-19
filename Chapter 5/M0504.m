%Distribution System Modelling and Analysis, Example 5.4
%Written by William Kersting and Robert Kerestes
clear

j = sqrt(-1);

% Defining resistivity of copper at 20 degrees celsius
rhom20 = 1.7721e-8;

%Defining the concentric neutral conductor data for the first line
ts.dt = 0.89;
ts.dc = 0.368;
ts.GMRc = 0.0111;
ts.rc = 0.97;
ts.T = 5;
ts.rho = 1.7721e-8;
ts.ncond = 2;

%Defining additional neutral data
neutral.r = 0.607;
neutral.GMR = 0.0113;
neutral.ncond = 1; 

ncond = ts.ncond+neutral.ncond;

yacb = zeros(ts.ncond,ts.ncond);


% Defining the distance from the conductor to the tape shield
Dcs = (ts.dt/2 - ts.T/2000)/12;

% Converting the distance from the conductor to the tape shield to inches
Dcs = Dcs*12;

% Calculating the conductor radius
RDc = ts.dc/2;

% Calculating the phase admittance matrix
for i = 1:1:ts.ncond/2

    for k = 1:1:ts.ncond/2
       
        if i == k
            
            yabc(i,k) = j*77.3619/log(Dcs/RDc);
            
        else
            
            yabc(i,k) = 0;
            
        end
          
    end
    
end




fprintf('The distance from conductor to tape shield in inches is\n\n')
disp('D12 = ') 
fprintf('\n')
disp(Dcs)


fprintf('The radius of the phase conductor in inches is')
disp('RDc = ') 
fprintf('\n')
disp(RDc)

 
fprintf('The phae admittance matrix for the line is ')
disp('[yabc] = ')
fprintf('\n')
disp(yabc)



% disp('The sequence impedance matrix in ohms/mile is ')
% fprintf('\n')
% disp('[z012] = ')
% fprintf('\n')
% disp(z012)
% 
