

% Top code is surface, bottom code is upper air

% vas lat ACCESS-CM2 is 145 while rest is 144????? opposite for ESM5-1

% KACE is a 30 day month model, not a leap year model, could describe
% events as fraction of year instead of day of year, which help for leap
% years as well

% I used the ACCESS-CM2 mask for KACE, same grid dimensions but different
% grid, manually checked that the same gridding scheme was used though...
% Had to use ACCESS-ESM1-5 mask for vas wind in KACE

% IPSL has no lat_bnds - breaks code, fixed work around

% KACE vas winds are wrong dimensions, exactly like ACCESS-CM2!!!!!
% assume KACE is correct and use the ACCESS-ESM1-5  mask for vas



% Grid sizes
% 192x144 ACCESS-CM2        NoUSE
% 192x145 ACCESS-ESM1-5     NoUSE
% 320x160 BCC-CSM2-MR       NoUSE
% 288x192 CMCC-ESM2          NoUSE zg
% 128x64 CanESM5-1
% 128x64 CanESM5
% 512x256 EC-Earth3-CC (missing mask)   NoUSE - delete
% 512x256 EC-Earth3-Veg-LR  NoUSE - delete
% 512x256 EC-Earth3-Veg     NoUSE - delete
% 320x160 EC-Earth3         NoUSE - delete
% 180x80 FGOALS-g3          NoUSE
% 144x90 GFDL-CM4           NoUSE hfls
% 288x180 GFDL-ESM4         NoUSE hfls hur, dates
% 192x94 IITM-ESM (missing mask)        NoUSE tasmax tasmin
% 180x120 INM-CM4-8
% 180x120 INM-CM5-0
% 144x143 IPSL-CM6A-LR      huss (irrelevant)
% 192x144 KACE-1-0-G (missing mask)
% 256x128 MIROC6
% 384x192 MPI-ESM1-2-HR
% 192x96 MPI-ESM1-2-LR
% 144x96 NorESM2-LM         NoUSE sfcwinds
% 288x192 NorESM2-MM        NoUSE sfcwinds
% 288x192 TaiESM1           NoUSE sfcwinds

% Model list MUST be in alphabetical order for landmasks to work!!!!!!!!

