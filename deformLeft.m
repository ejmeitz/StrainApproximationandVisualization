function deformedCellArray = deformLeft(posBoxCellArray, maxRowLength, leftClampPos)
      deformedCellArray = posBoxCellArray;  %in final dont make a copy
       minX = getMinX(posBoxCellArray(:,:,1));
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
 
  
       displacementPerFrame(1,1) = 0; %initialize first element 
      for i = 2:length(leftClampPos)
          displacementPerFrame(i,1) = leftClampPos(i,1) -  leftClampPos(i-1,1); %calculate the total displacement that occured in each frame relative to the previous frame
      end
      
      
      for j = 1:size(posBoxCellArray,3) %loop frames
         displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j,1)); %distribute the deformation of a single frame across the boxes
         for r = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
              currentIndex = currentIndex + 1;
             for c = size(posBoxCellArray,2):-1:1 %loop from right to left since right is fixed point now
                 if(~isempty(posBoxCellArray{r,c,j}))
                     if(currentIndex == 1) %if the first box in a row that doesn't mean it's furthest left in the image
                                startX_Of_Row = posBoxCellArray{r,c,1}(1); %do relative to first frame because the others will give decimal values
                                startIndex = ((startX_Of_Row - minX)/ initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
                                currentIndex = startIndex;
                      end 
                     deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) - sum(displacement(1:currentIndex,1));  %update xloc
                     deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacement(currentIndex,1);    %update width
                     currentIndex = currentIndex + 1;
                 end
             end
         end
         
      end





end