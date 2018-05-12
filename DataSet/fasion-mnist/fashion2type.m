function [ output_args ] = fashion2type()
   %将数据集变为相同的形式
    images = loadMNISTImages('train-images-idx3-ubyte');
    labels = loadMNISTLabels('train-labels-idx1-ubyte');
    
    ts_images = loadMNISTImages('t10k-images-idx3-ubyte');
    ts_labels = loadMNISTLabels('t10k-labels-idx1-ubyte');
    nclass = length(unique(labels));
    all_tr_data={};
    all_ts_data={};
    for i =0:nclass-1
        index = find(labels==i);
        data = images(:,index);
        fea = num2cell(data,1);
        tmp_fea = cellfun(@(x)reshape(x,28,28),fea,'un',0);
        all_tr_data{i+1}.fea =tmp_fea;  
        all_tr_data{i+1}.label = ones(1,length(index))*i;
    end
    
    for i =0:nclass-1
        index = find(ts_labels==i);
        data = ts_images(:,index);
        fea = num2cell(data,1);
        tmp_fea = cellfun(@(x)reshape(x,28,28),fea,'un',0);
        all_ts_data{i+1}.fea = tmp_fea;
        all_ts_data{i+1}.label =  ones(1,length(index))*i;
    end
    
    save('all_fashion_mnist.mat','all_tr_data','all_ts_data');
end

