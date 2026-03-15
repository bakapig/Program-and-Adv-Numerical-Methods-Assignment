%% Visualization Script: Progress up to Task 2.4
% Run this to visualize the data engine you have built so far!

% 1. Load the Data & Build the Curves
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365;
Ts = days / 365;

domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

% 2. Setup the Figure
figure('Name', 'FE5116 Project Progress', 'Position', [100, 100, 800, 900]);

%% Subplot 1: Interest Rate Yield Curves
subplot(3, 1, 1);
% Convert discount factors back into annualized continuous yields for plotting
domYields = -log(domdfs) ./ Ts;
forYields = -log(fordfs) ./ Ts;

plot(Ts, domYields * 100, '-o', 'LineWidth', 1.5); hold on;
plot(Ts, forYields * 100, '-o', 'LineWidth', 1.5);
title('Domestic and Foreign Zero Rates');
xlabel('Time to Maturity (Years)'); 
ylabel('Annualized Rate (%)');
legend('Domestic Rate', 'Foreign Rate', 'Location', 'best');
grid on;

%% Subplot 2: Forward Spot Curve
subplot(3, 1, 2);
% Generate 100 dense time points to make the line perfectly smooth
T_dense = linspace(0, max(Ts), 100);
fwd_dense = getFwdSpot(fwdCurve, T_dense); % Utilizing your vectorized function!

plot(T_dense, fwd_dense, '-k', 'LineWidth', 1.5); hold on;
plot(0, spot, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Mark today's spot
title('Forward Exchange Rate Curve (G_0(T))');
xlabel('Time to Maturity (Years)'); 
ylabel('Forward Rate');
legend('Forward Curve', 'Current Spot', 'Location', 'best');
grid on;

%% Subplot 3: Volatility Smile (1-Year Tenor)
subplot(3, 1, 3);
idx_1y = 8; % The 8th row in your data corresponds to 365 days
T_1y = Ts(idx_1y);
fwd_1y = getFwdSpot(fwdCurve, T_1y);
vol_1y = vols(idx_1y, :);

% Calculate the exact strikes using your root/analytical function
K_1y = getStrikeFromDelta(fwd_1y, T_1y, cps, vol_1y, deltas);

% Sort the strikes from lowest to highest so the line connects properly
[K_sorted, sort_idx] = sort(K_1y);
vol_sorted = vol_1y(sort_idx);

plot(K_sorted, vol_sorted * 100, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
hold on;
xline(fwd_1y, '--r', 'Forward Spot (ATM)'); % Mark the At-The-Money center
title('Implied Volatility Smile (1-Year Maturity)');
xlabel('Strike Price (K)'); 
ylabel('Implied Volatility (%)');
grid on;