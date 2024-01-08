function MD = calculateMD(calculated_data, calculated_bvecs, calculated_bvals, dim);

    % preaper for calc
    design = [calculated_bvecs(1,:).*calculated_bvecs(1,:);2.*calculated_bvecs(1,:).*calculated_bvecs(2,:);2.*calculated_bvecs(1,:).*calculated_bvecs(3,:);calculated_bvecs(2,:).*calculated_bvecs(2,:);2.*calculated_bvecs(2,:).*calculated_bvecs(3,:);calculated_bvecs(3,:).*calculated_bvecs(3,:)];
    design = -repmat(calculated_bvals',1,6) .* design';
    design = [ones(size(design,1),1) design];
    log_md_data = log(calculated_data);
    
    % calc
    beta = pinv(design)*log_md_data';
    cope = beta';
    MD = cope(:,2) + cope(:,5) + cope(:,7);
    MD(isnan(MD)) = 0;
    MD(isinf(MD)) = 0;
    MD(MD<0) = 0;
    MD = MD ./ 3;
    MD = reshape(MD,dim);
end