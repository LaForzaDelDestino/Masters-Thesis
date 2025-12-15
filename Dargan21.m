%% Time series of VPD and Temp for extreme events + x years prior for comparison
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD","tasmax","hurs","pr","hfls"];
Units = ["VPD (Pa)","Temperature (K)","Relative Humidity (%)","Precipitation (mm)","Latent Heat Flux (W/m^2)"];
Variable_name = ["Vapor Pressure Defecit","Max Temperature","Relative Humidity","Precipitation","Latent Heat Flux"];


load coastlines

Extreme1(:,2) = [29361 29716 27206 29424 29730 30800 27560 30852 23511];
Extreme2(:,2) = [28623 27532 30830 30165 29040 27511 24285 23915 29701]; % replaced 29371 for 30165
Extreme3(:,2) = [25357 30820 26493 14805 26086 30387 26095 17318 30826]; % replaced 30165 for 14805

Extreme1(:,1) = [11088.8305303168 11449.6419289909 10563.6805492859 9694.73702625366 6686.93022029314 12610.2814069302 20199.0250854194 7045.62775321073 6776.57564152376];
Extreme2(:,1) = [9934.67120078053 10617.8065432737 10438.5623661379 9395.81610746577 6394.53353040419 10355.793640001 18485.6517426566 6879.53375591118 6679.5536695823]; % replaced 9469.6059138292 for 9395.81610746577
Extreme3(:,1) = [9793.06296282034 10275.273589424 10134.9014413799 9120.86232165862 6321.19238533541 10092.6149901998 17194.1108080571 6701.36243232667 6677.12139504387]; % replaced 9395.81610746577 for 9120.86232165862

a = 1;
while a < size(model,2)+1
    
    % Get dates for the model to use in plot names
    time_c = []; %(:x3) year, month, day
    year = 2015;
    month = 1;
    day = 1;
    c = 1;
    if model(a) == "KACE-1-0-G"
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
                    if floor(year/4) == ceil(year/4) || year ~= 2100 && model(a) ~= "INM-CM5-0" && model(a) ~= "INM-CM4-8" && model(a) ~= "CanESM5" && model(a) ~= "CanESM5-1" % 2100 = Leap year, models w/o leap years
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
    indices(1,1) = Extreme1(a,2);
    indices(1,2) = Extreme2(a,2);
    indices(1,3) = Extreme3(a,2);
    index = Extreme1(a,2);
    year(1,1) = time_c(index,1);
    month(1,1) = time_c(index,2);
    day(1,1) = time_c(index,3);
    index = Extreme2(a,2);
    year(1,2) = time_c(index,1);
    month(1,2) = time_c(index,2);
    day(1,2) = time_c(index,3);
    index = Extreme3(a,2);
    year(1,3) = time_c(index,1);
    month(1,3) = time_c(index,2);
    day(1,3) = time_c(index,3);
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    VPD = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(VPD,1, "omitnan");
    VPD = [];
    VPD(1,:) = mean(model_avg1,1, "omitnan");
    
    
    
    if model(a) == "KACE-1-0-G"
        end_day = 30;
        end_extent = 180;
    else
        end_day = 31;
        end_extent = 184;
    end
    
    years_before = 0;
    
    fig = figure(a)
    
    e = 1;
    while e < size(Variable,2)+1
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_"+Variable(1,e)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(1,e));

        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        data = [];
        data(1,:) = mean(model_avg1,1, "omitnan");
        
        maximum = max(data);
        minimum = min(data);
        
        
        % Extremes
        subplot(5,2,e*2-1)

        b = 1;
        while b < size(year,2)+1 % loop each extreme event
            c = 0;
            while c < years_before+1 % three years before the extreme event + the extreme event(c=0)
                if c == 0 % plot extreme event
                    year1 = year(1,b);
                    d = 1; % determine indices to plot for the year
                    while d < size(time_c,1)+1
                        if time_c(d,1) == year1 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                            start_index = d;
                        end
                        if time_c(d,1) == year1 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                            end_index = d;
                        end
                        d = d+1;
                    end
                    plot([1:end_extent],data(1,start_index:end_index),"LineWidth",2) % 184 = days in this period
                    grid on
                    hold on
                    num = indices(1,b) - start_index +1;
                    plot(num,data(1,indices(1,b)),"*r")

                else % plot years prior
                    year1 = year(1,b)-c;
                    d = 1; % determine indices to plot for the year
                    while d < size(time_c,1)+1
                        if time_c(d,1) == year1 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                            start_index = d;
                        end
                        if time_c(d,1) == year1 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                            end_index = d;
                        end
                        d = d+1;
                    end
                    plot([1:end_extent],data(1,start_index:end_index),"-","LineWidth",1) % 184 = days in this period
                    grid on
                end
                c = c+1;
            end
            b = b+1;
        end
        if Variable(1,e) == "hurs"
            ylim([0 100])
        elseif Variable(1,e) == "hfls"
            ylim([0 maximum])
        elseif Variable(1,e) == "pr"
            ylim([0 maximum])
        elseif Variable(1,e) == "tasmax"
            ylim([minimum maximum])
        elseif Variable(1,e) == "VPD"
            ylim([0 maximum])                
        end
        xlim([1 184])
        title(Variable_name(1,e))
        xlabel("Days since 03/01")
        ylabel(Units(1,e))
        hold off
        
        
        % First 10 years
        subplot(5,2,e*2)

        c = 1;
        while c < 10+1 % first 10 years
            year2 = 2014+c; % start with 2015
            d = 1; % determine indices to plot for the year
            while d < size(time_c,1)+1
                if time_c(d,1) == year2 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                    start_index = d;
                end
                if time_c(d,1) == year2 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                    end_index = d;
                end
                d = d+1;
            end
            plot([1:end_extent],data(1,start_index:end_index),"-","LineWidth",1) % 184 = days in this period
            hold on
            grid on
            c = c+1;
        end
        if Variable(1,e) == "hurs"
            ylim([0 100])
        elseif Variable(1,e) == "hfls"
            ylim([0 maximum])
        elseif Variable(1,e) == "pr"
            ylim([0 maximum])
        elseif Variable(1,e) == "tasmax"
            ylim([minimum maximum])
        elseif Variable(1,e) == "VPD"
            ylim([0 maximum])                
        end
        xlim([1 184])
        title(Variable_name(1,e))
        xlabel("Days since 03/01")
        ylabel(Units(1,e))
        hold off

    e = e+1;
    end
    
    % Title
    sg = sprintf("Time Series: March-August\n%s\nLeft: 3 Most Extreme Cases, Right: 2015-2024", model(a));
    sgtitle(sg,'FontSize',24)

    % Set figure size in inches
    fig.Units = 'inches';
    fig.Position = [1, 1, 32, 16];  % [left, bottom, width, height] => 16x16 inches

    saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_Year/'+model(a)+'.png');
