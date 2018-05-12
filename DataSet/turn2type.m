function [ all_data ] = turn2type(fea,gnd)
%TURN2TYPE 数据格式转换，接口
%   此处显示详细说明
    nclass = max(gnd);
    all_data ={nclass};
    fea_cell = num2cell(fea,2);
    fea_cell = cellfun(@(x)mapminmax(reshape(x,32,32),0,1),fea_cell,'un',0);
    len = length(gnd);
    
    for i = 1:nclass
        index  = find(gnd==i);
        all_data{i}.fea = {};
        for j =1:length(index)
            all_data{i}.fea{j} = fea_cell{index(j)};
            all_data{i}.label(j) = i;
        end
    end
    
end

