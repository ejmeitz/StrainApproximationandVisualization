function displacement = calcBinIncrement(numBoxesInRow, totalDeformation, numFrames)

     averageDisplacement = double(totalDeformation) / double(numBoxesInRow);
 
    weightingFunction = @(binNum) averageDisplacement / double(binNum);

  

    displacement = averageDisplacement*ones(numBoxesInRow,1);
   
    %start the array as an even distribution where each valuye is the average displacement e.g. :  1 1 1 1 1
    %then take from the left and add to the right so that the sum remains the
    %same e.g 0 0.5 1 1.5 2  --> sum is still 5



    %this will be the displacement for each box in the row per frame
    for i = 1: fix(numBoxesInRow / 2) %if odd middle one is ignored so it doesn't matter that we skip it

       original = displacement(i,1);
       weight = weightingFunction(i);

       displacement(numBoxesInRow - i + 1) =  (displacement(i,1) + weight ) / double(numFrames);  %element mirrored in array from disp(i)
       displacement(i,1) = double(original - weight)/ double(numFrames);
    end
    
    return;

end