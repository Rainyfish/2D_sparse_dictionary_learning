
    addpath(genpath(cd));
    opts.tol = 1e-6;
    opts.max_iter = 1000;
    opts.rho = 1.1;
    opts.mu = 1e-4;
    opts.max_mu = 1e10;
    opts.DEBUG = 0;
    lambda = 0.01;
    opts.loss = 'l2'; 
    all_res = {};
x = all_ts_data{2}.fea{2};
A = dictionary{2}.A;
B = dictionary{2}.B;



%         A =rand([32,48]);
A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
%         B =rand([48,32]);
 B = B./repmat(sqrt(sum(B.^2,2)),1,size(B,2));
x_v = reshape(x,[],1);
D = kron(B',A);
all_kron=[];
    for i = 1:nclass
        A = dictionary{i}.A;
        B = dictionary{i}.B;
        A = A./repmat(sqrt(sum(A.^2,1)),size(A,1),1);
        B = B./repmat(sqrt(sum(B.^2,1)),size(B,1),1);
        kron_D = kron(B',A);
        all_kron = [all_kron,kron_D];
    end
beta_v = l1R(all_kron,x_v,lambda,opts);
beta_v(find(abs(beta_v)<0))=0;
re = all_kron*beta_v;

re  = reshape(re,size(x));

%re = A*beta*B;
%new_re = mapminmax(re,0,255);
figure;
subplot(1,3,1);
imshow(x);
new = mapminmax((x-re),0,1);
subplot(1,3,2);
imshow(new);
subplot(1,3,3);
imshow(re);