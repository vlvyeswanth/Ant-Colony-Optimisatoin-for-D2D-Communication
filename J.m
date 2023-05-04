function [res]=J(M,S)
FF=20;
%M is the arbitrary scheduled matrix
%S is the SINR
s=0;
for i=1:1:FF
    [p,q]=find(M(:,i)==1);
for j=1:1:length(p)
    s=s+S(p(j),i);
    end
end
res=s;
