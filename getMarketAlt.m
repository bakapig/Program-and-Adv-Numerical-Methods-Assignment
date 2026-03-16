function [spot, lag, days, domdf, fordf, vols, cps, deltas] = getMarketAlt()
    % Alternate Market Scenario for robustness testing
    spot = 1.1050; % Changed spot price
    lag = 2; % Standard 2-day lag

    % Columns: Days, DomDF(~4%), ForDF(~2%), Vols (10D P, 25D P, 50D C, 25D C, 10D C)
    % Notice how domdf decays faster than fordf now!
    data = [
        7    0.9992  0.9996  14.00 12.50 12.00 12.80 14.50
        14   0.9985  0.9992  14.20 12.70 12.20 13.00 14.70
        21   0.9977  0.9988  14.40 12.90 12.40 13.20 14.90
        28   0.9969  0.9985  14.60 13.10 12.60 13.40 15.10
        59   0.9936  0.9968  15.00 13.50 13.00 13.80 15.50
        90   0.9902  0.9951  15.40 13.90 13.40 14.20 15.90
        181  0.9804  0.9901  16.00 14.50 14.00 14.80 16.50
        365  0.9608  0.9802  16.80 15.30 14.80 15.60 17.30
        546  0.9419  0.9705  17.40 15.90 15.40 16.20 17.90
        730  0.9231  0.9608  18.00 16.50 16.00 16.80 18.50
    ];

    days = data(:, 1);
    domdf = data(:, 2);
    fordf = data(:, 3);
    
    % Divide by 100 to convert percentage to decimals
    vols = data(:, 4:end) / 100;
    
    cps = [-1, -1, 1, 1, 1];
    deltas = [0.1, 0.25, 0.5, 0.25, 0.1];
end