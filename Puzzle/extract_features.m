function [Top,Down,Left,Right]=extract_features(img)

    Cropped = img(1:1,:,:);

    Top = double(transpose((Cropped(:))));

    Cropped = img(size(img,1)  :end,:,:);

    Down = double(transpose(Cropped(:)));
    
    Cropped = img(:,1:1,:); 

    Left = double(transpose(Cropped(:))) ;
    
    Cropped = img(:,size(img,2) :end,:); 

    Right = double(transpose(Cropped(:))) ;

 
end