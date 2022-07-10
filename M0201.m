%Distribution System Modelling and Analysis, Example 2.1
%Written by William Kersting and Robert Kerestes
clear
j = sqrt(-1);

%Defining the energy demand for custormers on each transformer
kWh_T1 = [1523 1645 1984 1590 1456];
kWh_T2 = [1235 1587 1698 1745 2015 1765];
kWh_T3 = [2098 1856 2058 2265 2135 1985 2103];

%Calculating the maximum demand for each customer using load survey curve
kW_T1 = 0.2+0.008.*kWh_T1;
kW_T2 = 0.2+0.008.*kWh_T2;
kW_T3 = 0.2+0.008.*kWh_T3;

data_T1 = [kWh_T1;round(kW_T1,1)];
data_T2 = [kWh_T2;round(kW_T2,1)];
data_T3 = [kWh_T3;round(kW_T3,1)];

T1 = array2table(data_T1,'VariableNames',{'#1','#2','#3','#4','#5'},'RowNames',{'kWh','kW'});
T2 = array2table(data_T2,'VariableNames',{'#6','#7','#8','#9','#10','#11'},'RowNames',{'kWh','kW'});
T3 = array2table(data_T3,'VariableNames',{'#12','#13','#14','#15','#116','#17','#18'},'RowNames',{'kWh','kW'});

%Displaying the kWh and max demand for each custor for T1, T2, and T3
fprintf('\n\nTransformer 1:\n\n\n')
disp(T1)
fprintf('\n\nTransformer 2:\n\n\n')
disp(T2)
fprintf('\n\nTransformer 3:\n\n\n')
disp(T3)

%Calculation max noncoincident demand for each transformer
maxNonCo(1,1) = sum(kW_T1);
maxNonCo(1,2) = sum(kW_T2);
maxNonCo(1,3) = sum(kW_T3);


%Defining diversity factors for 5, 6 and 7 customers
D5 = 2.2;
D6 = 2.3;
D7 = 2.4;

%Calculating maximum diversitfied demand for each transformer
maxDiv(1,1) = maxNonCo(1,1)/D5;
maxDiv(1,2) = maxNonCo(1,2)/D6;
maxDiv(1,3) = maxNonCo(1,3)/D6;

%Calculating the utilization factor for each of the transformers
kVA_rated(1,1) = 25;
kVA_rated(1,2)= 37.5;
kVA_rated(1,3) = 50;
utilFact(1,1) = (maxDiv(1,1)/0.9)/kVA_rated(1,1)*100;
utilFact(1,2) = (maxDiv(1,2)/0.9)/kVA_rated(1,2)*100;
utilFact(1,3) = (maxDiv(1,3)/0.9)/kVA_rated(1,3)*100;


demand = [round(maxNonCo,1);round(maxDiv,1);round(utilFact,0)];
DemTab = array2table(demand,'VariableNames',{'XFMR 1','XFMR 2','XFMR 3'},'RowNames',{'Max non-coincident demand','Max diversified demand','Utilization factor'});

fprintf('\n\nTransformer Demands:\n\n\n')
disp(DemTab)


%Determing the noncoincident demand on the line segmenets
lineMaxNonCo(1,1) = maxNonCo(1,1)+maxNonCo(1,2)+maxNonCo(1,3);
lineMaxNonCo(1,2) = maxNonCo(1,2)+maxNonCo(1,3);
lineMaxNonCo(1,3) = maxNonCo(1,3);

%Defining diversity factors for 18 and 13
D18 = 2.86;
D13 = 2.74;

%Calculating the maximum deversified demand for the line segmnets
lineMaxDiv(1,1) = lineMaxNonCo(1,1)/D18;
lineMaxDiv(1,2) = lineMaxNonCo(1,2)/D13;
lineMaxDiv(1,3) = lineMaxNonCo(1,3)/D7;

lineDemand = [round(lineMaxNonCo,1);round(lineMaxDiv,1)];
LineDemTab = array2table(lineDemand,'VariableNames',{'N1-N2','N2-N3','N3-N4'},'RowNames',{'Max non-coincident demand','Max diversified demand'});

fprintf('\n\nLine Demands:\n\n\n')
disp(LineDemTab)
