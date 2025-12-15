%% Plot map VPD extremes
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Max Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Defecit"];

Variable = [Variable(1,13)];
Units = [Units(1,13)];
Variable_name = [Variable_name(1,13)];

Extreme1(:,2) = [29361 29716 27206 29424 29730 30800 27560 30852 23511];
Extreme2(:,2) = [28623 27532 30830 30165 29040 27511 24285 23915 29701]; % replaced 29371 for 30165
Extreme3(:,2) = [25357 30820 26493 14805 26086 30387 26095 17318 30826]; % replaced 30165 for 14805

Extreme1(:,1) = [11088.8305303168 11449.6419289909 10563.6805492859 9694.73702625366 6686.93022029314 12610.2814069302 20199.0250854194 7045.62775321073 6776.57564152376];
Extreme2(:,1) = [9934.67120078053 10617.8065432737 10438.5623661379 9395.81610746577 6394.53353040419 10355.793640001 18485.6517426566 6879.53375591118 6679.5536695823]; % replaced 9469.6059138292 for 9395.81610746577
Extreme3(:,1) = [9793.06296282034 10275.273589424 10134.9014413799 9120.86232165862 6321.19238533541 10092.6149901998 17194.1108080571 6701.36243232667 6677.12139504387]; % replaced 9395.81610746577 for 9120.86232165862

load coastlines
a = 1;
b = 1;
while a < 3+1 % three extremes
    fig = figure(a)
    
    while b < size(model,2)+1
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_"+Variable+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable);
        lat = ncread(filename, "lat");
        lon = ncread(filename, "lon");
        [lat, lon] = meshgrid(lat,lon);
        
        if a == 1
            data = data(:,:,Extreme1(b,2));
        elseif a == 2
            data = data(:,:,Extreme2(b,2));
        elseif a == 3
            data = data(:,:,Extreme3(b,2));
        end
        
        d = 1;
        e = 1;
        while d  < size(data,1)+1
            while e  < size(data,2)+1
                if data(d,e) < 1000
                    data(d,e) = NaN;
                end
                e = e+1;
            end
            d = d+1;
            e = 1;
        end
        
        subplot(3,3,b)
        ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
        
        levels = [1000:2000:25000];
        axis_spread = [1000 25000];
        
        contourfm(lat, lon, data, levels, "LineWidth", 0.1, "Color", [1 1 1]);
        
        caxis(axis_spread)
        contourcmap("jet")
        cb = contourcbar("eastoutside");
        cb.XLabel.String = Units;
        cb.Ticks = [1000:4000:25000];
        
        hold on

        geoshow(coastlat,coastlon, "Color", "k");
        
        m_lat_min = (22);% Define corners of the box 
        m_lat_max = (42);
        m_lon_min = (237);
        m_lon_max = (267);
        lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
        lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
        plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box
        
        title(model(b))
        ax = gca;
        ax.FontSize = 16;
        hold off
        
        b = b+1;
    end
    
    if a == 1
        word = "1st Extreme";
    elseif a == 2
        word = "2nd Extreme";
    elseif a == 3
        word = "3rd Extreme";
    end
    sg = sprintf("Vapor Pressure Deficit Extremes: %s",word);
    sgtitle(sg,'FontSize',24)
    
    % Set figure size in inches
    fig.Units = 'inches';
    fig.Position = [1, 1, 16, 12];  % [left, bottom, width, height] => 16x16 inches
    
    num = string(a);
    saveas(fig, '/home/disk/eos8/dglopez/pictures/Extreme_Event/Map_VPD_Extreme'+num+'_All.png');
    
    b = 1;
    a = a+1;
end