%% 1. Load the Market Data
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365;       % Convert settlement lag to years
Ts = days / 365;       % Convert all tenors to years

%% 2. Build the Interest Rate Curves
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);

%% 3. Build the Forward Curve Engine
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

%% 4. TEST: Calculate the Forward Spot for 1 Year
% Let's use the 1-year tenor, which is the 8th row in our data (365 days)
T_test = Ts(8); 
fwd = getFwdSpot(fwdCurve, T_test);
fprintf('1-Year Forward Spot: %.4f\n', fwd);

%% 5. TEST: Convert 1-Year Deltas to Strikes
% Grab the 5 volatilities for the 1-year tenor
vol_test = vols(8, :); 

% Run your root search function!
K_test = getStrikeFromDelta(fwd, T_test, cps, vol_test, deltas);

disp('Calculated Strikes for 1-Year (10P, 25P, 50D, 25C, 10C):');
disp(K_test);