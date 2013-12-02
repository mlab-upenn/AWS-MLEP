function [value,x]=result_guo(pop,stringlength,dimension,x_bound)
[value,k]=max(pop(:,stringlength*dimension+1));
temp=2.^(stringlength-1:-1:0)/(2^stringlength-1);
for i=1:dimension
    bound(i)=x_bound(i,2)-x_bound(i,1);
end
for j=1:dimension
    m(:,j)=pop(k,stringlength*(j-1)+1:stringlength*j);
end
x=temp*m;
x=x.*bound+x_bound(:,1)';