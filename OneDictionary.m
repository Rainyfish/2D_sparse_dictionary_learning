function [ output_args ] = OneDictionary( all_tr_data,all_ts_data,nclass )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.01;
    opts.loss = 'l2';
     A =rand(1024,2048);
     A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
     all_data = {};
     for round = 1:10
         for i = 1:nclass
             singleC = all_tr_data{i}.fea;
             single_D = cell2mat(cellfun(@(x)reshape(x,[],1),singleC,'un',0));
             all_data{i} =  single_D;
         end
         all_x_v = cell2mat(all_data);
         sparse =l1R(A,all_x_v,lambda,opts); 
         A = KSVD2(A,all_x_v,sparse);
         A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
     end
     save('OneCommonDictionary1.mat','A');
end

