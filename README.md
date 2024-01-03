DTI Continuous Calculation

Overview

This MATLAB function, DTI_continuous_calculation, is designed for calculating a continuous Mean Diffusivity (MD) or Fractional Anisotropy (FA) curve per voxel using a sliding window. 
It is intended for use with diffusion-weighted imaging (DWI) data after all preprocessing steps.

Input

mypath: Path to the data.
out_name: Name for the output 4D MD/FA nii.gz files.
sliding_window_size: Size of the sliding window.
jump_size: Size of the jump in the sliding window.
calculation_type: 'MD' for Mean Diffusivity, 'FA' for Fractional Anisotropy, 'both' for both.
data_name: Name of the DWI data file.
bvecs_name: Name of the bvecs file.
bvals_name: Name of the bvals file.

Notes on Input:

If data_name, bvecs_name, or bvals_name are not provided, the function will look for nii.gz, .bvec, and .bval files within mypath.
Multishell data can be provided, but it is not recommended.
At least one b0 image must be provided.

Output

4D MD/FA nii.gz files with names out_name_MD and out_name_FA.


General Instructions:

Ensure that the DWI data and corresponding files (bvecs and bvals) are available in the specified path (mypath).
Set the desired parameters such as sliding_window_size, jump_size, and calculation_type.
Run the script to obtain continuous MD and/or FA calculations.
Output files will be saved with the specified out_name in the same path.
Mask can't be provided in this code without editing. We recommend inserting masked data as the initiall data file. 

This code is based on the word that was done at Ido Tavor's lab and is based on the paper:

Please cite this paper when using the code provided here for you own work.
For any question regarding this repository, please contact: naama.f@gmail.com
