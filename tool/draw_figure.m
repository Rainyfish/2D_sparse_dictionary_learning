function [ output_args ] = draw_figure(data)
%DRAW_FIGURE 此处显示有关此函数的摘要
%   此处显示详细说明
    nclass = length(data);
    figure;
    for i = 1:nclass
        hold on;
        y = data{i};
        len = size(y,2);
        plot(y,'r-*');
    end
    
end

