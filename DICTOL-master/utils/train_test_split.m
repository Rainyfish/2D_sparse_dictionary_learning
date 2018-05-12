function [dataset, Y_train, Y_test, label_train, label_test] = train_test_split(...
    dataset, N_train)
myrng();
fprintf('Picking Train and Test set ...');
switch dataset
        case 'myARgender'
            AR_gender_fn = fullfile('data', 'myARgender.mat');
            load(AR_gender_fn);            
            Y_train = normc(double(Y_train));
            train_range = label_to_range(label_train);
            Y_train = PickDfromY(Y_train, train_range, N_train);
            C = numel(train_range) - 1;
            label_train = range_to_label(N_train*(0:C));
            Y_test = normc(double(Y_test));

        case 'myARreduce'
            dataset = 'test mode';
            load('data/AR_EigenFace.mat');
            % ---------------  -------------------------
            Y_train = normc(tr_dat);
            Y_test = normc(tt_dat);
            % ---------------  -------------------------
            label_train = trls;
            label_test = ttls;
        case 'cifar'
            dataSet = 'cifar';
            load('data/cifar.mat','all_tr_data','all_ts_data');
            Y_train=[];
            x_all = [];
            ts_all = [];
            label_train =[];
            label_test =[];
            for i = 1:10
                single_feaSet = all_tr_data{i}.fea;
                single_ts = all_ts_data{i}.fea;
                all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
                all_x_ts = cell2mat(cellfun(@(x)reshape(x,[],1),single_ts,'un',0));
                all_x_v=all_x_v(:,1:N_train);
                x_all=[x_all,all_x_v];
                ts_all = [ts_all,all_x_ts];
                tv_label = ones(1,size(all_x_v,2))*i;
                ts_label = ones(1,size(all_x_ts,2))*i;
                label_train =[label_train,tv_label];
                label_test =[label_test,ts_label];                
            end
            Y_train = x_all;
            Y_test = ts_all;
        case 'AR'     
            dataSet = 'AR';
            load('data/AR.mat','all_tr_data','all_ts_data');
            Y_train=[];
            x_all = [];
            ts_all = [];
            label_train =[];
            label_test =[];
            for i = 1:length(all_tr_data)
                single_feaSet = all_tr_data{i}.fea;
                single_ts = all_ts_data{i}.fea;
                all_x_v = cell2mat(cellfun(@(x)reshape(x,[],1),single_feaSet,'un',0));
                all_x_ts = cell2mat(cellfun(@(x)reshape(x,[],1),single_ts,'un',0));
                x_all=[x_all,all_x_v];
                ts_all = [ts_all,all_x_ts];
                tv_label = ones(1,size(all_x_v,2))*i;
                ts_label = ones(1,size(all_x_ts,2))*i;
                label_train =[label_train,tv_label];
                label_test =[label_test,ts_label];                
            end
            Y_train = x_all;
            Y_test = ts_all;
        case 'myFlower'
            dataset = 'myFlower102';
            % load(fullfile('data', dataset);
            load(fullfile('data',strcat(dataset, '.mat')));

            Y_train = normc(double(Y_train));
            train_range = label_to_range(label_train);
            Y_train = PickDfromY(Y_train, train_range, N_train);
            C = numel(train_range) - 1;

            label_train = range_to_label(N_train*(0:C));

            Y_test = normc(double(Y_test));
        otherwise
            [Y_train, label_train, Y_test, label_test] = ...
                pickTrainTest_2(dataset, N_train);
    end
    fprintf('DONE\n');
end 
