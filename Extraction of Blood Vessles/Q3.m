clc; clear; close all;
Path_Pic= 'D:\Term8\Computer Vision\CV_HW_5\Q3\DRIVE\Test\images\';
Path_Mask = 'D:\Term8\Computer Vision\CV_HW_5\Q3\DRIVE\Test\mask\'
Path_GT = 'D:\Term8\Computer Vision\CV_HW_5\Q3\DRIVE\Test\1st_manual\';
S_Pic = dir(Path_Pic);
S_Mask = dir(Path_Mask);
S_GT = dir(Path_GT);
Test_Dataset = setDataset(S_Pic,Path_Pic);
Mask_Dataset = setDataset(S_Mask,Path_Mask);
GT_Dataset = setDataset(S_GT,Path_GT);
for i=1:20
% Green channel has more contrast with background and fits better for our
% purpose
I = Test_Dataset{i,2};
mask = Mask_Dataset{i,2};
gt = GT_Dataset{i,2};
%I = im2double(imread('D:\Term8\Computer Vision\CV_HW_5\Q3\DRIVE\Test\images\03_test.tif'));
%mask = im2double(imread('D:\Term8\Computer Vision\CV_HW_5\Q3\DRIVE\Test\mask\03_test_mask.gif'));
%gt = im2double(imread('D:\Term8\Computer Vision\CV_HW_5\Q3\DRIVE\Test\1st_manual\03_manual1.gif'));
G = (I(:,:,2));
%G=imsharpen(G,'Radius',1,'Amount',0.3);
% GrayScale Image Enhancement using CLAHE

J = adapthisteq(G,'numTiles',[8 8],'nBins',128);

J  = J.*mask;
im_gray = imcomplement(J);
se = strel('square',2);

% top hat morphological filtering
im_top= im_gray-imopen(im_gray,se);
se = strel ('disk',6);
im_top_2 = im_gray- imopen(im_gray,se);
im_top_3 = abs(im_top - im_top_2);
imtop = im_top + im_top_2;
im_top =  imtop+(imtop- im_top_3);
gamma = 0.8;
im_top = (1 ^(1-gamma) ).*(im_top).^gamma;

%imshow([im_top im_top_1 im_top_2]);
x = graythresh(im_top);
BW = im2bw(im_top,x);
BW2 = bwareaopen(BW, 30,4);
BW2 = bwareaopen(BW2, 60,8);
BW2(:,end-20:end) = 0;
BW2(:,1:20) = 0;
BW2(1:20,:)=0;
BW2(end-20:end,:)=0;
BW2 = double(BW2);

imshow(BW2);

[se,sp,acc] = measure(BW2,gt);
SE{i,1} = se;
SP {i,1} = sp;
ACC{i,1} = acc;

end

m = mean(cell2mat(ACC));
se = mean(cell2mat(SE));
sp = mean(cell2mat(SP));
AAVG = (m+se+sp)/3;
disp("Average");
disp(["Sensitivity" se]);
disp(["Specificity" sp]);
disp(["Accuracy" m]);
disp(["AVERAGE ALL THREE" AAVG]);