%Distribution System Modelling and Analysis, Example 2.2
%Written by William Kersting and Robert Kerestes

clear
j = sqrt(-1);

%Defining the transformer kVA ratings
kVA_rated(1,1) = 25;
kVA_rated(1,2)= 37.5;
kVA_rated(1,3) = 50;

kVA_total = sum(kVA_rated);

load('lineMaxDiv_0201.mat')

%Calculating the allocation factor
AF = lineMaxDiv(1,1)/kVA_total;

%Calculating allocated kW for each transformer
allkW = kVA_rated*AF;

data = [kVA_total round(AF,4) round(allkW,1)];
dataTab = array2table(data,'VariableNames',{'Total kVA','Allocation Factor','T1','T2','T3'});

fprintf('\n\nTransformer Data:\n\n\n')
disp(dataTab)