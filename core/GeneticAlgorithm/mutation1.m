function new_pop=mutation1(new_pop,stringlength,dimension,pm)
new_popsize=size(new_pop,1);
for i=1:new_popsize
    if rand<pm mpoint=round(rand(1,dimension)*(stringlength-1))+1;
        for j=1:dimension
            new_pop(i,(j-1)*stringlength+mpoint(j))=1-new_pop(i,(j-1)*stringlength+mpoint(j));
        end
    end
end