function Framework()
%% Idea
% Demonstrate exploring starts Monte Carlo to solve a gambling problem
% You are given some amount of money between $1 and $99.
% You bet some amount of money and flip a coin. If it comes heads up, you
% win the amount you bet. Otherwise, you lose the amount you bet.
% Ex. You bet have $60 and bet $15 dollars. The coin lands tails, and now
% you have $45. If the coin had landed heads, you would have $75.

% You can bet up to the total amount you have, and you can't make a bet so
% that if you won you would have more than $100. (Bet_max = min(your money,
% 100 - your money)).

% We are NOT told that the coin is weighted to land with probability p on
% a heads. Perhaps p = 0.4 (the coin is weighted against you).
% If we knew this probability, we could use DP methods (Bellman backup).

% The game ends when you have $100 or $0. (episodic task)
% What is the optimal betting strategy to end the game with $100 with as
% high probability as possible?

%% If we were told what state we started in
% We could use an epsilon soft algorithm. This is probably more realistic
% than the assumption of exploring starts. Further, we can use our policy
% to restrict the starting states to a much smaller number.

%% Why (was) there assymetry in the results?
% This was because MATLAB's max command returns the first index of the
% maximum value. This biased stuff towards 1.

%% Takeaway ideas
% Beware of how you deal with landing on the same state twice

% The lookup table approach to generating state-action pair values is
% computationally intensive. (Could we calculate this values from a smaller
% vector of parameters? Think neural networks..)

% Monte Carlo takes MANY iterations to get a VAGUELY correct answer

% Exploring starts is fairly unrealistic, and computationally intensive

% Changing the reward if win to the reward if loss ratio is interesting
% and causes the results to change unpredictably

% Be sure to reset policy between averaging runs
% Otherwise, later rusn depend on previous ones (averaging won't help)

% Restarting policy from scratch too many times is bad, because then you
% essentially are averaging the starting values.

% One additional note - the number of times we visit each state is not very
% uniform (we get funelled into winning and losing states).
% We could try choosing the least visited states.
% This is probably because of the greedy nature of the algorithm (once you
% you win somewhere you keep doing the same thing and it takes a REALLY
% long time to get back down to where you were).
% We could try balancing reward and punishment.
%%
% Dollars to win
toWin = 100;

%% Initialization

% Set up state action pair estimates (arbitary initial values)
% There are less than 99 states x 99 actions.  
% We need to assign some values to these actions.
% --(actual setup code is below)--
% Rows are states, columns are actions ($ have, $ to bet)
% Ex. If you have 50 dollars and you choose to bet 15 dollars, the value of
% this action state pair is in Q(50,15).
% (note that Q is pretty big even for this small problem!)

% Set up policy (arbitary initial values)
% Policy is function from states to actions
% So, for each state we need to choose how much money to bet.
% Index in row vector is state (how much money), and value is how much
% money is bet. (Ex. if the 30th entry is 7, that means bet $7 if you have
% $30 to begin with).
% --(actual setup code is below)--

% Set up the weighting of the coin
% This is how likely we are to win each time we flip the coin
p = 0.4;

% Keep track of how many times we've visited each state action pair
numTimesVisited = zeros(toWin -1 , toWin -1 );

%% Learning loop

    % Set number of games to play
    numIter = 10000;
    
    % Reset Q and pi here
    initVal = -3.14;
    Q = initVal*ones(toWin-1,toWin-1); 
    for i = 1:size(Q,1) % Go through rows
        for j = 1: size(Q,2) % Go through columns
            if (i < j) % Can't bet more money than you have
               Q(i,j) = -1000; 
            end

            if (i + j > toWin) % Can't get more than 100 dollars
                Q(i,j) = -1000;
            end
        end
    end
           
    % Set up policy again
    % Let's set up it up randomly to avoid any biasing issues
    pi = ones(toWin-1, 1); 
    for i = 1: length(pi)
        toBet = min(i, toWin -i);
        pi(i) = randi([1 toBet],1);
    end
    
    for i = 1:numIter
        % Set initial state action pair
        % This could be any starting state - we are using "exploring starts"
        initState = randi([1 toWin-1]);          % Set initial amount of money
        initAction = randi([1 min(initState, toWin - initState)]);  % Set initial bet
        sa = [initState initAction];
               
        % Play one game
        % Returns reward obtained and the states passed through
        [reward, statesPassed] = playGame(sa, pi, p, toWin);
  
        % Update Q estimates and make pi greedy
        [Q, pi, numTimesVisited] = updateQpi(statesPassed, numTimesVisited, reward, Q, pi, toWin); 
        
       i % Print which game we're on
    end
   
    bar(pi);

   %figure
   %bar(wonRecord)


end