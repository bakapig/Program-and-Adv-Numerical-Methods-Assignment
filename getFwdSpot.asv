% Inputs :
% curve : pre - computed fwd curve data
% T: forward spot date
% Output :
% fwdSpot : E[S(t) | S (0)]
function fwdSpot = getFwdSpot ( curve , T )
% 1. Get the integral of the domestic rate (r) from 0 to tau, and 0 to T+tau
    domInt_tau = getRateIntegral(curve.domCurve, curve.tau);
    domInt_T_tau = getRateIntegral(curve.domCurve, T + curve.tau);
    
    % 2. Get the integral of the foreign rate (y) from 0 to tau, and 0 to T+tau
    forInt_tau = getRateIntegral(curve.forCurve, curve.tau);
    forInt_T_tau = getRateIntegral(curve.forCurve, T + curve.tau);
    
    % 3. Calculate the integral specifically for the window [tau, T+tau]
    dom_integral = domInt_T_tau - domInt_tau;
    for_integral = forInt_T_tau - forInt_tau;
    
    % 4. Compute the forward spot price G_0(T)
    fwdSpot = curve.spot .* exp(dom_integral - for_integral);

end