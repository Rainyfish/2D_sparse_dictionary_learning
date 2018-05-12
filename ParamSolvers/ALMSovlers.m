function [ dictionary,opts] = ALMSovlers( all_tr_data,nclass,dict_size1,dict_size2,opts,all_ts_data)
%UNTITLED solve the object function below
%   goal:
%  min_{D_{lk},D_{rk},\beta_i}&||X-DP||_F^2+\gamma||P||_{l1}+\sum_{k=1}^{C}\sum_{i=1}^{n_k}||x_{i_k} - D_{lk}\beta_{i_kk} D_{rk}||_F^2+\\ &\lambda_1||D_{lk}||_*+\lambda_2||D_{rk}||_*
%   +\gamma||\beta_{i_kk}||_{l1}+\eta \sum_{j,j\neq k}^{c}||D_{lj}\beta_{i_kj} D_{rj}||_F^2
% 
%SOLVEPARAM 
%   all_tr_data : is all the train data ,it is a
%                 structure,all_tr_date{i}.fea stands for 2D image data of
%                 class i,all_tr_data{i}.label stands for label
%   nclass:       stand for the the num of class
%   dict_size1:   is the size of left dictionary
%   dict_size2:   is the size of right dictionary
%   opts:         is the necessary the parameters of object function
%   all_ts_data:   is the test data 
%output:
%   dictionary:   is size of 1xnclass ,dictionary{i}.A stands for left
%                 dictionary of class i.dictionary{i}.B stands for right
%                 dictionary of class i.
%   opts:         same to input opts.
%process of the algorithm
%   1.solve the general dictionary
%     D,D=[kron{D_B1',D_A1},...kron{D_Bi',D_Ai},...];
%   2.sovle the class-special dictionary class by class
%       
%        a.solve J_1 min ||J_1||_*+ <T1,(D1-J1>+miu/2*||D1-J1||_F_2;
%        b.solve D1
%        c.solve J_2
%        d.solve D_2
%        e.solve X_ii
%
%% init the dictionaries 
dictionary={};
for i = 1:nclass
    %random init 
    A =rand(dict_size1);
    A =normc(A);
    B =rand(dict_size2);
    B = normr(B);
    dictionary{i}.A = A;
    dictionary{i}.B = B;
end

%% init sparse matrix of image 
all_tr_beta={};
for i =1:nclass
    all_tr_beta{i}=[];
end
%% iteration of the step 1 and step 2
for nn =1:opts.iter_all
    %solve the sparse matrix of data under the general dictionary
    [all_tr_beta,DD_R,loss_A]=solve_all_DD( dictionary,all_tr_data,nclass,all_tr_beta,opts);
    %all_sparse{i,j},i表示类，j表示图像在j类字典下的稀疏表示
    %split the a image sparse vector to nclass slices , slices i stands
    %for the sparse vector under the dictionaries items of class i.change the slices to 2D sparse matrix respectively 
    all_sparse=getblock_xii( all_tr_beta,DD_R,dictionary);
    all_loss = 0;

    %%  ALM求解字典
    [all_sparse dictionary,dict_loss] =sovlerDictionary(dictionary, all_tr_data,all_sparse,nclass,opts);
    
    %% ALM求解xii
    
    
    all_tr_beta = re_getblock_xi(all_sparse,dictionary);
    all_loss = all_loss_function(all_tr_data,dictionary,all_sparse,opts,nclass);
    fprintf('general dictionary loss  ,iter = %d, loss = %f \n',nn,(all_loss));
    fprintf('all_loss ,iter = %d, loss = %f \n',nn,(all_loss+dict_loss));
    acc = DLSI_test(all_ts_data,dictionary,nclass,opts);
    fprintf('class test acc is %f\n',acc );
    %         fprintf('class num is ,iter = %d, loss = %f \n',iter,loss);
    %dictionary{kk}.A = A;
    % dictionary{kk}.B = B;
    %all_sparse{kk}= Z;
    %  end
    % if(opts.reblock)
    
    
    %
    fprintf('iter num = %d,-----------------------------------------------------\n',nn);
end
%%
dictionary;



end

