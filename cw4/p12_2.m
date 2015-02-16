function p12_2()
load('dodder2.mat')

[K, ~] = size(x)

maxM = 1;
maxV = -inf;
for M=1:2^K-1
    binM = binary2vector(M,K);
    xTemp = x(binM,:);
    [dimX,~] = size(xTemp);
    A = eye(dimX);
    b = zeros(dimX, 1);
    for t=1:T-1
        A = A + xTemp(:,t) * xTemp(:,t)' / sigma2(t+1);
        b = b + y(t+1) * xTemp(:,t) / sigma2(t+1); 
    end
    
    value = b' * inv(A) * b - log(det(A))
    if maxV < value
       maxV = value;
       maxM = M;
    end
    
end

maxM
maxV

end

function out = binary2vector(data,nBits)
% converts a number into binary, where nBits is the length of the 
% desired binary representation   
    powOf2 = 2.^[0:nBits-1];

    %# do a tiny bit of error-checking
    if data > sum(powOf2)
       error('not enough bits to represent the data')
    end

    out = false(1,nBits);
    ct = nBits;

    while data>0
        if data >= powOf2(ct)
        data = data-powOf2(ct);
        out(ct) = true;
        end
    ct = ct - 1;
    end

end
