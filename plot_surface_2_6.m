%% Visualization Script for Task 2.6: The 3D Volatility Surface

% 1. Build the Market Engine
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365;
Ts = days / 365;

domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

% 2. THIS FIXES THE ERROR: Build the surface and save it to the workspace!
volSurf = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);

% 3. Test your getVol command
test_vols = getVol(volSurf, 1.34, [1.4, 1.5, 1.6]);
fprintf('\nSuccess! Vols for T=1.34 at K=[1.4, 1.5, 1.6] are:\n');
disp(test_vols);

% 4. Setup the 3D Grid (Time from 0.1 to 2 years, Strikes from 1.0 to 2.2)
T_grid = linspace(0.1, max(Ts), 30); 
K_grid = linspace(1.0, 2.2, 40);     

% Pre-allocate the Volatility matrix (Z-axis)
V_grid = zeros(length(T_grid), length(K_grid));

% 5. Evaluate the Surface using your engine
for i = 1:length(T_grid)
    V_grid(i, :) = getVol(volSurf, T_grid(i), K_grid);
end

% 6. Draw the 3D Plot!
figure('Name', 'Task 2.6: Implied Volatility Surface', 'Position', [200, 150, 900, 650]);
[K_mesh, T_mesh] = meshgrid(K_grid, T_grid);

% Use surf for a beautiful colored 3D mesh
surf(K_mesh, T_mesh, V_grid * 100, 'EdgeColor', 'none', 'FaceAlpha', 0.9);
colormap(jet); % Adds beautiful temperature colors
colorbar;
hold on;

% Add the original market data points as black dots to see how they anchor the surface
for i = 1:length(Ts)
    fwd_i = getFwdSpot(fwdCurve, Ts(i));
    K_market = getStrikeFromDelta(fwd_i, Ts(i), cps, vols(i,:), deltas);
    plot3(K_market, repmat(Ts(i), 1, 5), vols(i,:) * 100, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
end

% Formatting
title('3D Implied Volatility Surface \sigma(T, K)', 'FontSize', 15);
xlabel('Strike Price (K)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Time to Maturity (Years)', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('Implied Volatility (%)', 'FontSize', 12, 'FontWeight', 'bold');
view(-45, 30); % Set a nice angled 3D view
grid on;