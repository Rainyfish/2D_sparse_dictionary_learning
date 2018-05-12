addpath('./fashion-mnist');
load('all_fashion_mnist.mat','all_tr_data','all_ts_data');
tr_num =200;
ts_num = 200;
mat=cell(1,tr_num);
mati = cell(1,ts_num);
for i = 1:10
  %  all_tr_data{i}.fea{1:200}= all_tr_data{i}.fea{1:200};
    for  j = 1:tr_num
        mat{j} = all_tr_data{i}.fea{j};
    end
    all_tr_data{i}.fea =mat;
    all_tr_data{i}.label  = all_tr_data{i}.label(1:tr_num);
    for  j = 201:ts_num+200
        mati{j-200} = all_ts_data{i}.fea{j};
    end
    all_ts_data{i}.fea =mati;
    all_ts_data{i}.label  = all_ts_data{i}.label(1:ts_num);
end

save('fashion200_200.mat','all_tr_data','all_ts_data')