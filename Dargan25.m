%% Plot map first 20 years
clear all
close all
clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas","e","es","VPD"];
Units = ["Latent Heat Flux (W/m^2)","Relative Humidity (%)","Specific Humidity","Precipitation (mm)","Pressure (Pa)","Temperature (K)","Temperature (K)","Temperature (K)","Speed (m/s)","Speed (m/s)","Vapor Pressure (Pa)","Vapor Pressure (Pa)","VPD (Pa)"];
Variable_name = ["Latent Heat Flux","Relative Humidity","Specific Humidity","Precipitation","Sea Level Pressure","Temperature","Maximum Temperature","Min Temperature","Zonal Wind Speed","Meridional Wind Speed","Actual Vapor Pressure","Saturation Vapor Pressure","Vapor Pressure Deficit"];

Variable = [Variable(1,4),Variable(1,2),Variable(1,7),Variable(1,13)];
Units = [Units(1,4),Units(1,2),Units(1,7),Units(1,13)];
Variable_name = [Variable_name(1,4),Variable_name(1,2),Variable_name(1,7),Variable_name(1,13)];

load coastlines
a = 1;
b = 1;
while a < size(Variable,2)+1
    fig = figure(a+4)
    
    while b < size(model,2)+1
        if Variable(a) == "huss" && model(b) == "IPSL-CM6A-LR" % No huss for IPSL
            b = b+1;
        end
        filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_"+Variable(a)+"_daily_20150101_21001231.nc";
        data = ncread(filename, Variable(a));
        lat = ncread(filename, "lat");
        lon = ncread(filename, "lon");
        [lat, lon] = meshgrid(lat,lon);
        
        if Variable(a) == "pr"
           data = data*86400;
        end
        
        time = [1:(86*365)]; % resize to 365 day years
        model_avg = [];
        c = 1;
        d = 1;
        while c < size(data,1)+1
            while d < size(data,2)+1
                data1 = [];
                data1(1,:) = data(c,d,:);
                data1 = interp1(linspace(1, length(time), length(data1)), data1, 1:length(time), 'linear');
                model_avg(c,d,:) = data1;
                d = d+1;
            end
            c = c+1;
            d = 1;
        end
        
        first20 = [];
        last20 = [];
        diff = [];
        
        first20(:,:,:) = model_avg(:,:,1:365*20); 
        last20(:,:,:) = model_avg(:,:,66*365+1:end);
        diff = last20 - first20;

        first20 = mean(first20,3, "omitnan");
        last20 = mean(last20,3, "omitnan");
        diff = mean(diff,3, "omitnan");
        
        subplot(3,3,b)
        ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
        
        if Variable(a) == "VPD"
            levels = [-500,0:1000:6000];
            axis_spread = [-500 6000];
            ticks = levels;
        elseif Variable(a) == "tasmax"
            levels = [250:5:320];
            axis_spread = [250 320];
            ticks = [250:10:320];
        elseif Variable(a) == "hurs"
            levels = [0:5:100];
            axis_spread = [0 100];
            ticks = levels;
        elseif Variable(a) == "pr"
            levels = [0, 10^0, 10^.25, 10^.5, 10^.75, 10^1, 10^1.25];
        end
        
        contourfm(lat, lon, first20, levels, "LineWidth", 0.1, "Color", [1 1 1]);
        
        if Variable(a) == "pr"
            caxis([-10^-.5 10^1.25])
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = "Precipitation (mm)";
            cb.Ticks = [0, 10^.25, 10^.5, 10^.75, 10^1, 10^1.25];
        elseif Variable(a) == "hurs"
            caxis(axis_spread)
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = Units(a);
            cb.Ticks = [0:10:100];
        else
            caxis(axis_spread)
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = Units(a);
            cb.Ticks = ticks;
        end
        
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
    
    sg = sprintf("Maps: First 20 yr\n%s",Variable_name(a));
    sgtitle(sg,'FontSize',24)
    
    % Set figure size in inches
    fig.Units = 'inches';
    fig.Position = [1, 1, 16, 12];  % [left, bottom, width, height] => 16x16 inches
    saveas(fig, '/home/disk/eos8/dglopez/pictures/Differences_Variable/First20_Hemisphere_Map_'+Variable(a)+'_All.png');
    
    b = 1;
    a = a+1;
end
