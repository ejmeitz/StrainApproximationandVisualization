%tissueWidth (mm)
%numFrames (int)
%totalStrainPercent (double e.g. 2.5)
%poissonRatio (double e.g. 0.3);
%isSingleGrip (bool representing if 1 or 2 grips pull on sample)
%if gripSide can be left(0) or right(1)

%if pulling from center isSingleGrip = false and gripSide is anything
%besides 0 or 1


numFrames = size(allPosBoxArray,3);
gripSide = 0;

%function Test(tissueWidth, numFrames, totalStrainPercent, isSingleGrip, gripSide)
%    maxRowLength = getLongestRowFromCellArray(posBoxCellArray);
    %totalDeformation = (totalStrainPercent / 100) * tissueWidth; % under assumption totalStrainPercent is in form 2.5%
    %displacement = calcBinIncrement(maxRowLength, totalDeformation, numFrames);

    frames = [];
    clear('frames');
    
    f = figure(1);
    %set(gca,'color','black');
    xlim([0 size(s0,2)]);
    ylim([0 size(s0,1)]);
   
    sizeArray = size(allPosBoxArray);
    maxI = sizeArray(1);
    
  
    
    abc = waitbar(0,'Drawing boxes...');
    %when true grip is pulling on the right

        count = 1;
        for h = 200:(numFrames-100)
          
            
             for m = 1:maxI
                 r =  allPosBoxArray(m,14,h);
                 g =  allPosBoxArray(m,15,h);
                 b =  allPosBoxArray(m,16,h);
                   rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none','LineWidth',0.01);

             end
          
           set(gca,'color','black');
           xlim([0 size(s0,2)]);
           ylim([0 size(s0,1)]);
   
     
    
            frames(count) = getframe(f);  %add frame to array
            clf(f);  %clear figure 
             waitbar(count/(numFrames-300));
             count = count + 1;  
        end

    close(f);
    close(abc);
   
    %when grip is pulling from left
%     if(gripSide == 1)
%         displacement = flipud(displacement); % its a col vector so flip up-down
%         
%            for i = 1:(numFrames)
%                 for j = (length(boxes)-1):-1:1 %assume right most box doesn't deform
%                     boxes(j,3) =  boxes(j,3) + displacement(j,1);  %new width
%                     boxes(j,1) =   boxes(j+1,1) - boxes(j,3);  %update x loc (changes with new width now x is always lower left)
%                     
%                 end
%                 
%                   xlim([-200 250]);
%                   ylim([0 30]);
% 
%                 
%                 %draw all boxex after update
%                 for j = 1:length(boxes)
%                    rectangle('Position', boxes(j,:));
%                 end
%                  frames(i+1) = getframe(f);  %add frame to array
%                  clf(f);  %clear figure 
%            end  
%     end
%     
%     
%     %when grip is pulling from both sides
%     if(gripSide > 1 || gripSide < 0)
%         centerIndex = 0;
%         if(mod(length(boxes),2) == 0) %if even
%             centerIndex = (length(boxes)*0.5);
%         else %if odd 
%             centerIndex = (length(boxes)*0.5) + 1;
%         end
%         
%         
%         
%           for i = 1:(numFrames-1)
%                 for j = centerIndex:length(boxes) %assume center box(es) don't deform
%                     boxes(j,1) =   boxes(j+1,1) - boxes(j,3) + startX;  %update x loc (changes with new width now x is always lower left)
%                     boxes(j,3) =  boxes(j,3) + strechDistancePerFrame;
%                 end
% 
%                 xlim([-200 250]);
%                 ylim([0 30]);
% 
%                 %draw all boxex after update
%                 for j = 1:length(boxes)
%                    rectangle('Position', boxes(j,:));
%                 end
%                  frames(i) = getframe(f);  %add frame to array
%                  clf(f);  %clear figure 
%            end  
%         
%         
%     end
    
    set(gca,'visible','off')
    movie(frames,1000,20); %play movie x times at y fps
%end
