clc; clear; close all;
I = im2double(imread('Q2/Cells.tif'));
Path = 'CV_HW3_Q4.xlsx';

Thresh = adaptthresh(I,0.02);
I1 = imbinarize(I,Thresh);

thresh = multithresh(I,1);
I2 = imquantize(I,thresh);


SE = strel('disk',1);
I3= imopen(I1+I2,SE);
I3 (I3==1) = 0;
I3 (I3 > 1) = 1;
imshow(I3);
count = Cell_Count(I3);
table= get_area(I3,Path);
function Count= Cell_Count(I2)
j1 = size(I2,1);
j2 = size(I2,2);
Count = 0;
for i=1:j1
   for j=1:j2
      if I2(i,j)==1
         area = 0;
         queue = [];
         queue(end+1,:) = i;
         queue(end+1,:) = j;
         while numel(queue)~=0
            y = queue(end);
            queue(end) = [];
            x = queue(end);
            queue(end)=[];
            area= area+1;
            I2(x,y)= 0;
                    if x > 1 && y > 1 && I2(x-1,y-1) == 1
                            queue(end+1) = x-1;
                            queue(end+1) = y-1;
                     end
                     if x > 1 && I2(x-1,y) == 1
                            queue(end+1) = x-1;
                            queue(end+1) = y;
                     end
                     if x > 1 && y < j2 && I2(x-1,y+1) == 1
                            queue(end+1) = x-1;
                            queue(end+1) = y+1;
                     end
                     if y > 1 && I2(x,y-1) == 1
                            queue(end+1) = x;
                            queue(end+1) = y-1;
                     end
                     if y < j2 && I2(x,y+1) == 1
                            queue(end+1) = x;
                            queue(end+1) = y+1;
                     end
                     if x < j1 && y > 1 && I2(x+1,y-1) == 1
                            queue(end+1) = x+1;
                            queue(end+1) = y-1;
                     end
                     if x < j1 && I2(x+1,y) == 1
                            queue(end+1) = x+1;
                            queue(end+1) = y;
                     end
                     if x < j1 && y < j2 && I2(x+1,y+1) == 1
                            queue(end+1) = x+1;
                            queue(end+1) = y+1;
                     end
  
         end
        if area > 2
                   Count = Count + 1;
        end
      end
       
       
   end
end    
    
end
function excel= get_area(I2,Path)
excel = [];
j1 = size(I2,1);
j2 = size(I2,2);
Count = 0;
for i=1:j1
   for j=1:j2
      if I2(i,j)==1
         area = 0;
         SUM = 0;
         Queue = [];
         Queue(end+1,:) = i;
         Queue(end+1,:) = j;
         while numel(Queue)~=0
            y = Queue(end);
            Queue(end) = [];
            x = Queue(end);
            Queue(end)=[];
            area= area + 1;
            SUM = SUM + I2(x,y);
            I2(x,y)= 0;
            
                    if x > 1 && y > 1 && I2(x-1,y-1) == 1
                            Queue(end+1) = x-1;
                            Queue(end+1) = y-1;
                     end
                     if x > 1 && I2(x-1,y) == 1
                            Queue(end+1) = x-1;
                            Queue(end+1) = y;
                     end
                     if x > 1 && y < j2 && I2(x-1,y+1) == 1
                            Queue(end+1) = x-1;
                            Queue(end+1) = y+1;
                     end
                     if y > 1 && I2(x,y-1) == 1
                            Queue(end+1) = x;
                            Queue(end+1) = y-1;
                     end
                     if y < j2 && I2(x,y+1) == 1
                            Queue(end+1) = x;
                            Queue(end+1) = y+1;
                     end
                     if x < j1 && y > 1 && I2(x+1,y-1) == 1
                            Queue(end+1) = x+1;
                            Queue(end+1) = y-1;
                     end
                     if x < j1 && I2(x+1,y) == 1
                            Queue(end+1) = x+1;
                            Queue(end+1) = y;
                     end
                     if x < j1 && y < j2 && I2(x+1,y+1) == 1
                            Queue(end+1) = x+1;
                            Queue(end+1) = y+1;
                     end
  
         end
        if area > 2
              excel(end+1,:)= [area,255*SUM/area];
              
        end
      end
       
       
   end
end    

writematrix(excel,Path);



end