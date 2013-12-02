function selected=selection(pop,popsize,stringlength,dimension)
popsize_new=size(pop,1);
r=rand(1,popsize);
fitness=pop(:,dimension*stringlength+1);
fitness=fitness/sum(fitness);
fitness=cumsum(fitness);
for i=1:popsize
    for j=1:popsize_new
        if r(i)<=fitness(j)
            selected(i,:)=pop(j,:);
            break;
        end
    end
end
