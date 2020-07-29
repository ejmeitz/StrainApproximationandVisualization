function deformedCellArray = deformRight(posBoxCellArray, maxRowLength, rightClampPos)
      deformedCellArray = posBoxCellArray;
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
       
       filledClampData = filloutliers(rightClampPos,'makima','gesd');
       smoothClampData = smoothdata(filledClampData, 'movmean',2);
      %dataFit = fit(linspace(1,size(displacement,1),size(displacement,1))',displacement,'poly2');
       
       displacementPerFrame(1,1) = 0; %initialize first element 
       changeFromInit(1,1) = 0;
      for i = 2:length(rightClampPos)
          displacementPerFrame(i,1) = smoothClampData(i,1) -  smoothClampData(i-1,1);
      end
      
      
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array
            displacement = calcBinIncrement(maxRowLength, displacementPerFrame(j,1));
            
         for k = 1:size(posBoxCellArray,1) %loop through each row and apply the displacement
             for h = 2:size(posBoxCellArray,2) %first box always has 0 deformation
                 if(~isempty(posBoxCellArray{k,h,j}))
                      deformedCellArray{k,h,j}(1) =  deformedCellArray{k,h,j}(1) + sum(displacement(2:h-1),1);  %update xloc
                     deformedCellArray{k,h,j}(3) =  deformedCellArray{k,h,j}(3) + displacement(h,1);    %update width
                 end
             end
         end
      end






end