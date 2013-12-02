% Main File for GA
% f(x1,x,2,x3) = 6-x1^2-x2^2-x3^2;
clear;clc;

% Initial Population
Npop = 10;              % Population size
Ngene = 8;              % bit-encoding
Nvar = 3;               % Number of variables
Plimit = [-2 -2 -1;...
    3  4  1];    % Limits for variables
pm=0.05;                % Probability of mutation
Nrun = 1000;              % Number of generation

% Original Population
pop = generatePop(Npop,Ngene,Nvar);

% Decode
popDec = binaryDecoder(Ngene, pop, Plimit);

% Calculate Fitness
fitObj = calcFit1(popDec);

% Fittest
[choiceValue,choicePos] = max(fitObj);
choice = pop(choicePos,:);

% Progress
best = zeros(1, Nrun);
ave = zeros(1, Nrun);
worst = zeros(1, Nrun);

% Generations
for i = 1:Nrun
    % Cross Over
    newPop = cross_over(pop,Npop,Ngene,Nvar);
    % Mutate
    pop = mutation(newPop,Ngene,Nvar,pm);
    % Decode
    popDec = binaryDecoder(Ngene, pop, Plimit);
    % Calculate Fitness
    fitObj = calcFit1(popDec);
    % Fittest
    [number,pos] = max(fitObj);
    
    % Maximum Value
    if choiceValue < number
        choiceValue = number;
        choicePos = pos;
        choice = pop(choicePos,:);
    end
    
    % Selection
    [pop, fitObj] = selection(pop,fitObj,Npop);
    [~,m]=min(fitObj);
    pop(m,:) = choice;
    
    % Save progress
    best(i) = max(fitObj);
    ave(i) = mean(fitObj); 
    worst(i) = min(fitObj);
end

[v,k] = max(fitObj);
% Decode
popDec = binaryDecoder(Ngene, pop, Plimit);
% Calculate Fitness
popDec(k,:)
    

% Plot Progress
x = 1:Nrun;
plot(x, best, 'r', x, ave, 'b', x, worst, 'c');
legend('best', 'ave', 'worst');

