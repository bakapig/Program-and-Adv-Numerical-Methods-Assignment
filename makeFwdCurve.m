% Inputs :
% domCurve : domestic IR curve data
% forCurve : domestic IR curve data
% spot : spot exchange rate
% tau: lag between spot and settlement
% Output :
% curve : a struct containing data needed by getFwdSpot
function curve = makeFwdCurve ( domCurve , forCurve , spot , tau )

    % Simply pack the inputs into the output struct
    curve.domCurve = domCurve;
    curve.forCurve = forCurve;
    curve.spot = spot;
    curve.tau = tau;

end