function [forceLocation, leftClampPos, rightClampPos] = deduceForceLocation(trackedCircles)
    
    forceLocation = 'both';

    zDim = size(trackedCircles,3);
    xlocs1 = zeros(zDim,1);
    xlocs2 = zeros(zDim,1);

    for i = 1:zDim
        xlocs1(i,1) = trackedCircles(1,1,i);
        xlocs2(i,1) = trackedCircles(2,1,i);    
    end
    
        
    %figure out which clamp is the left/right
      leftClampPos = [];
      rightClampPos = [];
      if(xlocs1(1,1) < xlocs2(1,1))
          leftClampPos = xlocs1;
          rightClampPos = xlocs2;
          
      else
          leftClampPos = xlocs2;
          rightClampPos = xlocs1;
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