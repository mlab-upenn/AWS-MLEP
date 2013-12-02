function new_pop=cross_over1(pop,popsize,stringlength,dimension)
match=round(rand(1,popsize)*(popsize-1))+1;
for i=1:popsize
    [child1,child2]=cross_running1(pop(i,:),pop(match(i),:),stringlength,dimension);
    new_pop(2*i-1:2*i,:)=[child1;child2];
end
