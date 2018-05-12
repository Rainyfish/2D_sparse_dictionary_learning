function [ B ] =TWODOMP(D1,D2,B,K,x)
%2DOMP 此处显示有关此函数的摘要
% @author Chuangchuang Liu 2018.1.18
%D1 the left dictionary
%D2 the right dictionary
%K the sparse level
%B the 2D sparse matrix
[a_1,b_1] = size(D1);
[a_2,b_2] = size(D2);
R = x;
m =1;
for i = 1:b_1
    for j = 1:a_2
        seti{m} = [i,j,1];
        m = m+1;
    end
end
base = {};
H =[];
sumU = zeros(size(x));
f=[];
for t = 1:K
    max =-realmax('double');
    max_index = 0;
    for w = 1:m-1
        temp = seti{w};
        tempi=temp(1);
        tempj = temp(2);
        ff = temp(3);
        if(ff==0)
            continue
        end;
        Bi = D1(:,tempi);
        Bj = D2(tempj,:)';
        val = Bi'*R*Bj/(1);
        if(max<val)
            max = val;
            max_index =w;
        end;
    end;
    if(max_index==0)
        disp(max_index);
    end
    seti{max_index}(3)=0;
    base{t} = seti{max_index}(1,1:2);
    ait= base{t}(1);
    bit = base{t}(2);
    Bit = D1(:,ait);
    Bjt = D2(bit,:)';
    
    H_new = [];
    for ww = 1:t
        ii = base{ww}(1);
        jj = base{ww}(2);
        Bis = D1(:,ii);
        Bjs = D2(jj,:)';
        valij = Bit'*Bis*Bjt'*Bjs;
        H_new=[H_new,valij];
    end
    H =[H;H_new(1:t-1)];
    H =[H,H_new'];
    f = [f;Bit'*x*Bjt];
    u_hat = inv(H)*f;
    sumU=zeros(size(x));
    for ww = 1:t
        ii = base{ww}(1);
        jj = base{ww}(2);
        Bis = D1(:,ii);
        Bjs = D2(jj,:)';
        sumU = sumU + u_hat(ww)*Bis*Bjs';
    end
    R = x - sumU;
end
Z=zeros(size(B));


for t = 1:K
    ait = base{t}(1);
    bit = base{t}(2);
    Z(ait,bit) = u_hat(t);
end
B=Z;
end


