function [ all_tr_data,all_ts_data ] = AR2Type( input_args )
%AR2TYPE 此处显示有关此函数的摘要
%   此处显示详细说明
    load('AR_database_60_43.mat');
    newTestFace = reshape(NewTest_DAT, 60,43,700);
    newTrainFace = reshape(NewTrain_DAT, 60,43,700);
    num = size(newTestFace,3);
    faceLabel = -1;
    all_ts_data={};
    all_tr_data ={};
    faceLabel = -1;
    for i = 1 : num
        if(faceLabel ~= testlabels(i))
            faceLabel = testlabels(i);
            faceNum = 0;
        end
        faceNum = faceNum + 1;
        all_ts_data{faceLabel}.fea{faceNum} = im2double(newTestFace(:,:,i));
        all_ts_data{faceLabel}.label(faceNum) =  faceLabel; 
    end

    faceLabel = -1;
    num = size(newTrainFace,3);
    for i = 1 : num
        if(faceLabel ~= trainlabels(i))
            faceLabel = trainlabels(i);
            faceNum = 0;
        end
        faceNum = faceNum + 1;
        all_tr_data{faceLabel}.fea{faceNum} =im2double(newTrainFace(:,:,i));
        all_tr_data{faceLabel}.label(faceNum) =  faceLabel;
    end
    save('AR_60_43.mat','all_tr_data','all_ts_data');
end 

