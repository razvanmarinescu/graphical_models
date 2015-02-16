clear all; clc; close all;
load('printer.mat');
import brml.*

Fuse = 1;
Drum = 2;
Toner = 3;
Paper = 4;
Roller = 5;
Burning = 6;
Quality = 7;
Wrinkled = 8;
MultiplePages = 9;
PaperJam = 10;

fa=1; 
tr=2;

%Part 1
temppot = array(Fuse);
temppot.table(fa) = sum(x(Fuse,:) == fa)/length(x(Fuse,:));
temppot.table(tr) = 1 - temppot.table(fa);
pot{Fuse} = temppot;

temppot = array(Drum);
temppot.table(fa) = sum(x(Drum,:) == fa)/length(x(Drum,:));
temppot.table(tr) = 1 - temppot.table(fa);
pot{Drum} = temppot;

temppot = array(Toner);
temppot.table(fa) = sum(x(Toner,:) == fa)/length(x(Toner,:));
temppot.table(tr) = 1 - temppot.table(fa);
pot{Toner} = temppot;

temppot = array(Paper);
temppot.table(fa) = sum(x(Paper,:) == fa)/length(x(Paper,:));
temppot.table(tr) = 1 - temppot.table(fa);
pot{Paper} = temppot;

temppot = array(Roller);
temppot.table(fa) = sum(x(Roller,:) == fa)/length(x(Roller,:));
temppot.table(tr) = 1 - temppot.table(fa);
pot{Roller} = temppot;

temppot = array([Burning Fuse]);
temppot.table(fa,fa) = sum(x(Burning,x(Fuse,:) == fa)==fa)/length(find(x(Fuse,:) == fa));
temppot.table(fa,tr) = sum(x(Burning,x(Fuse,:) == tr)==fa)/length(find(x(Fuse,:) == tr));
temppot.table(tr,:) = 1 - temppot.table(fa,:);
pot{Burning} = condpot(temppot,Burning,Fuse);

temppot = array([Quality Drum Toner Paper]);
temppot.table(fa,fa,fa,fa) = sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == fa)==fa)/length(find((x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == fa)==fa));
temppot.table(fa,fa,fa,tr) = sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == tr)==fa)/length(find((x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == tr)==fa));
temppot.table(fa,fa,tr,fa) = sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == fa)==fa)/length(find((x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == fa)==fa));
temppot.table(fa,fa,tr,tr) = sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == tr)==fa)/length(find((x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == tr)==fa));
temppot.table(fa,tr,fa,fa) = sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == fa)==fa)/length(find((x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == fa)==fa));
temppot.table(fa,tr,fa,tr) = sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == tr)==fa)/length(find((x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == tr)==fa));
temppot.table(fa,tr,tr,fa) = sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == fa)==fa)/length(find((x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == fa)==fa));
temppot.table(fa,tr,tr,tr) = sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == tr)==fa)/length(find((x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == tr)==fa));
temppot.table(tr,:,:,:) = 1 - temppot.table(fa,:,:,:);
pot{Quality} = condpot(temppot,Quality,[Drum Toner Paper]);

temppot = array([Wrinkled Fuse Paper]);
temppot.table(fa,fa,fa) = sum(x(Wrinkled,x(Fuse,:) == fa & x(Paper,:) == fa)==fa)/length(find((x(Fuse,:) == fa & x(Paper,:) == fa)==fa));
temppot.table(fa,fa,tr) = sum(x(Wrinkled,x(Fuse,:) == fa & x(Paper,:) == tr)==fa)/length(find((x(Fuse,:) == fa & x(Paper,:) == tr)==fa));
temppot.table(fa,tr,fa) = sum(x(Wrinkled,x(Fuse,:) == tr & x(Paper,:) == fa)==fa)/length(find((x(Fuse,:) == tr & x(Paper,:) == fa)==fa));
temppot.table(fa,tr,tr) = sum(x(Wrinkled,x(Fuse,:) == tr & x(Paper,:) == tr)==fa)/length(find((x(Fuse,:) == tr & x(Paper,:) == tr)==fa));
temppot.table(tr,:,:) = 1 - temppot.table(fa,:,:);
pot{Wrinkled} = condpot(temppot,Wrinkled,[Fuse Paper]);

