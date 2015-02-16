function [] = raz_probs()

%prob313()
%prob314()
%prob322()
%prob26()
%extra1()
prob322var2()
end

function [dec] = cliqueToDec(clique)

%binarray = zeros(10,1);
dec = 0;
for i=1:10
    if (ismember(i, clique))
        %binarray(i) = 1
        dec = dec + 2^(10-i);
    end
end

end

%% prob 2.6
function [] = prob26()
load('WikiAdjSmall.mat');

% checked with david
%load('ABmatrices.mat');

matrix = A;

hist = zeros(1000,1);

[width, height] = size(matrix);

for i=1:width
    for j=1:height
        if (matrix(i,j) == 1 || matrix(j,i) == 1)
            matrix(i,j) = 1;
        end
    end
end

%dist = graphallshortestpaths(sparse(matrix));
dist = graphallshortestpaths(matrix,'Directed',false);

for i=1:width
    for j=1:i
        if (dist(i,j) ~= inf && dist(i,j) ~= 0)
            hist(dist(i,j)) = hist(dist(i,j)) + 1;
        end
    end
end

dist(1:9, 1:9)

hist(1:20)
bar(hist(1:20))

adjustPicture('Distance', 'Frequency', '', 'Histogram of distance between users')
axis([0 20 0 60000])
set(gca,'XTick',1:20);
end

%% prob 2.7

function [] = prob27()
C = load('cliques.mat');

C = C.cl;
len = length(C);

maxCliques = cell(100,1);
count = 1
for c1=1:len
    isContained = 0;
    for c2=1:len
        if(c1 ~= c2 && all(ismember(C{c1}, C{c2})))
            isContained = isContained + 1;
            break
        end
    end
    if(isContained == 0)
       maxCliques{count} = C{c1};
       count = count + 1;
    end
end

count = count - 1;

celldisp(maxCliques(1:count))

decCliques = zeros(count,1);
for i=1:count-1
    decCliques(i) = cliqueToDec(maxCliques{i});
end
    
decCliques

end

%% prob 3.13

function [] = prob313(a,b)
load('ABmatrices.mat');
findImmoralities(a,b);

findImmoralities(b,a);
end

function [] = findImmoralities(a,b)


undirA = a;
undirB = b;

[width, height] = size(a);

% build undirected graph
for i=1:width
    for j=1:height
        if (a(i,j) == 1)
            undirA(j,i) = 1;
        end
        if (b(i,j) == 1)
            undirB(j,i) = 1;
        end        
    end
end


% degrees of nodes are the same
sum(undirA)
sum(undirB)


% adjacency matrices of undirected graphs are the same
for i=1:width
    for j=1:height
        if (undirA(i,j) ~= undirB(i,j))
            i
            j
        end
    end
end

markovEq = 1;

% refactor code below so that all immoralities are obtained in two separate
% sets for each graph and then are
for j=1:height
    %j
    parentsA = find(a(:,j)); % parents of node j in graph A
    parentsB = find(b(:,j));
    for k=1:length(parentsA)
        for l=k+1:length(parentsA)
            if (undirA(parentsA(k), parentsA(l)) == 0)
                % check if other graph has immorality
                parentsExist = ismember(parentsA(k), parentsB) && ismember(parentsA(l), parentsB);
            
                immorality = [j, parentsA(k), parentsA(l)]
                
                if (parentsExist && undirB(parentsA(k), parentsA(l)) == 1)
                    markovEq = 0;
                    badImmorality = [k, l];
                end    
            end
        end
    end
end

markovEq
end


function [] = prob314()

%c122, c232, c121323, c232113 = 1,2,3,4

%indexC12 = PotArray(c121323, [0 0 0 0 1 1 1 1])
initProb = [0.9 0.1];
pC12 = initProb;
pC13 = initProb;
pC23 = initProb;
pC32 = initProb;
pC31 = initProb;
pC21 = initProb;

pC121332 = [0.9^3 0.9^2*0.1 0.9^2*0.1 0.9*0.1^2 0.9^2*0.1 0.9*0.1^2 0.9*0.1^2 0.1^3];

% conditional prob tables: p(C12(2) = 1 | C12 C13 C23) and the other one
pC122gC121332 = [1 1 1 0 0 0 0 0; 0 0 0 1 1 1 1 1];
pC232gC232113 = [1 1 1 0 0 0 0 0; 0 0 0 1 1 1 1 1];

