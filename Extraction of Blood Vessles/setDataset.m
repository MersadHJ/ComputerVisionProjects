function Dataset =setDataSet(S_pic,Path_Pic)
k = 1;
    for i=1:numel(S_pic)
        if S_pic(i).isdir == 0
            x = S_pic(i).name;
            I = im2double(imread([Path_Pic S_pic(i).name]));
            Dataset{k,1} = x;
            Dataset{k,2} = I;
            k = k+1;
        end
    end
end