%     close(figure(a))
    
    a = a+1;
end

%% Time series of VPD and Temp for extreme events
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD","tasmax","hurs","pr","hfls"];
Units = ["VPD (Pa)","Temperature (K)","Relative Humidity (%)","Precipitation (mm)","Latent Heat Flux (W/m^2)"];
Variable_name = ["Vapor Pressure Defecit","Max Temperature","Relative Humidity","Precipitation","Latent Heat Flux"];

load coastlines

Extreme1(:,2) = [29361 29716 27206 29424 29730 30800 27560 30852 23511];
Extreme2(:,2) = [28623 27532 30830 30165 29040 27511 24285 23915 29701]; % replaced 29371 for 30165
Extreme3(:,2) = [25357 30820 26493 14805 26086 30387 26095 17318 30826]; % replaced 30165 for 14805

Extreme1(:,1) = [11088.8305303168 11449.6419289909 10563.6805492859 9694.73702625366 6686.93022029314 12610.2814069302 20199.0250854194 7045.62775321073 6776.57564152376];
Extreme2(:,1) = [9934.67120078053 10617.8065432737 10438.5623661379 9395.81610746577 6394.53353040419 10355.793640001 18485.6517426566 6879.53375591118 6679.5536695823]; % replaced 9469.6059138292 for 9395.81610746577
Extreme3(:,1) = [9793.06296282034 10275.273589424 10134.9014413799 9120.86232165862 6321.19238533541 10092.6149901998 17194.1108080571 6701.36243232667 6677.12139504387]; % replaced 9395.81610746577 for 9120.86232165862

