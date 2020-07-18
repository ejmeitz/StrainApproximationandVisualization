%tissueWidth (mm)
%numFrames (int)
%totalStrainPercent (double e.g. 2.5)
%poissonRatio (double e.g. 0.3);
%isSingleGrip (bool representing if 1 or 2 grips pull on sample)
%if gripSide can be left(0) or right(1)

%if pulling from center isSingleGrip = false and gripSide is anything
%besides 0 or 1
function RectangleTest(tissueWidth, numFrames, totalStrainPercent, poissonRatio, isSingleGrip, gripSide)

    if(poissonRatio > 0.5 || poissonRatio < -1)
        error('Invalid Poisson''s Ratio');
    end


    frames = [];
    clear('frames');
    
    f = figure(1); 
    xlim([-200 250]);
    ylim([0 30]);

    %create boxes--in real pass this as param
    numBoxes = 10;
    boxes = zeros(numBoxes,4);  %y dim is the information associated with each box
     
    startX = 0;
    inc = 0;
    startY = 0;
    pix = tissueWidth / numBoxes;
     
    %create initial boxes
    for i = 1:length(boxes)
        boxes(i,1) =  startX + inc;                 %x loc
        boxes(i,2) =  startY;                       %y loc
        boxes(i,3) =  pix;                          %width
        boxes(i,4) =  pix;                          %height
        rectangle('Position', boxes(i,:));
        inc = inc + pix;
    end
   
    frames(1) = getframe(f);
    clf(f); 
    
    totalDeformation = (totalStrainPercent / 100) * tissueWidth; % under assumption totalStrainPercent is in form 2.5%
    displacement = calcBinIncrement(numBoxes, totalDeformation, numFrames);
    
    %when true grip is on left
    if(gripSide == 0) 
        for i = 1:(numFrames)
            for j = 2:length(boxes) %assume left most box doesnt deform       
                boxes(j,1) =  boxes(j-1,3) + boxes(j-1,1);  %new xloc
                boxes(j,3) =  boxes(j,3) + displacement(j,1); %new width
               
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
    
   
    %when grip is on right
    if(gripSide == 1)
        displacement = flipud(displacement); % its a col vector for flip up-down
        
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
end