% child node states
pC122 = [0 1];
pC232 = [1 0];

% lambda messages
lamC122 = pC122 * pC122gC121332;
lamC232 = pC232 * pC232gC232113;

% calculate the lambda evidence at the parent node
p1C121332 = lamC122 .* pC121332;

% normalise the probability of the joint state
p1C121332 = p1C121332 ./ sum(p1C121332);

indicesC13 = [1,2,5,6; 3,4,7,8];
indicesC32 = [1,3,5,7; 2,4,6,8];

% calculate the marginals p(C12) p(C13) p(C23)
pC12 = [sum(p1C121332(1:4)) sum(p1C121332(5:8))];
pC13 = [sum(p1C121332(indicesC13(1,:))) sum(p1C121332(indicesC13(2,:)))];
pC32 = [sum(p1C121332(indicesC32(1,:))) sum(p1C121332(indicesC32(2,:)))];

pC232113 = [pC23(1)*pC21(1)*pC13(1) pC23(1)*pC21(1)*pC13(2) pC23(1)*pC21(2)*pC13(1) pC23(1)*pC21(2)*pC13(2) pC23(2)*pC21(1)*pC13(1) pC23(2)*pC21(1)*pC13(2) pC23(2)*pC21(2)*pC13(1) pC23(2)*pC21(2)*pC13(2)];

% calculate the lambda evidence at the parent node
p1C232113 = lamC232 .* pC232113;

% normalise the probability of the joint state
p1C232113 = p1C232113 ./ sum(p1C232113);
     
% calculate the marginals p(C23) p(C21) p(C13)
pC23 = [sum(p1C232113(1:4)) sum(p1C232113(5:8))];
pC21 = [sum(p1C232113(indicesC13(1,:))) sum(p1C232113(indicesC13(2,:)))];
pC13 = [sum(p1C232113(indicesC32(1,:))) sum(p1C232113(indicesC32(2,:)))];

display('--------------------')

pC12
pC13
pC23
pC32
pC21
pC31
        
end

function [] = prob322()

data = [1 2 3; 2 5 3; 4 7 10; 6 3 4; 6 8 5; 9 3 7; 10 2 4; 7 1 2; 8 7 2; 8 3 6; 8 6 4; 4 3 9; 5 4 1; 9 5 1; 6 7 8; 4 9 7; 10 8 6; 5 4 3; 6 3 2; 1 4 2];

nrDataPoints = 10;
nrLevels = 5;
pInterest = ones(nrDataPoints, nrLevels) .* 0.2;

pDgABC = zeros(nrLevels, nrLevels, nrLevels);

for sA = 1:nrLevels
    for sB = 1:nrLevels
        for sC = 1:nrLevels
            pDgABC(sA, sB, sC) = exp(sA - max(sB, sC));
        end
    end
end

% calculate the marginal p(sA)
pSa = zeros(1, nrLevels);
for sA = 1:nrLevels
    pSa(sA) = sum(sum(pDgABC(sA, :, :)));
end

% calculate the marginal p(Sb). Note that p(Sc) = p(Sb)
pSb = zeros(1, nrLevels);
for sB = 1:nrLevels
    pSb(sB) = sum(sum(pDgABC(:, sB, :)));
end

% normalise the values (not strictly needed though)
pSa = pSa ./ sum(pSa);
pSb = pSb ./ sum(pSb);

for i=1:nrDataPoints
    dataPoint = data(i,:);
    
    advA = dataPoint(1);
    advB = dataPoint(2);
    advC = dataPoint(3);
    
    pInterest(advA,:) = pInterest(advA,:) .* pSa;
    pInterest(advB,:) = pInterest(advB,:) .* pSb;
    pInterest(advC,:) = pInterest(advC,:) .* pSb; % using pSb since pSc = pSb
    
    pInterest(advA,:) = pInterest(advA,:) ./ sum(pInterest(advA,:));
    pInterest(advB,:) = pInterest(advB,:) ./ sum(pInterest(advB,:));
    pInterest(advC,:) = pInterest(advC,:) ./ sum(pInterest(advC,:));
    % calc prob(sA)

end

% I think it's workin, because adv 3 has a very low interest and this
% corresponds to the data

pInterest

expected_values = zeros(nrDataPoints,1);
for level=1:nrLevels
    expected_values = expected_values + pInterest(:,level) * level;
