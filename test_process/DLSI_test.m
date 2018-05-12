function [ acc ] = DLSI_test( X,dictionary,nclass,opts)
%DLSI_TEST 此处显示有关此函数的摘要
%   此处显示详细说明
    len = length(dictionary);
    all_DD = [];
    DD_R =[0];
    if(length(dictionary)>1)
        range_A =[1];
        range_B =[1];
        all_A =[];
        all_B =[];
        sum_A =0;
        sum_B =0;
        sum_DD = 0;
        for i =1:len
            A = dictionary{i}.A;
            B = dictionary{i}.B;
            all_A =[all_A,A];
            all_B =[all_B;B];
            sum_A= sum_A +size(A,1);
            sum_B = sum_B +size(B,2);
            range_A =[range_A,sum_A];
            range_B = [range_A,sum_B];
            kronD =kron(B',A);
            all_DD=[all_DD,kronD];
            sum_DD = sum_DD +size(kronD,2);
            DD_R = [DD_R,sum_DD];
        end
    end
    label_test =[];
    Y_test =[];
    for kk = 1:nclass 
        label = X{kk}.label;
        test_feaSet = X{kk}.fea;
        all_ts_v= cell2mat( cellfun(@(x)reshape(x,[],1),test_feaSet,'un',0));
        Y_test=[Y_test,all_ts_v];
        label_test = [label_test,label];
    end 
    opts.D_range = DD_R;
    %opts.lambda = 0.0;
   % opts.threshold = 0.5;
    pred           = DLSI_pred(Y_test, all_DD, opts);
    acc            = double(sum(pred == (label_test+1)))/numel(label_test);
    

end

