function [ h5data ] = h5loadRange( inputFile, range )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


    structName = 'h5data';

    info = h5info(inputFile);
    
    if (~isempty(info.Groups))
        for ix = 1:length(info.Groups)
            baseName = info.Groups.Name;
            for jx = 1:length(info.Groups.Datasets)
                vName = info.Groups.Datasets(jx).Name;
                val = h5read(info.Filename, [baseName '/' vName]);
                eval(sprintf('%s.%s = %f;', structName, vName, val));
            end
        end
    end
        
    for ix = 1:length(info.Datasets)
        vName = info.Datasets(ix).Name;
        varName = char('val');
        dsetName = ['/' vName];
        if (strcmp('data',vName))
            rows = info.Datasets(ix).Dataspace.Size(1);
            cols = info.Datasets(ix).Dataspace.Size(2);
            for jx = 1:length(range)
                h5data.data(:,:,jx) = h5read(inputFile,'/data',[1 1 range(jx)],[rows cols 1]);
            end
            h5data.data = permute(h5data.data,[2 1 3]);
            h5data.rows = cols;
            h5data.cols = rows;
            h5data.numFrames = length(range);
        else
            ldStr = sprintf('%s = h5read(''%s''', varName, inputFile);
            ldStr = [ldStr, sprintf(', ''%s'');', dsetName)];
            eval(ldStr);
            eval(sprintf('%s.%s = %s;', structName, vName, varName));
        end
    end    
end

