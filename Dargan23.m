%% Create box timeseries, ALL + Ensemble avg, dif plot by varible in subplots with all models overlayed, SW-US
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Defecit"];

Variable = [Variable(1,7),Variable(1,8),Variable(1,2),Variable(1,3),Variable(1,1),Variable(1,5),Variable(1,9),Variable(1,10)];
Units = [Units(1,7),Units(1,8),Units(1,2),Units(1,3),Units(1,1),Units(1,5),Units(1,9),Units(1,10)];
Variable_name = [Variable_name(1,7),Variable_name(1,8),Variable_name(1,2),Variable_name(1,3),Variable_name(1,1),Variable_name(1,5),Variable_name(1,9),Variable_name(1,10)];

Colors = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 0.4940 0.1840 0.5560; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840; 0 0 0]; % Colors by model
% red green blue cyan magenta yellow purpleish orangeish maroonish black

% fraction of years
fraction = [1:365]/365;

fig = figure(2)
sgtitle("Ensemble Time Series (a)",'FontSize',24)

model_data = [];
a = 1;
b = 1;
while a < size(Variable,2)+1
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        model_avg = [];
        model_avg(1,:) = mean(model_avg1,1, "omitnan");
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');
        
        % time series of first and last 20 years
        first20 = model_avg(1,1:365*20); 
        last20 = model_avg(1,66*365+1:end);
        diff = last20 - first20;

        % 20 year average for first/last 20 & diff
        c = 1;
        d = 1;
        e = []; % first
        f = []; % last
        g = []; % diff
        while c < 20+1
            e(c,:) = first20(d:d+364);
            f(c,:) = last20(d:d+364);
            g(c,:) = diff(d:d+364);
            d = d+365;
            c = c+1;
        end
        first20 = mean(e,1, "omitnan");
        last20 = mean(f,1, "omitnan");
        diff = mean(g,1, "omitnan");
        
        if b == 1
            sum_first = first20;
            sum_last = last20;
            sum_diff = diff;
        else
            sum_first = sum_first + first20;
            sum_last = sum_last + last20;
            sum_diff = sum_diff + diff;
        end
        
        subplot(4,2,a)
        
        plot(fraction, diff(:), 'MarkerFace', Colors(b,:), "LineWidth", 2)
        title(Variable_name(a))
        xlabel("Year")
        ylabel(Units(a))
        xlim([0, 1])
        ax = gca;
        ax.FontSize = 12;
        hold on
        
        b = b+1;
    end
    ensemble_diff = sum_diff/size(model,2);
    plot(fraction, ensemble_diff, 'MarkerFace', Colors(b,:), "LineWidth", 2) % ensemble average plotting
    title(Variable_name(a))
    xlabel("Year")
    ylabel(Units(a))
    xlim([0, 1])
    ax = gca;
    ax.FontSize = 12;
    hold off
    
    b = 1;
    a = a+1;
end

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches
saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Model/Differences_SW-US_Timeseries_a.png');

%% Create box timeseries, ALL + Ensemble avg, dif plot by varible in subplots with all models overlayed, SW-US
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Deficit (daily)"];

Variable = [Variable(1,6),Variable(1,4),Variable(1,11),Variable(1,12),Variable(1,13)];
Units = [Units(1,6),Units(1,4),Units(1,11),Units(1,12),Units(1,13)];
Variable_name = [Variable_name(1,6),Variable_name(1,4),Variable_name(1,11),Variable_name(1,12),Variable_name(1,13)];

Colors = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 0.4940 0.1840 0.5560; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840; 0 0 0]; % Colors by model
% red green blue cyan magenta yellow purpleish orangeish maroonish black

% fraction of years
fraction = [1:365]/365;

fig = figure(3)
sgtitle("Ensemble Time Series (b)",'FontSize',24)

