%% Actual (from anomalies plot) 500mb zg, tas, pr, psl, VPD, hurs

% clear all
% close all
% clc

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];

load coastlines

filename = '/home/disk/p/dglopez/Extreme_VPD_Index.csv';
CSV = readtable(filename);
high(:,1) = table2array(CSV(:,1));
high_index(:,1) = table2array(CSV(:,2));

b = 1;
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
        
        day = time_c(a,3);
        month = time_c(a,2);
        year = time_c(a,1);

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

        fig = figure(a+1000000)

            % Surface Pressure
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_psl_daily_20150101_21001231.nc";
            psl = ncread(filename, "psl");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            psl = psl(:,:,a)/100;
            
            ax(1) = subplot(2,3,1);
            ax(1) = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            title("Surface Pressure")
            ax(1).FontSize = 12;

            levels = [988:4:1040];
            contourfm(lat, lon, psl(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            caxis([988 1040])
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = "Pressure (mb)";
            cb.Ticks = levels;

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off
            
            
            % VPD
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_VPD_daily_20150101_21001231.nc";
            VPD = ncread(filename, "VPD");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            VPD = VPD(:,:,a);
            
            c = 1; % plot VPD > 1000 Pa only
            d = 1;
            while c < size(VPD,1)+1
                while d < size(VPD,2)+1
                    if VPD(c,d) > 999

                    else
                        VPD(c,d) = NaN;
                    end
                    d = d+1;
                end
                d = 1;
                c = c+1;
            end

            ax(2) = subplot(2,3,2);
            ax(2) = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            title("Vapor Pressure Defecit")
            ax(2).FontSize = 12;

            levels = [1000:1000:24000];
            contourfm(lat, lon, VPD(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            caxis([1000 24000])
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = "Pressure (Pa)";
            cb.Ticks = levels;

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off
            
            
            % Surface Temp
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_tas_daily_20150101_21001231.nc";
            tas = ncread(filename, "tas");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            tas = ((tas(:,:,a)-273.15)*(9/5))+32;

            ax(3) = subplot(2,3,3);
            ax(3) = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            title("Surface Temperature")
            ax(3).FontSize = 12;

            levels = [0:5:130];
            contourfm(lat, lon, tas(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            caxis([0 130])
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = "Temperature (F)";
            cb.Ticks = levels;

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off

            
            % 500mb zg
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_500_daily_20150101_21001231.nc";
            zg = ncread(filename, "zg");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            zg = zg(:,:,a);

            ax(4) = subplot(2,3,4);
            ax(4) = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            title("500mb Height")
            ax(4).FontSize = 12;

            levels = [5200:40:6200];
            contourfm(lat, lon, zg(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            caxis([5200 6200])
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = "Geopotential Height (m)";
            cb.Ticks = levels;

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off
            
            
            % Surface Relative Humidity
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_hurs_daily_20150101_21001231.nc";
            hurs = ncread(filename, "hurs");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            hurs = hurs(:,:,a);
            
            ax(5) = subplot(2,3,5);
            ax(5) = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            title("Surface Relative Humidity")
            ax(5).FontSize = 12;

            levels = [0:5:100];
            contourfm(lat, lon, hurs(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            caxis([0 100])
            contourcmap("jet")
            cb = contourcbar("eastoutside");
            cb.XLabel.String = "Relative Humidity (%)";
            cb.Ticks = levels;

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off
            
            
            % Precipitation
            filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_pr_daily_20150101_21001231.nc";
            pr = ncread(filename, "pr");
            lat = ncread(filename, "lat");
            lon = ncread(filename, "lon");
            [lat, lon] = meshgrid(lat,lon);
            
            pr = pr(:,:,a)*86400; % flux /s to /day
            
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

            ax(6) = subplot(2,3,6);
            ax(6) = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
            title("Precipitation")
            ax(6).FontSize = 12;

            levels = [10^-.5, 10^-.25, 10^0, 10^.25, 10^.5, 10^.75, 10^1, 10^1.25, 10^1.5, 10^1.75, 10^2];
            contourfm(lat, lon, pr(:,:), levels, "LineWidth", 0.1, "Color", [1 1 1]);
            
            c = colorbar;
            c.Ticks = levels;
            c.XLabel.String = "Precipitation (mm)";
            set(gca,'ColorScale','log');
            caxis([10^-.5 10^2])

            hold on

            geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);

            m_lat_min = (22);% Define corners of the box 
            m_lat_max = (42);
            m_lon_min = (237);
            m_lon_max = (267);
            lat_box = [m_lat_min m_lat_min m_lat_max m_lat_max m_lat_min];
            lon_box = [m_lon_min m_lon_max m_lon_max m_lon_min m_lon_min];
            plotm(lat_box, lon_box, 'r-', 'LineWidth', 2); % Plot the box

            hold off
            
            
            % Title
            sg = sprintf("Actual (From Anomalies)\nMost Extreme VPD Day: %s, Max VPD Avg = %g (Pa)\nDate: %d/%d/%d ", model(b),high(b,1),time_c(a,2),time_c(a,3),time_c(a,1));
            sgtitle(sg,'FontSize',24)

            % Set figure size in inches
            fig.Units = 'inches';
            fig.Position = [1, 1, 32, 16];  % [left, bottom, width, height] => 16x16 inches
            c = a-index_mid;
            saveas(fig, '/home/disk/eos8/dglopez/pictures/Extreme_Event/Actual-Anom/Most-Extreme/'+model(b)+'/Most-Extreme-VPD_Actual-Anom_'+'Day_'+c+'_'+a+'.png');
            close(figure(a+1000000))
            
        a = a+1;
    end
        close all
    b = b+1;
end

%%        
function [] = windbarbm(lat,lon,u,v,varargin)
%WINDBARBM Project wind barbs onto map axes
%
%  WINDBARBM(lat,lon,u,v) projects two dimensional wind barbs onto the 
%  current map axes. The vector components (u,v) are in units of knots and
%  are specified at the points (lat,lon). It handles winds up to 130 knots.
%  Winds exceeding 130 knots will appear as 130 knots.
%
%  WINDBARBM(lat,lon,u,v,s) uses the input s to scale the vectors after 
%  they have been automatically scaled to fit within the grid. If omitted, 
%  s = 0.9 is assumed.
%  
%  WINDBARBM(lat,lon,u,v,'PropertyName',PropertyValue,...) and
%  WINDBARBM(lat,lon,u,v,s,'PropertyName',PropertyValue,...) uses the 
%  windbarbm object properties specified to display the windbarb objects.
%  The properties supported by windbarbm are the same as the properties
%  supported by linem.
% 
%   
%  MFILE:   windbarbm.m
%  MATLAB:  7.8.0 (R2009a)
%  VERSION: 1.3 (28 November 2011)
%  AUTHOR:  Nick Siler
%  CONTACT: siler@atmos.washington.edu
%Argument tests (from quiverm.m)
    if any([ndims(lat) ndims(lon) ...
            ndims(u)   ndims(v)  ] > 2)
        error(['map:' mfilename ':inputContainsPages'], ...
            'Input data can not contain pages.')
    elseif length(lat) == 1 && size(lat,1) ~= size(u,1)
        error(['map:' mfilename ':invalidLat'], ...
            'Lat vector input must have row dimension of u.')
    elseif length(lon) == 1 && size(lon,1) ~= size(u,2)
        error(['map:' mfilename ':invalidLon'], ...
            'Lon vector input must have column dimension of u.')
    elseif ~isequal(size(lat),size(lon),size(u),size(v))
        error(['map:' mfilename ':inconsistentDims'], ...
            'Inconsistent dimensions for inputs.')
    end
    %check for scale and wind barb property specification
    wbproperties = '''color'',''b'''; %default wind barb color is blue.
    switch length(varargin)
        case 1
            if ischar(varargin{1})
                error(['map:' mfilename ':invalidScale'], ...
                'Invalid scale factor.')
            end
            scale  = varargin{1};

        case 0
            scale  = .9;

        otherwise
            %for an odd number of arguments, the first will be the scale factor
            if rem(length(varargin),2)==1 
                if ischar(varargin{1})
                    error(['map:' mfilename ':invalidScale'], ...
                    'Invalid scale factor.')
                end
                scale  = varargin{1};
                nn = 2;
            else
                % for an even number of arguments, no scale factor is specified
                scale = .9;
                nn = 1;
            end
            for ii = nn:length(varargin)
                if ischar(varargin{ii})
                    wbproperties = [wbproperties,',''',varargin{ii},''''];
                else
                    wbproperties = [wbproperties,',',num2str(varargin{ii})];
                end                    
            end
    end
    umag = sqrt(u.^2+v.^2); %wind speed
    %find theta; add pi to atan(v/u) when u<0
    dummy = (u<0)*pi;
    theta = atan(v./u)+dummy;
    [a,b] = size(umag);
    %create 18 logical matrices for 18 possible barbs. Non-zero when the barb
    %is called for at that gridpoint.
    g1 = umag > 7.5 & umag <= 47.5;
    g2 = umag > 17.5 & umag <= 47.5;
    g3 = umag > 27.5;
    g4 = (umag > 37.5 & umag <= 47.5) | (umag > 57.5 & umag <= 97.5);
    g5 = umag > 67.5;
    g6 = (umag > 77.5 & umag < 97.5) | umag > 107.5;
    g7 = umag > 87.5 & umag < 97.5 | umag > 117.5;
    g8 = umag > 127.5;
    g9 = (umag > 2.5 & umag <= 7.5) | (umag > 12.5 & umag <= 17.5);
    g10 = umag > 22.5 & umag <= 27.5;
    g11 = (umag > 32.5 & umag <= 37.5) | (umag > 52.5 & umag <= 57.5);
    g12 = (umag > 42.5 & umag <= 47.5) | (umag > 62.5 & umag <= 67.5);
    g13 = (umag > 72.5 & umag <= 77.5) | (umag > 102.5 & umag <= 107.5); 
    g14 = (umag > 82.5 & umag <= 87.5) | (umag > 112.5 & umag <= 117.5);
    g15 = (umag > 92.5 & umag <= 97.5) | (umag > 122.5 & umag <= 127.5);
    g16 = umag > 47.5;
    g17 = umag > 97.5;
    g18 = true(a,b);
    %position of each barb relative to grid point: [x0 y0; x1 y1]
    c1 = [-1 0;-1.125 .325];
    c2 = [-.875 0; -1 .325];
    c3 = [-.75 0; -.875 .325];
    c4 = [-.625 0; -.75 .325];
    c5 = [-.5 0; -.625 .325];
    c6 = [-.375 0; -.5 .325];
    c7 = [-.25 0; -.375 .325];
    c8 = [-.125 0; -.25 .325];
    c9 = [-.875 0; -.9375 .1625];
    c10 = [-.75 0; -.8125 .1625];
    c11 = [-.625 0; -.6875 .1625];
    c12 = [-.5 0; -.5625 .1625];
    c13 = [-.3750 0; -.4375 .1625];
    c14 = [-.25 0; -.3125 .1625];
    c15 = [-.125 0; -.1875 .1625];
    c16 = [-1 0; -.875 .325];
    c17 = [-.75 0; -.625 .325];
    c18 = [0 0; -1 0];
    %set scale based on average latitude spacing
    [m,n]=size(lat);
    scale2 = scale*(max(max(lon))-min(min(lon)))/n;
    %draw the barbs
    for nn = 1:18
        eval(['dummy = reshape(g',int2str(nn),',1,a*b);']);
        count = sum(dummy); % number of barbs to draw
        if count == 0
            continue
        end

        %rotation operations
        eval(['x1 = c',int2str(nn),'(1,1)*cos(theta)-c',int2str(nn),...
            '(1,2)*sin(theta);']);
        eval(['y1 = c',int2str(nn),'(1,1)*sin(theta)+c',int2str(nn),...
            '(1,2)*cos(theta);']);
        eval(['x2 = c',int2str(nn),'(2,1)*cos(theta)-c',int2str(nn),...
            '(2,2)*sin(theta);']);
        eval(['y2 = c',int2str(nn),'(2,1)*sin(theta)+c',int2str(nn),...
            '(2,2)*cos(theta);']);

        x1 = x1*scale2+lon;
        x2 = x2*scale2+lon;
        %multiply y1 and y2 by cos(lat) to compensate for the closer spacing of
        %meridians.
        y1 = y1*scale2.*cos(lat*pi/180)+lat;
        y2 = y2*scale2.*cos(lat*pi/180)+lat;
        x = [reshape(x1(dummy),1,count);reshape(x2(dummy),1,count)];
        y = [reshape(y1(dummy),1,count);reshape(y2(dummy),1,count)];
        eval(['linem(y,x,',wbproperties,')']);
    end       
end     