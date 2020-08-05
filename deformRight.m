function deformedCellArray = deformRight(posBoxCellArray, maxRowLength, rightClampPos)
      deformedCellArray = posBoxCellArray;
      
      initialBoxWidth = posBoxCellArray{1,1,1}(3);
      minX = getMinX(posBoxCellArray(:,:,1));  %furthest to the left box
      
      
       displacementPerFrame(1,1) = 0; %initialize first element (first frame always has 0 displacement)

      for i = 2:length(rightClampPos)
          displacementPerFrame(i,1) = rightClampPos(i,1) -  rightClampPos(i-1,1); %calculate the displacement of a frame relative to the previous frame
      end
      
      
      for j = 2:size(posBoxCellArray,3) %loop frames
            displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j,1)); %distribute the deformation of a single frame across the boxes         
         for r = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
              currentIndex = 1; %reset index count at start of row
             for c = 1:size(posBoxCellArray,2)
                 if(~isempty(posBoxCellArray{r,c,j}))
                      if(currentIndex == 1) %if the first box in a row not necessarilly furthest left
                                startX_Of_Row = posBoxCellArray{r,c,1}(1); %do relative to first frame because the others will give decimal values
                                startIndex = ((startX_Of_Row - minX)/initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
                                currentIndex = startIndex; %first box in row is always first element in cell array but it may be the 10th box in the row if no other boxes exist before it so we ne
                       end 
                    
                     deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) + sum(displacement(1:currentIndex),1);  %update xloc
                     deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacement(currentIndex,1);    %update width
                     currentIndex = currentIndex + 1; %update index
                 end
             end
         end
      end






end