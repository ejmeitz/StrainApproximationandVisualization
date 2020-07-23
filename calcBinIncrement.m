%calculates the distribution of displacement for a frame

function displacement = calcBinIncrement(numBoxesInRow, totalDisplacement)

    %we want x-intercept at x = 1 so the first bin will always be 0
    distributionFunc = @(binNum) 0.5 * (binNum - 1);
  

    displacement = zeros(numBoxesInRow,1);
   

    %this will be the displacement for each box in the row per frame
    for i = 1:numBoxesInRow 
        displacement(i,1) = distributionFunc(i);  %initialize displacement value      
    end
    
    total = sum(displacement(:,1));
    
    for i = 1:numBoxesInRow
        displacement(i,1) = displacement(i,1) / double(total);      %change value to percentange of total deformation for that frame
        displacement(i,1) = displacement(i,1) * totalDisplacement;   %multiply percent by total displacement for that frame
    end
    
     
    
    return;

end