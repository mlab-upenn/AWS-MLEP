function pop = evalFit(pop, popDec, stringlength, dimension)

for i = 1:size(popDec, 1)
    pop(i,dimension*stringlength+1) = funname(popDec(i,:));
end