function [MM, SBIB] = gen_sbibd
% (1) Create variables
% Setup random stream
s=RandStream('mt19937ar');
RandStream.setGlobalStream(s);
reset(s,sum(100*clock)); %reset seed

%reset(RandStream.getDefaultStream,sum(100*clock));
%  num_of_blocks = mem_nodes;

v_value = 9; %u can change this value to your needs


Z= randperm(2^52,45)+(2^52 -1);
ZZ= Z* 2^75;

%Varr = randperm(100,45);
%Varr = randperm(2^31,45)+ 2^32; 
Varr = ZZ;

V = Varr(1:9);
v = length(V);

k = sqrt(length(V));
%             b = k * (k+1);
r = k+1;
%Cell 2;
%(2) Create resolution class
RC = cell(1,4);
for u = 1:r
    RC{u} = reshape(randperm(s,v),k,k);
    for i=1:size(RC{u},1)
        for j=1:size(RC{u},2)
            RCr{u}(i,j) = V(RC{u}(i,j));
        end
    end
end
%Cell 3
% (3) Create Parallel class
PC = cell(1,4);
for u = 1:r
    PC{u} = reshape((RCr{u})',1,v);
end
%Cell 4
% (4) Create incidence matrix
M = cell(1,5);
for ii = 1:r+1
    if ii == 1
        M{ii} = zeros(v,v);
    else
        for jj = 1:v
            a = RC{ii-1};
            ind = any(jj == a,2);
            data = zeros(k,k);
            data(a(ind,:)) = 1;
            M{ii}(jj,:) = reshape(data,1,v);
        end
    end
end
%Cell 5
% (5) General Incidence matrix
BM = cell(45,12);
vn = zeros(1,12);
ii = 1:length(M);
n = 1;
for vv = 1:length(M)
    f = ii(n:end);
    if n == 1
        b = [];
    else
        b = 1:n-1;
    end
    len = [f b];
    MM{vv,:} = cell2mat(M(len));
    n = n + 1;
end
MM = cell2mat(MM);

rws=size(MM,1);
clms=size(MM,2);
for i=1:rws
    count=0;
    for j=1:clms
        if (MM(j,i)==1)
            count = count +1;
            vn(1,count)=j;
        end
    end
    vnlen=length(vn);
    for vpsc=1:vnlen
        BM{i,vpsc}=vn(vpsc);
    end
end
BMN = cell2mat(BM);


SBIB = zeros(45,12);
for blck = 1:45
    for keyv = 1:12
        SBIB(blck,keyv) = Varr(BMN(blck,keyv));
    end
end
assignin('base','vnlen',vnlen);
end