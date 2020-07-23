function deformedCellArray = deformLeft(posBoxCellArray, longestRowIndex, maxRowLength, leftClampPos)
      deformedCellArray = posBoxCellArray;
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
      
       smoothClampData = smoothdata(leftClampPos, 'movmean',5);
       
       displacementPerFrame(1,1) = 0; %initialize first element 
      for i = 2:length(leftClampPos)
          displacementPerFrame(i,1) = smoothClampData(i-1,1) -  smoothClampData(i,1);
      end
      
      
      for j = 1:(size(posBoxCellArray,3)-1) %for each frame calculate new displacemenet array
         displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j+1,1));
         displacement = flipud(displacement);
         for k = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
             for h = 1:(size(posBoxCellArray,2)-1) %last box always has 0 deformation
                 if(~isempty(posBoxCellArray{k,h,j}))
                     deformedCellArray{k,h,j}(1) =  deformedCellArray{k,h,j}(1) - displacement(h,1);  %update xloc
                     deformedCellArray{k,h,j}(3) =  deformedCellArray{k,h,j}(3) + displacement(h,1);    %update width
                 end
             end
         end
         
      end





end