end

expected_values
end

function [] = prob322var2()

data = [1 2 3; 2 5 3; 4 7 10; 6 3 4; 6 8 5; 9 3 7; 10 2 4; 7 1 2; 8 7 2; 8 3 6; 8 6 4; 4 3 9; 5 4 1; 9 5 1; 6 7 8; 4 9 7; 10 8 6; 5 4 3; 6 3 2; 1 4 2];

nrDataPoints = 10;
nrLevels = 5;
pInterest = ones(nrDataPoints, nrLevels) .* 0.2;

pDgABC = zeros(nrLevels, nrLevels, nrLevels);

% compute the conditional probability table p(d | a b c )
for sA = 1:nrLevels
    for sB = 1:nrLevels
        for sC = 1:nrLevels
            pDgABC(sA, sB, sC) = exp(sA - max(sB, sC));
        end
    end
end

for i=1:nrDataPoints
    dataPoint = data(i,:);
    
    advA = dataPoint(1);
    advB = dataPoint(2);
    advC = dataPoint(3);
    
    % calculate the joint distribution p(a,b,c) fom p(a) p(b) p(c)
    pABC = zeros(nrLevels,nrLevels, nrLevels);
    for i=1:nrLevels
        for j=1:nrLevels
            for k=1:nrLevels
                pABC(i,j,k) = pInterest(advA,i) * pInterest(advB,j) * pInterest(advC,k);
            end
        end
    end
    
    % update the joint distribution and maginalise over all variables in
    % turn
    pABC = pABC .* pDgABC;
    pInterest(advA,:) = sum(sum(pABC(:,:,:),3),2);
    pInterest(advB,:) = sum(sum(pABC(:,:,:),1),3);
    pInterest(advC,:) = sum(sum(pABC(:,:,:),1),2);
    
    % normalise the evidence to get a probability distribution
    pInterest(advA,:) = pInterest(advA,:) ./ sum(pInterest(advA,:));
    pInterest(advB,:) = pInterest(advB,:) ./ sum(pInterest(advB,:));
    pInterest(advC,:) = pInterest(advC,:) ./ sum(pInterest(advC,:));

end

pInterest

% compute the expected values
expected_values = zeros(nrDataPoints,1);
for level=1:nrLevels
    expected_values = expected_values + pInterest(:,level) * level;
end

expected_values
end


function xclean = extra1()

load('noisyface.mat')

[h w] = size(xnoisy);

nrPixels = w * h;

xclean = xnoisy;

noChangeTimes = 0;
iteration = 1;
module_size = 10000;
    
while (noChangeTimes < 5 * nrPixels)

    % get me a random pixel to update
    nextPixelI = floor(rand * h) + 1;
    nextPixelJ = floor(rand * w) + 1;

    % clone the image file and flip the pixel
    flipped_pixel_img = xclean;
    flipped_pixel_img(nextPixelI, nextPixelJ) = 1 - flipped_pixel_img(nextPixelI, nextPixelJ);

    % calculate the objective functions
    valUnchanged = objective_func(xclean, xnoisy);
    valFlipped = objective_func(flipped_pixel_img, xnoisy);

    % compare the values of the objective function and update if necessary
    if(valFlipped > valUnchanged)
       % pixel was flipped 
       xclean = flipped_pixel_img;
       noChangeTimes = 0;
    else
       % pixel not flipped
       noChangeTimes = noChangeTimes + 1;
    end


    if(mod(iteration,module_size) == 0)
        iteration
        noChangeTimes
        valUnchanged
        index =  sprintf('%04d', iteration / module_size)
        imwrite(xclean,strcat('images/xclean', index,  '.png'));
    end
    iteration = iteration + 1;
    
end


end

function val = objective_func(image, original_noisy)

val = 0;
neigh_w = 10;

% create copies of the original image slided to the right and down
right_slided = image(:,2:end);
down_slided = image(2:end,:);

% chop 1 row/column of the original image and create copies
right_chopped = image(:,1:end-1);
down_chopped = image(1:end-1,:);

% compate the chopped version with the slided ones
right_eq = right_slided == right_chopped;
down_eq = down_slided == down_chopped;

% calculate the value of the objective function
val =  val + neigh_w  * 2 * (sum(sum(right_eq)) + sum(sum(down_eq)));
val = val + 2 * sum(sum(original_noisy .* image));


end