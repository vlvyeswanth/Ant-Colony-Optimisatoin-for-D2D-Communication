K=25;
A=generateants(N,K);
P=zeros(K,10);
BESTALLOT=[];
BESTVAL=[];
for iter=1:1:100
    COL=[];
for i=1:1:N
c=J(A{i},SINR);
P=0.9*P+A{i}*(1/c);
COL=[COL 1/(c+eps)];
end
[u,v]=max(COL);
BESTALLOT{iter}=A{v};
BESTVAL=[BESTVAL COL(v)];
%Generate next set of ants
for i=1:1:N
    M=zeros(K,10);
for j=1:1:K
    [a,b]=max(P(j,:));
    M(j,b)=1;
end
A{i}=M;
end
end