model_data = [];
a = 1;
b = 1;
while a < size(Variable,2)+1
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        model_avg = [];
        model_avg(1,:) = mean(model_avg1,1, "omitnan");
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');
        
        % time series of first and last 20 years
        first20 = model_avg(1,1:365*20); 
        last20 = model_avg(1,66*365+1:end);
        diff = last20 - first20;

        % 20 year average for first/last 20 & diff
        c = 1;
        d = 1;
        e = []; % first
        f = []; % last
        g = []; % diff
        while c < 20+1
            e(c,:) = first20(d:d+364);
            f(c,:) = last20(d:d+364);
            g(c,:) = diff(d:d+364);
            d = d+365;
            c = c+1;
        end
        first20 = mean(e,1, "omitnan");
        last20 = mean(f,1, "omitnan");
        diff = mean(g,1, "omitnan");
        
        if b == 1
            sum_first = first20;
            sum_last = last20;
            sum_diff = diff;
        else
            sum_first = sum_first + first20;
            sum_last = sum_last + last20;
            sum_diff = sum_diff + diff;
        end
        
        if a == 5
            subplot(4,2,5:6)
        else
            subplot(4,2,a)
        end
        plot(fraction, diff(:), 'MarkerFace', Colors(b,:), "LineWidth", 2)
        title(Variable_name(a))
        xlabel("Year")
        ylabel(Units(a))
        xlim([0, 1])
        ax = gca;
        ax.FontSize = 12;
        hold on
        
        b = b+1;
    end
    ensemble_diff = sum_diff/size(model,2);
    plot(fraction, ensemble_diff, 'MarkerFace', Colors(b,:), "LineWidth", 2) % ensemble average plotting
    title(Variable_name(a))
    xlabel("Year")
    ylabel(Units(a))
    xlim([0, 1])
    ax = gca;
    ax.FontSize = 12;
    hold off
    
    b = 1;
    a = a+1;
end

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    % time series of first and last 20 years
    first20 = model_avg(1,1:12*20); 
    last20 = model_avg(1,66*12+1:end);
    diff = last20 - first20;

    % 20 year average for first/last 20 & diff
    c = 1;
    d = 1;
    e = []; % first
    f = []; % last
    g = []; % diff
    while c < 20+1
        e(c,:) = first20(d:d+11);
        f(c,:) = last20(d:d+11);
        g(c,:) = diff(d:d+11);
        d = d+12;
        c = c+1;
    end
    first20 = mean(e,1, "omitnan");
    last20 = mean(f,1, "omitnan");
    diff = mean(g,1, "omitnan");

    if b == 1
        sum_first = first20;
        sum_last = last20;
        sum_diff = diff;
    else
        sum_first = sum_first + first20;
        sum_last = sum_last + last20;
        sum_diff = sum_diff + diff;
    end
    
    time = [1:12];
    
    subplot(4,2,7:8)
    plot(time, diff(:), 'MarkerFace', Colors(b,:), "LineWidth", 2)
    title("VPD - Monthly")
    xlabel("Months since 01/2015")
    ylabel("VPD (Pa)")
    xlim([1, size(time,2)])
    ax = gca;
    ax.FontSize = 12;
    hold on

    b = b+1;
