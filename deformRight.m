function deformedCellArray = deformRight(posBoxCellArray, maxRowLength, rightClampPos)
      deformedCellArray = posBoxCellArray;
      
      initialBoxWidth = posBoxCellArray{1,1,1}(3);
      startX = posBoxCellArray{1,1,1}(1);

       
       displacementPerFrame(1,1) = 0; %initialize first element 

      for i = 2:length(rightClampPos)
          displacementPerFrame(i,1) = rightClampPos(i,1) -  rightClampPos(i-1,1);
      end
      
      
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array
            displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j,1));
            
         for r = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
              countRight = 0; %at start of new row reset counts
              startIndex = 1;
             for c = 2:size(posBoxCellArray,2) %first box always has 0 deformation
                 if(~isempty(posBoxCellArray{r,c,j}))
                      if(countRight == 0) %if the first box (in a row not necessarilly furthest left) we look at on the right side
                                startXRight = posBoxCellArray{r,c,j}(1);
                                startIndex = ((startXRight-startX)/initialBoxWidth) + 1;
                       end %without checking this rows that don't start at the center will be displaced incorrectly
                    
                      deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) + sum(displacement(startIndex:c-1),1);  %update xloc
                     deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacement(c,1);    %update width
                     countRight = countRight + 1;
                 end
             end
         end
      end






end