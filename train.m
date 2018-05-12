function train()
    addpath(genpath(cd));
    path = genpath(cd);
     load('fashion200.mat','all_tr_data','all_ts_data');
   
    dict_size1 = [28,10];
    dict_size2 = [10,28];
    nclass = length(all_tr_data);
    var = [0.01,0.02,0.03,0.05,0.07,0.09];

    %load('LRSR_all_cifar_norm.mat','dictionary');
    for i =1:1
        %% 初始化参数
        opts.tol = 1e-6;
        opts.iter_solve_dict = 100;
        opts.iter_all = 20;
        opts.dict_size = [dict_size1,dict_size2];
        opts.nclass = nclass;
        opts.gamma =20;
        opts.miu = 0.1;
        opts.max_iter = 300;
        opts.rho = 1.1;
        opts.mu = 1e-4;
        opts.max_mu = 1e10;
        opts.DEBUG = 0;
        opts.rank_lambda=1;
        opts.lambda= 1;
        opts.reblock =0;
        opts.threshold =0;
        [dictionary,opts] = ALMSovlers(all_tr_data,nclass,dict_size1,dict_size2,opts,all_ts_data);
        str = datestr(clock)
        index = find(str==':');
        str(index) = '_';
        index = find(str=='-');
        str(index) = '_';
        index = find(str==' ');
        str(index) = '_';
        %str = strcat(str,'_',str(2));
        save('dictioanry.mat','opts','dictionary');
        path = strcat('DictionaryResult\fashion\Lnuclear_fashion','dict_',num2str(size(dictionary{1},2)),'_lambda_',num2str(opts.lambda),'_',str,'.mat');
        save(path,'dictionary','opts');
        %the test process 
        test_process(all_ts_data,all_tr_data,path);
    end
end

