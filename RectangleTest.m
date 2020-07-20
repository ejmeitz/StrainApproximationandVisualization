%tissueWidth (mm)
%numFrames (int)
%totalStrainPercent (double e.g. 2.5)
%poissonRatio (double e.g. 0.3);
%isSingleGrip (bool representing if 1 or 2 grips pull on sample)
%if gripSide can be left(0) or right(1)

%if pulling from center isSingleGrip = false and gripSide is anything
%besides 0 or 1


tissueWidth = 100;
numFrames = 10;
totalStrainPercent = 100;
isSingleGrip = true;
gripSide = 0;
poissonRatio = 0.3;
%function Test(tissueWidth, numFrames, totalStrainPercent, poissonRatio, isSingleGrip, gripSide)

    if(poissonRatio > 0.5 || poissonRatio < -1)
        error('Invalid Poisson''s Ratio');
    end


    frames = [];
    clear('frames');
    
    f = figure(1); 
    xlim([-200 250]);
    ylim([0 30]);

    %create boxes--in real pass this as param
    numBoxes = 30;
    boxes = zeros(numBoxes,4);  %y dim is the information associated with each box
    
    startX = 0;
    startY = 0;
    incX = 0;
    incY = 0;
    
    
    pix = tissueWidth / numBoxes;
     
    %create initial boxes
    for i = 1:length(boxes)
        boxes(i,1) =  startX + incX;                %x loc
        boxes(i,2) =  startY + incY;                %y loc
        boxes(i,3) =  pix;                          %width
        boxes(i,4) =  pix;                          %height
        
        rectangle('Position', boxes(i,:));          %draw rect
        incX = incX + pix;
        
        if(mod(i,10) == 0)
           incY  = incY + pix; 
           incX = 0;
        end
    end
   
    frames(1) = getframe(f);
    clf(f); 
    
    
    positiveCountByRow = createGrid(boxes);  %creates an array that has the total number of boxes in each row
    
    totalDeformation = (totalStrainPercent / 100) * tissueWidth; % under assumption totalStrainPercent is in form 2.5%
    displacement = calcBinIncrement(numBoxes, totalDeformation, numFrames);
    
    %when true grip is pulling on the right
    if(gripSide == 0) 
        for i = 1:(numFrames)
            totalWidth = 0;
            currentY = startY;
            k = 0;
       
            for j = 1:length(boxes) %assume left most box doesnt deform   
                
                 %check if still in same row (same height)

                   % boxes(j,1) =  boxes(j-1,3) + boxes(j-1,1);  %new xloc   %box to the left width + box to the left x
                   
                   if(currentY < boxes(j,2) || currentY > boxes(j,2)) %this is going to break if y changes across a row
                        totalWidth = 0;
                        currentY = boxes(j,2);
                        
                   end
                   
                    boxes(j,1) =  startX + totalWidth;
                    boxes(j,3) =  boxes(j,3) + displacement(j,1); %new width
                    
                    totalWidth = totalWidth + boxes(j,3);
                   
             
                    
               
            end
                  xlim([-200 250]);
                  ylim([0 30]);

        
            %draw all boxex after update
            for j = 1:length(boxes)
               rectangle('Position', boxes(j,:));
            end
             frames(i+1) = getframe(f);  %add frame to array
             clf(f);  %clear figure 
        end
    end
    
   
    %when grip is pulling from left
    if(gripSide == 1)
        displacement = flipud(displacement); % its a col vector so flip up-down
        
           for i = 1:(numFrames)
                for j = (length(boxes)-1):-1:1 %assume right most box doesn't deform
                    boxes(j,3) =  boxes(j,3) + displacement(j,1);  %new width
                    boxes(j,1) =   boxes(j+1,1) - boxes(j,3);  %update x loc (changes with new width now x is always lower left)
                    
                end
                
                  xlim([-200 250]);
                  ylim([0 30]);

                
                %draw all boxex after update
                for j = 1:length(boxes)
                   rectangle('Position', boxes(j,:));
                end
                 frames(i+1) = getframe(f);  %add frame to array
                 clf(f);  %clear figure 
           end  
    end
    
    
    %when grip is pulling from both sides
    if(gripSide > 1 || gripSide < 0)
        centerIndex = 0;
        if(mod(length(boxes),2) == 0) %if even
            centerIndex = (length(boxes)*0.5);
        else %if odd 
            centerIndex = (length(boxes)*0.5) + 1;
        end
        
        
        
          for i = 1:(numFrames-1)
                for j = centerIndex:length(boxes) %assume center box(es) don't deform
                    boxes(j,1) =   boxes(j+1,1) - boxes(j,3) + startX;  %update x loc (changes with new width now x is always lower left)
                    boxes(j,3) =  boxes(j,3) + strechDistancePerFrame;
                end

                xlim([-200 250]);
                ylim([0 30]);

                %draw all boxex after update
                for j = 1:length(boxes)
                   rectangle('Position', boxes(j,:));
                end
                 frames(i+1) = getframe(f);  %add frame to array
                 clf(f);  %clear figure 
           end  
        
        
    end
    
    set(gca,'visible','off')
    movie(frames,100,10); %play movie x times at y fps
%end
