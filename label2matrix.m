function matrix = label2matrix(all_tr_data)
    [a,b]=size(all_tr_data);
    matrix =[];
    for i = 1:b
        [row,col] = size(all_tr_data{i}.fea);
        mat = zeros(b,col);
        mat(i,:) =1;
        matrix = [matrix,mat];
    end
    matrix;
end
