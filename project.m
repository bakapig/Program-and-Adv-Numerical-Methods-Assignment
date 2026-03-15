function project ()
[ spot , lag , days , domdfs , fordfs , vols , cps , deltas ] = getMarket ();
tau = lag / 365; % spot rule lag
% time to maturities in years
Ts = days / 365;
% construct market objects
domCurve = makeDepoCurve ( Ts , domdfs );
forCurve = makeDepoCurve ( Ts , fordfs );
fwdCurve = makeFwdCurve ( domCurve , forCurve , spot , tau );
volSurface = makeVolSurface ( fwdCurve , Ts , cps , deltas , vols );
% compute a discount factor
domRate = exp ( - getRateIntegral ( domCurve , 0.8))
% compute a forward spot rate G_0 (0.8)
fwd = getFwdSpot ( fwdCurve , 0.8)
% build ans use a smile
smile = makeSmile ( fwdCurve , Ts (end) , cps , deltas , vols (end ,:));
atmfvol = getSmileVol ( smile , getFwdSpot ( fwdCurve , Ts (end )))
% get some vol
[ vol , f ] = getVol ( volSurface , 0.8 , [ fwd , fwd ])
% get pdf
pdf = getPdf ( volSurface , 0.8 , [ fwd , fwd ])
% atm european call
payoff = @ ( x )max (x - fwd ,0);
u = getEuropean ( volSurface , 0.8 , payoff )
% atm european put with subintervals hint
payoff = @ ( x )max ( fwd -x ,0);
u = getEuropean ( volSurface , 0.8 , payoff , [0 , fwd ])
% atm european digital call spread with subintervals hint
payoff = @ ( x ) ( x > 0.95* fwd ) .* ( x < 1.05* fwd );
u = getEuropean ( volSurface , 0.8 , payoff , [0.95* fwd , 1.05* fwd ])
end