clear all; clc;
import brml.*
load('diseaseNet.mat');
[jtpot, jtsep, infostruct]=jtree(pot);
[jtpotfullabsorb, jtsepfullabsorb, Z]=absorption(jtpot,jtsep,infostruct); % do full round of absorption

%Calculate Symptom marginals with the JT algorithm
CalculatedMarginals = false(1,40);
while(1)
    for i = 1:1:length(jtpotfullabsorb)
        for j = jtpotfullabsorb{i}.variables
            if(j > 20)
                if(~CalculatedMarginals(j-20))
                    SymptomMarginalsJT{j-20} = sumpot(jtpotfullabsorb{i},j,0);
                    CalculatedMarginals(j-20) = true;
                    if(sum(CalculatedMarginals) == 40)
                        break;
                    end
                end
            end
        end
        if(sum(CalculatedMarginals) == 40)
            break;
        end
    end
    if(sum(CalculatedMarginals) == 40)
        break;
    end
end

konstpS = zeros(40,1);

for i=1:length(SymptomMarginalsJT)
   tmpTable= SymptomMarginalsJT{i}.table;
   konstpS(i) = double(tmpTable(1)); 
end
konstpS

%Compute Symptom marginals with simple Belief Network Inference
for i = 1:1:40
    SymptomMarginalsBN{i} = sumpot(multpots(pot(pot{i+20}.variables)),i+20,0);
end

%Compute Error between the two methods
for i = 1:1:40
    MarginalErrors(:,i) = abs(SymptomMarginalsBN{i}.table-SymptomMarginalsJT{i}.table);
end
fprintf('Maximum Error: %e\n', max(max(MarginalErrors)));

%3rd part of exercise. Setting variables with evidence to their evidence
%state
for i = 1:1:60
    potcond{i} = setpot(pot{i},[21:1:30], [1 1 1 1 1 2 2 2 2 2]);
end
[newpot, newvars, uniquevariables, uniquenstates] = squeezepots(potcond);

[jtpotcond, jtsepcond, infostructcond]=jtree(newpot);
[jtpotfullabsorbcond, jtsepfullabsorbcond, Zcond]=absorption(jtpotcond,jtsepcond,infostructcond); % do full round of absorption
for i = 1:1:length(jtpotfullabsorbcond)
    jtpotfullabsorbcond{i}.table = jtpotfullabsorbcond{i}.table/Zcond;
end

%Calculate Disease marginals with the JT algorithm with the conditions
CalculatedMarginals = false(1,20);
while(1)
    for i = 1:1:length(jtpotfullabsorbcond)
        for j = jtpotfullabsorbcond{i}.variables
            if(j < 21)
                if(~CalculatedMarginals(j))
                    DiseaseMarginalsJT{j} = sumpot(jtpotfullabsorbcond{i},j,0);
                    CalculatedMarginals(j) = true;
                    if(sum(CalculatedMarginals) == 20)
                        break;
                    end
                end
            end
        end
        if(sum(CalculatedMarginals) == 20)
            break;
        end
    end
    if(sum(CalculatedMarginals) == 20)
        break;
    end
end

%Calculate Disease marginals with the JT algorithm without the conditions
CalculatedMarginals = false(1,20);
while(1)
    for i = 1:1:length(jtpotfullabsorb)
        for j = jtpotfullabsorb{i}.variables
            if(j < 21)
                if(~CalculatedMarginals(j))
                    DiseaseMarginalsJTuncond{j} = sumpot(jtpotfullabsorb{i},j,0);
                    CalculatedMarginals(j) = true;
                    if(sum(CalculatedMarginals) == 20)
                        break;
                    end
                end
            end
        end
        if(sum(CalculatedMarginals) == 20)
            break;
        end
    end
    if(sum(CalculatedMarginals) == 20)
        break;
    end
end

for i=1:length(DiseaseMarginalsJT)
    %SymptomMarginalsJT{i}.table
    DiseaseMarginalsJT{i}.table
end

%Check if there has been a difference in the marginals with the conditions
for i = 1:1:20
    ProbabilityChange(:,i) = [DiseaseMarginalsJTuncond{i}.table(1);DiseaseMarginalsJT{i}.table(1)];
end
