function energy_map = DMeng(I,IS,ID,Grad_I,sp,pp)
    %% Image Thresholding Using Otsu
    thresh = multithresh(ID,3);
    ID_thresh = imquantize(ID,thresh);

    %% Creating Fore Ground & Back Ground Mask
    maskforeground = ID_thresh>2;
    maskbackground = ID_thresh<=2;

    %% Back Ground Salt Add
    noised_img = logical(imnoise(uint8(maskforeground),"salt & pepper",sp));
    saltbackground = noised_img&maskbackground;
    
    %% Fore Ground Pepper Add
    noised_img = logical(imnoise(uint8(maskforeground),"salt & pepper",pp));
    pepperforeground = maskforeground&noised_img;

    %% Vertical Edge Detection
    h1 = zeros(10,3);
    h1(:,1) = -1;
    h1(:,2) = 0;
    h1(:,3) = 1;

    verticalEdgeImage = imfilter(I,h1,"replicate");
    EdgeImage = (uint8(verticalEdgeImage /3).* uint8(maskbackground));
    
    %% Creating The Final Energy
    ID = ID + uint8(Grad_I(:,:,1))/4;
    ID(saltbackground==1) = 255;
    ID = ID.*uint8(pepperforeground) + ID.*uint8(maskbackground);
    
    energy_map = ID+rgb2gray(EdgeImage);
end