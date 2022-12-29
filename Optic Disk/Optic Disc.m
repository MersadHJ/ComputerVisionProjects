clc; clear; close all;
I1 = im2double(imread('D:\Term8\Computer Vision\CV_HW_6\DRIVE\Test\images\01_test.tif'));
M1 = im2double(imread('D:\Term8\Computer Vision\CV_HW_6\DRIVE\Test\mask\01_test_mask.gif'));
J1 = I1 .* M1 ;
I2 = im2double(imread('D:\Term8\Computer Vision\CV_HW_6\DRIVE\Training\images\25_training.tif'));
M2 = im2double(imread('D:\Term8\Computer Vision\CV_HW_6\DRIVE\Training\mask\25_training_mask.gif'));
J2 = I2 .* M2 ;
Optic_Disk(J1);
Optic_Disk(J2);
function Optic_Disk(I)
% i found this values by analyzing pictures with imtool
   J = I(:,:,1) > 0.85 | I(:,:,2) > 0.46 | I(:,:,3) > 0.23;
   K = imclose(imopen(J,strel('disk', 2)),strel('disk',1));
   N = size(K,1);
   M = size(K,2);
  % figure,imshow(K);
   L = zeros(11,N,M);
   for i=1:N
       for j=1:M
           if K(i,j)
               for k=40:50
                   for teta=0:360
                       x = round(i +k*cosd(teta));
                       y = round(j+ k*cosd(teta));
                     %  disp([x y]);
                       if x > 0 && y > 0 && x < N && y < M
                           L(k+1-40,x,y) = L(k+1-40,x,y) + 1;
                       end
                   end
               end
           end
       end
   end
   [vr, r] = max(L);
    [vc, c] = max(vr);
    [v, k] = max(vc);
    c = c(1, 1, k);
    r = r(1, c, k);
    disp([c k v ]);
    max_val =0 ;
    max_r = 0;
    for r=1:11
        if max_val<= L(r,c,k)
            max_val= L(r,c,k);
            max_r = r;
        end
    end
   for i=1:N
       for j=1:M
           if round(sqrt(((i-c)^2) + ((j-k)^2))) == max_r + 39 
               I(i,j,1) = 1;
               I(i,j,2) = 1;
               I(i,j,3) = 0;

           end
       end
   end

   figure,imshow(I);
end