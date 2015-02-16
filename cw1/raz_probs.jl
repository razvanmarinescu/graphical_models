using brml

# problem 3.17

A,B,C=1,2,3

pA = PotArray(A, [1//2, 1//2])

pBgA = PotArray([B A], [1//2 1//5; 1//2 1//5; 0 3//5])

pCgB = PotArray([C B], [1//2 1//4 3//8; 1//2 3//4 5//8])

pABC = pCgB * pBgA * pA
pAC = sum(pABC, B)

pA=sum(pAC,C)
pC=sum(pAC,A)

println("pAC-pA*pC=")
println(pAC-pA*pC)



# problem 3.20


w,h,inc=1,2,3
low,high=1,2,3

pInc = PotArray(inc, [8//10 2//10])
pWgI = PotArray([w inc], [7//10 2//10; 3//10 1//10; 0 4//10; 0 3//10])
pHgI = PotArray([h inc], [2//10 0; 8//10 0; 0 3//10; 0 7//10])

pWHI = pWgI * pHgI * pInc
pWH = sum(pWHI, inc)

pW = sum(pWH, h)
pH = sum(pWH, w)

println("pWH - pW*pH= should not be zero")
pWH - pW*pH

pWHgI = pWHI / pInc

println("pWHgI - pWgI*pHgI= should be zero")
pWHgI - pWgI*pHgI


# problem 3.22


c12,c13,c23,c32,c31,c21 = 1,2,3,4,5,6
c122, c232 = 1,2
pC12 = PotArray(c12, [0.9 0.1])
pC13 = PotArray(c13, [0.9 0.1])
pC23 = PotArray(c23, [0.9 0.1])
pC32 = PotArray(c32, [0.9 0.1])
pC31 = PotArray(c31, [0.9 0.1])
pC21 = PotArray(c21, [0.9 0.1])

pC232gC23C21C13 = PotArray([c232 c23 c21 c12])


c122, c232, c121323, c232113 = 1,2,3,4

indexC12 = PotArray(c121323, [0 0 0 0 1 1 1 1])

pC121323 = PotArray(c121323, [0.9^3 0.9^2*0.1 0.9^2*0.1 0.9*0.1^2 0.9^2*0.1 0.9*0.1^2 0.9*0.1^2 0.1^3])
pC232113 = PotArray(c232113, [0.9^3 0.9^2*0.1 0.9^2*0.1 0.9*0.1^2 0.9^2*0.1 0.9*0.1^2 0.9*0.1^2 0.1^3])

pC122gC121323 = PotArray([c122 c121323], [1 1 1 0 0 0 0 0; 0 0 0 1 1 1 1 1])
pC232gC232113 = PotArray([c232 c232113], [1 1 1 0 0 0 0 0; 0 0 0 1 1 1 1 1])

pC122 = PotArray(c122, [0; 1])
pC232 = PotArray(c232, [1; 0])

lamC122 = sum(pC122 * pC122gC121323, c122)
lamC232 = sum(pC232 * pC232gC232113, c232)

p1C121323 = lamC122 * pC121323
p1C232113 = lamC232 * pC232113

p1C12 = p1C121323


# prob 3.15

low, high, normal = 1,2,3
E,O,I,R,B = 1,2,3,4,5

pE = PotArray(E, [2//10 8//10])
pOgE = PotArray([O E], [9//10 5//100; 1//10 95//100])


tabIgOE=zeros(2,2,2)
tabIgOE[low, low, low]=9//10
tabIgOE[low, low, high]=1//10
tabIgOE[low, high, low]=1//10
tabIgOE[low, high, high]=1//100

tabIgOE[high, low, low]=1//10
tabIgOE[high, low, high]=9//10
tabIgOE[high, high, low]=9//10
tabIgOE[high, high, high]=99//100

pIgOE = PotArray([I O E], tabIgOE)


tabRgIE=zeros(2,2,2)
tabRgIE[:, low, low]=[9//10; 1//10]
tabRgIE[:, low, high]=[1//10; 9//10]
tabRgIE[:, high, low]=[1//10; 9//10]
tabRgIE[:, high, high]=[1//100; 99//100]

pRgIE = PotArray([R I E], tabRgIE)


pBgO = PotArray([B O], [9//10 1//10; 1//10 4//10; 0//10 5//10])

pAll = pBgO * pRgIE * pIgOE * pOgE * pE

pIRB = sum(pAll, [O E])

pRB = sum(pIBR, I)

pIgRB = pIBR / pRB




# 3.4

tr, fa = 1, 2
A, T, L, B, X, D, E, S = 1,2,3,4,5,6,7,8

pA = PotArray([A], [0.01 0.99])

#pS = PotArray([S], [0.5 0.5])
pS = PotArray([S], [0 1])

pTgA = PotArray([T A], [0.05 0.01; 0.95 0.99])
pLgS = PotArray([L S], [0.1 0.01; 0.9 0.99])
pBgS = PotArray([B S], [0.6 0.3; 0.4 0.7])
pXgE = PotArray([X E], [0.98 0.05; 0.02 0.95])

tabDgEB = zeros(2,2,2)
tabDgEB[:, tr, tr] = [0.9; 0.1]
tabDgEB[:, tr, fa] = [0.7; 0.3]
tabDgEB[:, fa, tr] = [0.8; 0.2]
tabDgEB[:, fa, fa] = [0.1; 0.9]

pDgEB = PotArray([D E B ], tabDgEB)

tabEgTL = zeros(2,2,2)
tabEgTL[:, tr, tr] = [1; 0]
tabEgTL[:, tr, fa] = [1; 0]
tabEgTL[:, fa, tr] = [1; 0]
tabEgTL[:, fa, fa] = [0; 1]

pEgTL = PotArray([E T L], tabEgTL)

pAll = pXgE * pDgEB * pEgTL * pTgA * pLgS * pBgS * pA * pS


pT = sum(pAll, [A E L B X S D])
pL = sum(pAll, [A T E B X S D ])
pB = sum(pAll, [A T E X S D L])
pE = sum(pAll, [A T B X S D L])
pX = sum(pAll, [A T E B S D L])
pD = sum(pAll, [A T E B X S L])

pLgS = ()














