function [all_sparse, dictionary,all_loss] = sovlerDictionary( dictionary, all_tr_data,all_sparse,nclass,opts)
% step 2 :sovle the class-special dictionary class by class
%        a.solve J_1 min ||J_1||_*+ <T1,(D1-J1>+miu/2*||D1-J1||_F_2;
%        b.solve D1
%        c.solve J_2
%        d.solve D_2
%        e.solve X_ii
all_loss = 0;
tol = 1e-4;
miu = opts.miu;
% the parameters of low_rank terms 
lambdaD =opts.rank_lambda;
opts.verbose = 0;
opts.max_iter = 1000;
%the parameter of sparse term  
lambda =opts.lambda;
gamma = opts.gamma;
%% iterate of the step 2 class by class
for kk = 1:nclass
    A=dictionary{kk}.A;
    B =dictionary{kk}.B;
    % training data of class kk
    single_feaSet = all_tr_data{kk}.fea;
    %single_Z =all_sparse{kk,kk};
    % the transpose of image 2D matrix 
    singleT = cellfun(@(x)x',single_feaSet,'un',0);
    % init the parameters
    % the parameter of Lagrange multiplier
    miu = 0.0001;
    max_miu = 100000;
    rou = 1.1;
    %init the temporary variable
    J_1 = zeros(size(A));
    J_2 = zeros(size(B));
    T1=J_1;
    T2 =J_2;
    
    for j = 1:opts.iter_solve_dict
        %the sparse 2D matrix under class-special dictionaries 
        single_Z =all_sparse{kk,kk};
        %[x_1^T,x_2^T,...,x_N^T]
        J_all = cell2mat(singleT);
        %[x_1,x_2,x_3,....,x_n]
        I_all= cell2mat(single_feaSet);
        %% fix the dictionary ,solve J_1
        all_A1 = [];
        all_A2 = [];
        VB =zeros(size(A,2),size(A,2));
        %xij*B i!=j;
        %A*xij*xij^t ;
        %xij =xij*B;
        %Di+Dj;
        sumA =zeros(size(A,2),size(A,2));
        for ww = 1:nclass
            if(ww==kk)
                continue;
            end
            beta = all_sparse{kk,ww};
            Bxj = cellfun(@(x)x*B,beta,'un',0);
            Bx_mat = cell2mat(Bxj);
            VB = VB+Bx_mat*Bx_mat';
            sumA=sumA+dictionary{ww}.A'*dictionary{ww}.A;
        end
        A1 = cellfun(@(x)x*B,single_Z,'un',0);
        A1_mat = cell2mat(A1);
        all_A1 = [all_A1,A1_mat];
        %all_A2 = [all_A2,A2_mat];
        %  end
        %  resD_A = sum_D_A -dictionary{kk}.A;
        % resD_B = sum_D_B -dictionary{kk}.B;
        %                A = KSVD2(A,I_all,all_A1,resD_A,nta);
        %B = KSVD2(B',J_all,all_A2,resD_B',nta);
        % toc
        E = (T1+miu*A);
        len = size(J_1,2);
        F = eye(len,len);
        J_1 = min_rank_dict(J_1, E, F, lambdaD, opts);
        J_1= normc(J_1);
        %% solve D_1:
        % resD_A = sum_D_A -dictionary{kk}.A;
        A = (I_all*all_A1'+miu*J_1-T1)*inv(all_A1*all_A1'+miu*eye(size(A,2))+gamma*VB+0*sumA);
        %||D||_F_2
        % A = (I_all*all_A1')*inv(all_A1*all_A1'+eye(size(A,2))+VB);
        A =normc(A);
        
        %sum_D_A = resD_A+A;
        A2 =cellfun(@(x)(A*x)',single_Z,'un',0);
        A2_mat = cell2mat(A2);
        all_A2 = [all_A2,A2_mat];
        %%
        AV =zeros(size(B,1),size(B,1));
        sumB =zeros(size(B,1),size(B,1));
        for ww = 1:nclass
            if(ww==kk)
                continue;
            end
            beta = all_sparse{kk,ww};
            Bxj = cellfun(@(x)(A*x)',beta,'un',0);
            Bx_mat = cell2mat(Bxj);
            AV = AV+Bx_mat*Bx_mat';
            sumB = sumB+dictionary{ww}.B*dictionary{ww}.B';
        end
        
        %% solve J_2;
        %此时需要对B和J_2进行转置，然后在转置回来
        B = B';
        T2 = T2';
        J_2 = J_2';
        E = (T2+miu*B);
        len = size(J_2,2);
        F = eye(len,len);
        J_2 = min_rank_dict(J_2, E, F, lambdaD, opts);
        J_2 = J_2';
        T2 =T2';
        B = B';

        J_2= normr(J_2);
        %% solve D2;
        %  (I_all*all_A1'-miu*J_1+T1)*inv(all_A1*all_A1'+eye(size(A,2)));
        %
        %resD_B = sum_D_B -dictionary{kk}.B;
        B = (J_all*all_A2'+miu*J_2'-T2')*inv(all_A2*all_A2'+miu*eye(size(B',2))+gamma*AV+0*sumB);
        % B = (J_all*all_A2')*inv(all_A2*all_A2'+eye(size(B',2))+AV);
        B = B';
        B = normr(B);
        %sum_D_B = sum_D_B +B;
        %% updata param
        T1 = T1+miu*(A-J_1);
        T2 = T2 +miu*(B-J_2);
        miu = min(rou*miu,max_miu);
        dictionary{kk}.A = A;
        dictionary{kk}.B=B;
        
        % tic;
        %% solve the alpha_ii
        [beta,loss_beta] = SolveBeta(A,B,single_feaSet,lambda,opts,size(A,2),size(B,1),all_sparse{kk,kk});
        all_sparse{kk,kk} = beta;
        %% condition to break 
         if(norm(A-J_1)<0.0001&&norm(B-J_2)<0.0001)
            break;
         end
        %%
    end
    %% the loss of step 2 
    single_loss = loss_beta + lambdaD*nuclearnorm(J_1)+lambdaD*nuclearnorm(J_2)+trace(T1'*(J_1-A))+trace(T2'*(J_2-B))+...
        +gamma*(trace(A*VB*A')+trace(B'*AV*B));
    all_loss = single_loss+all_loss;
end
printf('loss is %f',all_loss);

end

