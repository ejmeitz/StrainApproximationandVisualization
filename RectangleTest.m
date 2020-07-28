%tissueWidth (mm)
%numFrames (int)
%totalStrainPercent (double e.g. 2.5)
%poissonRatio (double e.g. 0.3);
%isSingleGrip (bool representing if 1 or 2 grips pull on sample)
%if gripSide can be left(0) or right(1)

%if pulling from center isSingleGrip = false and gripSide is anything
%besides 0 or 1


numFrames = size(deformedCellArray,3);
gripSide = 0;

%function Test(tissueWidth, numFrames, totalStrainPercent, isSingleGrip, gripSide)
%    maxRowLength = getLongestRowFromCellArray(posBoxCellArray);
    %totalDeformation = (totalStrainPercent / 100) * tissueWidth; % under assumption totalStrainPercent is in form 2.5%
    %displacement = calcBinIncrement(maxRowLength, totalDeformation, numFrames);

    frames = [];
    clear('frames');
    
    f = figure(1); 
    xlim([0 size(s0,2)]);
    ylim([0 size(s0,1)]);
   
    sizeArray = size(deformedCellArray);
    maxI = sizeArray(1);
    maxJ = sizeArray(2);
    
    
    abc = waitbar(0,'Drawing boxes...');
    %when true grip is pulling on the right
    if(gripSide == 0) 
        count = 1;
        for h = 200:(numFrames-100)
           
              %draw all boxes
           % for m = 1:maxI
                %  for n = 1:maxJ
%                         if(~isempty(deformedCellArray{29,1,h}))
%                              rectangle('Position', deformedCellArray{29,1,h}(1:4));
%                              
%                         end
%                         if(~isempty(deformedCellArray{29,2,h}))
%                              rectangle('Position', deformedCellArray{29,2,h}(1:4));
%                              
%                         end
               %  end
            % end
            
             for m = 1:maxI
                 for n = 1:maxJ
                        if(~isempty(deformedCellArray{m,n,h}))
                             rectangle('Position', deformedCellArray{m,n,h}(1:4),'FaceColor',[0 .5 .5],'LineStyle','none');
                             
                        end
                end
            end
             
           xlim([0 size(s0,2)]);
            ylim([0 size(s0,1)]);
   
     
    
            frames(count) = getframe(f);  %add frame to array
            clf(f);  %clear figure 
             waitbar(count/(numFrames-300));
             count = count + 1;
%             for i = 1:maxI  %rows
%                 totalWidth = 0;  %on the start of a new row reset this
%                 startX = posBoxCellArray{i,1}(1);  %first x-val is different for every row
%                 for j = 1:maxJ  %cols
%                        if(~isempty(boxes{i,j}))
%                             boxes{i,j}(1) =  startX + totalWidth; %if theres a gap this breaks FIX
%                            
%                             boxes{i,j}(3) =  boxes{i,j}(3) + displacement(j,1); %new width
% 
%                             totalWidth = totalWidth + boxes{i,j}(3);  %this definition breaks on gaps FIX that
%                             
%                      
%                        end
%                 end
%             end
                       
             
        end
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
