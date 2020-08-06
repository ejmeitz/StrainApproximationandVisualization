function [trackedCircleLocations, circleFrames] = trackCircles  (scaled_s0, threshUp, threshDown, chosenCircles, numCirclesFound)  
    
    centers = [];
    circleFrames = [];
    clear('circleFrames');
    %these settings must match settings in "pickCircles.m"
    brushSize = 4;
    minRad = 18;  %for strain beads use smaller dimensions
    maxRad = 60;
    
    brush = strel('disk', brushSize);

    trackedCircleLocations = ones(2,size(scaled_s0,3));
    updateWaitbar = waitbarParfor(size(scaled_s0,3), "Tracking Circles");
    
    f = figure(1);
    for i = 1:size(scaled_s0,3)
        
        eroded = imerode(scaled_s0(:,:,i),brush);
        Iobr = imreconstruct(eroded,scaled_s0(:,:,i));

        %apply thresholds to whole s0 video
        thresh_img = (Iobr <= threshUp) & (Iobr >= threshDown);

         %fill in holes in image so circle alg works better 
         noNoise = medfilt2(thresh_img);
        filled_img = imfill(noNoise, 4, 'holes');
       
        
        [centers,radii] = imfindcircles(filled_img, [minRad maxRad]);
        
        imshow(Iobr);
        viscircles(centers,radii); %show circles
        hold on;
        plot(centers(:,1),centers(:,2),'r*');
        
        circleFrames(i) = getframe(f);
        clf(f);
        
        
        %loop through all found circles and find the two closest to the
        %originally chosen circles
           closestIndex1 = 0;
           closestIndex2 = 0;
           
           currentClosest1 = Inf;
           currentClosest2 = Inf;
        for j = 1:length(centers)
          
           dist1 = sqrt((centers(j,1) - chosenCircles(1,1))^2) + ((centers(j,2) - chosenCircles(1,2))^2);
           dist2 = sqrt((centers(j,1) - chosenCircles(1,1))^2) + ((centers(j,2) - chosenCircles(2,2))^2);
          % dist1 = (centers(j,1) - chosenCircles(1,1)); %calculate distance to chosen circles
          % dist2 = (centers(j,1) - chosenCircles(2,1));
          
           if(dist1 < currentClosest1)  %comapre x-distance with current closest distance
               closestIndex1 = j;
               currentClosest1 = dist1;
           end
           if(dist2 < currentClosest2)
               closestIndex2 = j;
               currentClosest2 = dist2;
           end
  
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % This check usually detects the issue but the mask is usually
     % unfixable and will just get stuck in an infinite loop
     
     %It seems that leaving the holes and filling the outliers later works
     %pretty well..alternately could use this detection and somehow figure
     %out what the value should be
        %%%%%%%%%%%%%%%%%%%%%
        
        
        %try again if picked the wrong circle
%         while(currentClosest1 >= 15 || currentClosest2 >= 15)  %if this is true it probably picked the wrong circle, 15 is totally arbitrary change as needed anything smaller is to small (I tested)
%              warning("Image mask was not good enough to find circles. Try changing the mask");
%             [threshUp, threshDown] =  slideThresh_E(Iobr); %this should update in main function body?
%              thresh_img = (Iobr <= threshUp) & (Iobr >= threshDown); 
% 
%          %remake all images and find circles with new mask 
%             noNoise = medfilt2(thresh_img);
%             filled_img = imfill(noNoise, 4, 'holes');
%             [centers,radii] = imfindcircles(filled_img, [minRad maxRad]);
%             
%             imshow(Iobr);
%             viscircles(centers,radii); 
%             hold on;
%             plot(centers(:,1),centers(:,2),'r*');
%             circleFrames(i) = getframe(f); %change frame to new choice
%             clf(f);
%             
%                 closestIndex1 = 0;
%                 closestIndex2 = 0;
% 
%                 currentClosest1 = Inf;
%                 currentClosest2 = Inf;
%             for j = 1:length(centers)
% 
%               dist1 = sqrt((centers(j,1) - chosenCircles(1,1))^2) + ((centers(j,2) - chosenCircles(1,2))^2); %cannot just compare x-vals 
%               dist2 = sqrt((centers(j,1) - chosenCircles(1,1))^2) + ((centers(j,2) - chosenCircles(2,2))^2);
% 
%                if(dist1 < currentClosest1) %update current closest
%                    closestIndex1 = j;
%                    currentClosest1 = dist1;
%                end
%                if(dist2 < currentClosest2)
%                    closestIndex2 = j;
%                    currentClosest2 = dist2;
%                end
% 
%             end
%         end
        
        trackedCircleLocations(1,i) = centers(closestIndex1, 1);
        trackedCircleLocations(2,i) = centers(closestIndex2, 1); %this way works with parfor 
        
       updateWaitbar();
    end
    close(f);
    save circleFrames.mat circleFrames;
    return;
end