clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD"];
Units = ["Pressure (Pa)"];
Variable_name = ["Vapor Pressure Defecit"];
Colors = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 0.4940 0.1840 0.5560; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840; 0 0 0]; % Colors by model
% red green blue cyan magenta yellow purpleish orangeish maroonish black

fig = figure(1)
sgtitle("Ensemble Time Series",'FontSize',24)

model_data = [];
a = 1;
b = 1;

while b < size(model,2)+1
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    data = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    time = [1:(86*365)]; % resize to 365 day years
    model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');

    if b == 1
        sum_data = model_avg;
    else
        sum_data = sum_data + model_avg;
    end

        subplot(2,1,1)
        plot(time, model_avg(:), 'MarkerFace', Colors(b,:))
        title(Variable_name(a))
        xlabel("Days since 01/01/2015")
        ylabel(Units(a))
        xlim([0, size(time,2)])
        ax = gca;
        ax.FontSize = 12;
        hold on

    b = b+1;
end
ensemble_avg = sum_data/size(model,2);
plot(time, ensemble_avg, 'MarkerFace', Colors(b,:)) % ensemble average plotting
hold off

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");
    time = [1:(86*12)];

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    if b == 1
        sum_data = model_avg;
    else
        sum_data = sum_data + model_avg;
    end

    subplot(2,1,2)
    plot(time, model_avg(:), 'MarkerFace', Colors(b,:))
    title("Vapor Pressure Defecit - Monthly")
    xlabel("Months since 01/2015")
    ylabel("VPD (Pa)")
    xlim([0, size(time,2)])
    ax = gca;
    ax.FontSize = 12;
    hold on

    b = b+1;
end
ensemble_avg = sum_data/size(model,2);
plot(time, ensemble_avg, 'MarkerFace', Colors(b,:)) % ensemble average plotting
xlim([0, size(time,2)])
legend("CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR", "Ensemble Average",'Location','northeastoutside')
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 32, 16];  % [left, bottom, width, height] => 16x16 inches
% saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_SW-US_All.png');

%% Histogram - All

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD"];
Units = ["Pressure (Pa)"];
Variable_name = ["Vapor Pressure Defecit"];
Colors = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 0.4940 0.1840 0.5560; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840; 0 0 0]; % Colors by model
% red green blue cyan magenta yellow purpleish orangeish maroonish black

fig = figure(2)
sgtitle("Histogram",'FontSize',24)

buckets = [0:1000:30000];

model_data = [];
a = 1;
b = 1;

while b < size(model,2)+1
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    data = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    time = [1:(86*365)]; % resize to 365 day years
    model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');

    if b == 1
        sum_data = model_avg;
    else
        sum_data = sum_data + model_avg;
    end

        subplot(2,1,1)
        histogram(model_avg(:),buckets)
        title(Variable_name(a))
        xlabel("Pressure Buckets (Pa)")
        ylabel("Number of Occurances")
        ax = gca;
        ax.FontSize = 12;
        hold on

    b = b+1;
end
ensemble_avg = sum_data/size(model,2);
histogram(ensemble_avg,buckets)
hold off

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");
    time = [1:(86*12)];

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    if b == 1
        sum_data = model_avg;
    else
        sum_data = sum_data + model_avg;
    end

    subplot(2,1,2)
    histogram(model_avg(:),buckets)
    xlabel("Pressure Buckets (Pa)")
    ylabel("Number of Occurances")
    ylabel("VPD (Pa)")
    ax = gca;
    ax.FontSize = 12;
    hold on

    b = b+1;
end
ensemble_avg = sum_data/size(model,2);
histogram(ensemble_avg,buckets)
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 32, 16];  % [left, bottom, width, height] => 16x16 inches
% saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_SW-US_All.png');

%% Histogram - Ensemble Average

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD"];
Units = ["Pressure (Pa)"];
Variable_name = ["Vapor Pressure Defecit"];
Colors = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 0.4940 0.1840 0.5560; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840; 0 0 0]; % Colors by model
% red green blue cyan magenta yellow purpleish orangeish maroonish black

fig = figure(3)
sgtitle("Occurances of Vapor Pressure Defecit",'FontSize',24)

buckets = [0:200:30000];

model_data = [];
a = 1;
b = 1;

while b < size(model,2)+1
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    data = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    time = [1:(86*365)]; % resize to 365 day years
    model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');

    if b == 1
        sum_data = model_avg;
    else
        sum_data = sum_data + model_avg;
    end

    b = b+1;
end
ensemble_avg = sum_data/size(model,2);

All = histogram(ensemble_avg,buckets);
All = All.Values;
first = ensemble_avg(1,1:20*365);
first = histogram(first,buckets);
first = first.Values;
last = ensemble_avg(1,(86-20)*365+1:end);
last = histogram(last,buckets);
last = last.Values;
diff = last - first;

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");
    time = [1:(86*12)];

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    if b == 1
        sum_data = model_avg;
    else
        sum_data = sum_data + model_avg;
    end

    b = b+1;
