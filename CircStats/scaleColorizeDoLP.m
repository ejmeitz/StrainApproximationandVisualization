function [ dolpRGB ] = scaleColorizeDoLP( dolp, dLow, dHigh )
%scaleColorizeDoLP Colorize the DoLP with the Jet colormap, scaled between
%   dLow and dHigh

    dolp(dolp < dLow) = 0;
    dolp(dolp > dHigh) = dHigh;
    %dolp = dolp ./ dHigh;
    
    dolp = (dolp - dLow)./(dHigh - dLow);
    
    dolpBar = squeeze(repmat(linspace(1,0,size(dolp,1)),[1 1 48]));
    dolpBar(dolpBar < dLow) = 0;
    dolpBar(dolpBar > dHigh) = dHigh;
    %dolpBar = dolpBar ./ dHigh;
    dolpBar = (dolpBar - dLow) ./ (dHigh - dLow);
    
    dolpRGB = dolpToColor(cat(2,dolp,dolpBar));

end

