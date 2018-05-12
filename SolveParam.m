function [D1,D2,B] = SolveParam(all_tr_data,nclass,dict_size1,dict_size2)
%SOLVEPARAM 对二维字典进行求解
%   此处显示详细说明
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.1;
    %opts.loss = 'l2'; 

   % tic;
    Z = {};
    I_all =[];
    J_all =[];
    dictionary={};
    lamda = 0.1;
    %对每一类训练一个字典
    cout = 1;
    all_sparse={};
    nta = 0.1;
    fi_loss ={};
    
    loss_v =[];
    for i = 1:nclass
        %初始化
        A =rand(dict_size1);
        A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
        B =rand(dict_size2);
        B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
        dictionary{i}.A = A;
        dictionary{i}.B = B;
        fi_loss{i}=[];
    end
    
    maxIter = 10;
    for iter=1:maxIter
        all_loss = 0;
        %计算参数all_beta
        [all_tr_beta,DD_R]=solve_all_DD( dictionary,all_tr_data,nclass);
        %计算dictionary and x_ii;
        %计算x_ii;
        [all_sparse] = getblock_xii(all_tr_beta,DD_R,dictionary);

        %             DD = kron(B',A);
        %             x = all_tr_data{kk}.fea{1};
        %             x_v = reshape(x,1024,1);
        %             %D = kron(B',A);
        %             %beta_v = SolveFISTA(DD,x_v);
        % %             [beta_v,E,obj,err,it] = l1R(DD,x_v,lambda,opts);
        % %             beta  = reshape(beta_v,48,48);
        % %             re = A*beta*B;
        %             %new_re = mapminmax(re,0,255);
        %             subplot(nclass,maxIter,cout);
        %             imshow(re);
        %             cout= cout+1;
        %for i = kk:kk
        %对每个图像数据进行求解稀疏系数
%         sum_D_A =dictionary{1}.A;
%         sum_D_B =dictionary{1}.B;
%         for kk = 2:nclass
%             sum_D_A = sum_D_A+dictionary{kk}.A;
%             sum_D_B = sum_D_B+dictionary{kk}.B;
%         end
        
       % for nextIter = 1:5
        all_loss = 0;
        for kk = 1:nclass
            A=dictionary{kk}.A;
            B =dictionary{kk}.B;
            single_fea = all_tr_data{kk}.fea;
            %
            %ADMM算
            beta = SolveBeta(A,B,single_fea,lambda,opts,dict_size1(2),dict_size2(1));
            all_sparse{kk} = beta;
            loss = lossfunction(single_fea,beta,A,B,lamda,1,nclass);
            fi_loss{kk} =[fi_loss{kk},loss];
            all_loss = all_loss+loss;
        end
        fprintf('process of solve beta  ,iter = %d, loss = %f \n',iter,all_loss);
        loss_v=[loss_v,all_loss];
        all_loss =0;
        for kk = 1:nclass                
            A=dictionary{kk}.A;
            B =dictionary{kk}.B;
            res_dict = sum_D_A-A;            
            single_feaSet = all_tr_data{kk}.fea;
            single_Z={};
            singleT = cellfun(@(x)x',single_feaSet,'un',0);
            %J = [x1',x2',...,xn']
            %I = [x1,x2,x3....,xn];
            J_all = cell2mat(singleT);
            I_all= cell2mat(single_feaSet);
            %固定稀疏系数，采用KSVD方法求解字典

            i = kk;
            
            single_Z =all_sparse{kk};
            for j = 1:100
                
                all_A1 = [];
                all_A2 = [];
                A1 = cellfun(@(x)x*B,single_Z,'un',0);               
                A1_mat = cell2mat(A1);
                all_A1 = [all_A1,A1_mat];

                %  end
                %求解字典A
                resD_A = sum_D_A -dictionary{kk}.A;                
                %resD_B = sum_D_B -dictionary{kk}.B;
                A = KSVD2(A,I_all,all_A1,resD_A,nta); 
                A = A;
                A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
                sum_D_A = resD_A+A;
                loss = lossfunction(single_feaSet,single_Z,A,B,lamda,1,10);
                
               % fprintf('process of solve dictionary A,iter = %d, loss = %f \n',iter,loss);
               
                %求解字典B
                sum_D_A = resD_A+A;
                resD_B = sum_D_B -dictionary{kk}.B;
                A2 =cellfun(@(x)(A*x)',single_Z,'un',0);
                A2_mat = cell2mat(A2);
                all_A2 = [all_A2,A2_mat]; 
                B = KSVD2(B',J_all,all_A2,resD_B',nta);
                % toc 
                B = B';
                B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
              %  loss = lossfunction(single_feaSet,single_Z,A,B,lamda,1,10);
               % fprintf('process of solve dictionary B,iter = %d, loss = %f \n',iter,loss);
               
              %  A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
               % B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
                dictionary{kk}.A =A;
                dictionary{kk}.B=B;
              
                sum_D_B = resD_B+B;
            end
                           
          %  A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
          %  B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
            loss = lossfunction(single_feaSet,single_Z,A,B,lamda,1,10);
            fi_loss{kk}= [fi_loss{kk},loss];
            all_loss = loss+all_loss;
        end
        
        loss_v = [loss_v,all_loss];
        fprintf('process of solve dictionary,iter = %d, loss = %f \n',iter,all_loss);

        %end   
    end
    draw_figure(fi_loss);
    new_loss{1} = loss_v;
    draw_figure(new_loss);
   %存储
  % save('all_sparse_ADMM_norm.mat','all_sparse');
   save('cifar_norm_class_dictionary.mat','dictionary');
end

