%Calculates the displacement of a row of bins according to a given
%distribution function. The function returns an array of the displacement
%per frame of each bin in the row

function displacement = calcBinIncrement(numBoxesInRow, totalDeformation, numFrames)

    %we want x-intercept at x = 1 so the first bin will always be 0
    distributionFunc = @(binNum) 0.5 * (binNum - 1);
  

    displacement = zeros(numBoxesInRow,1);
   

    %this will be the displacement for each box in the row per frame
    for i = 1:numBoxesInRow 
        displacement(i,1) = distributionFunc(i);  %initialize displacement value      
    end
    
    total = sum(displacement(:,1));
    
    for i = 1:numBoxesInRow
        displacement(i,1) = displacement(i,1) / double(total);      %change value to percentange
        displacement(i,1) = displacement(i,1) * totalDeformation;   %scale so sum of deformations adds to correct total
        displacement(i,1) = displacement(i,1) / numFrames;          %change to be displacement per frame
    end
    
    
    
    return;

end