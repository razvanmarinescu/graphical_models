function prob913()

import brml.*

load('chowliudata.mat')

A = ChowLiu(X);

end

function A = ChowLiu(X)

import brml.*

[D,N] = size(X)

pX = cell(D,1);
pXX = cell(D,D);

nrStates = 3;
states = 1:nrStates

for i=1:D
    indicesI = [(X(i,:) == 1); (X(i,:) == 2); (X(i,:) == 3)];
    tmpTable = sum(indicesI,2);
    pX{i} = tmpTable ./ sum(tmpTable);

    tmpTable ./ sum(tmpTable)
    
    for j=1:D
        indicesJ = [(X(j,:) == 1); (X(j,:) == 2); (X(j,:) == 3)];
        tmpTable2 = zeros(nrStates,nrStates);      
        for sI=states
            for sJ=states
                indices = indicesI(sI,:) .* indicesJ(sJ,:);
                tmpTable2(sI,sJ) = sum(indices); 
            end
        end
        pXX{i}{j} = tmpTable2 ./ sum(tmpTable2(:));
        
    end

end

w = zeros(D,D);
for i=1:D
    for j=1:D
        w(i,j) = MI(pX{i}, pX{j}, pXX{i}{j},X);
    end
     w(i,i) = 0;
end

[A elimseq weight] = spantree(w)

end


function w = MI(pI, pJ, pIJ,X)

nrStates = size(pI);
w = 0;

for sI=1:nrStates
    for sJ=1:nrStates
        if (pIJ(sI,sJ) ~= 0 && pI(sI) * pJ(sJ) ~= 0)
            w = w + pIJ(sI,sJ) * log ((pIJ(sI,sJ))/(pI(sI) * pJ(sJ)));
        end
        
    end
end

end