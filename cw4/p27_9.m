function p27_9()
  load('soccer.mat')
  games = game; % rename variable to games
  
  [~, G] = size(game); % nr of games
  P=20; % nr of players
  L=5; % nr of levels
  pA=ones(P,L) .* 1/L;
  pB=ones(P,L) .* 1/L;
    
  iterations = 200;
  
  for i=1:iterations
    i
    % for each player go through all the games in which he took part and update
    % p(a_i)
    for playerA=1:P
      for g=1:G % for each game
        if (ismember(playerA, game(g).teamAces))
          pA(playerA,:) = pA(playerA,:) .* calcAbilityLik(games(g), playerA, pA, pB, 'A');
        end
      end
      % normalise pA
      pA(playerA,:) = pA(playerA,:) ./ sum(pA(playerA,:));
    end
    % do the same for players in team B
    for playerB=1:P
      for g=1:G  % for each game
        if (ismember(playerB, game(g).teamBruisers))
          pB(playerB,:) = pB(playerB,:) .* calcAbilityLik(games(g), playerB, pA, pB, 'B');
        end
      end
      % normalise pB
      pB(playerB,:) = pB(playerB,:) ./ sum(pB(playerB,:));
    end
  end
  
abScores = [2,1,0,-1,-2]';
% expected ability for each player
expAbilA = pA * abScores;
expAbilB = pB * abScores;

[bestScoresA, bestPlayersA] = sort(expAbilA, 'descend');
[bestScoresB, bestPlayersB] = sort(expAbilB, 'descend');

best10PlayersA = bestPlayersA(1:10)
best10PlayersB = bestPlayersB(1:10)

end

% calculates ability likelihood p(a_i | Aces, a_{\i}, b, t^a, t^b)
function abilLike =  calcAbilityLik(game, player, pA, pB, team)
abScores = [2,1,0,-1,-2]';
[P,L] = size(pA);
abilLike = zeros(1,L);
if strcmp(team, 'A')
  for l=1:L
    sum = 0;
    pA2 = pA;
    pA2(player,:) = zeros(1,L);
    pA2(player,l) = 1;
    for i=1:10
      sum = sum + (pA2(game.teamAces(i),:) - pB(game.teamBruisers(i),:)) * abScores;
    end
    if(game.AcesWin == 1)
      abilLike(l) = 1/(1+exp(-sum));
    else
      % Aces lost
      abilLike(l) = 1 - 1/(1+exp(-sum));
    end
  end
end

if strcmp(team, 'B')
  for l=1:L
    sum = 0;
    pB2 = pB;
    pB2(player,:) = zeros(1,L);
    pB2(player,l) = 1;
    for i=1:10
      sum = sum + (pA(game.teamAces(i),:) - pB2(game.teamBruisers(i),:)) * abScores;
    end
    if(game.AcesWin == 1)
      abilLike(l) = 1/(1+exp(-sum));
    else
      % Aces lost
      abilLike(l) = 1 - 1/(1+exp(-sum));
    end
  end
end

  
end