temppot = array([MultiplePages Paper Roller]);
temppot.table(fa,fa,fa) = sum(x(MultiplePages,x(Paper,:) == fa & x(Roller,:) == fa)==fa)/length(find((x(Paper,:) == fa & x(Roller,:) == fa)==fa));
temppot.table(fa,fa,tr) = sum(x(MultiplePages,x(Paper,:) == fa & x(Roller,:) == tr)==fa)/length(find((x(Paper,:) == fa & x(Roller,:) == tr)==fa));
temppot.table(fa,tr,fa) = sum(x(MultiplePages,x(Paper,:) == tr & x(Roller,:) == fa)==fa)/length(find((x(Paper,:) == tr & x(Roller,:) == fa)==fa));
temppot.table(fa,tr,tr) = sum(x(MultiplePages,x(Paper,:) == tr & x(Roller,:) == tr)==fa)/length(find((x(Paper,:) == tr & x(Roller,:) == tr)==fa));
temppot.table(tr,:,:) = 1 - temppot.table(fa,:,:);
pot{MultiplePages} = condpot(temppot,MultiplePages,[Paper Roller]);

temppot = array([PaperJam Fuse Roller]);
temppot.table(fa,fa,fa) = sum(x(PaperJam,x(Fuse,:) == fa & x(Roller,:) == fa)==fa)/length(find((x(Fuse,:) == fa & x(Roller,:) == fa)==fa));
temppot.table(fa,fa,tr) = sum(x(PaperJam,x(Fuse,:) == fa & x(Roller,:) == tr)==fa)/length(find((x(Fuse,:) == fa & x(Roller,:) == tr)==fa));
temppot.table(fa,tr,fa) = sum(x(PaperJam,x(Fuse,:) == tr & x(Roller,:) == fa)==fa)/length(find((x(Fuse,:) == tr & x(Roller,:) == fa)==fa));
temppot.table(fa,tr,tr) = sum(x(PaperJam,x(Fuse,:) == tr & x(Roller,:) == tr)==fa)/length(find((x(Fuse,:) == tr & x(Roller,:) == tr)==fa));
temppot.table(tr,:,:) = 1 - temppot.table(fa,:,:);
pot{PaperJam} = condpot(temppot,PaperJam,[Fuse Roller]);

%Part 2
Jointpot = multpots(pot);
FuseML = setpot(sumpot(Jointpot,[Drum Toner Paper Roller]),[Burning PaperJam Quality Wrinkled MultiplePages],[tr tr fa fa fa]);
FuseML.table = FuseML.table/sum(FuseML.table);
fprintf('The probability that there is a fuse assembly malfunction with ML: %f\n',FuseML.table(tr));

%Part 3
temppot = array(Fuse);
temppot.table(fa) = (1+sum(x(Fuse,:) == fa))/(2+length(x(Fuse,:)));
temppot.table(tr) = 1 - temppot.table(fa);
Bayespot{Fuse} = temppot;

temppot = array(Drum);
temppot.table(fa) = (1+sum(x(Drum,:) == fa))/(2+length(x(Drum,:)));
temppot.table(tr) = 1 - temppot.table(fa);
Bayespot{Drum} = temppot;

temppot = array(Toner);
temppot.table(fa) = (1+sum(x(Toner,:) == fa))/(2+length(x(Toner,:)));
temppot.table(tr) = 1 - temppot.table(fa);
Bayespot{Toner} = temppot;

temppot = array(Paper);
temppot.table(fa) = (1+sum(x(Paper,:) == fa))/(2+length(x(Paper,:)));
temppot.table(tr) = 1 - temppot.table(fa);
Bayespot{Paper} = temppot;

temppot = array(Roller);
temppot.table(fa) = (1+sum(x(Roller,:) == fa))/(2+length(x(Roller,:)));
temppot.table(tr) = 1 - temppot.table(fa);
Bayespot{Roller} = temppot;

temppot = array([Burning Fuse]);
temppot.table(fa,fa) = (1+sum(x(Burning,x(Fuse,:) == fa)==fa))/(2+length(find(x(Fuse,:) == fa)));
temppot.table(fa,tr) = (1+sum(x(Burning,x(Fuse,:) == tr)==fa))/(2+length(find(x(Fuse,:) == tr)));
temppot.table(tr,:) = 1 - temppot.table(fa,:);
Bayespot{Burning} = condpot(temppot,Burning,Fuse);