a = 1;
while a < size(model,2)+1
    
    % Get dates for the model to use in plot names
    time_c = []; %(:x3) year, month, day
    year = 2015;
    month = 1;
    day = 1;
    c = 1;
    if model(a) == "KACE-1-0-G"
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
                    if floor(year/4) == ceil(year/4) || year ~= 2100 && model(a) ~= "INM-CM5-0" && model(a) ~= "INM-CM4-8" && model(a) ~= "CanESM5" && model(a) ~= "CanESM5-1" % 2100 = Leap year, models w/o leap years
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
    indices(1,1) = Extreme1(a,2);
    indices(1,2) = Extreme2(a,2);
    indices(1,3) = Extreme3(a,2);
    index = Extreme1(a,2);
    year(1,1) = time_c(index,1);
    month(1,1) = time_c(index,2);
    day(1,1) = time_c(index,3);
    index = Extreme2(a,2);
    year(1,2) = time_c(index,1);
    month(1,2) = time_c(index,2);
    day(1,2) = time_c(index,3);
    index = Extreme3(a,2);
    year(1,3) = time_c(index,1);
    month(1,3) = time_c(index,2);
    day(1,3) = time_c(index,3);
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    VPD = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(VPD,1, "omitnan");
    VPD = [];
    VPD(1,:) = mean(model_avg1,1, "omitnan");
    
    if model(a) == "KACE-1-0-G"
        end_day = 30;
        end_extent = 180;
    else
        end_day = 31;
        end_extent = 184;
    end
    
    years_before = 0;
    
    fig = figure(a)
    
    e = 1;
    while e < size(Variable,2)+1
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_"+Variable(1,e)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(1,e));

        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        data = [];
        data(1,:) = mean(model_avg1,1, "omitnan");
        
        maximum = max(data);
        minimum = min(data);
        
        
        % Extremes
        subplot(5,1,e)

        b = 1;
        while b < size(year,2)+1 % loop each extreme event
            c = 0;
            while c < years_before+1 % three years before the extreme event + the extreme event(c=0)
                if c == 0 % plot extreme event
                    year1 = year(1,b);
                    d = 1; % determine indices to plot for the year
                    while d < size(time_c,1)+1
                        if time_c(d,1) == year1 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                            start_index = d;
                        end
                        if time_c(d,1) == year1 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                            end_index = d;
                        end
                        d = d+1;
                    end
                    plot([1:end_extent],data(1,start_index:end_index),"LineWidth",2) % 184 = days in this period
                    grid on
                    hold on
                    num = indices(1,b) - start_index +1;
                    plot(num,data(1,indices(1,b)),"*r")

                else % plot years prior
                    year1 = year(1,b)-c;
                    d = 1; % determine indices to plot for the year
                    while d < size(time_c,1)+1
                        if time_c(d,1) == year1 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                            start_index = d;
                        end
                        if time_c(d,1) == year1 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                            end_index = d;
                        end
                        d = d+1;
                    end
                    plot([1:end_extent],data(1,start_index:end_index),"-","LineWidth",1) % 184 = days in this period
                    grid on
                end
                c = c+1;
            end
            b = b+1;
        end
        if Variable(1,e) == "hurs"
            ylim([0 100])
        elseif Variable(1,e) == "hfls"
            ylim([0 maximum])
        elseif Variable(1,e) == "pr"
            ylim([0 maximum])
        elseif Variable(1,e) == "tasmax"
            ylim([minimum maximum])
        elseif Variable(1,e) == "VPD"
            ylim([0 maximum])                
        end
        xlim([1 184])
        title(Variable_name(1,e))
        xlabel("Days since 03/01")
        ylabel(Units(1,e))
        ax = gca;
        ax.FontSize = 16;
        hold off

    e = e+1;
    end
    
    % Title
    sg = sprintf("Time Series: March-August, %s\n3 Most Extreme Cases", model(a));
    sgtitle(sg,'FontSize',24)

    % Set figure size in inches
    fig.Units = 'inches';
    fig.Position = [1, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches

    saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_Year/'+model(a)+'.png');
    close(figure(a))
    
    a = a+1;
end

%% Time series of VPD and Temp for first 20 years
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD","tasmax","hurs","pr","hfls"];
Units = ["VPD (Pa)","Temperature (K)","Relative Humidity (%)","Precipitation (mm)","Latent Heat Flux (W/m^2)"];
Variable_name = ["Vapor Pressure Defecit","Max Temperature","Relative Humidity","Precipitation","Latent Heat Flux"];

load coastlines

a = 1;
while a < size(model,2)+1
    
    % Get dates for the model to use in plot names
    time_c = []; %(:x3) year, month, day
    year = 2015;
    month = 1;
    day = 1;
    c = 1;
    if model(a) == "KACE-1-0-G"
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
                    if floor(year/4) == ceil(year/4) || year ~= 2100 && model(a) ~= "INM-CM5-0" && model(a) ~= "INM-CM4-8" && model(a) ~= "CanESM5" && model(a) ~= "CanESM5-1" % 2100 = Leap year, models w/o leap years
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

    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    VPD = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(VPD,1, "omitnan");
    VPD = [];
    VPD(1,:) = mean(model_avg1,1, "omitnan");
    
    if model(a) == "KACE-1-0-G"
        end_day = 30;
        end_extent = 180;
    else
        end_day = 31;
        end_extent = 184;
    end
    
    fig = figure(a)
    
    e = 1;
    while e < size(Variable,2)+1
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_"+Variable(1,e)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(1,e));

        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        data = [];
        data(1,:) = mean(model_avg1,1, "omitnan");
        
        maximum = max(data);
        minimum = min(data); 
        
        % First 20 years
        subplot(5,1,e)

        c = 1;
        while c < 20+1 % first 20 years
            year2 = 2014+c; % start with 2015
            d = 1; % determine indices to plot for the year
            while d < size(time_c,1)+1
                if time_c(d,1) == year2 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                    start_index = d;
                end
                if time_c(d,1) == year2 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                    end_index = d;
                end
                d = d+1;
            end
            plot([1:end_extent],data(1,start_index:end_index),"-","LineWidth",1) % 184 = days in this period
            hold on
            grid on
            c = c+1;
        end
        if Variable(1,e) == "hurs"
            ylim([0 100])
        elseif Variable(1,e) == "hfls"
            ylim([0 maximum])
        elseif Variable(1,e) == "pr"
            ylim([0 maximum])
        elseif Variable(1,e) == "tasmax"
            ylim([minimum maximum])
        elseif Variable(1,e) == "VPD"
            ylim([0 maximum])                
        end
        xlim([1 184])
        title(Variable_name(1,e))
        xlabel("Days since 03/01")
        ylabel(Units(1,e))
        ax = gca;
        ax.FontSize = 16;
        hold off

    e = e+1;
    end
    
    % Title
    sg = sprintf("Time Series: March-August, %s\nFirst 20 Years (2015-35)", model(a));
    sgtitle(sg,'FontSize',24)

    % Set figure size in inches
    fig.Units = 'inches';
    fig.Position = [1, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches

    saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_Year/'+model(a)+'_First20.png');
    close(figure(a))
    
    a = a+1;
end

%% Time series of VPD and Temp for extreme events with avg first20 year overlaid
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["VPD","tasmax","hurs","pr","hfls"];
Units = ["VPD (Pa)","Temperature (K)","Relative Humidity (%)","Precipitation (mm)","Latent Heat Flux (W/m^2)"];
Variable_name = ["Vapor Pressure Deficit","Maximum Temperature","Relative Humidity","Precipitation","Latent Heat Flux"];

load coastlines

Extreme1(:,2) = [29361 29716 27206 29424 29730 30800 27560 30852 23511];
Extreme2(:,2) = [28623 27532 30830 30165 29040 27511 24285 23915 29701]; % replaced 29371 for 30165
Extreme3(:,2) = [25357 30820 26493 14805 26086 30387 26095 17318 30826]; % replaced 30165 for 14805

Extreme1(:,1) = [11088.8305303168 11449.6419289909 10563.6805492859 9694.73702625366 6686.93022029314 12610.2814069302 20199.0250854194 7045.62775321073 6776.57564152376];
Extreme2(:,1) = [9934.67120078053 10617.8065432737 10438.5623661379 9395.81610746577 6394.53353040419 10355.793640001 18485.6517426566 6879.53375591118 6679.5536695823]; % replaced 9469.6059138292 for 9395.81610746577
Extreme3(:,1) = [9793.06296282034 10275.273589424 10134.9014413799 9120.86232165862 6321.19238533541 10092.6149901998 17194.1108080571 6701.36243232667 6677.12139504387]; % replaced 9395.81610746577 for 9120.86232165862

a = 1;
while a < size(model,2)+1
    
    % Get dates for the model to use in plot names
    time_c = []; %(:x3) year, month, day
    year = 2015;
    month = 1;
    day = 1;
    c = 1;
    if model(a) == "KACE-1-0-G"
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
                    if floor(year/4) == ceil(year/4) || year ~= 2100 && model(a) ~= "INM-CM5-0" && model(a) ~= "INM-CM4-8" && model(a) ~= "CanESM5" && model(a) ~= "CanESM5-1" % 2100 = Leap year, models w/o leap years
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
    indices(1,1) = Extreme1(a,2);
    indices(1,2) = Extreme2(a,2);
    indices(1,3) = Extreme3(a,2);
    index = Extreme1(a,2);
    year(1,1) = time_c(index,1);
    month(1,1) = time_c(index,2);
    day(1,1) = time_c(index,3);
    index = Extreme2(a,2);
    year(1,2) = time_c(index,1);
    month(1,2) = time_c(index,2);
    day(1,2) = time_c(index,3);
    index = Extreme3(a,2);
    year(1,3) = time_c(index,1);
    month(1,3) = time_c(index,2);
    day(1,3) = time_c(index,3);
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_VPD_daily_20150101_21001231.nc";
    VPD = ncread(filename, "VPD");

    model_avg1 = [];
    model_avg1(:,:) = mean(VPD,1, "omitnan");
    VPD = [];
    VPD(1,:) = mean(model_avg1,1, "omitnan");
    
    if model(a) == "KACE-1-0-G"
        end_day = 30;
        end_extent = 180;
    else
        end_day = 31;
        end_extent = 184;
    end
    
    years_before = 0;
    
    fig = figure(a)
    
    e = 1;
    while e < size(Variable,2)+1
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_Weighted_Landmasked_SW-US_"+Variable(1,e)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(1,e));
        
        if Variable(e) == "pr"
           data = data*86400;
        end
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        data = [];
        data(1,:) = mean(model_avg1,1, "omitnan");
        
        maximum = max(data);
        minimum = min(data);
        
        
        % Extremes
        subplot(5,1,e)

        b = 1;
        while b < size(year,2)+1 % loop each extreme event
            c = 0;
            while c < years_before+1 % three years before the extreme event + the extreme event(c=0)
                if c == 0 % plot extreme event
                    year1 = year(1,b);
                    d = 1; % determine indices to plot for the year
                    while d < size(time_c,1)+1
                        if time_c(d,1) == year1 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                            start_index = d;
                        end
                        if time_c(d,1) == year1 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                            end_index = d;
                        end
                        d = d+1;
                    end
                    plot([1:end_extent],data(1,start_index:end_index),"LineWidth",2) % 184 = days in this period
                    grid on
                    hold on
                    num = indices(1,b) - start_index +1;
                    plot(num,data(1,indices(1,b)),"*r")

                else % plot years prior
                    year1 = year(1,b)-c;
                    d = 1; % determine indices to plot for the year
                    while d < size(time_c,1)+1
                        if time_c(d,1) == year1 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                            start_index = d;
                        end
                        if time_c(d,1) == year1 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                            end_index = d;
                        end
                        d = d+1;
                    end
                    plot([1:end_extent],data(1,start_index:end_index),"-","LineWidth",2) % 184 = days in this period
                    grid on
                end
                c = c+1;
            end
            b = b+1;
        end
        if Variable(1,e) == "hurs"
            ylim([0 100])
        elseif Variable(1,e) == "hfls"
            ylim([0 maximum])
        elseif Variable(1,e) == "pr"
            ylim([0 maximum])
        elseif Variable(1,e) == "tasmax"
            ylim([minimum maximum])
        elseif Variable(1,e) == "VPD"
            ylim([0 maximum])                
        end
        xlim([1 184])
        title(Variable_name(1,e))
        xlabel("Days since 03/01")
        ylabel(Units(1,e))
        ax = gca;
        ax.FontSize = 16;
        
        % First 20 years
        subplot(5,1,e)

        c = 1;
        while c < 20+1 % first 20 years
            year2 = 2014+c; % start with 2015
            d = 1; % determine indices to plot for the year
            while d < size(time_c,1)+1
                if time_c(d,1) == year2 && time_c(d,2) == 3 && time_c(d,3) == 1 % plot starting march 1st of that year
                    start_index = d;
                end
                if time_c(d,1) == year2 && time_c(d,2) == 8 && time_c(d,3) == end_day % plot ending August 31st of that year
                    end_index = d;
                end
                d = d+1;
            end
            
            oneyear = data(1,start_index:end_index);

            if c == 1
                first20 = oneyear;
            else
                first20 = first20 + oneyear;
            end

            c = c+1;
        end
        plot([1:end_extent],first20/20,"-k","LineWidth",2)      
        hold off
        
    e = e+1;
    end
    
    % Title
    sg = sprintf("Time Series: March-August, %s\n3 Most Extreme Cases", model(a));
    sgtitle(sg,'FontSize',24)

    % Set figure size in inches
    fig.Units = 'inches';
    fig.Position = [1, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches

    saveas(fig, '/home/disk/eos8/dglopez/pictures/Timeseries_Year/'+model(a)+'avgfirst20_and _extremes.png');
    close(figure(a))
    
    a = a+1;
end
