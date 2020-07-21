
sizeArray = size(posBoxCellArray);
maxI = sizeArray(1);
maxJ = sizeArray(2);

    for i = 1:maxI
        for j = 1:maxJ
             if(~isempty(posBoxCellArray{i,j,1}))
                rectangle('Position', posBoxCellArray{i,j,1});          %draw rect
             end
        end

    end
    
    
