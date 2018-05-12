function [dictionary] = SolveParam_one_Dictionary(all_tr_data,nclass,dict_size1,dict_size2)
%SOLVEPARAM 求解一个通用的二维字典。
%   此处显示详细说明
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.01;
    opts.loss = 'l2'; 
    all_loss={};
    tic;
    Z = {};
    I_all =[];
    J_all =[];
    dictionary={};
    all_sparse={};
    
    %对类训练一个字典
    cout = 1;  
    %最大迭代次数后收敛 
    maxIter = 10;        
    A =rand(dict_size1);
    A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
    B =rand(dict_size2);
    B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
    for iter=1:maxIter
        %初始化
        
        DD = kron(B',A);
        Z = {};
        I_all =[];
        J_all =[];
        x_all =[];
        tic;
        m = 1;
        for kk = 1:nclass             
            %对每个图像数据进行求解稀疏系数
            single_feaSet = all_tr_data{kk}.fea;
            single_Z={};
            singleT = cellfun(@(x)x',single_feaSet,'un',0);
            %J = [x1',x2',...,xn']
            %I = [x1,x2,x3....,xn];
            J = cell2mat(singleT);
            I= cell2mat(single_feaSet);
            I_all = [I_all,I];
            J_all =[J_all,J];
            all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
            x_all=[x_all,all_x_v];
        end
        [x_hat_v,E,obj,err,it] = l1R(DD,x_all,lambda,opts);
        new_x = num2cell(x_hat_v,1);
        new_Z = cellfun(@(x)reshape(x,dict_size1(2),dict_size2(1)),new_x,'un',0);
        %固定稀疏系数，采用KSVD方法求解字典

        single_Z = new_Z;
        for kk = 1:100
            all_A1 = [];
            all_A2 = [];


            % matrix = label2matrix(all_tr_data);
            %  all_A1 = [all_A1;matrix];
            % all_A1 = [all_A2;matrix];            
            %  end
            param.K = 40;
            param.numIteration = 1000;
            param.errorFlag=1;
            param.errorGoal = 10;
            param.InitializationMethod = 'GivenMatrix';
            param.initialDictionary =A;
            param.preserveDCAtom = 0;
            % KSVD2( D,X,alpha,resD,nta)
            %fix B solve A
            A1 = cellfun(@(x)x*B,single_Z,'un',0);
        
            A1_mat = cell2mat(A1);

            all_A1 = [all_A1,A1_mat];
            A = KSVD2(A,I_all,all_A1,[],0);
            param.param.initialDictionary =B;
            A = A; 
            A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
            %fix A sovle B
            A2 =cellfun(@(x)(A*x)',single_Z,'un',0);
            A2_mat = cell2mat(A2);
            all_A2 = [all_A2,A2_mat];
            
            B = KSVD2(B,J_all,all_A2,[],0);
            toc           
            B = B';
            loss = lossfunction(all_tr_data,new_Z,A,B,0.1,0,nclass);
            fprintf('iter = %d, loss = %f \n',iter,loss);
            B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
        end
        
        %存储
        dictionary{1}.A = A;
        dictionary{1}.B = B;
        all_sparse{1}= Z;
    end
  % save('one_dictionary_sparse_ADMM_norm.mat','all_sparse');
   save('one_dictionary_cifar.mat','dictionary');
end

