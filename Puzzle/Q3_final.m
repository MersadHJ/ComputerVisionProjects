clc; clear; close all;
Path_Puzzle= 'D:\Term8\Computer Vision\CV_HW_4\Q3\Puzzle_4_160\';
Path_Answer = 'D:\Term8\Computer Vision\CV_HW_4\';
S_Puzzle = dir(Path_Puzzle);
S_Sum = dir(Path_Answer);
FeatureDataset = setDataSet(S_Puzzle,Path_Puzzle);
length =abs(FeatureDataset{2,4}-FeatureDataset{1,4})+1;
width = abs(FeatureDataset{3,3}-FeatureDataset{1,3})+1;
block_m =size(FeatureDataset{1,5},1);
block_n = size(FeatureDataset{1,5},2);
%creating output image with given Corners
answers = cell(width,length,5);
features = cell(width,length);
for i=1:width*length-4
     [FeatureDataset{i+6,6},FeatureDataset{i+6,7},FeatureDataset{i+6,8},FeatureDataset{i+6,9}]= extract_features(FeatureDataset{i+6,5});
end
for i=1:width
    for j=1:length
    answers{i,j,1} = uint8(zeros(block_m,block_n,3));
    end
end

for i=1:4
 I = (FeatureDataset{i,5});
  [FeatureDataset{i,6},FeatureDataset{i,7},FeatureDataset{i,8},FeatureDataset{i,9}]=extract_features(FeatureDataset{i,5});
 answers{FeatureDataset{i,3},FeatureDataset{i,4},1}= I;
 answers{FeatureDataset{i,3},FeatureDataset{i,4},2}= FeatureDataset{i,6};
 answers{FeatureDataset{i,3},FeatureDataset{i,4},3}= FeatureDataset{i,7};
 answers{FeatureDataset{i,3},FeatureDataset{i,4},4}=FeatureDataset{i,8};
 answers{FeatureDataset{i,3},FeatureDataset{i,4},5}=FeatureDataset{i,9};

 %features{FeatureDataset{i,3},FeatureDataset{i,4}} = extract_features(FeatureDataset{i,5});
end

%first row
idx = -5;
for i=1:width
    for j=1:length
    temp = [];
   if (i==1 &&j==1)||(i==width&&j==1)||(i==1&&j==length)||(i==width&&j==length)
       
    continue
   else
       for k=1:width*length-4
        temp(k)=0;
        if ~isempty(FeatureDataset{k+6,5})
            if (i-1>=1)
                if(sum(answers{i-1,j})~=0)
            temp(k) = temp(k)+norm(FeatureDataset{k+6,6}-answers{i-1,j,3});
                end
            end
            if(i+1<=width)
                if(sum(answers{i+1,j})~=0)
                temp(k) = temp(k)+ norm(FeatureDataset{k+6,7}-answers{i+1,j,2});
                end
            end
            if(j-1 >= 1)
                 if(sum(answers{i,j-1})~=0)
                    temp(k) = temp(k)+ norm(FeatureDataset{k+6,8}-answers{i,j-1,5});
                 end
            end
            if(j+1 <= length)
                 if(sum(answers{i,j+1})~=0)
                    temp(k) = temp(k)+ norm(FeatureDataset{k+6,9}-answers{i,j+1,4});
                 end
            end
            else 
            temp(k) = 100000;
        end
    
    end
    [minx,idx] = min(temp);
    answers{i,j,1} = FeatureDataset{idx+6,5};
    answers{i,j,2}= FeatureDataset{idx+6,6};
    answers{i,j,3}= FeatureDataset{idx+6,7};
    answers{i,j,4}=FeatureDataset{idx+6,8};
    answers{i,j,5}=FeatureDataset{idx+6,9};
    FeatureDataset{idx+6,5} = [];
    
    t_ans = answers(:,:,1);
    imshow(cell2mat(t_ans),[]);
   end
    end
end
