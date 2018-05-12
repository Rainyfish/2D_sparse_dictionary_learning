function [ all_tr_beta,DD_R ,loss] = solve_all_DD( dictionary,all_tr_data ,nclass,all_tr_beta,opts)
%SOLVE_ALL_DD solve the sparse matirx of data under the general dictionary
%input parameters:
%   dictionary:   is size of 1xnclass ,dictionary{i}.A stands for left
%                 dictionary of class i.dictionary{i}.B stands for right
%                 dictionary of class i.
%   all_tr_data : is all the train data ,it is a
%                 structure,all_tr_date{i}.fea stands for 2D image data of
%                 class i,all_tr_data{i}.label stands for label
%   opts:         is the necessary the parameters of object function
%   all_ts_data:   is the test data 
%   nclass:       stand for the the num of class
%Output parametes:
%   all_tr_beta : is the 1D sparse vector of image j. size is 1 x nclass
%                 all_tr_beta{i} stands for the sparse vectors of images
%                 belongs to class i.all_tr_beta{i}  is size of 1 x
%                 imageNum of class i.all_tr_beta{i}{j} stands for the j-th
%                 image of class i.all_tr_beta{i}{j} is a sparse vector
%   DD_R        : is the range of class-special dictionary items 
%   loss:         is the loss of the first two terms
len = length(dictionary);
all_DD = [];
DD_R =[0];
%% compute the general dictionary  D=[kron{D_B1',D_A1},...kron{D_Bi',D_Ai},...];
if(length(dictionary)>1)
    sum_DD = 0;
    for i =1:len
        %left dictionary of class i 
        A = dictionary{i}.A;
        %right dictionary of class i
        B = dictionary{i}.B;
        kronD =kron(B',A);
        all_DD=[all_DD,kronD];
        sum_DD = sum_DD +size(kronD,2);
        % range of DD_R(i,i+1) the dictionary items of class i  
        DD_R = [DD_R,sum_DD];
    end
end
%%
lambda2 = 4;
opts.loss = 'l2';
opts.show_cost = 1;
opts.show      = 0;
opts.verbose    = true;
opts.max_iter  = 300;
loss = 0;
%% solve the sparse vectors of class i,class by class
for i = 1:nclass
    %all the train data of class i
    feaSet = all_tr_data{i}.fea;
    %change the 2D image data to 1D vectors
    all_tr_v=  cell2mat(cellfun(@(x)reshape(x,[],1),feaSet,'un',0));
    % ts_beta = l1R(all_DD,all_tr_v,opts.lambda,opts);
    xinit = cell2mat(all_tr_beta{i});
    % solve the sparse vectors by FISTA algorithm 
    % ts_beta = lasso_fista(all_tr_v,all_DD,xinit, opts.lambda, opts);
    %solve the sparse vectors by ADMM algorithm , use the libADMM 
    [ts_beta,E,obj,err,it] = l1R(all_DD,all_tr_v,opts.lambda,opts);
    % loss = loss+norm(all_tr_v-all_DD*ts_beta)+opts.lambda*sum(sum(abs(ts_beta)));
    ts_beta = num2cell(ts_beta,1);
    all_tr_beta{i} = ts_beta;
end

end

