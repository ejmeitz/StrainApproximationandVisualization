function [Ct darks x0def y0def] = loadH5cal(calFile)
%loadH5cal Read in the calibration matrix (and transpose it for MATLAB)

    % Load Matrix Calibration Data
    C = h5read(calFile,'//calibration//gains');

    for ix = 1:size(C,1)
        for jx = 1:size(C,2)
            Ct1(ix,jx,:,:) = squeeze(C(ix,jx,:,:))';
        end
    end
    
    for ix = 1:size(Ct1,1)
        for jx = 1:size(Ct1,2)
            Ct(ix,jx,:,:) = Ct1(jx,ix,:,:);
        end
    end
    
    darks = h5read(calFile,'//calibration//darks')';
    
    try
    x0def = h5read(calFile,'/calibration/attributes/x0');
    y0def = h5read(calFile,'/calibration/attributes/y0');
    catch err
        x0def = uint32(1);
        y0def = uint32(1);
    end
end