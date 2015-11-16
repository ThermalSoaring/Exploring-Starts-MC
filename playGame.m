function [reward, statesPassed] = playGame(sa, pi, p, toWin)
% sa holds the initial state
% sa(1) holds initial money
% sa(2) holds initial amount to bet

% pi is our betting policy

% p is how likely we are to win on each flip

% toWin is the amount of money needed to win

% Reward assigned if winning or losing
% Changing the relative weights has unexpected results
rIfWin = toWin;
rIfLoss = -toWin;

% reward is one if win, zero if loss
reward = 0;

% statesPassed holds all the states we pass through during the game
statesPassed(1,:) = sa;

% gameOver is 0 if the game is not over, and 1 otherwise
gameOver = 0;

currState = 1;
while (gameOver == 0) % Keep betting until we win or lose
    
    % Keep track of which state this is, for purposes of storing in sa
    currState = currState + 1;
    
    % Simulate betting episode, following policy
    winFlip = rand(1) < p; % If p = 0.4, we win less often than losing
    
    if (sa(1) == 1 && sa(2) == 1)
       a = [1 2 3]; 
    end 
    
    if (winFlip == 1)
        if (sa(1) + sa(2) == toWin) % We bet the amount to get to 100
            % We won
           reward = rIfWin;
           gameOver = 1;
        else % We gained some money
            sa(1) = sa(1) + sa(2); % update how much money we have        
        end
    else % winFlip == 0 (lost the best)
       if (sa(1) == sa(2)) % We bet everything
           % We lost
           reward = rIfLoss;
           gameOver = 1;
       else % We still have some money
           sa(1) = sa(1) - sa(2); % Update how much money we have
       end
    end    
  
    
    % Choose the amount to bet next time, if the game is not over
    if (gameOver == 0)
       if (rand(1) < 0) % Explore once in a while (currently disabled)
            sa(2) = randi([1 min(sa(1), toWin - sa(1))]);
       else
            sa(2) = pi(sa(1)); % Choose how much to bet, given how much money we have  
       end
                     
       % Add current states to states passed through
       statesPassed(currState,:) = sa;
    end    
    
    
end
