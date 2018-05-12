function [ all_tr_beta ] = re_getblock_xi( all_sparse,dictionary)
%RE_GETBLOCK_XI 此处显示有关此函数的摘要
%   此处显示详细说明
     [row,col] = size(all_sparse);
     new_all_sparse = cell(row,col);
     all_tr_beta = cell(1,col);
     %将所有的二维稀疏系数变为一维向量形式
     for i =1:row
         for j = 1:col
             beta =[];
             A = dictionary{i}.A;
             if(i==j)
                 beta = cellfun(@(x)reshape(x,[],1),all_sparse{i,j},'un',0);
             end
             new_all_sparse{i,j} = beta;         
         end
     end
     %将各个类的稀疏系数拼接起来 x_i=[x_i1,x_i2,...,x_ic];
     single_v_len = length(new_all_sparse{1,1}{1});
     all_len = row*single_v_len;
     for i =1:row
         data_cell = cell(1,length(new_all_sparse));
         for k = 1:length(new_all_sparse{i,i});
             beta =[];
             beta = zeros(all_len,1);
             begin = (i-1)*single_v_len+1;
             endidx = i*single_v_len;
             beta(begin:endidx,:) = new_all_sparse{i,i}{k};
%              for j = 1:col
%                  data = new_all_sparse{i,j}{k};
%                  beta = [beta;data];
%              end
             data_cell{k} = beta;
         end
        all_tr_beta{i} = data_cell;
     end
     

end

