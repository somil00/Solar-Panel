clear all;
clc;

% load data for school
% wattage(W) | qty(n) | avg usage time(hrs/day)

school_data = [11 16 4
              9 4 8
              9 1 8
              9 1 8
              11 3 8
              200 7 8
              360 1 8
              35 8 4
              30 4 8
              3 4 4];
% load data for house
% wattage(W) | qty(n) | avg usage time(hrs/day)

home_data = [2 5 4
             1 7 4
             25 1 14
             3 1 2];

temp1 = size(school_data);
rowsschool = temp1(1,1);

% Daily energy consumption by school in wh

E_school = 0;

for i=1:1:rowsschool
    E_school=E_school+school_data(i,1)*school_data(i,2)*school_data(i,3);
end

temp2=size(home_data);
rowshome = temp2(1,1);

% Daily energy consumption by 1 house in wh

E_home = 0;

for i=1:1:rowshome
    E_home=E_home+home_data(i,1)*home_data(i,2)*home_data(i,3);
end

% Total energy needed in a day

E_total=E_school+90*E_home;
E_total=E_total+E_total*(10/100); % 10% extra to account for transmission loss

% PV Cell Calculations

P_max = 250; % Maximum Power of PV
E_day = P_max*24*0.15; % Average energy (15%) output of 1 PV panel in 1 day

P_total = (E_total/E_day)*P_max; %Toatal size of the PV panel grid

nPV = floor(P_total/P_max)+1; %Number Of PV grid required to meet the energy requirement

% We get number of solar panels = 69

% Battery Calculations

V=48; % Transmitted voltage according to IEEE standard is 48V
AmpHr_school = E_school/V; %battery capacity consumed by school in AmpHr
AmpHr_home = E_home/V; %battery capacity consumed by home in AmpHr

AmpHr_total = AmpHr_school + AmpHr_home*90; % Total battery capacity required in AmpHr

% Size of battery = (Total battery capacity)/(efficiency of battery)

efficiency = 0.5;  % Efficiency is 50%
Battery_size = AmpHr_total/efficiency;

% Battery size comes to be ...

% Conductor Size Calculation
% Conductor Size will depend on the peak current in that line/wire
% 1) The peak current in that branch.
% 2) The voltage recieved at the last house due to loss in transmission.
  % Note - The voltage at the end will also depend on the resistance of the
  % actual loads i.e. the houses.

% Splitting the current calculations into suitable time slots to calculate 
% power and current.

% 1) From 8 am to 12 pm
% Wattage(w) | quantity (number)

load_1 = [11 16
         9 4
         9 1 
         9 1
         11 3
         200 7
         360 1
         35 8
         30 4];

temp3 = size(load_1);
rows_1 = temp3(1,1);

P1 = 0; % Power Consumption for school in W for 8am to 12pm

for i=1:1:rows_1
    P1=P1+load_1(i,1)+load_1(i,2);
end

I1 = P1/V; %Current flowing from 8am to 12pm

% 2) From 12pm to 4pm
% Wattage(w) | quantity (number)

load_2 = [9 4
         9 1
         9 1
         11 3
         200 7
         360 1
         30 4
         3 4];

temp4 = size(load_2);
rows_2 = temp4(1,1);

P2 = 0; % Power Consumption in W for 12pm to 4pm

for i=1:1:rows_2
    P2=P2+load_2(i,1)+load_2(i,2);
end

I2 = P2/V; %Current flowing from 12pm to 4pm


% 3) From 6pm to 8pm
% Wattage(w) | quantity (number)

load_3 = [5 2
          7 1
          25 1];

temp5 = size(load_3);
rows_3 = temp5(1,1);

P3 = 0; % Power Consumption in W for 6pm to 8pm

for i=1:1:rows_3
    P3=P3+load_3(i,1)+load_3(i,2);
end

I3 = P3/V; %Current flowing from 6pm to 8pm

% 4) From 8pm to 10pm
% Wattage(w) | quantity (number)

