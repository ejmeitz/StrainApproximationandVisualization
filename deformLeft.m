function deformedCellArray = deformLeft(posBoxCellArray, maxRowLength, leftClampPos)
      deformedCellArray = posBoxCellArray;  %in final dont make a copy
       startX = getMinX(posBoxCellArray(:,:,1));
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
      
%         filledClampData = filloutliers(leftClampPos,'makima','gesd');
%        smoothClampData = smoothdata(filledClampData, 'movmean',2);
     
       
       
       displacementPerFrame(1,1) = 0; %initialize first element 
      for i = 2:length(leftClampPos)
          displacementPerFrame(i,1) = leftClampPos(i,1) -  leftClampPos(i-1,1);
      end
      
      
      for j = 1:(size(posBoxCellArray,3)-1) %for each frame calculate new displacemenet array
         displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j+1,1));
         for r = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
              currentIndex = currentIndex + 1;
             for c = (size(posBoxCellArray,2)-1):-1:1 %loop from right to left since left is fixed point now
                 if(~isempty(posBoxCellArray{r,c,j}))
                     if(currentIndex == 1) %if the first box in a row not necessarilly furthest left
                                startXRow = posBoxCellArray{r,c,j}(1);
                                startIndex = ((startXRow-startX)/initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
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