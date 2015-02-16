function exerciseInvest
import brml.*
pars.WealthValue=0:0.2:5; % these are the possible states that wealth can take

pars.epsilonAval=[0 0.01]; % these are the possible states that price A change by 
pars.epsilonBval=[-0.12 0 0.15]; % these are the possible states that price A change by
% for example, if we use the state 2 of epsilonAval, the price for A at the next timestep will
% be (1+0.01) times the current value. Similarly, if we use state 1 for B,
% B's new price will be (1-0.12) times the current price.

pars.DecisionValue=[1:-0.25:0]; % these are the decision values (order this way so that for two decisions with equally optimal expected utility, the more conservative (safer asset) will be preferred.

% transition matrices:
% asset A
pars.epsilonAtran=condp(ones(length(pars.epsilonAval)));

% asset B
for st=1:length(pars.epsilonBval)
    for stp=1:length(pars.epsilonBval)
        epsilonBtran(stp,st)=exp(- 10*(pars.epsilonBval(stp)-pars.epsilonBval(st)).^2);
    end
end
pars.epsilonBtran=condp(epsilonBtran);

epsilonA(1)=1; epsilonB(1)=1; w(1)=1; % initial states

T=40;
desired=1.5;
[dec val]=optdec(epsilonA(1),epsilonB(1),desired,T,w(1),pars);
fprintf('optimally place %f of wealth in asset A, giving expected wealth at time %d of %f\n',pars.DecisionValue(dec),T,val)

end

function [d1 val] = optdec(epsilonA1, epsilonB1, desired, T,w1,pars)

import brml.*

sizeW = length(pars.WealthValue);
sizeEpsA = length(pars.epsilonAval);    
sizeEpsB = length(pars.epsilonBval);    
sizeD = length(pars.DecisionValue);  
  
maxW = max(pars.WealthValue);
minW = min(pars.WealthValue);

% construct array p(wT | Wtm epsAt epsBt dTm)
p = zeros(sizeW, sizeW, sizeEpsA, sizeEpsB, sizeD);


for wTmI=1:sizeW
   for epsAtI=1:sizeEpsA
       for epsBtI=1:sizeEpsB
            for dTmI=1:sizeD
                %wT = pars.DecisionValue(dTi);
                epsAt = pars.epsilonAval(epsAtI);
                epsBt = pars.epsilonBval(epsBtI);
                decT = pars.DecisionValue(dTmI);
                wT = pars.WealthValue(wTmI)*(decT*(1+epsAt)+(1-decT)*(1+epsBt));
                % find the index of wT in the array and round to the
                % nearest square
                wTI = round(wT * 5) + 1;
                % truncate the value of wTI if it exceeds the max or min
                % values
                if(wT > maxW)
                    wTI = 26;
                end
                if (wT < minW)
                    wTI = 1;    
                end
                
                p(wTI, wTmI, epsAtI, epsBtI, dTmI) = 1;
            end
       end
   end
end
size(p)


[epsAt, epsAtm, epsBt, epsBtm, wT, wTm, dTm] = assign(1:7);

% construct arrays p(epsAT | epsATm) and p(epsBT | epsBTm)
pEAgEA = array([epsAt epsAtm],pars.epsilonAtran);
pEBgEB = array([epsBt epsBtm],pars.epsilonBtran);
pWtgWtmEpsD = array([wT, wTm, epsAt, epsBt, dTm], p);

gamEAtEBtWt = zeros(sizeEpsA, sizeEpsB, sizeW);
for wI=1:sizeW
   if(pars.WealthValue(wI) > desired* w1) 
      gamEAtEBtWt(:,:,wI) = 10000 * ones(sizeEpsA, sizeEpsB);
   end
end

% gamma message at time t
gamEAtEBtWt = array([epsAt, epsBt, wT], gamEAtEBtWt);

% potential of p(epsAT | epsATm) * p(epsBT | epsBTm) * p(wT | Wtm epsAt epsBt dTm)
prodPot3 = multpots([pEAgEA, pEBgEB, pWtgWtmEpsD]);

for t=1:T
    [gamEAtEBtWt, maxStates] = maxpot (sumpot(multpots([prodPot3, gamEAtEBtWt]), [epsAt, epsBt, wT]), dTm);
    gamEAtEBtWt.table
    % change labels from epsAtm, epsBtm, wTm --> epsAt, epsBtm wT
    gamEAtEBtWt = array([epsAt, epsBt, wT], gamEAtEBtWt.table);
end

maxStates = reshape(maxStates,sizeEpsA, sizeEpsB, sizeW);

w1I = round(w1 * 5) + 1;

d1 = maxStates(epsilonA1, epsilonB1, w1I);
val = gamEAtEBtWt.table(epsilonA1, epsilonB1, w1I);

end