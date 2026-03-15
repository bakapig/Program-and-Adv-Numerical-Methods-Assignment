%% Visualization Script for Task 2.5: The Volatility Smile
% This plots the cubic spline interpolation and hyperbolic tangent extrapolation!

% 1. Setup Market Data & Curves (from your earlier functions)
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365;
Ts = days / 365;

domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

% 2. Select a specific tenor to plot (Let's use the 1-Year / 365 day tenor)
idx_1y = 8; 
T_1y = Ts(idx_1y);
fwd_1y = getFwdSpot(fwdCurve, T_1y);
vol_1y = vols(idx_1y, :);

% 3. Build the Smile Structure using your brilliant Task 2.5 factory
smile_1y = makeSmile(fwdCurve, T_1y, cps, deltas, vol_1y);

% 4. Generate a dense grid of strikes extending FAR beyond the market data
% We go from K=0.5 to K=2.8 to force the engine to use the extrapolation wings
K_dense = linspace(0.5, 2.8, 500);

% 5. Evaluate the continuous volatility curve using your Task 2.5 engine
vol_dense = getSmileVol(smile_1y, K_dense);

% 6. Let's build a beautiful plot!
figure('Name', 'Task 2.5: Volatility Smile Interpolation', 'Position', [150, 150, 850, 550]);

% Plot the full continuous curve (Spline + Wings)
plot(K_dense, vol_dense * 100, 'b-', 'LineWidth', 2);
hold on;

% Plot the 5 original market quotes as red dots
plot(smile_1y.Ks, smile_1y.vols * 100, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Add vertical lines to show exactly where the math changes from Spline to Tanh
xline(smile_1y.Ks(1), 'k--', 'Left Boundary (K_1)', 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
xline(smile_1y.Ks(end), 'k--', 'Right Boundary (K_N)', 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');

% Add a vertical line for the ATM Forward Spot
xline(fwd_1y, 'm:', 'Forward Spot (ATM)', 'LabelVerticalAlignment', 'top', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Formatting the chart
title(sprintf('Continuous Implied Volatility Smile (T = %.2f Years)', T_1y), 'FontSize', 14);
xlabel('Strike Price (K)', 'FontSize', 12);
ylabel('Implied Volatility (%)', 'FontSize', 12);
legend('Continuous \sigma(K) Curve', 'Actual Market Quotes', 'Location', 'north');
grid on;

% Add some text to point out the wings
text(0.6, smile_1y.vols(1)*100 + 0.5, 'Left \tanh Wing \rightarrow', 'FontSize', 11, 'Color', 'b');
text(2.3, smile_1y.vols(end)*100 + 0.5, '\leftarrow Right \tanh Wing', 'FontSize', 11, 'Color', 'b');