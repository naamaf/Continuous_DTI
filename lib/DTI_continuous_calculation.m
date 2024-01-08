function DTI_continuous_calculation(mypath, out_name, sliding_window_size, jump_size, calculation_type, data_name, bvecs_name, bvals_name)
    % Calculate a continuous MD of FA curve per voxel using a sliding window 
    % The function recives DWI data after all preprocceing steps.    
    % Input:
    %   - mypath: Path to the data
    %   - sliding_window_size: Size of the sliding window
    %   - jump_size: Size of the jump in the sliding window
    %   - data_name: Name of the data file
    %   - bvecs_name: Name of the bvecs file
    %   - bvals_name: Name of the bvals file
    %   - calculation_type: 'MD' for Mean Diffusivity, 'FA' for Fractional Anisotropy, 'BOTH' for both
    % If data_name, bvecs_name or bvals_name are not provided, the function will look for nii.gz .bvec and .bval files within mypath
    % Output:
    %   - 4D MD/FA/Both nii.gz files with out_name_MD/out_name_FA
    %
    % Multishell data can be provided but is not recomended. 
    % At least one b0 most be provided. 
    %
    % Naama Friedman 2020
    %% Load Data
    % Check and set out_name
    if nargin < 2 || isempty(out_name) 
        out_name = '';
    end    
    
    % Check and set sliding_window_size
    if nargin < 3 || isempty(sliding_window_size) || ~isnumeric(sliding_window_size)
        error('Sliding window size must be a numeric value');
    end

    % Check and set jump_size
    if nargin < 4 || isempty(jump_size) || ~isnumeric(jump_size)
        error('Jump size must be a numeric value');
    end

    % Check and set calculation_type
    if nargin < 5 || isempty(calculation_type)
        calculation_type = 'both';
    else
        valid_types = {'MD', 'FA', 'both'};
        if ~ismember(calculation_type, valid_types)
            error('Invalid calculation type. Use ''MD'' for Mean Diffusivity, ''FA'' for Fractional Anisotropy, or ''both'' for both');
        end
    end

    % If data_name, bvecs_name, or bvals_name is not provided, load default files
    if nargin < 6 || isempty(data_name)
        data_name = dir('*.nii.gz');
        if isempty(data_name)
            error('No NIfTI file found in the current directory');
        end
        data_name = data_name(1).name;
    end

    if nargin < 7 || isempty(bvecs_name)
        bvecs_name = dir('*.bvec');
        if isempty(bvecs_name)
            error('No bvecs file found in the current directory');
        end
        bvecs_name = bvecs_name(1).name;
    end

    if nargin < 8 || isempty(bvals_name)
        bvals_name = dir('*.bval');
        if isempty(bvals_name)
            error('No bvals file found in the current directory');
        end
        bvals_name = bvals_name(1).name;
    end
    
    % Load data, bvecs, and bvals
    cd(mypath);
    [myData, bvecs, bvals, hdr] = load_data(data_name, bvecs_name, bvals_name);

    dim = size(myData);
    myData = reshape(myData,[],size(myData,4));
    %% Calculate MD or FA
    % define only b~=0 shells. Multishell data can be provided but is not
    % recomended.

    data_dwi = myData(:,bvals ~= 0);
    bvecs_dwi = bvecs(:,bvals ~= 0);
    bvals_dwi = bvals(:,bvals ~= 0);

    count = 1;
    number_of_calculations = floor((size(data_dwi,2) - sliding_window_size) / jump_size);
    continuous_MD = zeros(dim(1),dim(2),dim(3),number_of_calculations);
    continuous_FA = zeros(dim(1),dim(2),dim(3),number_of_calculations);

    for calc_index = 1:number_of_calculations
        if (count + sliding_window_size - 1) > size(bvals_dwi, 2)
            break;
        end

        % data setup
        current_data_dwi = data_dwi(:,count:count+sliding_window_size-1);
        current_bvecs_dwi = bvecs_dwi(:,count:count+sliding_window_size-1);
        current_bvals_dwi = bvals_dwi(:,count:count+sliding_window_size-1);

        loc_b0 = find(bvals(:,1:count)==0,1, 'last');

        current_data_b0 = myData(:,loc_b0);
        current_bvecs_b0 = bvecs(:,loc_b0);
        current_bvals_b0 = bvals(:,loc_b0);

        calculated_data = [current_data_b0 current_data_dwi];
        calculated_bvecs = [current_bvecs_b0 current_bvecs_dwi];
        calculated_bvals = [current_bvals_b0 current_bvals_dwi];

        % Calculation
        % Choose calculation function based on calculation_type
        if strcmpi(calculation_type, 'MD')
            continuous_MD(:,:,:,calc_index) = calculateMD(calculated_data, calculated_bvecs, calculated_bvals, [dim(1),dim(2),dim(3)]);
        elseif strcmpi(calculation_type, 'FA')
            continuous_FA(:,:,:,calc_index) = calculateFA(calculated_data, calculated_bvecs, calculated_bvals, [dim(1),dim(2),dim(3)]);
        elseif strcmpi(calculation_type, 'both')
            continuous_MD(:,:,:,calc_index) = calculateMD(calculated_data, calculated_bvecs, calculated_bvals, [dim(1),dim(2),dim(3)]);
            continuous_FA(:,:,:,calc_index) = calculateFA(calculated_data, calculated_bvecs, calculated_bvals, [dim(1),dim(2),dim(3)]);
        end
        count = count + jump_size; % Change for the next loop
    end
    
    %% Save data  
    saveResult(mypath,calculation_type, out_name, hdr, continuous_MD, continuous_FA);
end




