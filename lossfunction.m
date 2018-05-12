function [ value ] = lossfunction(X,alpha,A,B,lambda,flag,nclass)
%LOSSFUNCTION 此处显示有关此函数的摘要
%   此处显示详细说明

    loss = 0;
    if(flag == 1)
    %for i = nclass:nclass
        alphaC = alpha;
        single_x = X;
        new_X = cellfun(@(x)A*x*B,alphaC,'un',0);
        normC = cellfun(@(x,y,z)norm(x-y)+lambda*sum(abs(z)),new_X,single_x,alphaC,'un',0);
        mat = cell2mat(normC);
        loss= loss+sum(mat);
   % end
        value = loss;
        
        return ;
    end  
    all=[];
    if(flag==2)
       loss = lossfunction(X,alpha,A,B,lambda,1,nclass)+nuclearnorm(A)+nuclearnorm(B); 
       value = loss;
       return ;
    end
%     for i = 1:nclass
%         %alphaC = alpha;
%         single_x = X{i}.fea;
%         all = [all,single_x];
%     end
%     new_X = cellfun(@(x)A*x*B,alpha,'un',0);
%     normC = cellfun(@(x,y,z)norm(x-y)+lamda*sum(abs(z)),new_X,all,alpha,'un',0); 
%     mat = cell2mat(normC);
%     loss= loss+sum(mat);
%     value = loss;
end
    

