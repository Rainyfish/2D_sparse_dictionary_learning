function [ output_args ] = Multi_dict_test( X,all_tr_data,dictionary,nclass )
%MULTI_DICT_TEST 此处显示有关此函数的摘要
%   此处显示详细说明
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
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.2;
    opts.loss = 'l2';
    DD = kron(all_B',all_A);
                 opts.lambda    = lambda;
%             opts.eta       = eta;
           %  opts.D_range   = D_range;
             opts.show_cost = 0;
             opts.show      = 0;
             opts.verbose    = false;
             opts.max_iter  = 100;
    right = 0;
    for kk = 1:nclass 
        %对每个图像数据进行求解稀疏系数
        %single_feaSet = X_tr{kk}.fea;
        %train_label = [train_label;X_tr{kk}.label'];
        test_feaSet = X{kk}.fea;    
      %  test_label = [test_label;X{kk}.label'];
        %all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
        all_ts_v=  cellfun(@(x)reshape(x,[],1),test_feaSet,'un',0);
      % all_ts_beta = cellfun(@(x)l1R(all_DD,x,lambda,opts),all_ts_v,'un',0);
        all_ts_beta = cellfun(@(x)lasso_fista(x, all_DD, [], lambda, opts),all_ts_v,'un',0);
        %all_ts_beta = cellfun(@(x)reshape(x,size(all_A,2),[]),all_ts_beta,'un',0);
        %all_index =cellmat(cellfun(@(x,y)(x,DD_R,y,all_DD),all_ts_v,all_ts_beta,'un',0));
        for j = 1:length(all_ts_beta)
            x = all_ts_v{j};
            beta = all_ts_beta{j};
            index = getDDmin(x,DD_R,beta,all_DD);
            right = right+(kk==(index));
        end;
        right
       
    end 
    
   
   %% get residual
    for kk = 1:nclass
        
    end
end
function index=get_mine(x,range_A,rang_B,beta,dictionary)
    minval = [];
    for i = 1:size(range_A,1)-1;
        A = dictionary{i};
        B = dictionary{i};
        size1 = range_A(i);
        size2 = range_B(i);
        block = x(range_B(i):range_B(i+1),range_A(i):range_A(i+1));
        val =norm(A*block*B-y)+0.2*(sum(abs(block)));
        minval =[minval,val];
    end
    [val,index] = min(minval) ;
end

function index = getDDmin(x,DD_R,beta,all_DD)
    minval =[];
    for i =1:size(DD_R,2)-1
        beta_v = beta((DD_R(i)+1):DD_R(i+1));
        singleDD = all_DD(:,(DD_R(i)+1):DD_R(i+1));
        minval =[minval, norm(x-singleDD*beta_v)];        
    end
    [val,index] =min(minval);  
end

