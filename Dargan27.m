%% Time series of VPD and Temp for extreme events with avg first20 year overlaid - Extended KACE-1-0-G model only
clear all
close all
clc

model = ["MPI-ESM1-2-LR"];
Variable = ["VPD","tasmax","hurs","pr","hfls"];
Units = ["VPD (Pa)","Temperature (K)","Relative Humidity (%)","Precipitation (mm)","Latent Heat Flux (W/m^2)"];
Variable_name = ["Vapor Pressure Deficit","Maximum Temperature","Relative Humidity","Precipitation","Latent Heat Flux"];


load coastlines

Extreme1(:,2) = [23511];
Extreme2(:,2) = [29701];
Extreme3(:,2) = [30826];

Extreme1(:,1) = [6776.57564152376];
Extreme2(:,1) = [6679.5536695823];
Extreme3(:,1) = [6677.12139504387];


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
                    plot([-19:end_extent],data(1,start_index-20:end_index),"LineWidth",2) % 184 = days in this period
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
                    plot([-19:end_extent],data(1,start_index-20:end_index),"-","LineWidth",2) % 184 = days in this period
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
        xlim([-19 184])
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
            
            oneyear = data(1,start_index-20:end_index);

            if c == 1
                first20 = oneyear;
            else
                first20 = first20 + oneyear;
            end

            c = c+1;
        end
        plot([-19:end_extent],first20/20,"-k","LineWidth",2)      
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