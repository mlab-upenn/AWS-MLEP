clear;clc;

% Init Parameters
popsize=10;
dimension=3;
stringlength=8;
x_bound=[-2,3;-2,4;-1,1];
pm=0.05;

% Encoding
pop=encoding1(popsize,stringlength,dimension);
% Decoding
popDec=decoding1(pop,stringlength,dimension,x_bound);
% Evaluate
pop = evalFitMlep(pop,popDec,stringlength,dimension);

[choice_number,choice_k]=max(pop(:,stringlength*dimension+1));
choice=pop(choice_k,:);

for i=1:30 
    % Cross Over
    new_pop=cross_over1(pop,popsize,stringlength,dimension);
    % Mutation
    pop=mutation1(new_pop,stringlength,dimension,pm);
    % Decoding
    popDec=decoding1(pop,stringlength,dimension,x_bound);
    % Evaluate
    pop = evalFit(pop, popDec,stringlength,dimension);
    [number,k]=max(pop(:,stringlength*dimension+1));
    
    % Replace Best Choice
    if choice_number<number
        choice_number=number;
        choice_k=k;
        choice=pop(choice_k,:);
    end
    
    % Selection
    pop = selection1(pop,popsize,stringlength,dimension);
    [number,m] = min(pop(:,stringlength*dimension+1));
    pop(m,:) = choice;
end

% Final Results 
[value,x] = result_guo(pop,stringlength,dimension,x_bound)
