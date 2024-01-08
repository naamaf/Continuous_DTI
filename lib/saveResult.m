function saveResult(mypath, calculation_type, out_name, hdr, continuous_MD, continuous_FA)
    % Save Result
    cd(mypath)
    hdr.ImageSize(4) = size(continuous_MD, 4);

    if strcmpi(calculation_type, 'MD')
        hdr.Datatype = class(continuous_MD);
        niftiwrite(continuous_MD, [out_name, '_MD'], hdr, 'Compressed', true);
    end

    if strcmpi(calculation_type, 'FA')
        hdr.Datatype = class(continuous_FA);
        niftiwrite(continuous_FA, [out_name, '_FA'], hdr, 'Compressed', true);
    end
    
    if strcmpi(calculation_type, 'both')
        hdr.Datatype = class(continuous_MD);
        niftiwrite(continuous_MD, [out_name, '_MD'], hdr, 'Compressed', true);
        hdr.Datatype = class(continuous_FA);
        niftiwrite(continuous_FA, [out_name, '_FA'], hdr, 'Compressed', true);
    end
end