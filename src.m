function [ output_args ] = src( all_tr_data,all_ts_data,nclass)
%SRC 此处显示有关此函数的摘要
%   此处显示详细说明
    addpath(genpath(cd));
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.01;
    opts.loss = 'l2'; 
    all_res = {};
    all_kron = [];
    all_dictionary = [];
    all_label_ts = [];
    all_label_tr = [];
    all_Data = {};
    ts_data = [];
    %变为通用字典
     A =rand(100,100);
     A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
    for i = 1:nclass
       singleC = all_tr_data{i}.fea;
       singleT = all_ts_data{i}.fea;
       all_label_tr = [all_label_tr;all_tr_data{i}.label'];      
       single_D = cell2mat(cellfun(@(x)reshape(x,[],1),singleC,'un',0));
       all_Data{i} = single_D;
    end
    all_dicitionary = cell2mat(all_Data);
    allright = 0;
   for i = 1:nclass           
       singleT = all_ts_data{i}.fea;
     
       single_ts= cellfun(@(x)reshape(x,[],1),singleT,'un',0);
       all_ts_i = cell2mat(single_ts);
       sparse =cell2mat(cellfun(@(x)l1R(all_dicitionary,x,lambda,opts),single_ts,'un',0)); 
       %sparse =cell2mat(cellfun(@(x)SolveFISTA(x,all_dicitionary),single_ts,'un',0)); 
       all_res =[];
        for j = 1:nclass
           index=find(all_label_tr==j);
           Dj = all_Data{j};
           sparsej = sparse(index,:);
           re =Dj*sparsej;
           resj = sum((all_ts_i-re).*(all_ts_i-re),1);
           all_res = [all_res;resj];
        end
        [minval,minindex] = min(all_res,[],1);
        right = sum(minindex==i);
        allright = allright+right
   end;
    
end