% model = ["ACCESS-CM2","ACCESS-ESM1-5","BCC-CSM2-MR","CMCC-ESM2",
%         "CanESM5-1","CanESM5","EC-Earth3-CC","EC-Earth3-Veg-LR",
%         "EC-Earth3-Veg","EC-Earth3","FGOALS-g3","GFDL-CM4",
%         "GFDL-ESM4","IITM-ESM","INM-CM4-8","INM-CM5-0",
%         "IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR",
%         "MPI-ESM1-2-LR","NorESM2-LM","NorESM2-MM","TaiESM1"];
% grid = ["gn","gn","gn","gn",
%         "gn","gn","gr","gr",
%         "gr","gr","gn","gr2",
%         "gr1","gn","gr1","gr1",
%         "gr","gr","gn","gn",
%         "gn","gn","gn","gn"];

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
grid = ["gn","gn","gr1","gr1","gr","gr","gn","gn","gn"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas"];
Variable_up = ["hur","hus","ta","ua","va","wap","zg"];

%%
% ncdisp("/home/disk/eos8/dglopez/cmip6/INM-CM4-8_Weighted_Landmasked_SW-US_hurs_daily_20150101_21001231.nc")



%% for plotting, grid knowledge is needed
% a = 1;
% dims = [];
% filename = ["sftlf_fx_CanESM5-1_ssp585_r1i1p1f1_gn","sftlf_fx_CanESM5_ssp585_r1i1p1f1_gn","sftlf_fx_INM-CM4-8_ssp585_r1i1p1f1_gr1","sftlf_fx_INM-CM5-0_amip_r1i1p1f1_gr1","sftlf_fx_IPSL-CM6A-LR_ssp585_r1i1p1f1_gr","sftlf_fx_KACE-1-0-G_ssp585_r1i1p1f1_gr","sftlf_fx_MIROC6_ssp585_r1i1p1f1_gn","sftlf_fx_MPI-ESM1-2-HR_ssp585_r1i1p1f1_gn","sftlf_fx_MPI-ESM1-2-LR_ssp585_r1i1p1f1_gn"];
% while a < 9+1 % 9 models
%     ncdisp("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc")
%     sftlf = ncread("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc", "sftlf");
%     lat = ncread("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc", "lat");
%     lon = ncread("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc", "lon");
%     dims(a,1:4) = [lat(1,1), lat(end,1), lon(1,1), lon(end,1)];
%     a = a+1;
% end

% filename = "/home/disk/eos9/cmip6/ssp585/KACE-1-0-G/dglopez/tasmax_day_KACE-1-0-G_ssp585_r1i1p1f1_gr_20150101-21001230.nc";
% ncdisp(filename)
% lat = ncread(filename, "lat");
% lon = ncread(filename, "lon");
% dims(10,1:4) = [lat(1,1), lat(end,1), lon(1,1), lon(end,1)];

% % KACE uses the same exact gridding scheme as the ACCESS-CM2 based in
% % dimensions of grid boxes

% % --> All models have same lat and lon positives/negatives scheme

%% Plot of landmasks
% determine which masks are 1/0 or %, and which ones are inverted
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
LandMaskPercent = 100;

filename = ["sftlf_fx_CanESM5-1_ssp585_r1i1p1f1_gn","sftlf_fx_CanESM5_ssp585_r1i1p1f1_gn","sftlf_fx_INM-CM4-8_ssp585_r1i1p1f1_gr1","sftlf_fx_INM-CM5-0_amip_r1i1p1f1_gr1","sftlf_fx_IPSL-CM6A-LR_ssp585_r1i1p1f1_gr","sftlf_fx_KACE-1-0-G_ssp585_r1i1p1f1_gr","sftlf_fx_MIROC6_ssp585_r1i1p1f1_gn","sftlf_fx_MPI-ESM1-2-HR_ssp585_r1i1p1f1_gn","sftlf_fx_MPI-ESM1-2-LR_ssp585_r1i1p1f1_gn"];

SW_Region = 1;
Hemisphere = 0;

load coastlines
fig = figure(1)
sgtitle("Landmasks",'FontSize',24)

a = 1;
dims = [];
while a < 9+1 % 9 models
    sftlf = ncread("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc", "sftlf");
    lat = ncread("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc", "lat");
    lon = ncread("/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/"+filename(1,a)+".nc", "lon");
    
    e=1;
    f=1;
    while e < size(lat,1) +1
        while f < size(lon,1) +1
            if sftlf(f,e) < LandMaskPercent
                sftlf(f,e) = NaN;
            end
            f=f+1;
        end
        e=e+1;
        f=1;
    end
    
    if SW_Region == 1
        m_lat_min = (112/180);
        m_lat_max = (132/180);
        m_lon_min = (237/360);
        m_lon_max = (267/360);
        lat_min = round(length(lat)*m_lat_min);
        lat_max = round(length(lat)*m_lat_max);
        lon_min = round(length(lon)*m_lon_min);
        lon_max = round(length(lon)*m_lon_max);
    end
    if Hemisphere == 1
        m_lat_min = (90/180);
        m_lat_max = (170/180);
        m_lon_min = (180/360);
        m_lon_max = (310/360);
        lat_min = round(length(lat)*m_lat_min);
        lat_max = round(length(lat)*m_lat_max);
        lon_min = round(length(lon)*m_lon_min);
        lon_max = round(length(lon)*m_lon_max);
    end
    sftlf = sftlf(lon_min:lon_max,lat_min:lat_max,:);
    lat = lat(lat_min:lat_max);
    lon = lon(lon_min:lon_max);
    [lat, lon] = meshgrid(lat, lon);
    
    if model(a) == "IPSL-CM6A-LR" % IPSL saves as a single instead of a double for some reason???
        lat = double(lat);
        lon = double(lon);
    end
    
    subplot(3,3,a)
    ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
    geoshow(ax,lat,lon,sftlf, 'displaytype', 'texturemap');
%     cb = colorbar('eastoutside');
    hold on
%     cb.Label.String = '% of Land';
    geoshow(coastlat,coastlon, "Color", "k", "LineWidth", 2);
    title(model(a))
    xlabel("Longitude")
    ylabel("Latitude")
    ax = gca;
    ax.FontSize = 18;
    hold off
    
    a = a+1;
end

fig.Units = 'inches';
fig.Position = [1, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches

saveas(fig, '/home/disk/eos8/dglopez/pictures/Landmasks.png');

%% Creates matrix of available variables and dates in each model
All_variables = [Variable, Variable_up];
a = 1;
b = 1;
while a < size(model,2)+1
    List = dir('/home/disk/eos9/cmip6/ssp585/'+model(a)+'/dglopez/**');
    while b < size(All_variables,2)+1
        c = 1;
        d = 1;
        directories = [];
        directories = string(directories);
        while c < size(List,1)+1 % find each variable from list of full directory
            meta = List(c,1);
            name = extractBefore(meta.name, "_");
            if name == All_variables(1,b) % extracts the variable name
                start_date = extractAfter(meta.name, grid(1,a)+"_");
                start_date1 = extractBefore(start_date, "0101-");
                if str2double(start_date1) < 2100+1 % Checks that file start date not after year 2100
                    directories(1,d) = string(meta.folder)+'/'+string(meta.name); % assign directories of variable to new list
                    d = d+1; % if true, saves to directories and goes to next line
                end
            end
            c = c+1;
        end
        if size(directories,2) > 0
            exists = 1;
        else
            exists = 0;
        end
        if exists == 1
            start_date = extractAfter(directories(1,1), grid(1,a)+"_");
            start_date1 = extractBefore(start_date, "0101-");
            if a == 6 % KACE skips last day of year instead of leap years
                end_date = extractBefore(directories(1,end), "1230.nc");
                end_date1 = extractAfter(end_date, "01-");
            else
                end_date = extractBefore(directories(1,end), "1231.nc");
                end_date1 = extractAfter(end_date, "01-");
            end
            Available(1,1+(a-1)*3) = model(a); % writes on itself but does not change
            Available(1+b,1+(a-1)*3) = All_variables(1,b);
            Available(1+b,1+1+(a-1)*3) = start_date1;
            Available(1+b,1+2+(a-1)*3) = end_date1;
        else
            Available(1,1+(a-1)*3) = model(a); % writes on itself but does not change
            Available(1+b,1+(a-1)*3) = All_variables(1,b);
            Available(1+b,1+1+(a-1)*3) = "DNE";
            Available(1+b,1+2+(a-1)*3) = "DNE";
        end
        b = b+1;
    end
    a = a+1;
    b = 1;
end

% writematrix(Available, "/home/disk/p/dglopez/Available_CMIP6_SSP585_Using.csv")

%%
clear
clc

Weight_on = 0; % Latitude weight
Landmask_on = 1; % turns land mask on
LandMaskPercent = 100;
% can only choose one region at a time
SW_Region = 1; % saves the US SW
Hemisphere = 0; % NW Hemisphere minus some unused Atlantic ocean
World = 0;

model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
grid = ["gn","gn","gr1","gr1","gr","gr","gn","gn","gn"];
Variable = ["hfls","hurs","huss","pr","psl","tas","tasmax","tasmin","uas","vas"];

a = 1; % model number to start on
% Can put a while loop here and do multiple models

% while a < size(model,2)+1 % breaks
    
List = dir('/home/disk/eos9/cmip6/ssp585/'+model(a)+'/dglopez/**');

b = 1;
while b < size(Variable,2)+1 % iterate through each variable
    c = 1;
    d = 1;
    directories = [];
    directories = string(directories);
    while c < size(List,1)+1 % find each variable from list of full directory
        meta = List(c,1);
        name = extractBefore(meta.name, "_");
        if name == Variable(1,b) % extracts the variable name (before the "_")
            if a == 6 % KACE skips last day of year instead of leap years
                end_date = extractBefore(meta.name, "1230.nc");
                end_date1 = extractAfter(end_date, "01-");
            else
                end_date = extractBefore(meta.name, "1231.nc");
                end_date1 = extractAfter(end_date, "01-");
            end
            if str2double(end_date1) < 2100+1 % Checks that file end date not after year 2100
                directories(1,d) = string(meta.folder)+'/'+string(meta.name); % assign directories of variable to new list
                d = d+1; % if true, saves to directories and goes to next line
            end
        end
        c = c+1;
    end
    
    abc = 1;
    while abc < size(directories,2)+1 % read data from each directory for a variable and concatenate, if variable DNE, size = 0
        filename = directories(1,abc);
        data_ = ncread(filename, Variable(1,b));
        time_ = ncread(filename, 'time');
        if abc == 1
            data = data_;
            time = time_;
        end
        if abc > 1
            data = cat(3, data, data_);
            time = cat(1, time, time_);
        end
        abc = abc+1;
    end
    if size(directories,2) > 0 % in case the variable does not exist, won't lead to an error
        lat = ncread(filename, 'lat'); % same lat and lon in each file for the model, read once
        lon = ncread(filename, 'lon');
        clear data_
        clear time_
    else % if variable does not exist, it prints it
        fprintf("DNE, %s, %s\n", model(a), Variable(b))
    end
    
    % LANDMASK
    if size(directories,2) > 0
        abs_lat_max = length(lat);
        abs_lon_max = length(lon);
        if Landmask_on == 1 && model(a) ~= "KACE-1-0-G" 
            Mask_List = dir('/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/**');
            Mask_meta = Mask_List(a+4,1); % =4 for extra meta data garbage
            Mask_Directory = string(Mask_meta.folder)+"/"+string(Mask_meta.name);
            mask = ncread(Mask_Directory,'sftlf');

            e=1;
            f=1;
            while e < abs_lat_max +1
                while f < abs_lon_max +1
                    if mask(f,e) < LandMaskPercent
                        mask(f,e) = NaN;
                    end
                    f=f+1;
                end
                e=e+1;
                f=1;
            end

            e = 1;
            while e < length(time)+1
                data(1:abs_lon_max,1:abs_lat_max,e) = data(1:abs_lon_max,1:abs_lat_max,e).*mask/100;
                e = e+1;
            end
        elseif Landmask_on == 1 && model(a) == "KACE-1-0-G" && Variable(b) ~= "vas"
            Mask_List = dir('/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/**');
            Mask_meta = Mask_List(a+4,1); % =4 for extra meta data garbage
            Mask_Directory = string(Mask_meta.folder)+"/"+string(Mask_meta.name);
            mask = ncread(Mask_Directory,'sftlf');

            e=1;
            f=1;
            while e < abs_lat_max +1
                while f < abs_lon_max +1
                    if mask(f,e) < LandMaskPercent
                        mask(f,e) = NaN;
                    end
                    f=f+1;
                end
                e=e+1;
                f=1;
            end

            e = 1;
            while e < length(time)+1
                data(1:abs_lon_max,1:abs_lat_max,e) = data(1:abs_lon_max,1:abs_lat_max,e).*mask/100;
                e = e+1;
            end
        elseif Landmask_on == 1 && model(a) == "KACE-1-0-G" && Variable(b) == "vas"
            Mask_Directory = "/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks_Unused/sftlf_fx_ACCESS-ESM1-5_ssp585_r1i1p1f1_gn.nc";
            mask = ncread(Mask_Directory,'sftlf');

            e=1;
            f=1;
            while e < abs_lat_max +1
                while f < abs_lon_max +1
                    if mask(f,e) < LandMaskPercent
                        mask(f,e) = NaN;
                    end
                    f=f+1;
                end
                e=e+1;
                f=1;
            end

            e = 1;
            while e < length(time)+1
                data(1:abs_lon_max,1:abs_lat_max,e) = data(1:abs_lon_max,1:abs_lat_max,e).*mask/100;
                e = e+1;
            end
        end

        % LIMIT COORDINATES
        if SW_Region == 1
            m_lat_min = (112/180);
            m_lat_max = (132/180);
            m_lon_min = (237/360);
            m_lon_max = (267/360);
            lat_min = round(length(lat)*m_lat_min);
            lat_max = round(length(lat)*m_lat_max);
            lon_min = round(length(lon)*m_lon_min);
            lon_max = round(length(lon)*m_lon_max);
        end
        if Hemisphere == 1
            m_lat_min = (90/180);
            m_lat_max = (170/180);
            m_lon_min = (180/360);
            m_lon_max = (310/360);
            lat_min = round(length(lat)*m_lat_min);
            lat_max = round(length(lat)*m_lat_max);
            lon_min = round(length(lon)*m_lon_min);
            lon_max = round(length(lon)*m_lon_max);
        end
        
        if World == 1
            lat_min = 0;
            lat_max = length(lat);
            lon_min = 0;
            lon_max = length(lon);
        end
        
        data = data(lon_min:lon_max,lat_min:lat_max,:);
        lat = lat(lat_min:lat_max);
        lon = lon(lon_min:lon_max);
        
        if model(a) == "IPSL-CM6A-LR" % IPSL saves as a single instead of a double for some reason???
            lat = double(lat);
            lon = double(lon);
        end

        % LATITUDE WEIGHT
        if Weight_on == 1
            if model(a) == "IPSL-CM6A-LR" % IPSL does not have lat_bnds variable
                weight = [];
                e = 1;
                while e < size(lat,1)+1
                    weight(e) = cosd(lat(e,1));
                    e = e+1;
                end
            else
                lat_bnds = ncread(filename,"lat_bnds");
                actual_lat_min = lat_bnds(1,1);
                actual_lat_max = lat_bnds(2,end);
                size_lat_box = ((abs(actual_lat_min)+actual_lat_max)/abs_lat_max);
                actual_lat = [actual_lat_min:size_lat_box:actual_lat_max];

                weight = [];
                e = 1;
                f = lat_min;
                while f < lat_max + 1
                    weight(e) = mean(cosd([actual_lat(f), actual_lat(f+1)]), 'omitnan');
                    e = e+1;
                    f = f+1;
                end
            end

            weighted_data = [];
            f = 1;
            g = 1;
            while f < length(time)+1
                while g < size(data,1)+1
                    weighted_data(g,:,f) = data(g,:,f).*weight/mean(weight);
                    g = g+1;
                end
                f = f+1;
                g = 1;
            end
            data = weighted_data;
            clear weighted_data lat_bnds
        end

        % CREATE NETCDF
        if SW_Region == 1 
            Region = "SW-US";
        elseif Hemisphere == 1
            Region = "NorthWest_Hemisphere";
        elseif World == 1
            Region = "World";
        end
        
        if Landmask_on ==1
            Mask_Type = "Landmasked";
        else
            Mask_Type = "Unmasked";
        end
        
        if Weight_on == 1
            Weight_Type = "Weighted";
        else
            Weight_Type = "UnWeighted";
        end
        
        start_date = extractAfter(directories(1,1), grid(1,a)+"_");
        start_date1 = extractBefore(start_date, "-");
        if a == 6 % KACE model has all the available proper dates
            end_date1 = "21001231"; % force case to follow proper naming scheme
        else
            end_date = extractAfter(directories(1,end), "01-");
            end_date1 = extractBefore(end_date, ".nc");
        end
        
        variable = Variable(1,b);
%         nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
%         ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","time",time(:,:))
% 
%         nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
%         ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))
% 
%         nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
%         ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))
% 
%         nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
%         ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc",variable,data(:,:,:))

        nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
        ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

        nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
        ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

        nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
        ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))

        nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
        ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,data(:,:,:))

        fprintf("Finished, %s, %s\n",model(a),Variable(b))
        clear data lat lon time
        
    end
