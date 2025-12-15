%% Precip and IVT

% clear all
% close all
% clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];

load coastlines

filename = '/home/disk/p/dglopez/Extreme_VPD_Index.csv';
CSV = readtable(filename);
high(:,1) = table2array(CSV(:,1));
high_index(:,1) = table2array(CSV(:,2));

b = 2;
while b < 9+1 % 9 models
    
    index_mid = high_index(b);
    a = index_mid - 20;
    while a < index_mid+20+1
    
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


        % Keep only winds every 2nd Can, 3rd INM IPSL MPI-LR, 4th KACE MIROC, 6th MPI-HR for
        % ease of view, and rescale wind barbs
        if model(b) == "CanESM5-1" || model(b) == "CanESM5"
            step = 1;
            barb_scale = .9; % Wind barb scaling size
            IVT_scale = 2; % IVT arrow scaling size
        elseif model(b) == "INM-CM4-8" || model(b) == "INM-CM5-0" || model(b) == "MPI-ESM1-2-LR"
            step = 2;
            barb_scale = 1.8;
            IVT_scale = 3;
        elseif model(b) == "IPSL-CM6A-LR"
            step = 2;
            barb_scale = 2.5;
            IVT_scale = 3;
        elseif model(b) == "KACE-1-0-G"
            step = 3;
            barb_scale = 2.7;
            IVT_scale = 4;
        elseif model(b) == "MIROC6"
            step = 3;
            barb_scale = 2.3;
            IVT_scale = 4;
        elseif model(b) == "MPI-ESM1-2-HR"
            step = 5;
            barb_scale = 3.8;
            IVT_scale = 6;
        end

        fig = figure(a+1300000)

            % Precip and IVT
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_pr_daily_20150101_21001231.nc";
            pr = ncread(filename, "pr");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_IVT_daily_20150101_21001231.nc";
            IVTv = ncread(filename, "IVTv");
            IVTu = ncread(filename, "IVTu");
            IVT = ncread(filename, "IVT");

            pr = pr(:,:,a)*86400; % flux /s to /day
            IVTu = IVTu(:,:,a);
            IVTv = IVTv(:,:,a);
            IVT = IVT(:,:,a);

            % Remove every other wind row to make plotting easier to see
            c = 1;
            while c < size(IVTu,1)+1
                IVTu(c+1:c+step,:) = NaN;
                IVTv(c+1:c+step,:) = NaN;
                c = c+step+1;
            end
            c = 1;
            while c < size(IVTu,2)+1
                IVTu(:,c+1:c+step) = NaN;
                IVTv(:,c+1:c+step) = NaN;
                c = c+step+1;
            end
            u = [];
            v = [];
            if size(IVTu,1) > size(lon,1) || size(IVTu,1) > size(lat,2)
                d = size(lon,1);
                e = size(lat,2);
                u(1:d,1:e) = IVTu(1:d,1:e);
                v(1:d,1:e) = IVTv(1:d,1:e);
            end
            IVTu = u;
            IVTv = v;
            clear u v
            
            % max IVT
            max_IVT = max(IVT);
            max_IVT = max(max_IVT);
            
            % max/min wap
            max_precip = max(pr);
            max_precip = max(max_precip);
            
            c = 1; % plot precip > 10^-.5 mm/m^2*day only
            d = 1;
            while c < size(pr,1)+1
                while d < size(pr,2)+1
                    if pr(c,d) > 10^-.5

                    else
                        pr(c,d) = NaN;
                    end
                    d = d+1;
                end
                d = 1;
                c = c+1;
            end

            ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            ax.FontSize = 16;

            levels = [10^-.5, 10^-.25, 10^0, 10^.25, 10^.5, 10^.75, 10^1, 10^1.25, 10^1.5, 10^1.75, 10^2];
            contourfm(lat, lon, pr(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            
            c = colorbar;
            c.Ticks = levels;
            c.XLabel.String = "Precipitation (mm)";
            set(gca,'ColorScale','log');
            caxis([10^-.5 10^2])

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);
            
            quiverm(lat,lon,IVTv(:,:),IVTu(:,:),"r",IVT_scale)

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off
            

            % Title
            sg = sprintf("Precipitation and IVT\nMost Extreme VPD Day: %s, Max VPD Avg = %g (Pa)\nMax IVT = %g (Kg/m*s)\nDate: %d/%d/%d", model(b),high(b,1),max_IVT,time_c(a,2),time_c(a,3),time_c(a,1));
            sgtitle(sg,'FontSize',24)

            % Set figure size in inches
            fig.Units = 'inches';
            fig.Position = [1, 1, 32, 16];  % [left, bottom, width, height] => 16x16 inches
            c = a-index_mid;
            saveas(fig, '/home/disk/eos8/dglopez/pictures/Extreme_Event/Precip-IVT/Most-Extreme/'+model(b)+'/Most-Extreme-VPD_Precip-IVT_'+'Day_'+c+'_'+a+'.png');
            close(figure(a+1300000))
            
        a = a+1;
    end
        close all
    b = b+1;
end