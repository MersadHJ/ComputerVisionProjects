% SEAM CARVING
a = dir("./Samples/");
ind = 7;
path = [a(ind).folder '\' a(ind).name];
IS_path = [a(ind+2).folder '\' a(ind+2).name];
ID_path = [a(ind+1).folder '\' a(ind+1).name];
grad_I_path = [a(ind+3).folder '\' a(ind+3).name];

I = imread(path);
IS= imread(IS_path);
ID = (imread(ID_path));
Grad_I = imread(grad_I_path);

%% Back Ground Salt Percentage
sp = 0.1;

%% Fore Ground Pepper Percentage
pp = 0.25;

%% Energy Map
energy_map = DMeng(I,IS,ID,Grad_I,sp,pp);

imwrite(energy_map, ['./Results/' a(ind).name(1:end-4) 'Energy Map.png']);

energy_map = uint64(energy_map);

imshow(energy_map,[]);
title([a(ind).name(1:end-4) ' Energy Map']);
pause(5);

initial_I_length = size(I,1);
initial_I_width = size(I,2);

%% Reduction Factor ({change=50}% Decrease in Width)
change = 50;

%% Auto Crop
crop_change = 0.15*change;

gray_grad_I = rgb2gray(Grad_I);
max_col = 1;
max_val = 0;
window_size = size(I,2) - int16((crop_change/100)*size(I,2));
imgrad = (IS + ID)/2;
for col=1:int16((crop_change/100)*size(I,2))
    sum_grad = sum(sum(energy_map(:,col:col+window_size)));
    if sum_grad > max_val
        max_col = col;
        max_val = sum_grad;
    end
end

I = I(:,max_col:max_col+window_size,:);
energy_map = energy_map(:,max_col:max_col+window_size,:);

%% Seam Carving
while size(I,2)>initial_I_width/(100/(100-change))
    rng('shuffle');
    I_length = size(I,1);
    I_width = size(I,2);

    tmp_pad = padarray(I,[1 1],'replicate','both');
    tmp_pad = tmp_pad(2:end-1,:,:);
    tmp_L = int16(tmp_pad(:,1:end-2,:));
    tmp_R = int16(tmp_pad(:,3:end,:));
    tmp_diff = abs(tmp_R-tmp_L);
    tmp = tmp_diff(:,:,1)+tmp_diff(:,:,2)+tmp_diff(:,:,3);
    tmp = tmp/2;
    tmp = uint64(tmp);

    seam_eng = energy_map + tmp;
    for i=2:I_length
        for j=1:I_width
            if j>1 && j<I_width
                seam_eng(i,j) = energy_map(i,j) + tmp(i,j) +min([seam_eng(i-1,j-1) seam_eng(i-1,j) seam_eng(i-1,j+1)]);
            elseif j==1
                seam_eng(i,j) = energy_map(i,j) + tmp(i,j) + min([seam_eng(i-1,j) seam_eng(i-1,j+1)]);
            else
                seam_eng(i,j) = energy_map(i,j) + tmp(i,j) + min([seam_eng(i-1,j-1) seam_eng(i-1,j)]);
            end
        end
    end

    seam = zeros(1,I_length);

    minseam = min(seam_eng(end,:));
    new_j = find(seam_eng(end,:)==minseam);
    j = new_j(randperm(size(new_j,2),1));

    for new_i=1:I_length-1
        i = I_length-new_i+1;
        seam(1,i)=j;
        minseam = minseam - tmp(i,j);
        minseam = minseam - energy_map(i,j);
        new_j = find(seam_eng(i-1,:)==minseam);
        new_j = new_j(abs(new_j-j)<=1);
        choice = randperm(size(new_j,2),1);
        j = new_j(choice);
    end

    seam(1,1) = j;

    for i=1:I_length
        I(i,seam(1,i),:) = [255 0 0];
    end
    imshow(I,[]);

    for i=1:I_length
        I(i,seam(1,i):end-1,:) = I(i,seam(1,i)+1:end,:);
        energy_map(i,seam(1,i):end-1) = energy_map(i,seam(1,i)+1:end);
    end

    I = I(:,1:end-1,:);
    energy_map = energy_map(:,1:end-1);
end

%% Showing and Saving Results
imshow(I,[]);
title(['Final Result: ' num2str(change) '% Reduction in Width']);

imwrite(I,['./Results/' a(ind).name(1:end-4) '[' num2str(change) '% Width Reduction].png']);