temppot = array([Quality Drum Toner Paper]);
temppot.table(fa,fa,fa,fa) = (1+sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == fa)==fa))/(2+length(find((x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == fa)==fa)));
temppot.table(fa,fa,fa,tr) = (1+sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == tr)==fa))/(2+length(find((x(Drum,:) == fa & x(Toner,:) == fa & x(Paper,:) == tr)==fa)));
temppot.table(fa,fa,tr,fa) = (1+sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == fa)==fa))/(2+length(find((x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == fa)==fa)));
temppot.table(fa,fa,tr,tr) = (1+sum(x(Quality,x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == tr)==fa))/(2+length(find((x(Drum,:) == fa & x(Toner,:) == tr & x(Paper,:) == tr)==fa)));
temppot.table(fa,tr,fa,fa) = (1+sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == fa)==fa))/(2+length(find((x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == fa)==fa)));
temppot.table(fa,tr,fa,tr) = (1+sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == tr)==fa))/(2+length(find((x(Drum,:) == tr & x(Toner,:) == fa & x(Paper,:) == tr)==fa)));
temppot.table(fa,tr,tr,fa) = (1+sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == fa)==fa))/(2+length(find((x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == fa)==fa)));
temppot.table(fa,tr,tr,tr) = (1+sum(x(Quality,x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == tr)==fa))/(2+length(find((x(Drum,:) == tr & x(Toner,:) == tr & x(Paper,:) == tr)==fa)));
temppot.table(tr,:,:,:) = 1 - temppot.table(fa,:,:,:);
Bayespot{Quality} = condpot(temppot,Quality,[Drum Toner Paper]);

temppot = array([Wrinkled Fuse Paper]);
temppot.table(fa,fa,fa) = (1+sum(x(Wrinkled,x(Fuse,:) == fa & x(Paper,:) == fa)==fa))/(2+length(find((x(Fuse,:) == fa & x(Paper,:) == fa)==fa)));
temppot.table(fa,fa,tr) = (1+sum(x(Wrinkled,x(Fuse,:) == fa & x(Paper,:) == tr)==fa))/(2+length(find((x(Fuse,:) == fa & x(Paper,:) == tr)==fa)));
temppot.table(fa,tr,fa) = (1+sum(x(Wrinkled,x(Fuse,:) == tr & x(Paper,:) == fa)==fa))/(2+length(find((x(Fuse,:) == tr & x(Paper,:) == fa)==fa)));
temppot.table(fa,tr,tr) = (1+sum(x(Wrinkled,x(Fuse,:) == tr & x(Paper,:) == tr)==fa))/(2+length(find((x(Fuse,:) == tr & x(Paper,:) == tr)==fa)));
temppot.table(tr,:,:) = 1 - temppot.table(fa,:,:);
Bayespot{Wrinkled} = condpot(temppot,Wrinkled,[Fuse Paper]);

temppot = array([MultiplePages Paper Roller]);
temppot.table(fa,fa,fa) = (1+sum(x(MultiplePages,x(Paper,:) == fa & x(Roller,:) == fa)==fa))/(2+length(find((x(Paper,:) == fa & x(Roller,:) == fa)==fa)));
temppot.table(fa,fa,tr) = (1+sum(x(MultiplePages,x(Paper,:) == fa & x(Roller,:) == tr)==fa))/(2+length(find((x(Paper,:) == fa & x(Roller,:) == tr)==fa)));
temppot.table(fa,tr,fa) = (1+sum(x(MultiplePages,x(Paper,:) == tr & x(Roller,:) == fa)==fa))/(2+length(find((x(Paper,:) == tr & x(Roller,:) == fa)==fa)));
temppot.table(fa,tr,tr) = (1+sum(x(MultiplePages,x(Paper,:) == tr & x(Roller,:) == tr)==fa))/(2+length(find((x(Paper,:) == tr & x(Roller,:) == tr)==fa)));
temppot.table(tr,:,:) = 1 - temppot.table(fa,:,:);
Bayespot{MultiplePages} = condpot(temppot,MultiplePages,[Paper Roller]);

