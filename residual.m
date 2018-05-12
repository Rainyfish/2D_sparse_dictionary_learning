function [ output_args ] = residual(X,all_tr_data, dictionary,nclass)
%RESIDUAL 此处显示有关此函数的摘要
%   求出残差最小的指作为类标
% X 所有的测试数据
% D1 各个类的左字典集合
% D2 各个类的右字典集合
    addpath(genpath(cd));
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.01;
    opts.loss = 'l2'; 
    all_res = {};
    all_kron = [];
%     for i = 1:nclass
%         A = dictionary{i}.A;
%         B = dictionary{i}.B;
%         A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
%         B = B./repmat(sqrt(sum(B.^2,1)),size(B,1),1);
%         kron_D = kron(B',A);
%         all_kron = [all_kron,kron_D];
%     end

    [ all_tr_beta,DD_R ] = solve_all_DD( dictionary,all_tr_data ,nclass)

    thes = 0;
    
    for i = 1:nclass
        all_value =[];
        all_res = {};
        singleC = X{i}.fea;
        all_label =X{i}.label; 
       
        
        tic;
        for j = 1:nclass
            %             index_s =(i-1)*48*48+1;
            %             index_e =i*48*48;
            %             in = cellfun(@(x)reshape(x(index_s:index_e),48,48),sparse,'un',0);
            A = dictionary{j}.A;
            B = dictionary{j}.B;
            A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
            B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
            
            kron_D = kron(B',A);
            sparse = cellfun(@(x)l1R(kron_D,reshape(x,[],1),lambda,opts),singleC,'un',0);
            sparse = cellfun(@(x)threshold(x,thes),sparse,'un',0);
            all_res{j} =cell2mat(cellfun(@(x,y)norm(A*reshape(x,size(A,2),size(B,1))*B-y),sparse,singleC,'un',0));

        end
%          ADMM
%           all_x_v = cell2mat(cellfun(@(x)reshape(x,1024,1),singleC,'un',0));             
%           [x_hat_v,E,obj,err,it] = l1R(DD,all_x_v,lambda,opts);
%           new_x = num2cell(x_hat_v,1);
%           new_Z = cellfun(@(x)reshape(x,48,48),new_x,'un',0);
%           Z = new_Z;
          
          
        
        for j = 1:nclass
            all_value=[all_value;all_res{j}];  
        end
        [val,index]=min(all_value,[],1);
        right{i} = sum((index-1)==all_label)
        toc;
    end
    all_right = 0;
    for i = 1:10
        right{i}
        all_right = all_right+right{i};       
    end
    all_right


end
function mat  = threshold(mat,thres)
    mat(find(abs(mat)<thres)) = 0;
end
