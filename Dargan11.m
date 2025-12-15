%% Vapor Pressure equations and plots
% From the NEW paper (Huang) and the database based upon (Standard)
% Standard_P = [611.655,2339.32,7384.94,19946.4,47414.5,101418];
% New_P = [611.689,2339.32,7384.93,19946.1,47415.0,101417];

%From book on standards:
Standard_P = [0.006116570,0.00872575,0.0122818, 0.0170574,0.0233921,0.0316975,0.0424669,0.0562862,0.0738443,0.0959439,0.123513,0.157614,0.199458,0.250411,0.312006,0.385954,0.474147,0.578675,0.701824,0.846089,1.01418]*10^5; % from book table
Standard_T = [0.01,5:5:100];

fig = figure(1)
% sgtitle("Vapor Pressure Methods",'FontSize',24)


subplot(3,1,1)

plot(Standard_T,Standard_P, "-*", "color", "[0.25, 0.25, 0.25]", "LineWidth", 2)
hold on

% Using the new paper paper (Huang)
t = [00.1,5:5:100];
t_k = t + 273.15; % paper suggests t should be in kelvin
Huang_P = exp(34.494 - (4924.99./(t + 237.1)))./((t + 105).^(1.57));
plot(t,Huang_P, "-o","color", "[1, 0, 0]", "LineWidth", 2)

Improved_Magnus_P = 610.94 * exp((17.625 * t)./(t + 234.04));
plot(t,Improved_Magnus_P, "-", "color", "[0.9290, 0.6940, 0.1250]", "LineWidth", 2)

% From Bolton Paper
Bolton_P = (6.112 * exp((17.67 * t)./(t + 243.5)))*100; % equation in mb - eq.10
plot(t,Bolton_P, "-","color", "[0, 0, 1]", "LineWidth", 2)

% From Bolton:
g = [-2.9912729*10^3, -6.0170128*10^3, 1.887643854*10^1, -2.8354721*10^-2, 1.7838301*10^-5, -8.4150417*10^-10, 4.4412543*10^-13, 2.858487*10^0]; % Wexler, t in K
Wexler_P = g(1)*t_k.^(-2) + g(2)*t_k.^(-1) + g(3)*t_k.^(-0) + g(4)*t_k.^(1) + g(5)*t_k.^(2) + g(6)*t_k.^(3) + g(7)*t_k.^(4) + g(8)*log(t_k);
Wexler_P = exp(Wexler_P);
plot(t,Wexler_P, "-","color", "[0, 0.5, 0]", "LineWidth", 2)

a = 17.2693882;
b = 35.86;
Murray_P = (6.1078 * exp((a*(t_k - 273.16))./(t_k - b)))*100; % in K and mb???
plot(t,Murray_P, "-","color", "[0.75, 0, 0.75]", "LineWidth", 2)

title("Saturation Vapor Pressure")
xlabel("Temperature (°C)")
ylabel("Pressure (Pa)")
legend("Standard", "Huang","Improved Magnus","Bolton","Wexler","Murray", "Location", "northwest")
ax = gca;
ax.FontSize = 18;
grid on
hold off


%%
subplot(3,1,2)

d_Huang_P = Huang_P - Standard_P;
d_Improved_Magnus_P = Improved_Magnus_P - Standard_P;
d_Bolton_P = Bolton_P - Standard_P;
d_Wexler_P = Wexler_P - Standard_P;
d_Murray_P = Murray_P - Standard_P;

plot(Standard_T,d_Huang_P, "-o","color", "[1, 0, 0", "LineWidth", 2)
hold on
plot(Standard_T,d_Improved_Magnus_P, "-", "color", "[0.9290, 0.6940, 0.1250]", "LineWidth", 2)
plot(Standard_T,d_Bolton_P, "-","color", "[0, 0, 1]", "LineWidth", 2)
plot(Standard_T,d_Wexler_P, "-","color", "[0, 0.5, 0]", "LineWidth", 2)
plot(Standard_T,d_Murray_P, "-","color", "[0.75, 0, 0.75]", "LineWidth", 2)

title("Difference from Standard")
legend("Huang","Improved Magnus","Bolton","Wexler","Murray", "Location", "northwest")
xlabel("Temperature (°C)")
ylabel("Pressure (Pa)")
ax = gca;
ax.FontSize = 18;
grid on
hold off

%%
subplot(3,1,3)
dp_Huang_P = d_Huang_P./Standard_P;
dp_Improved_Magnus_P = Improved_Magnus_P./Standard_P;
dp_Bolton_P = d_Bolton_P./Standard_P;
dp_Wexler_P = d_Wexler_P./Standard_P;
dp_Murray_P = d_Murray_P./Standard_P;


plot(Standard_T,dp_Huang_P*100, "-o","color", "[1, 0, 0", "LineWidth", 2)
hold on
% plot(Standard_T,dp_Improved_Magnus_P, "-")
plot(Standard_T,dp_Bolton_P*100, "-","color", "[0, 0, 1]", "LineWidth", 2)
plot(Standard_T,dp_Wexler_P*100, "-","color", "[0, 0.5, 0]", "LineWidth", 2)
plot(Standard_T,dp_Murray_P*100, "-","color", "[0.75, 0, 0.75]", "LineWidth", 2)

title("Percent Difference from Standard (W/O Improved Magnus)")
legend("Huang","Bolton","Wexler","Murray", "Location", "northwest")
xlabel("Temperature (°C)")
ylabel("Percent Difference (%)")
ax = gca;
ax.FontSize = 18;
grid on
hold off

%% Set figure size in inches
fig.Units = 'inches';
fig.Position = [1, 1, 16, 16];  % [left, bottom, width, height] => 16x16 inches

saveas(fig, '/home/disk/eos8/dglopez/pictures/Vapor-Pressure-Methods.png');
