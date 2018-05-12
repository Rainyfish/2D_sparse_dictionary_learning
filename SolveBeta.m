function [ beta ,loss_beta] = SolveBeta( A,B,single_feaSet,lambda,opts,dict_size1,dict_size2,all_sparse)
%solve the sparse matrix of image i under dictionaries i 
DD = kron(B',A);
%lambda = 0.1;
lambda2 = 4;
opts.loss = 'l2';
%ADMM Ëã·¨
opts.lambda    = lambda;
opts.show_cost = 0;
opts.show      = 0;
opts.verbose    = false;
opts.max_iter  = 300;
loss_beta =0;
all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
xinit= cell2mat(cellfun(@(x)reshape(x,[],1),all_sparse,'un',0));
[x_hat_v,E,obj,err,it] = l1R(DD,all_x_v,opts.lambda,opts);
new_x = num2cell(x_hat_v,1);
new_Z = cellfun(@(x)reshape(x,dict_size1,dict_size2),new_x,'un',0);
beta = new_Z;
loss_beta = norm(all_x_v-DD*x_hat_v,'fro')+opts.lambda*norm(x_hat_v,1);
end

