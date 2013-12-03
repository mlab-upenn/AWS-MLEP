function [child1,child2]=cross_running1(parent1,parent2,stringlength,dimension)
cpoint=round((stringlength-1)*rand(1,dimension))+1;
for j=1:dimension
    child1((j-1)*stringlength+1:j*stringlength)=[parent1((j-1)*stringlength+1:(j-1)*stringlength+cpoint(j))...
        parent2((j-1)*stringlength+cpoint(j)+1:j*stringlength)];
    child2((j-1)*stringlength+1:j*stringlength)=[parent2((j-1)*stringlength+1:(j-1)*stringlength+cpoint(j))...
        parent1((j-1)*stringlength+cpoint(j)+1:j*stringlength)];
end