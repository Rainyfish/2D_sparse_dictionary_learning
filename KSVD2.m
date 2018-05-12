function [ D_new,beta ] = KSVD2( D,X,alpha,resD,nta)
%KSVD KSVD 分解
%   此处显示详细说明
%     D2 = D;
%     [r_d1,c_d1]=size(D2);
%     for i =1:c_d1
%         col_di = D2(:,i);
%         row_Ai = alpha(i,:);
%         D2(:,i) =0;
%         index = find(row_Ai);
%         R = (X-D2*alpha);
%         R_non = R(:,index);
%         [u,s,v] = svd(R_non);
%         col_di = u(:,1)';
%         D2(:,i) = col_di;
%         alpha(i,index) =s(1)*v(1,:);
%         u = [];
%         s = [];
%         v =[];
%     end
%     D_new = D2;  
    lamda = 0.02;
    [a,b] = size(alpha);
   % D_new = (X*alpha'-nta*resD)*inv(alpha*alpha'+lamda*eye(a));
     D_new = (X*alpha')*inv(alpha*alpha'+lamda*eye(a));
    
end

