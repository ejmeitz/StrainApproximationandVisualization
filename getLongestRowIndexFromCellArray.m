function longestRowIndex = getLongestRowIndexFromCellArray(cellArray)
    
    longestRowIndex = 0;
    
    sizeArray = size(cellArray);
    maxI = sizeArray(1);
    maxJ = sizeArray(2);

     for m = 1:maxI %loop through rows of first frame
          temp = cellArray(m,:,1);
          length = sum(~cellfun(@isempty,temp),2);
          
          if(length == maxJ)
             longestRowIndex = m; 
             return;  %return at first row that is the full length
          end
     end
    

    return;
    
end