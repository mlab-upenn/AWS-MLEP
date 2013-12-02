function popDec=decoding1(pop,stringlength,dimension,x_bound)
popsize=size(pop,1);
temp=2.^(stringlength-1:-1:0)/(2^stringlength-1);
for i=1:dimension
    bound(i)=x_bound(i,2)-x_bound(i,1);
end

popDec = zeros(popsize, dimension);
for i=1:popsize
    for j=1:dimension
        m(:,j)=pop(i,stringlength*(j-1)+1:stringlength*j);
    end
    x=temp*m;
    x=x.*bound+x_bound(:,1)';
    popDec(i,:) = x;
end