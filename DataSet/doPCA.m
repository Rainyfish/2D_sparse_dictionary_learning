function [ output_args ] = doPCA( input_args )
%DOPCA 此处显示有关此函数的摘要
%   此处显示详细说明
    load('cifar200.mat','all_tr_data','all_ts_data');
    all_data_train = [];
    nclass = length(all_tr_data);
    tr_label =[];
    ts_label =[];
    for i =1:nclass
        single = all_tr_data{i}.fea;
        tr_label =[tr_label,all_tr_data{i}.label];
        all_s = cell2mat(cellfun(@(x)reshape(x,[],1),single,'un',0));
        all_s = all_s';
        all_data_train = [all_data_train;all_s];
    end
    all_data_test=[];
    for i =1:nclass
        single = all_ts_data{i}.fea;
        ts_label =[ts_label,all_ts_data{i}.label];
        all_s = cell2mat(cellfun(@(x)reshape(x,[],1),single,'un',0));
        all_s = all_s';
        all_data_test = [all_data_test;all_s];
    end
    co = pca(all_data_train);
    ee = co(:,1:256);
    new_all_train = all_data_train*ee;
    new_all_test = all_data_test*ee;
   for i =1:nclass
        idx = find(tr_label==(i-1));
        data = new_all_train(idx,:);
        data = data';
        fea = num2cell(data,1);
        fea = cellfun(@(x)reshape(x,16,16),fea,'un',0);
        all_tr_data{i}.fea = fea;
   end
   
     for i =1:nclass
        idx = find(ts_label==(i-1));
        data = new_all_test(idx,:);
        data = data';
        fea = num2cell(data,1);
        fea = cellfun(@(x)reshape(x,16,16),fea,'un',0);
        all_ts_data{i}.fea = fea;
   end
   save('cifar200_pca_16x16.mat','all_tr_data','all_ts_data');
end