b = b+1;
end

% create VPD e es
% tasmax_structure = dir('/home/disk/eos9/cmip6/ssp585/'+model(a)+'/dglopez/'+Weight_Type+'_'+Mask_Type+'_'+Region+'_tasmax_daily_'+model(a)+'_*');
tasmax_structure = dir('/home/disk/eos8/dglopez/cmip6/'+model(a)+'_'+Weight_Type+'_'+Mask_Type+'_'+Region+'_tasmax_daily_*');
tasmax_name = tasmax_structure.name;
% tasmax_start = extractAfter(tasmax_name, model(a)+"_");
tasmax_start = extractAfter(tasmax_name, "daily_");
tasmax_start1 = extractBefore(tasmax_start, "_");
tasmax_end = extractAfter(tasmax_name, "01_");
tasmax_end1 = extractBefore(tasmax_end, ".nc");

% hurs_structure = dir('/home/disk/eos9/cmip6/ssp585/'+model(a)+'/dglopez/'+Weight_Type+'_'+Mask_Type+'_'+Region+'_hurs_daily_'+model(a)+'_*');
hurs_structure = dir('/home/disk/eos8/dglopez/cmip6/'+model(a)+'_'+Weight_Type+'_'+Mask_Type+'_'+Region+'_hurs_daily_*');
hurs_name = hurs_structure.name;
% hurs_start = extractAfter(hurs_name, model(a)+"_");
hurs_start = extractAfter(hurs_name, "daily_");
hurs_start1 = extractBefore(hurs_start, "_");
hurs_end = extractAfter(hurs_name, "01_");
hurs_end1 = extractBefore(hurs_end, ".nc");

