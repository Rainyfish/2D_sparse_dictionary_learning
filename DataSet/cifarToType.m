load('data_batch_1to6_double.mat','trainData','trainLabels','testData','testLabels');
numclass = 10;
all_tr_Data={};
all_ts_Data ={};
all_tr_data ={};
all_ts_data={};
for i = 1:10
    index =find(trainLabels==(i-1));
    images = trainData(index,:);
    all = num2cell(images,2);
    alls=cellfun(@(x)im2double(rgb2gray(uint8(reshape(x,[32,32,3]))))',all,'un',0);
   % new_data = images(1,:);   
    %img = reshape(img,[32,32,3]);
    %img  = imread(img);
   % img = mat2gray(img);
    %imgs  = rgb2gray(double(img));
   % imshow(img);
   all_tr_data{i}.fea = alls';
   all_tr_data{i}.label = trainLabels(index)'; 
end
for i = 1:10
    index =find(testLabels==(i-1));
    image = testData(index,:);
     all = num2cell(image,2);
    alls=cellfun(@(x)im2double(rgb2gray(uint8(reshape(x,[32,32,3]))))',all,'un',0);
    img = alls{1};
   % new_data = images(1,:);   
    %img = reshape(img,[32,32,3]);
    %img  = imread(img);
   % img = mat2gray(img);
    %imgs  = rgb2gray(double(img));
   % imshow(img);
   all_ts_data{i}.fea = alls';
   all_ts_data{i}.label = testLabels(index)'; 
end
save('all_cifar.mat','all_tr_data','all_ts_data')
