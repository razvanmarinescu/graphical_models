clear all; clc; close all;
import brml.*;
load('soccer.mat');
%Convert struct
for i = 1:20
    teamAces(:,i) = game(i).teamAces;
    teamBruisers(:,i) = game(i).teamBruisers;
    Win(i) = game(i).AcesWin;
end
%Which games did each player play in
for player = 1:20
    Aplayedin{player,1} = ceil(find(teamAces == player)/10);
    Bplayedin{player,1} = ceil(find(teamBruisers == player)/10);
end

RandIterations = 200;
BestTotalProbability = 0;
Abest = [];
Bbest = [];
for randiter = 1:RandIterations
    NumIterations = 1000;
    %Skill levels initially all zero
    A = randi(5,20,1)-3;%zeros(20,1);
    B = randi(5,20,1)-3;%zeros(20,1);
    for iteration = 1:NumIterations
        for player = 1:20
            MaxProbability = 0;
            BestSkill = A(player);
            for skill = -2:1:2
                Probability = 1;
                for gameplayed = Aplayedin{player}'
                    Asum = sum(A(teamAces(:,gameplayed))) - A(player) + skill;
                    Bsum = sum(B(teamBruisers(:,gameplayed)));
                    Probability = Probability * (1/(1+exp(Win(gameplayed)*(-Asum+Bsum))));
                end
                if(MaxProbability < Probability)
                    MaxProbability = Probability;
                    BestSkill = skill;
                end
            end
            A(player) = BestSkill;

            MaxProbability = 0;
            BestSkill = B(player);
            for skill = -2:1:2
                Probability = 1;
                for gameplayed = Bplayedin{player}'
                    Asum = sum(A(teamAces(:,gameplayed)));
                    Bsum = sum(B(teamBruisers(:,gameplayed))) - B(player) + skill;
                    Probability = Probability * (1/(1+exp(Win(gameplayed)*(-Asum+Bsum))));
                end
                if(MaxProbability < Probability)
                    MaxProbability = Probability;
                    BestSkill = skill;
                end
            end
            B(player) = BestSkill;
        end
        Probability = 1;
        for gameplayed = 1:20
            Asum = sum(A(teamAces(:,gameplayed)));
            Bsum = sum(B(teamBruisers(:,gameplayed)));
            Probability = Probability * (1/(1+exp(Win(gameplayed)*(-Asum+Bsum))));
        end
        TotalProbability = Probability;
        if(iteration > 1 && TotalProbability == PrevTotalProbability)
            break;
        end
        PrevTotalProbability = TotalProbability;
    end
    if(BestTotalProbability < TotalProbability)
        Abest = A;
        Bbest = B;
        BestTotalProbability = TotalProbability
    end
end

awrafa = 1;

