function [ all_sparse ] = getblock_xii( all_tr_beta,DD_R,dictionary)
%GETBLOCK_XII 
%split the a image sparse vector to nclass slices , slices i stands
%for the sparse vector under the dictionaries items of class i.change the slices to 2D sparse matrix respectively
    for i =1:length(all_tr_beta) 
        A = dictionary{i}.A;
        for j = 1:length(all_tr_beta)
            %find the sparse vectors images belong to class i under dictionary of class j
            %for example all_tr_beta{1} is all the sparse vectors of class
            %one all_tr_beta{1}{1} is the sparse vector of image 1 under
            %general dictionarys.the first sliece of the vector is the
            %sparse vector under dictionary one.
            sparse =cellfun(@(x)get_ii(x,DD_R,j),all_tr_beta{i},'un',0);
            %all_sparse rows stands for image from different classes 
            %all_sparse cols stands form sparse vectors under different
            %class dictionaries 
            all_sparse{i,j} = cellfun(@(x)reshape(x,size(A,2),[]),sparse,'un',0);
        end
    end
end
function x=get_ii(x,DD_R,i)
   % x is the sparse vector x =[alph_1;alph_2,...alph_i,...]
   % alph_i is the sparse vector under dictionary i 
    x = x(DD_R(i)+1:DD_R(i+1));
end

