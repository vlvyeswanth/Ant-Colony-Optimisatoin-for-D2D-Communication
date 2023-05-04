clear all;clc;close all;
hold off;
N = 50; %no.of pairs
area=100;
FF=20;
Pd= 0.01; % -20dB
N0=0.001; % -174dBm/Hz=30dB....
% Generating random positions
xValues = uint8(rand(1,N)*area);
yValues = uint8(rand(1,N)*area);
xdValues = uint8(rand(1,N)*area);
ydValues = uint8(rand(1,N)*area);
rt = scatter(yValues, xValues, '*');
axis([0 area 0 area]);
step=3;
%% positions of D2D pairs at "t" time intervals
for t=1:1:4
    yt = double(ydValues)-double(yValues);
    xt = double(xdValues)-double(xValues); 
    x = zeros(1,N);
    y = zeros(1,N);
    for i=1:N
        if(xt(i) == 0)
            y(i) = double(yValues(i))+  sign(yt(i)) * step;
        else
            m = yt(i)./xt(i);
            sine = m./sqrt(1+m.^2);
            cosine = 1./sqrt(1+m.^2);
            x(i) = double(xValues(i)) +cosine.*sign(xt(i))*step;
            y(i) = double(yValues(i)) +(abs(sine).*sign(yt(i)))*step;
        end
    
    t=t+1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FINDING SINR for D2D pairs
d=zeros(N,N);
freq=2*10^6;
c=3*10^8;
lamda=c/freq;
alpd=(lamda/(4*pi*5))^2;
alpN=0;
for i=1:1:N
    for j=1:1:N
         d(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2); 
        if i==j
            alp(i,j)=alpd;
        else
        alp(i,j)=(lamda/(4*pi*d(i,j)))^2;
        end
    end
end
for i=1:1:N
    for j=1:1:N
    alpN=sum(alp(i,:));
    SINR(i,j)=(Pd*alp(i,j))/(Pd*alpN + N0);
    SINR(i,j)=SINR(i,j)*1000;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACO
K=100;
%Number of ants
A=generateants(K,N);
P=zeros(N,FF);
BESTALLOT=[];
BESTVAL=[];
for iter=1:1:100
    COL=[];
for i=1:1:K
c=J(A{i},1./SINR);

P=P+A{i}*c;
COL=[COL c];
end
[u,v]=max(COL);
BESTALLOT{iter}=A{v};
BESTVAL=[BESTVAL COL(v)];
%Generate next set of ants
for i=1:1:K
    M=zeros(N,FF);
for j=1:1:N
    temp=P(j,:)/sum(P(j,:));
    cs=cumsum(temp);
    [u,v]=find((cs-rand)>0);
    M(j,v(1))=1;
end
A{i}=M;
end
end
BEST=zeros(N,FF);
[g,h]=max(BESTVAL);
BEST=BESTALLOT{h};           
figure;
imagesc(M);
%imgg=(imshow(BEST,'InitialMagnification','fit'));

xlabel("Frequency Blocks");
ylabel("D2D pairs");

t=t+1;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   xValues = x;
    yValues = y;
    d = sqrt(yt.^2 + xt.^2);    
    h = findobj(rt);
    pause(1);
    prevX = get(h,'XData');
    prevY = get(h,'YData');
    set(h,'XData',xValues);
    set(h,'YData',yValues);
end



