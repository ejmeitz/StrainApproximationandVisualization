function deformedPosBoxArray = cellArrayBackToArray(deformedCellArray, allPosXLength)

 
    
    
    sizeArray = size(deformedCellArray);
    rows = sizeArray(1);
    cols = sizeArray(2);
    depth = sizeArray(3);

   deformedPosBoxArray = zeros(allPosXLength,7,depth);
   
    for j = 1:depth %for each frame calculate new displacemenet array
        count = 1;
         for k = 1:rows %loop through each row and apply the displacement
             for h = 1:cols %last box always has 0 deformation
                 if(~isempty(deformedCellArray{k,h,j}))
                    deformedPosBoxArray(count ,1, j) = deformedCellArray{k,h,j}(1);
                    deformedPosBoxArray(count ,2 , j) = deformedCellArray{k,h,j}(2);
                    deformedPosBoxArray(count ,3 , j) = deformedCellArray{k,h,j}(3);
                    deformedPosBoxArray(count ,4 , j) = deformedCellArray{k,h,j}(4);
                    count = count + 1;
                 end
             end
         end
         
    end











end