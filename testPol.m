function [fracWon] = testPol(sa, pi, p, toWin)

totReward = 0;
for i = 1:100
    [reward, ~] = playGame(sa, pi, p, toWin);
    totReward = totReward + reward;
end

fracWon = totReward/(toWin*100);

end