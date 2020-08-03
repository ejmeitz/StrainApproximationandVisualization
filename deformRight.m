function deformedCellArray = deformRight(posBoxCellArray, maxRowLength, rightClampPos)
      deformedCellArray = posBoxCellArray;
      
      initialBoxWidth = posBoxCellArray{1,1,1}(3);
      startX = getMinX(posBoxCellArray(:,:,1));  %furthest to the left box

       
       displacementPerFrame(1,1) = 0; %initialize first element 

      for i = 2:length(rightClampPos)
          displacementPerFrame(i,1) = rightClampPos(i,1) -  rightClampPos(i-1,1);
      end
      
      
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array
            displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j,1));
            
         for r = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
              currentIndex = 1; %first box in row is always first element but it may be the 10th box in the row if no other boxes exist before it
             for c = 1:size(posBoxCellArray,2)
                 if(~isempty(posBoxCellArray{r,c,j}))
                      if(currentIndex == 1) %if the first box in a row not necessarilly furthest left
                                startXRow = posBoxCellArray{r,c,j}(1);
                                startIndex = ((startXRow-startX)/initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
                                currentIndex = startIndex;
                       end 
                    
                     deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) + sum(displacement(1:currentIndex),1);  %update xloc
                     deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacement(currentIndex,1);    %update width
                     currentIndex = currentIndex + 1;
                 end
             end
         end
      end






end