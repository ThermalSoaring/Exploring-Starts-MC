function [Q, pi, numTimesVisited] = updateQpi(statesPassed, numTimesVisited, reward, Q, pi, toWin)

% Determine the states passed through
% statesPassed makes a list of all the states passed through, but some
% states are likely entered more than once (especially with the initial
% policy of betting 1 in each state)
% We want to just find the unique states.
statesPassed = unique(statesPassed,'rows');

% Now we update the average reward obtained when we've passed through
% states
for i = 1:size(statesPassed,1)
    passedState = statesPassed(i,:);
    
    % Increment the number of times we've visited the current state
    numTimesVisited(passedState(1), passedState(2)) =  numTimesVisited(passedState(1), passedState(2)) + 1;
    numCurr =  numTimesVisited(passedState(1), passedState(2));
    
    % Take a weighted average based on past and current experience on how
    % good the state action pair are (average reward)  
    Q(passedState(1), passedState(2)) =...
    Q(passedState(1), passedState(2))*(numCurr - 1)/numCurr + reward*1/numCurr;    
end

% Now we need to make pi greedy with respect to our new estimates
% For each state, we need to choose how much to bet
for i = 1:size(statesPassed,1)
    passedState = statesPassed(i,:);
    
     % This picks the first maximum value
     % This gives a bias towards betting 1
     % We want to pick a RANDOM maximum value
    %[~, whichAction] = max(Q(passedState(1),:));
    % pi(passedState(1)) = whichAction;
    
    % This picks a RANDOM maximum value action
    currQVals = Q(passedState(1),:);
    bestCurrQ = max(currQVals);
    whichActionVect = find(currQVals == bestCurrQ);
    if (length(whichActionVect) < 1) % Check we have data to sample
        a = [1 2 3]; % Place for breakpoint 
    end
    whichAction = whichActionVect(randi(numel(whichActionVect)));
    pi(passedState(1)) = whichAction;
    
     % Checks if we are betting more money than we have
     if (pi(passedState(1)) > passedState(1) || pi(passedState(1)) + passedState(1) >  toWin)
         a = [1 2 3]; % Place for breakpoint
     end
end

