function FA = calculateFA(calculated_data, calculated_bvecs, calculated_bvals, dim);

    % preaper for calc
    design = [calculated_bvecs(1,:).*calculated_bvecs(1,:);2.*calculated_bvecs(1,:).*calculated_bvecs(2,:);2.*calculated_bvecs(1,:).*calculated_bvecs(3,:);calculated_bvecs(2,:).*calculated_bvecs(2,:);2.*calculated_bvecs(2,:).*calculated_bvecs(3,:);calculated_bvecs(3,:).*calculated_bvecs(3,:)];
    design = -repmat(calculated_bvals',1,6) .* design';
    bmatrix = [ones(size(design,1),1) design];
    log_data = log(calculated_data);
    
    % calc
    pinv_bmatrix = pinv(bmatrix);
    cope = pinv_bmatrix * log_data';
    cope(isnan(cope)) = 0;
    cope(isinf(cope)) = 0;
    val = cope(2:end,:);
    for vox = 1:size(val,2)
        myTensor = [[val(1,vox) val(2,vox) val(3,vox)];...
                    [val(2,vox) val(4,vox) val(5,vox)];...
                    [val(3,vox) val(5,vox) val(6,vox)]];
        myEigValues = eig(myTensor);
        FA(vox) = (sqrt(...
          (myEigValues(1) - myEigValues(2))^2 ...
        + (myEigValues(1) - myEigValues(3))^2 ...
        + (myEigValues(2) - myEigValues(3))^2)) ...
        / (sqrt(2 * (myEigValues(1)^2 + myEigValues(2)^2 + myEigValues(3)^2)));
    end
    FA(isnan(FA)) = 0;
    FA(isinf(FA)) = 0;
    FA = reshape(FA,dim);
end