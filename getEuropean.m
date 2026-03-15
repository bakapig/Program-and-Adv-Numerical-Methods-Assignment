% Computes the price of a European payoff by integration
% Input:
%   volSurface : volatility surface data
%   T : time to maturity of the option
%   payoff: payoff function (must accept vectorized inputs)
%   ints: optional, partition of integration domain into sub-intervals
%         e.g. [0, 3, +Inf]. Defaults to [0, +Inf]
% Output:
%   u : forward price of the option (undiscounted price)
function u = getEuropean(volSurface, T, payoff, ints)

    % 1. Handle the optional 'ints' argument
    % If the user didn't provide sub-intervals, default to [0, Infinity]
    if nargin < 4 || isempty(ints)
        ints = [0, Inf];
    end

    % 2. Define the mathematical integrand
    % We are integrating: Payoff(x) * Probability(x)
    % 'x' represents the potential future spot prices (S_T)
    integrand = @(x) payoff(x) .* getPdf(volSurface, T, x);

    % 3. Loop through the sub-intervals and sum the integrals
    u = 0;
    num_intervals = length(ints) - 1;
    
    for i = 1:num_intervals
        lower_bound = ints(i);
        upper_bound = ints(i+1);
        
        % Skip if the interval is zero-width (e.g., [K, K])
        if lower_bound == upper_bound
            continue;
        end
        
        % Use MATLAB's built-in adaptive quadrature for numerical integration
        % Note: We use the default vectorized evaluation for maximum speed.
        % If the payoff function fails to vectorize, adding 'ArrayValued', true helps,
        % but requires significantly more computation time.
        interval_value = integral(integrand, lower_bound, upper_bound);
        
        % Add the area of this sub-interval to our total expected value
        u = u + interval_value;
    end

end