temppot = array([PaperJam Fuse Roller]);
temppot.table(fa,fa,fa) = (1+sum(x(PaperJam,x(Fuse,:) == fa & x(Roller,:) == fa)==fa))/(2+length(find((x(Fuse,:) == fa & x(Roller,:) == fa)==fa)));
temppot.table(fa,fa,tr) = (1+sum(x(PaperJam,x(Fuse,:) == fa & x(Roller,:) == tr)==fa))/(2+length(find((x(Fuse,:) == fa & x(Roller,:) == tr)==fa)));
temppot.table(fa,tr,fa) = (1+sum(x(PaperJam,x(Fuse,:) == tr & x(Roller,:) == fa)==fa))/(2+length(find((x(Fuse,:) == tr & x(Roller,:) == fa)==fa)));
temppot.table(fa,tr,tr) = (1+sum(x(PaperJam,x(Fuse,:) == tr & x(Roller,:) == tr)==fa))/(2+length(find((x(Fuse,:) == tr & x(Roller,:) == tr)==fa)));
temppot.table(tr,:,:) = 1 - temppot.table(fa,:,:);
Bayespot{PaperJam} = condpot(temppot,PaperJam,[Fuse Roller]);

BayesJointpot = multpots(Bayespot);
FuseBayes = setpot(sumpot(BayesJointpot,[Drum Toner Paper Roller]),[Burning PaperJam Quality Wrinkled MultiplePages],[tr tr fa fa fa]);
FuseBayes.table = FuseBayes.table/sum(FuseBayes.table);
fprintf('The probability that there is a fuse assembly malfunction with Bayesian Learning: %f\n',FuseBayes.table(tr));

%part 4
for i = 1:1:10
    potcond{i} = setpot(Bayespot{i},[Burning PaperJam Quality Wrinkled MultiplePages], [tr tr fa fa fa]);
end
[newpot, ~, ~, ~] = squeezepots(potcond);
[jtpotcond, jtsepcond, infostructcond]=jtree(newpot);
[jtpotfullabsorbcond, jtsepfullabsorbcond, Zcond]=absorption(jtpotcond,jtsepcond,infostructcond,'max');
fprintf('After inspection of the tables of jtpotfullabsorbcond and jtsepfullabsorbcond, the most likely state is that there is a fuse assembly malfunction and no other problems\n');

maxPot = multpots([jtpotfullabsorbcond{1}, jtpotfullabsorbcond{2}]);
[maxElem2, maxIndex2] = max(maxPot.table(:))
[fuseState,drumState,tonerState,paperState,rollerState] = ind2sub(size(maxPot.table),maxIndex2)

%part 5
for i = 1:1:10
    potcond2{i} = setpot(Bayespot{i},[Burning PaperJam], [tr tr]);
end
[newpot2, ~, ~, ~] = squeezepots(potcond2);
[jtpotcond2, jtsepcond2, infostructcond2]=jtree(newpot2);
for i = 1:1:length(jtpotcond2)
    jtpotcond2{i} = sumpot(jtpotcond2{i},[6 7 8]);
end
jtpotcond2{1} = multpots([jtpotcond2{1} jtpotcond2{2} jtpotcond2{3}]);
jtpotcond2{2} = jtpotcond2{4};
jtpotcond2 = jtpotcond2([1 2]);
jtsepcond2 = jtsepcond2(1);
infostructcond2.cliquevariables{1} = [1 4 5];
infostructcond2.cliquevariables{2} = [2 3 4];
infostructcond2.cliquevariables = infostructcond2.cliquevariables([1 2]);
infostructcond2.separator = infostructcond2.separator([3]);
infostructcond2.cliquetree = sparse([0 1;1 0]);
infostructcond2.sepind = sparse([1 2], [2 1], [1 1]);
infostructcond2.EliminationSchedule = [1 2];
[jtpotfullabsorbcond2, jtsepfullabsorbcond2, Zcond2]=absorption(jtpotcond2,jtsepcond2,infostructcond2,'max');
fprintf('After inspection of the tables of jtpotfullabsorbcond2 and jtsepfullabsorbcond2, the most likely state is that there is a fuse assembly malfunction and poor paper quality and no other problems\n');



