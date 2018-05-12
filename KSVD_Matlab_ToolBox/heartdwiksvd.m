%============================================================
%               demo2 - denoise an image
% this is a run_file the demonstrate how to denoise an image, 
% using dictionaries. The methods implemented here are the same
% one as described in "Image Denoising Via Sparse and Redundant
% representations over Learned Dictionaries", (appeared in the 
% IEEE Trans. on Image Processing, Vol. 15, no. 12, December 2006).
%============================================================

clear
bb=8; % block size
RR=4; % redundancy factor
K=RR*bb^2; % number of atoms in the dictionary

load('T2_15_29_3.mat');
img=M;
sigma=20;
[Iout,output] = denoiseImageKSVD(img,sigma,K);

load('T2_15_29_3ROI1.mat');
load('T2_15_29_3ROI2.mat');
roi1DE=Iout(roigray1>0);
roi2DE=Iout(roigray2>0);
sigmaDE=std2(roi1DE)/.655;
SNRDE=10*log10(mean(roi2DE).^2/sigmaDE.^2);
CNRDE=(mean(roi2DE)-mean(roi1DE))/sqrt(var(roi2DE)+var(roi1DE));

figure;
subplot(1,2,1); imshow(img,[]); title('Original clean image');
subplot(1,2,2); imshow(Iout,[]); 
