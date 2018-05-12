function  []=findNN(X,dictionary,X_tr,nclass)
    A = dictionary{1}.A;
    B = dictionary{1}.B;
    %init
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.01;
    opts.loss = 'l2';
    
   % DD = kron(B',A);
    %DD = dictionary;
    
    x_all =[];
    ts_all = [];
    train_label = [];
    test_label = [];
    len = length(dictionary);
    range_A =[size(A,1)];
    range_B =[size(B,2)];


    
    for kk = 1:nclass 
        %对每个图像数据进行求解稀疏系数
        single_feaSet = X_tr{kk}.fea;
        train_label = [train_label;X_tr{kk}.label'];
        test_feaSet = X{kk}.fea;
        test_label = [test_label;X{kk}.label'];
        all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
        all_ts_v=  cell2mat(cellfun(@(x)reshape(x,[],1),test_feaSet,'un',0));
        ts_all =[ts_all,all_ts_v];
        x_all=[x_all,all_x_v];
    end 
    thres = 0.2;
   [x_hat_v,E,obj,err,it] = l1R(DD,x_all,lambda,opts);
   [ts_hat_v,E,obj,err,it] = l1R(DD,ts_all,lambda,opts);
   x_hat_v(find(abs(x_hat_v)<thres)) = 0;
   ts_hat_v(find(abs(ts_hat_v)<thres)) = 0;
   %tr_re = (x_all-DD*x_hat_v);
  % ts_re = (ts_all-DD*ts_hat_v);
   
   % x_hat_v = x_hat_v./repmat(sqrt(sum(x_hat_v.^2,1)),size(x_hat_v,1),1);
    %ts_hat_v = ts_hat_v./repmat(sqrt(sum(ts_hat_v.^2,1)),size(ts_hat_v,1),1);
%    k = 200;
%    c = pca(x_all');
%    pca_tr_v = (x_all'*c(:,1:k))';
%    pca_ts_v =(ts_all'*c(:,1:k))';
   
%     new_tr_cell = num2cell(x_all,1);
%     new_ts_cell = num2cell(ts_all,1);
% %     
%     new_tr_reshape=cellfun(@(x)reshape(x,32,32),new_tr_cell,'un',0);
%     new_ts_reshape=cellfun(@(x)reshape(x,32,32),new_ts_cell,'un',0);
% %    
%    new_tr_v = cell2mat(cellfun(@(x)matrix2vector(x),new_tr_reshape,'un',0));
%    new_ts_v = cell2mat(cellfun(@(x)matrix2vector(x),new_ts_reshape,'un',0));
%    
     %[D,tr_Z] =solveZ(tr_re,train_label);
     %ts_Z =inv(D'*D+0.5*eye(size(D,2)))*D'*ts_re;
    model = svmtrain(train_label,x_hat_v');
    [group,acc,kk] = svmpredict(test_label,ts_hat_v',model);
    right = 0;
    for i =1:length(test_label)
        v = ts_hat_v(:,i);
        minval = bsxfun(@minus,x_hat_v,v);
        [val,index] =min(sum(minval.*minval,1));
        right = right+(test_label(i)==train_label(index(1)));
    end
    right
  end