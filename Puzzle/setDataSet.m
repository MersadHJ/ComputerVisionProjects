function FeatureDataset =setDataSet(S_Puzzle,Path_Puzzle)
k = 1;
    for i=1:numel(S_Puzzle)
        if S_Puzzle(i).isdir == 0
            x = S_Puzzle(i).name;
            I = imread([Path_Puzzle S_Puzzle(i).name]);
            FeatureDataset{k,1} = S_Puzzle(i).name;
%            if S_Puzzle(i).name
            Answer = S_Puzzle(i).name(find(S_Puzzle(i).name == '_', 1, 'first') + 1: end-4);
            FeatureDataset{k,2} = str2num(Answer);
            
            Answer=extractBetween(S_Puzzle(i).name,'_','_');
            FeatureDataset{k,3} = Answer;
            if ~isempty( Answer ) 
            FeatureDataset{k,3} = str2num(Answer{1});
            end
            Answer = S_Puzzle(i).name(find(S_Puzzle(i).name == '_', 1, 'last') + 1: end-4);
            FeatureDataset{k,4} = str2num(Answer);
            FeatureDataset{k,5} = I;
            k = k + 1;     
        end
    end
end