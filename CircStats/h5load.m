function [ h5data ] = h5load( inputFile )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    structName = 'h5data';

    info = h5info(inputFile);
    
    if (~isempty(info.Groups))
        for ix = 1:length(info.Groups)
            baseName = info.Groups.Name;
            for ix = 1:length(info.Groups.Datasets)
                vName = info.Groups.Datasets(ix).Name;
                val = h5read(info.Filename, [baseName '/' vName]);
                eval(sprintf('%s.%s = %f;', structName, vName, val));
            end
        end
    end
        
    for ix = 1:length(info.Datasets)
        vName = info.Datasets(ix).Name;
        varName = char('val');
        dsetName = ['/' vName];
        ldStr = sprintf('%s = h5read(''%s''', varName, inputFile);
        ldStr = [ldStr, sprintf(', ''%s'');', dsetName)];
        eval(ldStr);
        if (strcmp('data',vName))
            val = permute(val,[2 1 3]);
            eval(sprintf('%s.rows = %f;', structName, size(val,1)));
            eval(sprintf('%s.cols = %f;', structName, size(val,2)));
            eval(sprintf('%s.numFrames = %f;', structName, size(val,3)));
        end
        eval(sprintf('%s.%s = %s;', structName, vName, varName));
    end
    
end

