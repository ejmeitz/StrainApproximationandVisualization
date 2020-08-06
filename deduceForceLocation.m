function [forceLocation, leftClampPos, rightClampPos] = deduceForceLocation(trackedCircleLocations)
    
    forceLocation = 'both';

    zDim = size(trackedCircleLocations,2);
    xlocs1 = zeros(zDim,1);
    xlocs2 = zeros(zDim,1);
    leftClampPos = zeros(zDim,1);
    rightClampPos = zeros(zDim,1);
    
    for i = 1:zDim
        xlocs1(i,1) = trackedCircleLocations(1,i);
        xlocs2(i,1) = trackedCircleLocations(2,i);    
    end
    
        
    %figure out which clamp is the left/right
      if(xlocs1(1,1) < xlocs2(1,1))
          leftClampPos(:,1) = xlocs1(:,1);
          rightClampPos(:,1) = xlocs2(:,1);
          
      else
          leftClampPos(:,1) = xlocs2(:,1);
          rightClampPos(:,1) = xlocs1(:,1);
      end
      
      filledLeft = filloutliers(leftClampPos,'makima','gesd');
      leftClampPos = smoothdata(filledLeft, 'movmean',2);
   
      filledRight = filloutliers(rightClampPos,'makima','gesd');
      rightClampPos = smoothdata(filledRight, 'movmean',2);
      
      
      %if left clamp is stationary
      if(range(leftClampPos) <= 4)
          forceLocation = 'right';
      end
      
      %if right clamp is stationary
      if(range(rightClampPos <= 4))
         forceLocation = 'left';
      end
      
      if(range(rightClampPos <= 4) && range(leftClampPos) <= 4) 
        forceLocation = 'bug';
        warning("No movement detected");
      end
      
    return;
end