end
ensemble_avg = sum_data/size(model,2);

All1 = histogram(ensemble_avg,buckets);
All1 = All1.Values;
first1 = ensemble_avg(1,1:20*12);
first1 = histogram(first1,buckets)
first1 = first1.Values;
last1 = ensemble_avg(1,(86-20)*12+1:end);
last1 = histogram(last1,buckets)
last1 = last1.Values;
diff1 = last1 - first1;

subplot(2,1,1) % daily all
plot(buckets(2:end),All)
hold on
title("Daily Occurances")
xlabel("Pressure Buckets (Pa)")
ylabel("Number of Occurances")
ax = gca;
ax.FontSize = 12;
ylim([-1428.6 10000])
xlim([0 7000])
plot(buckets(2:end),first)
plot(buckets(2:end),last)
plot(buckets(2:end),diff)

grid on
legend("All Days", "Days: 2015-2035", "Days: 2080-2100", "Days Difference: 2080-2100 minus 2015-2035")
hold off



subplot(2,1,2) % monthly all
plot(buckets(2:end),All1)
hold on
xlabel("Pressure Buckets (Pa)")
ylabel("Number of Occurances")
title("Monthly Occurances")
ax = gca;
ax.FontSize = 12;
ylim([-50 350])
xlim([0 7000])
plot(buckets(2:end),first1)
plot(buckets(2:end),last1)
plot(buckets(2:end),diff1)

grid on
legend("All Months", "Months: 2015-2035", "Months: 2080-2100", "Months Difference: 2080-2100 minus 2015-2035")
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 32, 16];  % [left, bottom, width, height] => 16x16 inches
% saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_SW-US_All.png');


%% Plotted Monthly
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];

filename = '/home/disk/p/dglopez/Extreme_VPD_Index.csv';
CSV = readtable(filename);
high(:,1) = table2array(CSV(:,1));
high_index(:,1) = table2array(CSV(:,2));

b = 1;
while b < 9+1 % 9 models
    
    a = high_index(b);
        % Get dates for the model to use in plot names
        time_c = []; %(:x3) year, month, day
        year = 2015;
        month = 1;
        day = 1;
        c = 1;
        if model(b) == "KACE-1-0-G"
            while year < 2100+1
                while month < 12+1
                    time1 = [];
                    year1 = [];
                    month1 = [];
                    day1 = [];

                    year1 = zeros(30,1)+year;
                    month1 = zeros(30,1)+month;
                    day1(:,1) = 1:30;
                    c = c+30;

                    time1(:,1) = year1;
                    time1(:,2) = month1;
                    time1(:,3) = day1;
                    if year == 2015 && month == 1
                        time_c = time1;
                    else
                        time_c = cat(1, time_c, time1);
                    end

                    month = month+1;
                end
                year = year+1;
                month = 1;
            end
        else
            while year < 2100+1
                while month < 12+1
                    time1 = [];
                    year1 = [];
                    month1 = [];
                    day1 = [];
                    if month == 4 || month == 6 || month == 9 || month == 11
                        year1 = zeros(30,1)+year;
                        month1 = zeros(30,1)+month;
                        day1(:,1) = 1:30;
                        c = c+30;
                    elseif month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12
                        year1 = zeros(31,1)+year;
                        month1 = zeros(31,1)+month;
                        day1(:,1) = 1:31;
                        c = c+31;
                    elseif month == 2 % Leap Year
                        if floor(year/4) == ceil(year/4) || year ~= 2100 && model(b) ~= "INM-CM5-0" && model(b) ~= "INM-CM4-8" && model(b) ~= "CanESM5" && model(b) ~= "CanESM5-1" % 2100 = Leap year, models w/o leap years
                            year1 = zeros(29,1)+year;
                            month1 = zeros(29,1)+month;
                            day1(:,1) = 1:29;
                            c = c+29;
                        else
                            year1 = zeros(28,1)+year;
                            month1 = zeros(28,1)+month;
                            day1(:,1) = 1:28;
                            c = c+28;
                        end 
                    end
                    time1(:,1) = year1;
                    time1(:,2) = month1;
                    time1(:,3) = day1;
                    if year == 2015 && month == 1
                        time_c = time1;
                    else
                        time_c = cat(1, time_c, time1);
                    end
                    month = month+1;
                end
                year = year+1;
                month = 1;
            end
        end
        
%         day = time_c(a,3);
%         month = time_c(a,2);
%         year = time_c(a,1);

        fig = figure(b);
        
        c = 1;
        while c < 12+1 % 12 months
            subplot(2,6,c)
            
            
            c = c+1;
        end






        close(figure(b))
    b =b+1;
    end
