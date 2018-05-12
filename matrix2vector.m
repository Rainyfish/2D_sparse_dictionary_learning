function [val] = matrix2vector( x )
%MATRIX2VECTOR 三种方法将二维矩阵变为一维
    flag = 3;
    %直接转为向量
    if(flag ==1)
        v = reshape(x,[],1);
    end
    %行列最大化
    if(flag==2)
        v = reshape(x,[],1);
        col_max = max(x,[],1);
        row_max = max(x,[],2);
        v = [x;col_max;row_max];
    end
    %SPM思想
    if(flag ==3)
        [row,col]=size(x); 
        v = reshape(x,[],1);
        %v=[];
        l = 3 ;
        for i = 1:l
            div = 2^(i-1);
            len_r =row/div;
            len_c =col/div;
            index_c = [0:len_c:col];
            index_r = [0:len_r:row];
            for j = 1:length(index_r)-1
                start_r = index_r(j)+1;
                end_r = index_r(j+1);
                for k = 1:length(index_c)-1
                    start_c = index_c(k)+1;
                    end_c = index_r(k+1);
                    block = x(start_r:end_r,start_c:end_c);
                    col_max_b = max(block,[],1);
                    row_max_b = max(block,[],2);
                    v = [v;col_max_b';row_max_b];
                end
            end
        end
    end
    val = v;
end

