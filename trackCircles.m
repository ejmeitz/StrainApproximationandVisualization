function trackedCircleLocations = trackCircles  (s0, threshUp, threshDown, chosenCircles)

    %these settings must match settings in "pickCircles.m"
    brushSize = 4;
    minRad = 18;
    maxRad = 100;
    
    brush = strel('disk', brushSize);

    
  

    trackedCircleLocations = ones(2,2,size(s0,3));
    h = waitbar(0,'Tracking circles...');
    for i = 1:size(s0,3)
        
        eroded = imerode(s0(:,:,i),brush);
        Iobr = imreconstruct(eroded,s0(:,:,i));

        %apply thresholds to whole s0 video
        thresh_img = (Iobr <= threshUp) & (Iobr >= threshDown);

         %fill in holes in image so circle alg works better
        filled_img = imfill(thresh_img, 8, 'holes');
   
        [centers,radii] = imfindcircles(filled_img, [minRad maxRad]);
      
        %loop through all found circles and find the two closest to the
        %originally chosen circles
           closestIndex1 = 0;
           closestIndex2 = 0;
           
           currentClosest1 = Inf;
           currentClosest2 = Inf;
        for j = 1:length(centers)
          
           dist1 = abs(centers(j,1) - chosenCircles(1,1)); %calculate x-distance to chosen circles
           dist2 = abs(centers(j,1) - chosenCircles(2,1));
          
           if(dist1 < currentClosest1)  %comapre x-distance with current closest distance
               closestIndex1 = j;
               currentClosest1 = dist1;
           end
           if(dist2 < currentClosest2)
               closestIndex2 = j;
               currentClosest2 = dist2;
           end
  
        end
        trackedCircleLocations(1,1,i) = centers(closestIndex1, 1); %add new x loc of circle to array
        trackedCircleLocations(2,1,i) = centers(closestIndex2, 1);
        
        waitbar(i/size(s0,3),h)
    end
    close(h);
    return;
end