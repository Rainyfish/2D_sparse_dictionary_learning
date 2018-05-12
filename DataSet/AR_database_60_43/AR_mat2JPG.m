clc;
clear;
load('AR_database_60_43.mat');
newTestFace = reshape(NewTest_DAT, 60,43,700);
newTrainFace = reshape(NewTrain_DAT, 60,43,700);

num = size(newTestFace,3);
faceLabel = -1;
for i = 1 : num
    if(faceLabel ~= testlabels(i))
        faceLabel = testlabels(i);
        faceNum = 0;
    end
    faceNum = faceNum + 1;
    % there is no the floder
    if(exist(sprintf('test\\p%d',faceLabel),'dir') ~= 7)
        mkdir(sprintf('test\\p%d',faceLabel));
    end   
    imwrite(newTestFace(:,:,i),sprintf('test\\p%d\\%d.jpg',faceLabel,faceNum ));
end

faceLabel = -1;
num = size(newTrainFace,3);
for i = 1 : num
    if(faceLabel ~= trainlabels(i))
        faceLabel = trainlabels(i);
        faceNum = 0;
    end
    faceNum = faceNum + 1;
    if(exist(sprintf('train\\p%d',faceLabel),'dir') == 7)
        mkdir(sprintf('train\\p%d',faceLabel));
    end   
    imwrite(newTrainFace(:,:,i),sprintf('train\\p%d\\%d.jpg',faceLabel,faceNum ));
end