end
ensemble_avg = sum_diff/size(model,2);
subplot(4,2,7:8)
plot(time, ensemble_avg, 'MarkerFace', Colors(b,:), "LineWidth", 2) % ensemble average plotting
title("Vapor Pressure Deficit (monthly)")
xlabel("Months since 01/2015")
ylabel("VPD (Pa)")
xlim([1, size(time,2)])
ax = gca;
ax.FontSize = 12;
legend("CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR", "Ensemble Average",'Location','northeastoutside')
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [16, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches
saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Model/Differences_SW-US_Timeseries_b.png');

%% Create box timeseries, ALL + Ensemble avg, dif plot by varible in subplots with all models overlayed, SW-US
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Deficit (daily)"];

Variable = [Variable(1,7),Variable(1,4),Variable(1,11),Variable(1,12),Variable(1,2),Variable(1,1),Variable(1,13)];
Units = [Units(1,7),Units(1,4),Units(1,11),Units(1,12),Units(1,2),Units(1,1),Units(1,13)];
Variable_name = [Variable_name(1,7),Variable_name(1,4),Variable_name(1,11),Variable_name(1,12),Variable_name(1,2),Variable_name(1,1),Variable_name(1,13)];

% fraction of years
fraction = [1:365]/365;

fig = figure(4)
sgtitle("Ensemble Time Series: Differences (a)",'FontSize',24)

model_data = [];
a = 1;
b = 1;
while a < size(Variable,2)+1
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        
        if Variable(a) == "pr"
           data = data*86400;
        end
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        model_avg = [];
        model_avg(1,:) = mean(model_avg1,1, "omitnan");
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');
        
        % time series of first and last 20 years
        first20 = model_avg(1,1:365*20); 
        last20 = model_avg(1,66*365+1:end);
        diff = last20 - first20;

        % 20 year average for first/last 20 & diff
        c = 1;
        d = 1;
        e = []; % first
        f = []; % last
        g = []; % diff
        while c < 20+1
            e(c,:) = first20(d:d+364);
            f(c,:) = last20(d:d+364);
            g(c,:) = diff(d:d+364);
            d = d+365;
            c = c+1;
        end
        first20 = mean(e,1, "omitnan");
        last20 = mean(f,1, "omitnan");
        diff = mean(g,1, "omitnan");
        
        if b == 1
            sum_first = first20;
            sum_last = last20;
            sum_diff = diff;
        else
            sum_first = sum_first + first20;
            sum_last = sum_last + last20;
            sum_diff = sum_diff + diff;
        end
        
        if a == 7
            subplot(5,2,7:8)
        else
            subplot(5,2,a)
        end
        
        if model(b) == "CanESM5-1"
           plot(fraction,diff(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
        elseif model(b) == "CanESM5"
            plot(fraction,diff(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
        elseif model(b) == "INM-CM4-8"
            plot(fraction,diff(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
        elseif model(b) == "INM-CM5-0"
            plot(fraction,diff(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
%         elseif model(b) == "IPSL-CM6A-LR"
%             plot(fraction,diff(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
%         elseif model(b) == "KACE-1-0-G"
%             plot(fraction,diff(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
%         elseif model(b) == "MIROC6"
%             plot(fraction,diff(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-HR"
%             plot(fraction,diff(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-LR"
%             plot(fraction,diff(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
            
        title(Variable_name(a))
        xlabel("Fraction of Year")
        ylabel(Units(a))
        xlim([0, 1])
        ax = gca;
        ax.FontSize = 12;
        if Variable(a) == "tasmax"
            ylim([0 10])
        elseif Variable(a) == "pr"
            ylim([-10 5])
        elseif Variable(a) == "e"
            ylim([-500 2000])
        elseif Variable(a) == "es"
            ylim([0 5000])
        elseif Variable(a) == "hurs"
            ylim([-20 15])
        elseif Variable(a) == "hfls"
            ylim([-30 30])
        elseif Variable(a) == "VPD"
            ylim([-1000 4000])
        end
        hold on
        
        b = b+1;
    end
    ensemble_diff = sum_diff/size(model,2);
    plot(fraction,ensemble_diff, "-","color", "[0, 0, 0]", "LineWidth", 2) % ensemble average plotting
    title(Variable_name(a))
    xlabel("Fraction of Year")
    ylabel(Units(a))
    xlim([0, 1])
    ax = gca;
    ax.FontSize = 14;
    grid on
    hold off
    
    b = 1;
    a = a+1;
end

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    % time series of first and last 20 years
    first20 = model_avg(1,1:12*20); 
    last20 = model_avg(1,66*12+1:end);
    diff = last20 - first20;

    % 20 year average for first/last 20 & diff
    c = 1;
    d = 1;
    e = []; % first
    f = []; % last
    g = []; % diff
    while c < 20+1
        e(c,:) = first20(d:d+11);
        f(c,:) = last20(d:d+11);
        g(c,:) = diff(d:d+11);
        d = d+12;
        c = c+1;
    end
    first20 = mean(e,1, "omitnan");
    last20 = mean(f,1, "omitnan");
    diff = mean(g,1, "omitnan");

    if b == 1
        sum_first = first20;
        sum_last = last20;
        sum_diff = diff;
    else
        sum_first = sum_first + first20;
        sum_last = sum_last + last20;
        sum_diff = sum_diff + diff;
    end
    
    time = [1:12];
    
    subplot(5,2,9:10)
        if model(b) == "CanESM5-1"
           plot(time,diff(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
        elseif model(b) == "CanESM5"
            plot(time,diff(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
        elseif model(b) == "INM-CM4-8"
            plot(time,diff(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
        elseif model(b) == "INM-CM5-0"
            plot(time,diff(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
%         elseif model(b) == "IPSL-CM6A-LR"
%             plot(time,diff(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
%         elseif model(b) == "KACE-1-0-G"
%             plot(time,diff(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
%         elseif model(b) == "MIROC6"
%             plot(time,diff(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-HR"
%             plot(time,diff(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-LR"
%             plot(time,diff(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
        
    title("VPD - Monthly")
    xlabel("Months since 01/2015")
    ylabel("VPD (Pa)")
    xlim([1, size(time,2)])
    ylim([0 4000])
    ax = gca;
    ax.FontSize = 14;
    grid on
    hold on

    b = b+1;
end
ensemble_avg = sum_diff/size(model,2);
subplot(5,2,9:10)
plot(time, ensemble_avg, "-k", "LineWidth", 2) % ensemble average plotting
title("Vapor Pressure Deficit (monthly)")
xlabel("Months since 01/2015")
ylabel("VPD (Pa)")
xlim([1, size(time,2)])
ax = gca;
ax.FontSize = 14;
legend("CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0", "Ensemble Average",'Location','northeastoutside')
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 16, 20];  % [left, bottom, width, height] => 16x16 inches
saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Model/Differences_SW-US_Timeseries_Extended_a.png');

%% Create box timeseries, ALL + Ensemble avg, dif plot by varible in subplots with all models overlayed, SW-US
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Deficit (daily)"];

Variable = [Variable(1,7),Variable(1,4),Variable(1,11),Variable(1,12),Variable(1,2),Variable(1,1),Variable(1,13)];
Units = [Units(1,7),Units(1,4),Units(1,11),Units(1,12),Units(1,2),Units(1,1),Units(1,13)];
Variable_name = [Variable_name(1,7),Variable_name(1,4),Variable_name(1,11),Variable_name(1,12),Variable_name(1,2),Variable_name(1,1),Variable_name(1,13)];

% fraction of years
fraction = [1:365]/365;

fig = figure(5)
sgtitle("Ensemble Time Series: Differences (b)",'FontSize',24)

model_data = [];
a = 1;
b = 1;
while a < size(Variable,2)+1
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        
        if Variable(a) == "pr"
           data = data*86400;
        end
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        model_avg = [];
        model_avg(1,:) = mean(model_avg1,1, "omitnan");
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');
        
        % time series of first and last 20 years
        first20 = model_avg(1,1:365*20); 
        last20 = model_avg(1,66*365+1:end);
        diff = last20 - first20;

        % 20 year average for first/last 20 & diff
        c = 1;
        d = 1;
        e = []; % first
        f = []; % last
        g = []; % diff
        while c < 20+1
            e(c,:) = first20(d:d+364);
            f(c,:) = last20(d:d+364);
            g(c,:) = diff(d:d+364);
            d = d+365;
            c = c+1;
        end
        first20 = mean(e,1, "omitnan");
        last20 = mean(f,1, "omitnan");
        diff = mean(g,1, "omitnan");
        
        if b == 1
            sum_first = first20;
            sum_last = last20;
            sum_diff = diff;
        else
            sum_first = sum_first + first20;
            sum_last = sum_last + last20;
            sum_diff = sum_diff + diff;
        end
        
        if a == 7
            subplot(5,2,7:8)
        else
            subplot(5,2,a)
        end
        
        if model(b) == "CanESM5-1"
%            plot(fraction,diff(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
%         elseif model(b) == "CanESM5"
%             plot(fraction,diff(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
%         elseif model(b) == "INM-CM4-8"
%             plot(fraction,diff(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
%         elseif model(b) == "INM-CM5-0"
%             plot(fraction,diff(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
        elseif model(b) == "IPSL-CM6A-LR"
            plot(fraction,diff(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
        elseif model(b) == "KACE-1-0-G"
            plot(fraction,diff(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
        elseif model(b) == "MIROC6"
            plot(fraction,diff(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
        elseif model(b) == "MPI-ESM1-2-HR"
            plot(fraction,diff(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
        elseif model(b) == "MPI-ESM1-2-LR"
            plot(fraction,diff(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
            
        title(Variable_name(a))
        xlabel("Fraction of Year")
        ylabel(Units(a))
        xlim([0, 1])
        ax = gca;
        ax.FontSize = 12;
        if Variable(a) == "tasmax"
            ylim([0 10])
        elseif Variable(a) == "pr"
            ylim([-10 5])
        elseif Variable(a) == "e"
            ylim([-500 2000])
        elseif Variable(a) == "es"
            ylim([0 5000])
        elseif Variable(a) == "hurs"
            ylim([-20 15])
        elseif Variable(a) == "hfls"
            ylim([-30 30])
        elseif Variable(a) == "VPD"
            ylim([-1000 4000])
        end
        hold on
        
        b = b+1;
    end
    ensemble_diff = sum_diff/size(model,2);
    plot(fraction,ensemble_diff, "-","color", "[0, 0, 0]", "LineWidth", 2) % ensemble average plotting
    title(Variable_name(a))
    xlabel("Fraction of Year")
    ylabel(Units(a))
    xlim([0, 1])
    ax = gca;
    ax.FontSize = 14;
    grid on
    hold off
    
    b = 1;
    a = a+1;
end

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    % time series of first and last 20 years
    first20 = model_avg(1,1:12*20); 
    last20 = model_avg(1,66*12+1:end);
    diff = last20 - first20;

    % 20 year average for first/last 20 & diff
    c = 1;
    d = 1;
    e = []; % first
    f = []; % last
    g = []; % diff
    while c < 20+1
        e(c,:) = first20(d:d+11);
        f(c,:) = last20(d:d+11);
        g(c,:) = diff(d:d+11);
        d = d+12;
        c = c+1;
    end
    first20 = mean(e,1, "omitnan");
    last20 = mean(f,1, "omitnan");
    diff = mean(g,1, "omitnan");

    if b == 1
        sum_first = first20;
        sum_last = last20;
        sum_diff = diff;
    else
        sum_first = sum_first + first20;
        sum_last = sum_last + last20;
        sum_diff = sum_diff + diff;
    end
    
    time = [1:12];
    
    subplot(5,2,9:10)
    if model(b) == "CanESM5-1"
%        plot(time,diff(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
%     elseif model(b) == "CanESM5"
%         plot(time,diff(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
%     elseif model(b) == "INM-CM4-8"
%         plot(time,diff(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
%     elseif model(b) == "INM-CM5-0"
%         plot(time,diff(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
    elseif model(b) == "IPSL-CM6A-LR"
        plot(time,diff(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
    elseif model(b) == "KACE-1-0-G"
        plot(time,diff(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
    elseif model(b) == "MIROC6"
        plot(time,diff(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
    elseif model(b) == "MPI-ESM1-2-HR"
        plot(time,diff(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
    elseif model(b) == "MPI-ESM1-2-LR"
        plot(time,diff(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
    
    title("VPD - Monthly")
    xlabel("Months since 01/2015")
    ylabel("VPD (Pa)")
    xlim([1, size(time,2)])
    ylim([0 4000])
    ax = gca;
    ax.FontSize = 14;
    grid on
    hold on

    b = b+1;
end
ensemble_avg = sum_diff/size(model,2);
subplot(5,2,9:10)
plot(time, ensemble_avg, "-k", "LineWidth", 2) % ensemble average plotting
title("Vapor Pressure Deficit (monthly)")
xlabel("Months since 01/2015")
ylabel("VPD (Pa)")
xlim([1, size(time,2)])
ax = gca;
ax.FontSize = 14;
legend("IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR", "Ensemble Average",'Location','northeastoutside')
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [16, 1, 16, 20];  % [left, bottom, width, height] => 16x16 inches
saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Model/Differences_SW-US_Timeseries_Extended_b.png');

%% Create box timeseries, ALL + Ensemble avg, dif plot by varible in subplots with all models overlayed, SW-US
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Deficit (daily)"];

Variable = [Variable(1,7),Variable(1,4),Variable(1,11),Variable(1,12),Variable(1,2),Variable(1,1),Variable(1,13)];
Units = [Units(1,7),Units(1,4),Units(1,11),Units(1,12),Units(1,2),Units(1,1),Units(1,13)];
Variable_name = [Variable_name(1,7),Variable_name(1,4),Variable_name(1,11),Variable_name(1,12),Variable_name(1,2),Variable_name(1,1),Variable_name(1,13)];

% fraction of years
fraction = [1:365]/365;

fig = figure(4)
sgtitle("Ensemble Time Series: First 20 Years (a)",'FontSize',24)

model_data = [];
a = 1;
b = 1;
while a < size(Variable,2)+1
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        
        if Variable(a) == "pr"
           data = data*86400;
        end
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        model_avg = [];
        model_avg(1,:) = mean(model_avg1,1, "omitnan");
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');
        
        % time series of first and last 20 years
        first20 = model_avg(1,1:365*20); 
        last20 = model_avg(1,66*365+1:end);
        diff = last20 - first20;

        % 20 year average for first/last 20 & diff
        c = 1;
        d = 1;
        e = []; % first
        f = []; % last
        g = []; % diff
        while c < 20+1
            e(c,:) = first20(d:d+364);
            f(c,:) = last20(d:d+364);
            g(c,:) = diff(d:d+364);
            d = d+365;
            c = c+1;
        end
        first20 = mean(e,1, "omitnan");
        last20 = mean(f,1, "omitnan");
        diff = mean(g,1, "omitnan");
        
        if b == 1
            sum_first = first20;
            sum_last = last20;
            sum_diff = diff;
        else
            sum_first = sum_first + first20;
            sum_last = sum_last + last20;
            sum_diff = sum_diff + diff;
        end
        
        if a == 7
            subplot(5,2,7:8)
        else
            subplot(5,2,a)
        end
        
        if model(b) == "CanESM5-1"
           plot(fraction,first20(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
        elseif model(b) == "CanESM5"
            plot(fraction,first20(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
        elseif model(b) == "INM-CM4-8"
            plot(fraction,first20(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
        elseif model(b) == "INM-CM5-0"
            plot(fraction,first20(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
%         elseif model(b) == "IPSL-CM6A-LR"
%             plot(fraction,first20(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
%         elseif model(b) == "KACE-1-0-G"
%             plot(fraction,first20(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
%         elseif model(b) == "MIROC6"
%             plot(fraction,first20(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-HR"
%             plot(fraction,first20(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-LR"
%             plot(fraction,first20(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
            
        title(Variable_name(a))
        xlabel("Fraction of Year")
        ylabel(Units(a))
        xlim([0, 1])
        ax = gca;
        ax.FontSize = 12;
        if Variable(a) == "tasmax"
            ylim([280 320])
        elseif Variable(a) == "pr"
            ylim([0 15])
        elseif Variable(a) == "e"
            ylim([0 6000])
        elseif Variable(a) == "es"
            ylim([0 15000])
        elseif Variable(a) == "hurs"
            ylim([0 100])
        elseif Variable(a) == "hfls"
            ylim([0 110])
        elseif Variable(a) == "VPD"
            ylim([0 10000])
        end
        hold on
        
        b = b+1;
    end
    ensemble_diff = sum_first/size(model,2);
    plot(fraction,ensemble_diff, "-","color", "[0, 0, 0]", "LineWidth", 2) % ensemble average plotting
    title(Variable_name(a))
    xlabel("Fraction of Year")
    ylabel(Units(a))
    xlim([0, 1])
    ax = gca;
    ax.FontSize = 14;
    grid on
    hold off
    
    b = 1;
    a = a+1;
end

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    % time series of first and last 20 years
    first20 = model_avg(1,1:12*20); 
    last20 = model_avg(1,66*12+1:end);
    diff = last20 - first20;

    % 20 year average for first/last 20 & diff
    c = 1;
    d = 1;
    e = []; % first
    f = []; % last
    g = []; % diff
    while c < 20+1
        e(c,:) = first20(d:d+11);
        f(c,:) = last20(d:d+11);
        g(c,:) = diff(d:d+11);
        d = d+12;
        c = c+1;
    end
    first20 = mean(e,1, "omitnan");
    last20 = mean(f,1, "omitnan");
    diff = mean(g,1, "omitnan");

    if b == 1
        sum_first = first20;
        sum_last = last20;
        sum_diff = diff;
    else
        sum_first = sum_first + first20;
        sum_last = sum_last + last20;
        sum_diff = sum_diff + diff;
    end
    
    time = [1:12];
    
    subplot(5,2,9:10)
        if model(b) == "CanESM5-1"
           plot(time,first20(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
        elseif model(b) == "CanESM5"
            plot(time,first20(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
        elseif model(b) == "INM-CM4-8"
            plot(time,first20(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
        elseif model(b) == "INM-CM5-0"
            plot(time,first20(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
%         elseif model(b) == "IPSL-CM6A-LR"
%             plot(time,first20(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
%         elseif model(b) == "KACE-1-0-G"
%             plot(time,first20(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
%         elseif model(b) == "MIROC6"
%             plot(time,first20(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-HR"
%             plot(time,first20(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
%         elseif model(b) == "MPI-ESM1-2-LR"
%             plot(time,first20(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
        
    title("VPD - Monthly")
    xlabel("Months since 01/2015")
    ylabel("VPD (Pa)")
    xlim([1, size(time,2)])
    ax = gca;
    ax.FontSize = 14;
    ylim([0 10000])
    grid on
    hold on

    b = b+1;
end
ensemble_avg = sum_first/size(model,2);
subplot(5,2,9:10)
plot(time, ensemble_avg, "-k", "LineWidth", 2) % ensemble average plotting
title("Vapor Pressure Deficit (monthly)")
xlabel("Months since 01/2015")
ylabel("VPD (Pa)")
xlim([1, size(time,2)])
ax = gca;
ax.FontSize = 14;
legend("CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0", "Ensemble Average",'Location','northeastoutside')
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 16, 20];  % [left, bottom, width, height] => 16x16 inches
saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Model/First20_SW-US_Timeseries_Extended_a.png');

%% Create box timeseries, ALL + Ensemble avg, dif plot by varible in subplots with all models overlayed, SW-US
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Deficit (daily)"];

Variable = [Variable(1,7),Variable(1,4),Variable(1,11),Variable(1,12),Variable(1,2),Variable(1,1),Variable(1,13)];
Units = [Units(1,7),Units(1,4),Units(1,11),Units(1,12),Units(1,2),Units(1,1),Units(1,13)];
Variable_name = [Variable_name(1,7),Variable_name(1,4),Variable_name(1,11),Variable_name(1,12),Variable_name(1,2),Variable_name(1,1),Variable_name(1,13)];

% fraction of years
fraction = [1:365]/365;

fig = figure(5)
sgtitle("Ensemble Time Series: First 20 Years (b)",'FontSize',24)

model_data = [];
a = 1;
b = 1;
while a < size(Variable,2)+1
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        
        if Variable(a) == "pr"
           data = data*86400;
        end
        
        model_avg1 = [];
        model_avg1(:,:) = mean(data,1, "omitnan");
        model_avg = [];
        model_avg(1,:) = mean(model_avg1,1, "omitnan");
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = interp1(linspace(1, length(time), length(model_avg)), model_avg, 1:length(time), 'linear');
        
        % time series of first and last 20 years
        first20 = model_avg(1,1:365*20); 
        last20 = model_avg(1,66*365+1:end);
        diff = last20 - first20;

        % 20 year average for first/last 20 & diff
        c = 1;
        d = 1;
        e = []; % first
        f = []; % last
        g = []; % diff
        while c < 20+1
            e(c,:) = first20(d:d+364);
            f(c,:) = last20(d:d+364);
            g(c,:) = diff(d:d+364);
            d = d+365;
            c = c+1;
        end
        first20 = mean(e,1, "omitnan");
        last20 = mean(f,1, "omitnan");
        diff = mean(g,1, "omitnan");
        
        if b == 1
            sum_first = first20;
            sum_last = last20;
            sum_diff = diff;
        else
            sum_first = sum_first + first20;
            sum_last = sum_last + last20;
            sum_diff = sum_diff + diff;
        end
        
        if a == 7
            subplot(5,2,7:8)
        else
            subplot(5,2,a)
        end
        
        if model(b) == "CanESM5-1"
%            plot(fraction,first20(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
%         elseif model(b) == "CanESM5"
%             plot(fraction,first20(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
%         elseif model(b) == "INM-CM4-8"
%             plot(fraction,first20(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
%         elseif model(b) == "INM-CM5-0"
%             plot(fraction,first20(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
        elseif model(b) == "IPSL-CM6A-LR"
            plot(fraction,first20(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
        elseif model(b) == "KACE-1-0-G"
            plot(fraction,first20(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
        elseif model(b) == "MIROC6"
            plot(fraction,first20(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
        elseif model(b) == "MPI-ESM1-2-HR"
            plot(fraction,first20(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
        elseif model(b) == "MPI-ESM1-2-LR"
            plot(fraction,first20(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
            
        title(Variable_name(a))
        xlabel("Fraction of Year")
        ylabel(Units(a))
        xlim([0, 1])
        ax = gca;
        ax.FontSize = 12;
        if Variable(a) == "tasmax"
            ylim([280 320])
        elseif Variable(a) == "pr"
            ylim([0 15])
        elseif Variable(a) == "e"
            ylim([0 6000])
        elseif Variable(a) == "es"
            ylim([0 15000])
        elseif Variable(a) == "hurs"
            ylim([0 100])
        elseif Variable(a) == "hfls"
            ylim([0 110])
        elseif Variable(a) == "VPD"
            ylim([0 10000])
        end
        hold on
        
        b = b+1;
    end
    ensemble_diff = sum_first/size(model,2);
    plot(fraction,ensemble_diff, "-","color", "[0, 0, 0]", "LineWidth", 2) % ensemble average plotting
    title(Variable_name(a))
    xlabel("Fraction of Year")
    ylabel(Units(a))
    xlim([0, 1])
    ax = gca;
    ax.FontSize = 14;
    grid on
    hold off
    
    b = 1;
    a = a+1;
end

b = 1;
while b < size(model,2)+1 % VPD_m
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_Weighted_Landmasked_SW-US_VPD_m_monthly_20150101_21001231.nc";
    data = ncread(filename, "VPD_m");

    model_avg1 = [];
    model_avg1(:,:) = mean(data,1, "omitnan");
    model_avg = [];
    model_avg(1,:) = mean(model_avg1,1, "omitnan");

    % time series of first and last 20 years
    first20 = model_avg(1,1:12*20); 
    last20 = model_avg(1,66*12+1:end);
    diff = last20 - first20;

    % 20 year average for first/last 20 & diff
    c = 1;
    d = 1;
    e = []; % first
    f = []; % last
    g = []; % diff
    while c < 20+1
        e(c,:) = first20(d:d+11);
        f(c,:) = last20(d:d+11);
        g(c,:) = diff(d:d+11);
        d = d+12;
        c = c+1;
    end
    first20 = mean(e,1, "omitnan");
    last20 = mean(f,1, "omitnan");
    diff = mean(g,1, "omitnan");

    if b == 1
        sum_first = first20;
        sum_last = last20;
        sum_diff = diff;
    else
        sum_first = sum_first + first20;
        sum_last = sum_last + last20;
        sum_diff = sum_diff + diff;
    end
    
    time = [1:12];
    
    subplot(5,2,9:10)
    if model(b) == "CanESM5-1"
%        plot(time,first20(:), "-","color", "[1, 0, 0]", "LineWidth", 2)
%     elseif model(b) == "CanESM5"
%         plot(time,first20(:), "-","color", "[0, .5, 0]", "LineWidth", 2)
%     elseif model(b) == "INM-CM4-8"
%         plot(time,first20(:), "-","color", "[0, 0, 1]", "LineWidth", 2)
%     elseif model(b) == "INM-CM5-0"
%         plot(time,first20(:), "-","color", "[1, .75, 0]", "LineWidth", 2)
    elseif model(b) == "IPSL-CM6A-LR"
        plot(time,first20(:), "-","color", "[0, 0.4470, 0.7410]", "LineWidth", 2)
    elseif model(b) == "KACE-1-0-G"
        plot(time,first20(:), "-","color", "[0.8500, 0.3250, 0.0980]", "LineWidth", 2)
    elseif model(b) == "MIROC6"
        plot(time,first20(:), "-","color", "[0.4660, 0.6740, 0.1880]", "LineWidth", 2)
    elseif model(b) == "MPI-ESM1-2-HR"
        plot(time,first20(:), "-","color", "[0.9290 0.6940 0.1250]", "LineWidth", 2)
    elseif model(b) == "MPI-ESM1-2-LR"
        plot(time,first20(:), "-","color", "[0, 0.75, 0.75]", "LineWidth", 2)
        end
    
    title("VPD - Monthly")
    xlabel("Months since 01/2015")
    ylabel("VPD (Pa)")
    xlim([1, size(time,2)])
    ax = gca;
    ax.FontSize = 14;
    ylim([0 10000])
    grid on
    hold on

    b = b+1;
end
ensemble_avg = sum_first/size(model,2);
subplot(5,2,9:10)
plot(time, ensemble_avg, "-k", "LineWidth", 2) % ensemble average plotting
title("Vapor Pressure Deficit (monthly)")
xlabel("Months since 01/2015")
ylabel("VPD (Pa)")
xlim([1, size(time,2)])
ax = gca;
ax.FontSize = 14;
legend("IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR", "Ensemble Average",'Location','northeastoutside')
hold off

% Set figure size in inches
fig.Units = 'inches';
fig.Position = [16, 1, 16, 20];  % [left, bottom, width, height] => 16x16 inches
saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Model/First20_SW-US_Timeseries_Extended_b.png');