load_4 = [5 2
          7 1
          3 1];

temp6 = size(load_4);
rows_4 = temp6(1,1);

P4 = 0; % Power Consumption in W for 8pm to 10pm

for i=1:1:rows_4
    P4=P4+load_4(i,1)+load_4(i,2);
end

I4 = P4/V; %Current flowing from 8pm to 10pm

% 5) From 10pm to 8am
% Wattage(w) | quantity (number)

load_5 = [25 1];

temp7 = size(load_5);
rows_5 = temp7(1,1);

P5 = 0; % Power Consumption in W for 10pm to 8am

for i=1:1:rows_5
    P5=P5+load_5(i,1)+load_5(i,2);
end

I5 = P5/V; %Current flowing from 10pm to 8am

%{

The maximum current drawn by the school is I1.
The maximum current drawn by any branch of houses is 30*i3.
( I1 > I3*30)
Therefore for the branch containing the school we have I_max = I1
and for rest of the branches containing only houses, we have I_max = I3



Imax_school = I1;
Imax_rest = I3;

Pmin = p;
R = (48*48)/Pmin;
V1
for i=1:1:30
%}    

%{

We take 5 volts as the maximum drop at the last house. Therefore the
Voltage at the last house cannot drop below 48V-5V=43V.

Now for calculating the voltage at the last house, we need the resistance
of the transmission wire in between two houses and also the resistance
offered by load itself. We choose the maximum load offered by house at any
time to set the standard. This will unsure that the voltage across the last
house will always be at least 43 volts.

Also the load offers maximum resistance when it consumes the minimum power.

%}

% 1) For the branches without the school

P_min = P5; % Minimum power consumption of load means maximum resistance

V_end_house = 10;
R_house = (48*48)/P_min;
r = 50;

%{

Here R is the maximum resistance offered by a single house.
and r is the resistance of the transmission wire present between two
houses.

Let the voltage at the last house be something less than 43.
We run a while loop untill the end voltage is > 43 i.e. which is the
desired senario.

We start with a random big enough value of n and with each iteration reduce
r by 0.0001 to get more accuracy.

This loop will decrease r untill the voltage drop across the last house is
more than 43 volts.

%calculation for V_end_house-
   We use voltage division rule to get voltage across every next house.
   We start with 48V as the supply voltge and we repeat this process 30 
   times i.e. the number of houses in one branch to get the voltage across 
   the last house.

%}

while (V_end_house < 43)
    V_supply = 48;
    V_temp = V_supply;
    for i=1:1:30
        V_temp = (V_temp*R_house)/(R_house+2*r);
    end
    V_end_house = V_temp;
    r = r - 0.0001;
end

% This gives us V_end_house as 43.001 and the corresponding r as 0.168
% ohms.
% This r is for 12 meters of the wire.
% Thus this scales up to r*1000/12 = 14 ohms/Km.
% Also the maximum current that flows is I2 = 41.23A

% Thus we need a conductor with maximum rating  of 14 ohms/Km and minimum
% current capacity of 42 amps.

% 2) For the branch with school

P_school = P1; % Power consumed by the school

V_end_house = 10;
R_house = (48*48)/P_min;      %Resistance of 1 house using P_min from above
R_school = (48*48)/P_school;  %Resistance offered by the school
r = 50;



while (V_end_house < 43)
    V_supply = 48;
    V_temp = V_supply;
    V_temp=(V_temp*R_house)/(R_school+2*r);
    for i=1:1:30
        V_temp=(V_temp*R_house)/(R_house+2*r);
    end
    V_end_house = V_temp;
    r = r - 0.0001;
end

% This gives us V_end_house as 43.009 and the corresponding r as 0.041
% ohms.
% This r is for 12 meters of the wire.
% Thus this scales up to r*1000/12 = 3.4166 ohms/Km.
% Also the maximum current that flows is I2 = 50.48A

% Thus we need a conductor with maximum rating  of 3.40 ohms/Km and minimum
% current capacity of 51.00 amps.
