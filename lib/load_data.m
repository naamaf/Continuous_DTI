function [myData, bvecs, bvals, hdr] = load_data(data_name, bvecs_name, bvals_name)
    % Load DWI data (including header), bvecs, and bvals
  
    myData = niftiread(data_name); % Load DWI data
    bvecs = load(bvecs_name); % Load bvecs  
    bvals = load(bvals_name); % Load bvals
    hdr = niftiinfo(data_name); % Load header
end


