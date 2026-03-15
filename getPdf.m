% Compute the probability density function of the price S(T)
% Inputs:
%   volSurf: volatility surface data
%   T: time to expiry of the option
%   Ks: vector of strikes
% Output:
%   pdf: vector of pdf(Ks)
function pdf = getPdf(volSurf, T, Ks)

    dK = 1e-4;
    
    % THE FIX: Prevent strikes from hitting 0 or going negative!
    % We floor the strikes at 1e-8 so log(K) never generates imaginary numbers.
    Ks_safe = max(Ks, 1e-8);
    K_up = Ks_safe + dK;
    K_down = max(Ks_safe - dK, 1e-8);
    
    % Get the volatilities
    [vols, fwd] = getVol(volSurf, T, Ks_safe);
    [vols_up, ~] = getVol(volSurf, T, K_up);
    [vols_down, ~] = getVol(volSurf, T, K_down);
    
    % Get the call prices
    C = getBlackCall(fwd, T, Ks_safe, vols);
    C_up = getBlackCall(fwd, T, K_up, vols_up);
    C_down = getBlackCall(fwd, T, K_down, vols_down);
    
    % Compute the PDF using finite difference
    pdf = (C_up - 2 * C + C_down) ./ (dK^2);
    
    % A probability cannot be negative, so cap floating point errors at 0
    pdf = max(pdf, 0);

end