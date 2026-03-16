function projectAlt()
    disp('==================================================');
    disp('   BOOTSTRAPPING ALTERNATIVE MARKET DATA TEST     ');
    disp('==================================================');
    
    % Load the new alternative market data
    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarketAlt();
    tau = lag / 365;
    Ts = days / 365;

    % 1. Construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
    volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);

    % We will test at a new random maturity: 1.2 Years
    test_T = 1.2;
    disp(['Testing Evaluation at Maturity T = ', num2str(test_T), ' Years']);
    disp('--------------------------------------------------');

    % 2. Extract Basic Rates
    domRate = exp(-getRateIntegral(domCurve, test_T));
    fwd = getFwdSpot(fwdCurve, test_T);
    
    disp(['Spot Price (T=0):        ', num2str(spot)]);
    disp(['Forward Price (T=1.2):   ', num2str(fwd), ' (Notice it drifted UP!)']);
    disp(['Dom Discount Factor:     ', num2str(domRate)]);
    disp(' ');

    % 3. Extract Volatilities (ATM and 110% OTM)
    [vol, ~] = getVol(volSurface, test_T, [fwd, fwd * 1.10]);
    disp(['ATM Volatility:          ', num2str(vol(1) * 100), '%']);
    disp(['OTM Volatility (110% K): ', num2str(vol(2) * 100), '%']);
    disp(' ');

    % 4. Price Vanilla Options (Check Put-Call Parity)
    disp('Pricing European Vanilla Options (Strike = Forward):');
    call_payoff = @(x) max(x - fwd, 0);
    put_payoff = @(x) max(fwd - x, 0);

    % Using sub-interval hints for speed and accuracy
    call_price = getEuropean(volSurface, test_T, call_payoff, [fwd, Inf]);
    put_price = getEuropean(volSurface, test_T, put_payoff, [0, fwd]);

    disp(['Forward ATM Call Price:  ', num2str(call_price)]);
    disp(['Forward ATM Put Price:   ', num2str(put_price)]);
    disp(['Parity Difference:       ', num2str(abs(call_price - put_price)), ' (Should be near zero)']);
    disp(' ');

    % 5. Price Discontinuous Payout
    disp('Pricing Binary/Digital Call (Pays 1 if S_T > Fwd):');
    digital_payoff = @(x) (x > fwd);
    digi_price = getEuropean(volSurface, test_T, digital_payoff, [fwd, Inf]);
    disp(['Digital Call Price:      ', num2str(digi_price)]);
    
    disp('==================================================');
end