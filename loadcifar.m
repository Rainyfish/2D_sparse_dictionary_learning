function [ all_tr_data,all_ts_data ] = loadcifar( input_args )
%LOADCIFAR 加载训练数据和测试数据
%   此处显示详细说明
    nclass =10;
    %test process 
    database = retr_database_dir('raw/image')
    clabel = unique(database.label);
    nclass = length(clabel);
    %所有样本的idx
    tr_idx = {};
    ts_idx = {};
    
    %所有样本对于的稀疏数据。
    all_tr_data = {};
    all_ts_data ={};
    %随机选取数据。
    tr_num = 400;
    for jj = 1:nclass
        idx_label = find(database.label == clabel(jj));
        num = length(idx_label);
        
        idx_rand = [1:420];
        
        tr_idx{jj}= [idx_label(idx_rand(1:tr_num))];
        ts_idx{jj}= [idx_label(idx_rand(tr_num+1:end))];
    end
    
    fprintf('Training number: %d\n', length(tr_idx));
    fprintf('Testing number:%d\n', length(ts_idx));
    
    % load the training features
    
    for kk = 1:nclass
        tr_single_idx =tr_idx{kk};
        ts_single_idx = ts_idx{kk};
        tr_fea = [];
        tr_cow_fea = [];
        tr_label =[];
        for jj = 1:length(tr_single_idx)
            fpath = database.path{tr_single_idx(jj)};
            load(fpath, 'fea', 'label');
            tr_fea{jj} =fea;
            tr_label(jj) = label;
        end
        all_tr_data{kk}.fea = tr_fea;
        all_tr_data{kk}.label = tr_label;
        %read the test features
        ts_label = [];
        for jj = 1:length(ts_single_idx)
            fpath = database.path{ts_single_idx(jj)};
            load(fpath, 'fea', 'label');
            ts_fea{jj} = fea;
            ts_label(jj) = label;
        end
        all_ts_data{kk}.fea = ts_fea;
        all_ts_data{kk}.label = ts_label;
    end

    save('cifar.mat','all_tr_data','all_ts_data');
end

