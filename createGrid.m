%iterates through the array of positive boxes and counts how many are
%positive ...can't use sum(A,dim) because the array is 1D despite the boxes
%being 2D

function positiveCountByRow = createGrid (posBoxArray)


positiveCountByRow = [];
k = 1;
count = 0;

    for i = 1:length(posBoxArray)
        
        if(i > 1)
            if(posBoxArray(i , 2) < posBoxArray(i-1 , 2) || posBoxArray(i , 2) > posBoxArray(i-1 , 2))  %this will break if height changes across a row
               k = k + 1;
               count = 0;
            end
        end
        
        
        count = count + 1;
        positiveCountByRow(k) = count;
        
       
  
    end

    return;
end