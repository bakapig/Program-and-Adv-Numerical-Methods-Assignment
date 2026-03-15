% % Inputs :
% f: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% Ks: vector of strikes
% Vs: vector of implied Black volatilities
% Output :
% u: vector of call options undiscounted prices
function u = getBlackCall(f, T, Ks, Vs)
    
    % Calculate d1 and d2
    d1 = (log(f) - log(Ks)) ./ (Vs .* sqrt(T)) + 0.5 * Vs .* sqrt(T);
    d2 = d1 - Vs .* sqrt(T);
    
    % Use the core 'erf' function instead of the toolbox 'normcdf'
    N_d1 = 0.5 * (1 + erf(d1 / sqrt(2)));
    N_d2 = 0.5 * (1 + erf(d2 / sqrt(2)));
    
    % Calculate the undiscounted call price
    u = f .* N_d1 - Ks .* N_d2;
    
    % Edge case where call option with zero strike
    u(Ks == 0) = f;
    
end
