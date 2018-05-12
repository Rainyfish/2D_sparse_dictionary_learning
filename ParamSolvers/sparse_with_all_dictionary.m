function [ output_args ] = sparse_with_all_dictionary( dictiaonary,all_tr_data,nclass)
%SPARSE_WITH_ALL_DICTIONARY 此处显示有关此函数的摘要
%   此处显示详细说明
    Com_D =[];
    for i =1:nclass
        A = dictionary{i}.A;
        B = dictionary{i}.B;
        D = kron(B',A);
        Com_D =[Com_D,D];
    end
    opts = initopts;
    for i = 1:nclass
            single_fea = all_tr_data{kk}.fea;
           % tic;
            beta = SolveBeta(A,B,single_fea,lambda,opts,dict_size1(2),dict_size2(1));
          % beta = zeros(48*48,size(single_fea,1));
            all_sparse{kk} = beta;
            loss = lossfunction(single_fea,beta,A,B,lamda,1,nclass);
            all_loss = all_loss+loss;
    end;
end

