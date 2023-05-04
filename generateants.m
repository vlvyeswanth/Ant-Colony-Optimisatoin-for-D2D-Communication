function [ANT]=generateants(K,N)
FF=20;
for j=1:1:K
M=zeros(N,FF);
for i=1:1:N
    r=round(rand*(FF-1))+1;
    M(i,r)=1;
end
ANT{j}=M;
end
