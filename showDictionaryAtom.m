function [ output_args ] = showDictionaryAtom( dictionary )
%SHOWDICTIONARYATOM 此处显示有关此函数的摘要
%   此处显示详细说明
    A = dictionary{1}.A;
    B = dictionary{1}.B;
    imshow(A);
    figure;
    hold on;
    imshow(B);
    
    DD = kron(B',A);
    DD  = DD./repmat(sqrt(sum(DD.^2,1)),size(DD,1),1);
    imshow(DD);
    len = size(DD,2);
    wide =ceil(len/5);
    cout = 1;
    for i = 1:25
        atom = DD(:,i);
        atom = reshape(atom,32,32);
        subplot(5,5,cout);
        imshow(atom);
        cout = cout+1;
    end


end

