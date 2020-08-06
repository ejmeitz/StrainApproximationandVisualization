%% regionHeatMapGenerator v1
% created by Leanne Iannucci
% 2/1/2020


%Ethan's Notes on How to Use:
%When picking circles  the perimeter of the circle is most important. Pick
%the two circles on opposite sides you wish to track and only focus on
%making the mask good for those. Try to avoid any large blobs sticking off
%the edge. Any salt and pepper noise will be removed and any holes inside the circle will
%be filled.
%
%If the mask is bad from the start it will always be bad
%If the circles in the initial mask are clear and do not have blobs near
%them it should work for the whole thing. You can run strainApproximation()
%step by step and view the outputs to debug.


% objective of this code is to create a script that can input MAT files
% that have already been analyzed using UCL Analysis, and output dynamic
% heatmaps about relative changes in AVG DoLP, AVG AoP and STD AoP compared
% to baseline during dynamic testing

% user must input multiple files & also already have created the delta heat
% maps folder

% eventually will convert this into a function that can be incorporated
% into UCL analysis script

%% Change me and Housekeeping


%set bin size and scaling factor of s0
horzPix = 3;
vertPix = 3;
scale = 500;
fps = 25;

%% load info about files
% addpath(genpath('Y:\Active\Iannucci\Science\Tissue Analogs'))
% [files, paths] = uigetfile('*.*', 'MultiSelect', 'on');
% newPath = strcat(erase(paths, 'MAT Files\'), 'Delta Heat Maps\');
% y = waitbar(0, 'Big loop');
%%
%for bigI = 1:numel(files)
%     cd(paths);
%     load(files{1,bigI}, 'aop', 'dolp','s0', 'maskImg')
%     newSam = erase(files{1,bigI}, '-output-alignment.mat');
%     cd(newPath)
% 
%     disp('Loaded File')

    %% segment mask into regions
    addpath('CircStats');  %functions for AoP calcs

    %create bounding box for ROI
    q = bwareafilt(maskImg(:,:,1),1);  %get rid of all blobs except the biggest one
    se = strel('disk', 25); %creates a disk shaped region in a matrix with r=25 (brush)
    dilatedImage = imdilate(q,se);  %dilates image
    binaryImage = imerode(dilatedImage,se);   %erodes image
    
    brush = strel('square',8); %new smaller brush
    erodedImg = imerode(binaryImage,brush); %trim edges back a bit more
    
    filledImg = imfill(binaryImage, 8, 'holes'); %fill in holes in mask
    
    c = regionprops(filledImg,'BoundingBox'); %creates bounding box on image 
    f1 = figure; 
    imshow(filledImg); %show mask
    rectangle('Position',c.BoundingBox, 'EdgeColor', 'r'); %draws bounding box on image 

   
 %create array of square ROIs comprising the bounding box
    leastX = c.BoundingBox(1); %x-val at left edge of box
    greatestX = c.BoundingBox(1) + c.BoundingBox(3);  %x-val at right edge of box
    leastY = c.BoundingBox(2);  %y-val at bottom of box
    greatestY = c.BoundingBox(2) + c.BoundingBox(4);  %y-val at top of box
    
    maxNumRowBox = ceil((greatestX - leastX)/horzPix); %round up to ensure box is covered
    maxNumColBox = ceil((greatestY - leastY)/vertPix);
    
    numBox = maxNumRowBox*maxNumColBox;
    
    boxArray = zeros(numBox,5);
    countX = 0;
    countY = 0;
    startX = floor(c.BoundingBox(1,1)); %top left
    startY = floor(c.BoundingBox(1,2));

    %create an array of boxes that will fill the bounding box
    for i = 1:numBox
        boxArray(i,1) = startX +((countX)*horzPix); %x coord of all boxes
        boxArray(i,2) = startY +((countY)*vertPix);  %y coord of all boxes
        boxArray(i,3) = horzPix;  
        boxArray(i,4) = vertPix;  
       
        if countX < maxNumRowBox - 1
            countX = countX + 1;
        else
            countX = 0;
            countY = countY + 1;
        end

    end
    close(f1);
    f2= figure;
    imshow(filledImg);
    rectangle('Position',c.BoundingBox, 'EdgeColor', 'r');

       %check if box contains gel -- if it contains any gel spot 5 gets a
       %value greater than 0
    for i = 1:numBox
      rectangle('Position', boxArray(i,1:4), 'EdgeColor', 'b');
      subArray = filledImg(boxArray(i,2):(boxArray(i,2)+ boxArray(i,4)-1), boxArray(i,1):(boxArray(i,1)+ boxArray(i,3)-1));
      boxArray(i,5) = sum(subArray, 'all'); %if sum is 0 there is no gel
    end

    close(f2);
    figure;
    imshow(filledImg);
    rectangle('Position',c.BoundingBox, 'EdgeColor', 'r');
    count = 1;
    
%creates and draws array of boxes that contain gel
    for i =1:numBox
        if boxArray(i,5) > 0  % spot five is 0 if theres no gel
            posBoxArray(count,1:4) = boxArray(i,1:4);  %array of boxes with gel, has to be dynamic cause we dont know how many at start
            rectangle('Position', posBoxArray(count,1:4), 'EdgeColor', 'g') %draws box
            count = count + 1;
        end
    end
    disp('Mask Segmented');
    
    allPosBoxArray = repmat(posBoxArray,[1 1 size(aop,3)]);   
    scaled_s0 = s0./scale;
    allPosBoxArray = strainApproximation(allPosBoxArray, scaled_s0);  %approximate strain by tracking pins and deforming the boxes accordingly
    
     disp('Deformation Calculated');
    

    %% calculate the average baseline dolp and aop within each region
    
    h = waitbar(0,"Calculating subAoP and subDoLP");
    for j = 1:size(aop,3)
            bDoLPMask = filledImg.*dolp(:,:,j);  %apply mask to dolp 
            bAoPMask = filledImg.*aop(:,:,j);  %apply mask to aop
        for i = 1:size(posBoxArray,1)
            %base off undeformed array 
            subDoLP = bDoLPMask(posBoxArray(i,2):(posBoxArray(i,2)+posBoxArray(i,4)-1), posBoxArray(i,1):(posBoxArray(i,1)+posBoxArray(i,3)-1)); %calc 5x5 subDoLP
            allPosBoxArray(i,5,j) = nanmean(subDoLP,'all');
           subAoP = bAoPMask(posBoxArray(i,2):(posBoxArray(i,2)+posBoxArray(i,4)-1), posBoxArray(i,1):(posBoxArray(i,1)+posBoxArray(i,3)-1));
            tmp1 = circ_stats(subAoP.*(2*pi/180));
            avgAoP = tmp1.mean*(90/pi);
                if avgAoP < 0
                    avgAoP = avgAoP + 180;
                end
            stdAoP = tmp1.std*(90/pi);
            allPosBoxArray(i,6,j) = avgAoP;
            allPosBoxArray(i,7,j) = stdAoP;


            clear subDoLP subAoP tmp1 avgAoP

        end
        waitbar(j/size(aop,3),h);
    end
    close(h);
    
    disp('Aop and dolp calcd for each bin');


    %% calculate the change relative to baseline in each region

    posBoxChange = zeros(size(allPosBoxArray));
    posBoxChange(:,1:4,:) = allPosBoxArray(:,1:4,:);
    for i = 1:size(allPosBoxArray, 3)
        posBoxChange(:,5,i) = allPosBoxArray(:,5,i) - allPosBoxArray(:,5,1);
        posBoxChange(:,6,i) = allPosBoxArray(:,6,i) - allPosBoxArray(:,6,1);
        posBoxChange(:,7,i) = allPosBoxArray(:,7,i) - allPosBoxArray(:,7,1);

    end

    %% color each region based on the change

    avgDoLPHeatMap = nan(size(dolp));
    avgAoPHeatMap = nan(size(aop));
    stdAoPHeatMap = nan(size(aop));

    for j = 1:size(allPosBoxArray, 3)
        for i = 1:size(posBoxArray,1)

            avgDoLPHeatMap(posBoxArray(i,2):(posBoxArray(i,2)+posBoxArray(i,4)-1),posBoxArray(i,1):(posBoxArray(i,1)+posBoxArray(i,3)-1),j) = posBoxChange(i,5,j);
            avgAoPHeatMap(posBoxArray(i,2):(posBoxArray(i,2)+posBoxArray(i,4)-1),posBoxArray(i,1):(posBoxArray(i,1)+posBoxArray(i,3)-1),j) = posBoxChange(i,6,j);
            stdAoPHeatMap(posBoxArray(i,2):(posBoxArray(i,2)+posBoxArray(i,4)-1),posBoxArray(i,1):(posBoxArray(i,1)+posBoxArray(i,3)-1),j) = posBoxChange(i,7,j);


        end
 
    end

    disp('Data converted to RGB');
    %% export to a video file

    %calculate range for each type

    rangeMapDolp = max(max(max(abs(avgDoLPHeatMap), [], 'omitnan'), [], 'omitnan'), [], 'omitnan');
    rangeMapAvgAop = max(max(max(abs(avgAoPHeatMap), [], 'omitnan'), [], 'omitnan'), [], 'omitnan');
    rangeMapStdAop = max(max(max(abs(stdAoPHeatMap), [], 'omitnan'), [], 'omitnan'), [], 'omitnan');

    % create 4d matrix with data
    rgbAvgDolpDelta = double2rgb(avgDoLPHeatMap, redblue, [-rangeMapDolp rangeMapDolp]);
    rgbAvgAopDelta = double2rgb(avgAoPHeatMap, redblue, [-rangeMapAvgAop rangeMapAvgAop]);
    rgbStdAopDelta = double2rgb(stdAoPHeatMap, redblue, [-rangeMapStdAop rangeMapStdAop]);

    %take color data from each image and put into posBox
    %rgbAvgDolpDelta(row,col,RGB,frame)
    for i = 1:size(rgbAvgDolpDelta,4)  %loop frames
        row = 1; %at start of new frame reset row count
        for r = startY:vertPix:size(rgbAvgDolpDelta,1) %the y dimension
            for c = startX:horzPix:size(rgbAvgDolpDelta,2)  %the x dimension
                  if(allPosBoxArray(row,1,1) == c && allPosBoxArray(row,2,1) == r)  %if in a box in the posBoxArray (always compare to first undeformed frame)
                       allPosBoxArray(row,8,i) = rgbAvgDolpDelta(r,c,1,i); %extract R
                       allPosBoxArray(row,9,i) = rgbAvgDolpDelta(r,c,2,i); %extract G
                       allPosBoxArray(row,10,i) = rgbAvgDolpDelta(r,c,3,i); %extract B
                       
                       allPosBoxArray(row,11,i) = rgbAvgAopDelta(r,c,1,i); %extract R
                       allPosBoxArray(row,12,i) = rgbAvgAopDelta(r,c,2,i); %extract G
                       allPosBoxArray(row,13,i) = rgbAvgAopDelta(r,c,3,i); %extract B
                       
                       allPosBoxArray(row,14,i) = rgbStdAopDelta(r,c,1,i); %extract R
                       allPosBoxArray(row,15,i) = rgbStdAopDelta(r,c,2,i); %extract G
                       allPosBoxArray(row,16,i) = rgbStdAopDelta(r,c,3,i); %extract B
                       
                       
                        row = row + 1; %allPosBox has a new row for every element so we incremement this every time we find one
                  end
                  if(row == size(allPosBoxArray,1)) %since outer loop is bigger than the num of boxes we have to check if we've completed all the boxes
                        break;
                  end 
            end
             if(row == size(allPosBoxArray,1))
                        break;
             end
        end
    end    
    
    drawRectangles(allPosBoxArray,size(s0,2),size(s0,1),fps);
    
%     % compile and save into a video
% 
%     vidobj1 = VideoWriter(strcat(newSam, '-deltaAvgDoLP-heatmap.mp4'), 'MPEG-4');
%     open(vidobj1);
%     writeVideo(vidobj1, rgbAvgDolpDelta);
%     close(vidobj1);
% 
%     vidobj2 = VideoWriter(strcat(newSam, '-deltaAvgAoP-heatmap.mp4'), 'MPEG-4');
%     open(vidobj2);
%     writeVideo(vidobj2, rgbAvgAopDelta);
%     close(vidobj2);
% 
%     vidobj3 = VideoWriter(strcat(newSam, '-deltaStdAoP-heatmap.mp4'), 'MPEG-4');
%     open(vidobj3);
%     writeVideo(vidobj3, rgbStdAopDelta);
%     close(vidobj3);
% 
% 
%     % save colorbar for each video
%     fig1 = figure;
%     ax1 = axes;
%     r1 = colormap(redblue);
%     cbar_handle = colorbar;
%     cbar_handle.TickLabels = string(num2cell(round(linspace(-rangeMapDolp, rangeMapDolp, 11),3)));
%     ax1.Visible = 'off';
%     fig1.Color = 'w';
%     testme = export_fig('-transparent');
%     imwrite(testme, strcat(newSam, '-deltaAvgDoLP-colorbar.tif'));
% 
% 
%     fig2 = figure;
%     ax2 = axes;
%     r2 = colormap(redblue);
%     cbar_handle = colorbar;
%     cbar_handle.TickLabels = string(num2cell(round(linspace(-rangeMapAvgAop, rangeMapAvgAop, 11),3)));
%     ax2.Visible = 'off';
%     fig2.Color = 'w';
%     testme = export_fig('-transparent');
%     imwrite(testme, strcat(newSam, '-deltaAvgAoP-colorbar.tif'));
% 
%     fig3 = figure;
%     ax3 = axes;
%     r3 = colormap(redblue);
%     cbar_handle = colorbar;
%     cbar_handle.TickLabels = string(num2cell(round(linspace(-rangeMapStdAop, rangeMapStdAop, 11),3)));
%     ax3.Visible = 'off';
%     fig3.Color = 'w';
%     testme = export_fig('-transparent');
%     imwrite(testme, strcat(newSam, '-deltaStdAoP-colorbar.tif'));
    
    disp('Videos and colorbar imgs saved');
    %cd(paths);
    %save(files{1,bigI}, 'allPosBoxArray', '-append');
    disp('Data Saved');
    
    close all
    %waitbar(bigI/numel(files), y);
    clearvars -except horzPix vertPix files paths newPath bigI y allPosBoxArray scale
    
%end
