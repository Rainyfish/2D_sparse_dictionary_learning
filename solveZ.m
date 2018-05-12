function [D,Z] = solveZ(Y,label)
%SOLVEZ 对稀疏z求解
%   此处显示详细说明
    %||Y - YZ||2+||Z||2+tr(ZLZ);
    %求解L
    %compute Wij
    tao= 0.5;
    theta = 0.5;
    sigma = 1;
    [a,b] =size(Y);
    W = [];
    Dii =[];
    for i =1:b
        disW = zeros(1,b);
        index = label(i);
        same_label_index= find(label==index);
        v = Y(:,i);
        same_Y = Y(:,same_label_index);
        mius = bsxfun(@minus,same_Y,v);
        dis = sum(mius.*mius,1).^0.5;
        ker = normpdf(dis,0,1);
        Dii =[Dii,sum(ker)];
        %norm or not
        disW(same_label_index) = ker;
        W =[W;disW];
    end
    D_diag = diag(Dii);
    L = D_diag -W;
%     Z = lyap(Y'*Y+tao/2*eye(b),theta*L+tao/2*eye(b),Y'*Y);
    %D = rand(a,1000);
   % D = D./repmat(sqrt(sum(D.^2,1)),size(D,1),1);
    D = Y;
%     maxIter = 10;
%     for i = 1:maxIter
%         Z = lyap(D'*D+tao/2*eye(1000),theta*L+tao/2*eye(b),D'*Y);
%         %KSVD2( D,X,alpha,resD,nta)
%        % D = KSVD2(D,Y,Z,[],0);
%     end
    Z = lyap(D'*D+tao/2*eye(size(Y,2)),theta*L+tao/2*eye(b),D'*Y);
    %D = Z;
%     Z=[];
%     for i=1:b
%         y = Y(:,i);
%         row =[1:b];
%         index = (row~=i);
%         D = Y(:,index);
%         L= L(:,i)
%         zi = lyap(D'*D+tao/2*eye(b),theta*L+tao/2*eye(b),y'*D);
%         Z = [Z;zi]
%     end
    
end

