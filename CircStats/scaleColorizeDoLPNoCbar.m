function [dolpRGB] = scaleColorizeDoLPNoCbar(dolp, dLow, dHigh)

    dolp(dolp < dLow) = dLow;
    dolp(dolp > dHigh) = dHigh;
    %dolp = dolp ./ dHigh;
    
    dolp = (dolp - dLow)./(dHigh - dLow);
    
    dolpRGB = dolpToColor(dolp);
    
end
    