if str2double(hurs_start1) == str2double(tasmax_start1) && str2double(hurs_end1) == str2double(tasmax_end1)
%     filename1 = "/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_tasmax_daily_"+model(a)+"_"+tasmax_start1+"_"+tasmax_end1+".nc";
    filename1 = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_tasmax_daily_"+tasmax_start1+"_"+tasmax_end1+".nc";
    tasmax = ncread(filename1, "tasmax");
%     filename2 = "/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_hurs_daily_"+model(a)+"_"+tasmax_start1+"_"+tasmax_end1+".nc";
    filename2 = "/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_hurs_daily_"+tasmax_start1+"_"+tasmax_end1+".nc";
    hurs = ncread(filename2, "hurs");
    es = (exp(34.494 - (4924.99/(tasmax - 273.15 + 237.1)))./(tasmax - 273.15 + 105).^(1.57));
    e = (hurs/100) .* es;
    VPD = es .* (1 - (hurs/100));
    clear tasmax hurs

    lat = ncread(filename2, "lat");
    lon = ncread(filename2, "lon");
    time = ncread(filename2, "time");

    variable = "es";
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","time",time(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lat",lat(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lon",lon(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc",variable,es(:,:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,es(:,:,:))

    fprintf("Finished, %s, %s\n",model(a), variable)
    clear es

    variable = "e";
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","time",time(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lat",lat(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lon",lon(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc",variable,e(:,:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,e(:,:,:))

    fprintf("Finished, %s, %s\n",model(a), variable)
    clear e

    variable = "VPD";
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","time",time(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lat",lat(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc","lon",lon(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+hurs_start1+"_"+hurs_end1+".nc",variable,VPD(:,:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,VPD(:,:,:))

    fprintf("Finished, %s, %s\n",model(a), variable)

    % Create and store VPD, monthly
    year_start = hurs_start1(1:4);
    year_end = hurs_end1(1:4);
    period = str2double(year_end)-str2double(year_start)+1;
    time_monthly(1:period,1) = time(1:period,1); % monthly
    years = [str2double(year_start):1:str2double(year_end)];

    Variable = VPD;
    Variable_m(:,:,1:period) = Variable(:,:,1:period); % monthly
    c = 1;
    b = 0;
    d = 1;
    while d < period+1
        year = years(d);
        if model(a) == "KACE-1-0-G"
            Variable_m(:,:,c) = mean(Variable(:,:,b+1:b+30),3);
            Variable_m(:,:,c+1) = mean(Variable(:,:,b+31:b+60),3);
            Variable_m(:,:,c+2) = mean(Variable(:,:,b+61:b+90),3);
            Variable_m(:,:,c+3) = mean(Variable(:,:,b+91:b+120),3);
            Variable_m(:,:,c+4) = mean(Variable(:,:,b+121:b+150),3);
            Variable_m(:,:,c+5) = mean(Variable(:,:,b+151:b+180),3);
            Variable_m(:,:,c+6) = mean(Variable(:,:,b+181:b+210),3);
            Variable_m(:,:,c+7) = mean(Variable(:,:,b+211:b+240),3);
            Variable_m(:,:,c+8) = mean(Variable(:,:,b+241:b+270),3);
            Variable_m(:,:,c+9) = mean(Variable(:,:,b+271:b+300),3);
            Variable_m(:,:,c+10) = mean(Variable(:,:,b+301:b+330),3);
            Variable_m(:,:,c+11) = mean(Variable(:,:,b+331:b+360),3);
            c= c+12;
            b= b+360;

        elseif floor(year/4) == ceil(year/4) && year ~= 2100 && model(a) ~= "INM-CM5-0" && model(a) ~= "INM-CM4-8" && model(a) ~= "BCC-CSM2-MR" && model(a) ~= "CanESM5" && model(a) ~= "CanESM5-1" && model(a) ~= "CMCC-ESM2" && model(a) ~= "EC-Earth3" && model(a) ~= "GFDL-CM4" && model(a) ~= "GFDL-ESM4" && model(a) ~= "NorESM2-LM" && model(a) ~= "NorESM2-MM" && model(a) ~= "EC-Earth3-CC" && model(a) ~= "EC-Earth3-Veg" && model(a) ~= "EC-Earth3-Veg-LR" && model(a) ~= "IITM-ESM" % 2100 = Leap year
            Variable_m(:,:,c) = mean(Variable(:,:,b+1:b+31),3);
            Variable_m(:,:,c+1) = mean(Variable(:,:,b+32:b+60),3);
            Variable_m(:,:,c+2) = mean(Variable(:,:,b+61:b+91),3);
            Variable_m(:,:,c+3) = mean(Variable(:,:,b+92:b+121),3);
            Variable_m(:,:,c+4) = mean(Variable(:,:,b+122:b+152),3);
            Variable_m(:,:,c+5) = mean(Variable(:,:,b+153:b+182),3);
            Variable_m(:,:,c+6) = mean(Variable(:,:,b+183:b+213),3);
            Variable_m(:,:,c+7) = mean(Variable(:,:,b+214:b+244),3);
            Variable_m(:,:,c+8) = mean(Variable(:,:,b+245:b+274),3);
            Variable_m(:,:,c+9) = mean(Variable(:,:,b+275:b+305),3);
            Variable_m(:,:,c+10) = mean(Variable(:,:,b+306:b+335),3);
            Variable_m(:,:,c+11) = mean(Variable(:,:,b+336:b+366),3);
            c= c+12;
            b= b+366;

        else % NOT Leap year
            Variable_m(:,:,c) = mean(Variable(:,:,b+1:b+31),3);
            Variable_m(:,:,c+1) = mean(Variable(:,:,b+32:b+59),3);
            Variable_m(:,:,c+2) = mean(Variable(:,:,b+60:b+90),3);
            Variable_m(:,:,c+3) = mean(Variable(:,:,b+91:b+120),3);
            Variable_m(:,:,c+4) = mean(Variable(:,:,b+121:b+151),3);
            Variable_m(:,:,c+5) = mean(Variable(:,:,b+152:b+181),3);
            Variable_m(:,:,c+6) = mean(Variable(:,:,b+182:b+212),3);
            Variable_m(:,:,c+7) = mean(Variable(:,:,b+213:b+243),3);
            Variable_m(:,:,c+8) = mean(Variable(:,:,b+244:b+273),3);
            Variable_m(:,:,c+9) = mean(Variable(:,:,b+274:b+304),3);
            Variable_m(:,:,c+10) = mean(Variable(:,:,b+305:b+334),3);
            Variable_m(:,:,c+11) = mean(Variable(:,:,b+335:b+365),3);
            c= c+12;
            b= b+365;
        end
        d = d+1;

    end
    VPD_m = Variable_m;

    c = 1;
    b = 0;
    d = 1;
    while d < period+1
        year = years(d);
        if model(a) == "KACE-1-0-G" % 2100 = Leap year, models w/o leap years
            time_monthly(c,1) = time(b+1,1);
            time_monthly(c+1,1) = time(b+31,1);
            time_monthly(c+2,1) = time(b+61,1);
            time_monthly(c+3,1) = time(b+91,1);
            time_monthly(c+4,1) = time(b+121,1);
            time_monthly(c+5,1) = time(b+151,1);
            time_monthly(c+6,1) = time(b+181,1);
            time_monthly(c+7,1) = time(b+211,1);
            time_monthly(c+8,1) = time(b+241,1);
            time_monthly(c+9,1) = time(b+271,1);
            time_monthly(c+10,1) = time(b+301,1);
            time_monthly(c+11,1) = time(b+331,1);
            c= c+12;
            b= b+360;

        elseif floor(year/4) == ceil(year/4) && year ~= 2100 && model(a) ~= "INM-CM5-0" && model(a) ~= "INM-CM4-8" && model(a) ~= "BCC-CSM2-MR" && model(a) ~= "CanESM5" && model(a) ~= "CanESM5-1" && model(a) ~= "CMCC-ESM2" && model(a) ~= "EC-Earth3" && model(a) ~= "GFDL-CM4" && model(a) ~= "GFDL-ESM4" && model(a) ~= "NorESM2-LM" && model(a) ~= "NorESM2-MM" && model(a) ~= "EC-Earth3-CC" && model(a) ~= "EC-Earth3-Veg" && model(a) ~= "EC-Earth3-Veg-LR" && model(a) ~= "IITM-ESM" % 2100 = Leap year, models w/o leap years
            time_monthly(c,1) = time(b+1,1);
            time_monthly(c+1,1) = time(b+32,1);
            time_monthly(c+2,1) = time(b+61,1);
            time_monthly(c+3,1) = time(b+92,1);
            time_monthly(c+4,1) = time(b+122,1);
            time_monthly(c+5,1) = time(b+153,1);
            time_monthly(c+6,1) = time(b+183,1);
            time_monthly(c+7,1) = time(b+214,1);
            time_monthly(c+8,1) = time(b+245,1);
            time_monthly(c+9,1) = time(b+275,1);
            time_monthly(c+10,1) = time(b+306,1);
            time_monthly(c+11,1) = time(b+336,1);
            c= c+12;
            b= b+366;

        else % NOT Leap year
            time_monthly(c,1) = time(b+1,1);
            time_monthly(c+1,1) = time(b+32,1);
            time_monthly(c+2,1) = time(b+60,1);
            time_monthly(c+3,1) = time(b+91,1);
            time_monthly(c+4,1) = time(b+121,1);
            time_monthly(c+5,1) = time(b+152,1);
            time_monthly(c+6,1) = time(b+182,1);
            time_monthly(c+7,1) = time(b+213,1);
            time_monthly(c+8,1) = time(b+244,1);
            time_monthly(c+9,1) = time(b+274,1);
            time_monthly(c+10,1) = time(b+305,1);
            time_monthly(c+11,1) = time(b+335,1);
            c= c+12;
            b= b+365;
        end
        d = d+1;

    end
    time = time_monthly;

    variable = "VPD_m";
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc","time",time(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc","lat",lat(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc","lon",lon(:,:))
% 
%     nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
%     ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+model(a)+"_"+year_start+"01_"+year_end+"12.nc",variable,VPD_m(:,:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_monthly_"+start_date1+"_"+end_date1+".nc",variable,VPD_m(:,:,:))

    fprintf("Finished, %s, %s\n",model(a), variable)
    clear VPD VPD_m lat lon time
end



% a = a+1;
% if a == 5 % issues with KACE wind vas, and IPSL lat_bnds
%     a = a+2;
% end
% end
%% Upper Air
clear
clc

Weight_on = 0; % Latitude weight
Landmask_on = 0; % turns land mask on
LandMaskPercent = 100;
SW_Region = 0; % saves the US SW
Hemisphere = 1; % NW Hemisphere minus some unused Atlantic ocean
World = 0;

% Model list MUST be in alphabetical order for landmasks to work!!!!!!!!
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];
grid = ["gn","gn","gr1","gr1","gr","gr","gn","gn","gn"];
Variable_up = ["hur","hus","ta","ua","va","wap","zg"];

a = 7; % model number to start on

List = dir('/home/disk/eos9/cmip6/ssp585/'+model(a)+'/dglopez/**');

b = 1;
while b < size(Variable_up,2)+1 % iterate through each variable
    c = 1;
    d = 1;
    directories = [];
    directories = string(directories);
    while c < size(List,1)+1 % find each variable from list of full directory
        meta = List(c,1);
        name = extractBefore(meta.name, "_");
        if name == Variable_up(1,b) % extracts the variable name (before the "_")
            if a == 6 % KACE skips last day of year instead of leap years
                end_date = extractBefore(meta.name, "1230.nc");
                end_date1 = extractAfter(end_date, "01-");
            else
                end_date = extractBefore(meta.name, "1231.nc");
                end_date1 = extractAfter(end_date, "01-");
            end
            if str2double(end_date1) < 2100+1 % Checks that file end date not after year 2100
                directories(1,d) = string(meta.folder)+'/'+string(meta.name); % assign directories of variable to new list
                d = d+1; % if true, saves to directories and goes to next line
            end
        end
        c = c+1;
    end
    
    abc = 1;
    while abc < size(directories,2)+1 % read data from each directory for a variable and concatenate, if variable DNE, size = 0
        filename = directories(1,abc);
        data_ = ncread(filename, Variable_up(1,b));
        time_ = ncread(filename, 'time');
        if abc == 1
            data = data_;
            time = time_;
        end
        if abc > 1
            data = cat(4, data, data_);
            time = cat(1, time, time_);
        end
        abc = abc+1;
    end
    if size(directories,2) > 0 % in case the variable does not exist, won't lead to an error
        lat = ncread(filename, 'lat'); % same lat and lon in each file for the model, read once
        lon = ncread(filename, 'lon');
        plev = ncread(filename, 'plev');
        clear data_
        clear time_
    else % if variable does not exist, it prints it
        fprintf("DNE, %s, %s\n", model(a), Variable_up(b))
    end
    
    % LANDMASK
    if size(directories,2) > 0
        abs_lat_max = length(lat);
        abs_lon_max = length(lon);
        if Landmask_on == 1 && model(a) ~= "KACE-1-0-G"
            Mask_List = dir('/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/**');
            Mask_meta = Mask_List(a+3,1); % =3 for extra meta data garbage
            Mask_Directory = string(Mask_meta.folder)+"/"+string(Mask_meta.name);
            mask = ncread(Mask_Directory,'sftlf');

            e=1;
            f=1;
            while e < abs_lat_max +1
                while f < abs_lon_max +1
                    if mask(f,e) < LandMaskPercent
                        mask(f,e) = NaN;
                    end
                    f=f+1;
                end
                e=e+1;
                f=1;
            end

            e = 1;
            f = 1;
            while e < length(time)+1
                while f < size(data,3)+1
                    data(1:abs_lon_max,1:abs_lat_max,f,e) = data(1:abs_lon_max,1:abs_lat_max,f,e).*mask/100;
                    f = f+1;
                end
                e = e+1;
                f = 1;
            end
        elseif Landmask_on == 1 && model(a) == "KACE-1-0-G" && Variable(b) ~= "va"
            Mask_List = dir('/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/**');
            Mask_meta = Mask_List(a+3,1); % =3 for extra meta data garbage
            Mask_Directory = string(Mask_meta.folder)+"/"+string(Mask_meta.name);
            mask = ncread(Mask_Directory,'sftlf');

            e=1;
            f=1;
            while e < abs_lat_max +1
                while f < abs_lon_max +1
                    if mask(f,e) < LandMaskPercent
                        mask(f,e) = NaN;
                    end
                    f=f+1;
                end
                e=e+1;
                f=1;
            end

            e = 1;
            f = 1;
            while e < length(time)+1
                while f < size(data,3)+1
                    data(1:abs_lon_max,1:abs_lat_max,f,e) = data(1:abs_lon_max,1:abs_lat_max,f,e).*mask/100;
                    f = f+1;
                end
                e = e+1;
                f = 1;
            end
        elseif Landmask_on == 1 && model(a) == "KACE-1-0-G" && Variable(b) == "vas"
            Mask_Directory = "/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks_Unused/sftlf_fx_ACCESS-ESM1-5_ssp585_r1i1p1f1_gn.nc";
            mask = ncread(Mask_Directory,'sftlf');
            
            e=1;
            f=1;
            while e < abs_lat_max +1
                while f < abs_lon_max +1
                    if mask(f,e) < LandMaskPercent
                        mask(f,e) = NaN;
                    end
                    f=f+1;
                end
                e=e+1;
                f=1;
            end

            e = 1;
            f = 1;
            while e < length(time)+1
                while f < size(data,3)+1
                    data(1:abs_lon_max,1:abs_lat_max,f,e) = data(1:abs_lon_max,1:abs_lat_max,f,e).*mask/100;
                    f = f+1;
                end
                e = e+1;
                f = 1;
            end
        end

        % LIMIT COORDINATES
        if SW_Region == 1
            m_lat_min = (112/180);
            m_lat_max = (132/180);
            m_lon_min = (237/360);
            m_lon_max = (267/360);
            lat_min = round(length(lat)*m_lat_min);
            lat_max = round(length(lat)*m_lat_max);
            lon_min = round(length(lon)*m_lon_min);
            lon_max = round(length(lon)*m_lon_max);
        end
        if Hemisphere == 1
            m_lat_min = (90/180);
            m_lat_max = (170/180);
            m_lon_min = (180/360);
            m_lon_max = (310/360);
            lat_min = round(length(lat)*m_lat_min);
            lat_max = round(length(lat)*m_lat_max);
            lon_min = round(length(lon)*m_lon_min);
            lon_max = round(length(lon)*m_lon_max);
        end
        
        if World == 1
            lat_min = 0;
            lat_max = length(lat);
            lon_min = 0;
            lon_max = length(lon);
        end
        
        data = data(lon_min:lon_max,lat_min:lat_max,:,:);
        lat = lat(lat_min:lat_max);
        lon = lon(lon_min:lon_max);
        
        if model(a) == "IPSL-CM6A-LR" % IPSL saves as a single instead of a double for some reason???
            lat = double(lat);
            lon = double(lon);
        end
        
        % LATITUDE WEIGHT
        if Weight_on == 1
            if model(a) == "IPSL-CM6A-LR" % IPSL does not have lat_bnds variable
                weight = [];
                e = 1;
                while e < size(lat,1)+1
                    weight(e) = cosd(lat(e,1));
                    e = e+1;
                end
            else
                lat_bnds = ncread(filename,"lat_bnds");
                actual_lat_min = lat_bnds(1,1);
                actual_lat_max = lat_bnds(2,end);
                size_lat_box = ((abs(actual_lat_min)+actual_lat_max)/abs_lat_max);
                actual_lat = [actual_lat_min:size_lat_box:actual_lat_max];

                weight = [];
                e = 1;
                f = lat_min;
                while f < lat_max + 1
                    weight(e) = mean(cosd([actual_lat(f), actual_lat(f+1)]), 'omitnan');
                    e = e+1;
                    f = f+1;
                end
            end

            weighted_data = [];
            f = 1;
            g = 1;
            h = 1;
            while f < length(time)+1
                while h < size(data,3)+1
                    while g < size(data,1)+1
                        weighted_data(g,:,h,f) = data(g,:,h,f).*weight/mean(weight);
                        g = g+1;
                    end
                    h = h+1;
                    g = 1;
                end
                f = f+1;
                g = 1;
                h = 1;
            end
            data = weighted_data;
            clear weighted_data lat_bnds
        end
         
        % Create netCDF for the variable, save each height sepeartely in a
        % height file
        if SW_Region == 1 
            Region = "SW-US";
        elseif Hemisphere == 1
            Region = "NorthWest_Hemisphere";
        elseif World == 1
            Region = "World";
        end
        if Landmask_on ==1
            Mask_Type = "Landmasked";
        else
            Mask_Type = "Unmasked";
        end
        if Weight_on == 1
            Weight_Type = "Weighted";
        else
            Weight_Type = "UnWeighted";
        end

        start_date = extractAfter(directories(1,1), grid(1,a)+"_");
        start_date1 = extractBefore(start_date, "-");
        if a == 6 % KACE model has all the available proper dates
            end_date1 = "21001231"; % force case to follow proper naming scheme
        else
            end_date = extractAfter(directories(1,end), "01-");
            end_date1 = extractBefore(end_date, ".nc");
        end
        
        level = 1;
        while  level < 8+1 % 8 upper levels
            height_data = [];
            aa = 1;
            bb = 1;
            while aa < size(data,1)+1
                while bb < size(data,2)+1
                    height_data(aa,bb,:) = data(aa,bb,level,:);
                    bb = bb+1;
                end
                aa = aa+1;
                bb = 1;
            end
            
            variable = Variable_up(1,b);
            height = plev(level)/100;
            if b == 1 % only save lat lon and time once
                    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","netcdf4")
                    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

                    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","netcdf4")
                    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

                    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","netcdf4")
                    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))
            end
            
            nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","netcdf4")
            ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+height+"_daily_"+start_date1+"_"+end_date1+".nc",variable,height_data(:,:,:))
            
            fprintf("Finished, %s, %s, %d\n",model(a),Variable_up(b),height)

            level = level+1;
        end
    end
    b = b+1;
end

%%
% CREATE NETCDF

% nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
% ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","time",time(:,:))
% 
% nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
% ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))
% 
% nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
% ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))
% 
% nccreate("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
% ncwrite("/home/disk/eos9/cmip6/ssp585/"+model(a)+"/dglopez/"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+model(a)+"_"+start_date1+"_"+end_date1+".nc",variable,data(:,:,:))

nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time","Dimensions",{"time",size(time,1)},"Format","classic")
ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","time",time(:,:))

nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lat",lat(:,:))

nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc","lon",lon(:,:))

nccreate("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,"Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","classic")
ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(a)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_"+variable+"_daily_"+start_date1+"_"+end_date1+".nc",variable,data(:,:,:))

fprintf("Finished, %s, %s\n",model(a),Variable_up(b))
clear data lat lon time


%% Create new mask for KACE for ACCESS-CM2
% filename = "/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks_Unused/sftlf_fx_ACCESS-CM2_ssp585_r1i1p1f1_gn.nc";
% ncdisp(filename);
% 
% sftlf = ncread(filename, "sftlf");
% lat = ncread(filename, "lat");
% lon = ncread(filename, "lon");
% 
% filename = "/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/sftlf_fx_KACE-1-0-G_ssp585_r1i1p1f1_gr.nc";
% nccreate(filename,"lat","Dimensions",{"lat",size(lat,1)},"Format","classic")
% ncwrite(filename,"lat",lat(:,:))
% 
% nccreate(filename,"lon","Dimensions",{"lon",size(lon,1)},"Format","classic")
% ncwrite(filename,"lon",lon(:,:))
% 
% nccreate(filename,"sftlf","Dimensions",{"lon",size(lon,1),"lat",size(lat,1)},"Format","classic")
% ncwrite(filename,"sftlf",sftlf(:,:))

%% Create hus for MIROC6
clear
clc

levels = [1000, 850, 700, 500, 250, 100, 50, 10];
level = ["1000", "850", "700", "500", "250", "100", "50", "10"];

a = 1;
while a < size(level, 2)+1
    filename = "/home/disk/eos8/dglopez/cmip6/MIROC6_UnWeighted_Unmasked_NorthWest_Hemisphere_"+level(a)+"_daily_20150101_21001231.nc";
    hur = ncread(filename, "hur");
    ta = ncread(filename, "ta");
    lon = ncread(filename, "lon");
    lat = ncread(filename, "lat");
    time = ncread(filename, "time");

    p =levels(a)*100; % Pa
    es = (exp(34.494 - (4924.99/(ta - 273.15 + 237.1)))./(ta - 273.15 + 105).^(1.57));
    e = hur/100.*es;
    r = (0.622*e)./(p - e);
    q = r./(1+r);

    nccreate("/home/disk/eos8/dglopez/cmip6/MIROC6_UnWeighted_Unmasked_NorthWest_Hemisphere_"+level(a)+"_daily_20150101_21001231.nc","hus","Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/MIROC6_UnWeighted_Unmasked_NorthWest_Hemisphere_"+level(a)+"_daily_20150101_21001231.nc","hus",q(:,:,:))

    a = a+1;
end
%% Integrated Vapor Transport
clear
clc

Weight_on = 0; % Latitude weight
Landmask_on = 0; % turns land mask on
LandMaskPercent = 100;
SW_Region = 0; % saves the US SW
Hemisphere = 1; % NW Hemisphere minus some unused Atlantic ocean
World = 0;

% Model list MUST be in alphabetical order for landmasks to work!!!!!!!!
model = ["CanESM5-1","CanESM5","INM-CM4-8","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR"];

b = 1; % model number to start on
while b < size(model,2)+1 % iterate through each model
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_1000_daily_20150101_21001231.nc";
    ua_1000 = ncread(filename, "ua");
    va_1000 = ncread(filename, "va");
    hus_1000 = ncread(filename, "hus");
    lat = ncread(filename, "lat");
    lon = ncread(filename, "lon");
    time = ncread(filename, "time");
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_850_daily_20150101_21001231.nc";
    ua_850 = ncread(filename, "ua");
    va_850 = ncread(filename, "va");
    hus_850 = ncread(filename, "hus");
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_700_daily_20150101_21001231.nc";
    ua_700 = ncread(filename, "ua");
    va_700 = ncread(filename, "va");
    hus_700 = ncread(filename, "hus");
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_500_daily_20150101_21001231.nc";
    ua_500 = ncread(filename, "ua");
    va_500 = ncread(filename, "va");
    hus_500 = ncread(filename, "hus");
    
    filename = "/home/disk/eos8/dglopez/cmip6/"+model(b)+"_UnWeighted_Unmasked_NorthWest_Hemisphere_250_daily_20150101_21001231.nc";
    ua_250 = ncread(filename, "ua");
    va_250 = ncread(filename, "va");
    hus_250 = ncread(filename, "hus");
    
    % Calculate IVT
    aa = [];
    bb = [];
    cc = [];
    dd = [];
    ee = [];
    aaa = [];
    bbb = [];
    ccc = [];
    ddd = [];
    eee = [];
    c = 1;
    d = 1;
    while c < size(hus_1000, 1)+1
        while d < size(hus_1000, 2)+1
            aa(c,d,:) = hus_1000(c,d,:).*ua_1000(c,d,:);
            bb(c,d,:) = hus_850(c,d,:).*ua_850(c,d,:);
            cc(c,d,:) = hus_700(c,d,:).*ua_700(c,d,:);
            dd(c,d,:) = hus_500(c,d,:).*ua_500(c,d,:);
            ee(c,d,:) = hus_250(c,d,:).*ua_250(c,d,:);
            
            aaa(c,d,:) = hus_1000(c,d,:).*va_1000(c,d,:);
            bbb(c,d,:) = hus_850(c,d,:).*va_850(c,d,:);
            ccc(c,d,:) = hus_700(c,d,:).*va_700(c,d,:);
            ddd(c,d,:) = hus_700(c,d,:).*va_500(c,d,:);
            eee(c,d,:) = hus_250(c,d,:).*va_250(c,d,:);
            
            d = d+1;
        end
        d = 1;
        c = c+1;
    end
    aaaa = [];
    bbbb = [];
    cccc = [];
    dddd = [];
    eeee = [];
    aaaa = (aa.^(2)+aaa.^(2)).^(1/2);
    bbbb = (bb.^(2)+bbb.^(2)).^(1/2);
    cccc = (cc.^(2)+ccc.^(2)).^(1/2);
    dddd = (dd.^(2)+ddd.^(2)).^(1/2);
    eeee = (ee.^(2)+eee.^(2)).^(1/2);
    
    IVT = [];
    IVT = (-1/9.80665)*((eeee-dddd)*25000+(dddd-cccc)*20000+(cccc-bbbb)*15000+(bbbb-aaaa)*20000);
    IVTu = (-1/9.80665)*((ee-dd)*25000+(dd-cc)*20000+(cc-bb)*15000+(bb-aa)*20000);
    IVTv = (-1/9.80665)*((eee-ddd)*25000+(ddd-ccc)*20000+(ccc-bbb)*15000+(bbb-aaa)*20000);
    
    % Create netCDF for the variable, save each height sepeartely in a
    % height file
    if SW_Region == 1 
        Region = "SW-US";
    elseif Hemisphere == 1
        Region = "NorthWest_Hemisphere";
    elseif World == 1
        Region = "World";
    end
    if Landmask_on ==1
        Mask_Type = "Landmasked";
    else
        Mask_Type = "Unmasked";
    end
    if Weight_on == 1
        Weight_Type = "Weighted";
    else
        Weight_Type = "UnWeighted";
    end

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","time","Dimensions",{"time",size(time,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","time",time(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","lat","Dimensions",{"lat",size(lat,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","lat",lat(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","lon","Dimensions",{"lon",size(lon,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","lon",lon(:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","IVT","Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","IVT",IVT(:,:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","IVTu","Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","IVTu",IVTu(:,:,:))

    nccreate("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","IVTv","Dimensions",{"lon",size(lon,1),"lat",size(lat,1),"time",size(time,1)},"Format","netcdf4")
    ncwrite("/home/disk/eos8/dglopez/cmip6/"+model(b)+"_"+Weight_Type+"_"+Mask_Type+"_"+Region+"_IVT_daily_20150101_21001231.nc","IVTv",IVTv(:,:,:))

    fprintf("Finished IVT, %s\n",model(b))

    b = b+1;
end

%% Plot upper Air
filename = "/home/disk/eos9/cmip6/ssp585/MPI-ESM1-2-LR/dglopez/ta_day_MPI-ESM1-2-LR_ssp585_r1i1p1f1_gn_20350101-20541231.nc";
ncdisp(filename)
ta = ncread(filename, "ta"); %(lon,lat,plev,time)
plev = ncread(filename, "plev");
lat = ncread(filename, "lat");
lon = ncread(filename, "lon");
time = ncread(filename, "time");

%%
load coastlines
% ax = worldmap('World');   [lat, lon] = meshgrid(lat, lon);

ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
setm(ax,'Origin',[0,180]);
geoshow(coastlat,coastlon, "Color", "k");
hold on
contourm(lat,lon,data(:,:,4,1))
%%
% filename = "/home/disk/eos9/cmip6/ssp585/CanESM5-1/dglopez/Weighted_Landmasked_SW-US_tasmax_daily_CanESM5-1_20150101_21001231.nc";
filename = "/home/disk/eos8/dglopez/cmip6/IPSL-CM6A-LR_Weighted_Landmasked_SW-US_tas_daily_20150101_21001231.nc";
ncdisp(filename)
VPD_m = ncread(filename, "tas");
lat = ncread(filename, "lat");
lon = ncread(filename, "lon");
%%
[lat, lon] = meshgrid(lat,lon);
%%
load coastlines
ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
geoshow(ax, lat, lon, VPD_m(:,:,31390), 'displaytype', 'texturemap')
% geoshow(lat, lon, VPD_m(:,:,1), 'displaytype', 'surface');
cb = colorbar('eastoutside');
hold on
cb.Label.String = '';
geoshow(coastlat,coastlon, "Color", "k");
hold off

%%
filename = "/home/disk/eos9/cmip6/ssp585/dglopez_Landmasks/sftlf_fx_CanESM5-1_ssp585_r1i1p1f1_gn.nc";
ncdisp(filename);

sftlf = ncread(filename, "sftlf");
lat = ncread(filename, "lat");
lon = ncread(filename, "lon");

%%
[lat, lon] = meshgrid(lat,lon);
%%
load coastlines
ax = worldmap([lat(1),lat(end)],[lon(1),lon(end)]);
geoshow(ax, lat, lon, sftlf, 'displaytype', 'texturemap');
% geoshow(lat, lon, VPD_m(:,:,1), 'displaytype', 'surface');
cb = colorbar('eastoutside');
hold on
cb.Label.String = '';
geoshow(coastlat,coastlon, "Color", "k");
hold off
%% 
filname = "/home/disk/eos9/cmip6/ssp585/IPSL-CM6A-LR/dglopez/tasmax_day_IPSL-CM6A-LR_ssp585_r1i1p1f1_gr_20150101-21001231.nc";
lat = ncread(filename, "lat")
lon = ncread(filename, "lon")

