function [ loss ] = all_loss_function(all_tr_data,dictionary,all_sparse,opts,nclass)
%ALL_LOSS_FUNCTION 此处显示有关此函数的摘要
%   此处显示详细说明
    [ all_tr_beta ] = re_getblock_xi( all_sparse,dictionary);
          len = length(dictionary);
    all_DD = [];
    DD_R =[0];
    if(length(dictionary)>1)
        range_A =[1];
        range_B =[1];
        all_A =[];
        all_B =[];
        sum_A =0;
        sum_B =0;
        sum_DD = 0;
        for i =1:len
            A = dictionary{i}.A;
            B = dictionary{i}.B;
            all_A =[all_A,A];
            all_B =[all_B;B];
            sum_A= sum_A +size(A,1);
            sum_B = sum_B +size(B,2);
            range_A =[range_A,sum_A];
            range_B = [range_A,sum_B];
            kronD =kron(B',A);
            all_DD=[all_DD,kronD];
            sum_DD = sum_DD +size(kronD,2);
            DD_R = [DD_R,sum_DD];
        end
    end
%    [opts,lambda] = initopts();
    DD = kron(all_B',all_A);
    %all_tr_beta={};
    %opts.lambda    = lambda;
%    opts.eta       = eta;
   % opts.D_range   = D_range;
    opts.show_cost = 0;
    opts.show      = 0;
    opts.verbose    = false;
    opts.max_iter  = 100;
    
    %all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
    %  [x_hat_v,E,obj,err,it] = l1R(DD,all_x_v,lambda1,opts);
    loss = 0;
    for kk = 1:nclass 
        %对每个图像数据进行求解稀疏系数
        feaSet = all_tr_data{kk}.fea;    
        %将二维矩阵变为向量的形式
        all_tr_v=  cell2mat(cellfun(@(x)reshape(x,[],1),feaSet,'un',0));
       % ts_beta = l1R(all_DD,all_tr_v,opts.lambda,opts);
        xinit = cell2mat(all_tr_beta{kk});
        %ts_beta = lasso_fista(all_tr_v,all_DD,xinit, opts.lambda, opts);
        loss = loss+norm(all_tr_v-all_DD*xinit,'fro')+opts.lambda*norm(xinit,1);
    end 
    
end

