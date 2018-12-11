# rDNN



## Title
Toward an Interpretable Alzheimer's Disease Diagnostic Model with Regional Abnormality Representation via Deep Learning


## Purpose
- We proposed a network that provides deep learning-based diagnosis and interpretability for Alzheimer's disease.
- We used a 1.5-T T1-weighted MRI dataset with images from 801 subjects from the ADNI (Alzheimer's Disease Neuroimaging Initiative).
- We pretrined our network with greedy layer-wise pretraining by first constructing stacked denoising auto-encoders (SDAEs) Vincent et al., 2010).

## Result
- We showed an accuracy of 89.22% for mild cognitive impairment (MCI) vs. cognitive normal (CN) classification and an accuracy of 88.52% for progressive MCI (pMCI) vs. stable MCI (sMCI) classification tasks.

## Example of individual regional abnormality map
- The closer to red, the greater the degree of abnormality (from a model perspective).

![image](https://user-images.githubusercontent.com/28587809/49800475-f1de6c00-fd8a-11e8-80c9-7b40e5b34212.png)





## Requirements 
Implemented by MATLAB(R2017a)

### toolbox
	
	DeepLearnToolbox (https://github.com/rasmusbergpalm/DeepLearnToolbox)
	LIBSVM v3.21(https://www.csie.ntu.edu.tw/~cjlin/libsvm/)


### data preparation
	Used converted MRI (from .nii or .img to .mat)
	Used template Kabani's atlas (Kabani, N. J., 1998. 3D anatomical atlas of the human brain. NeuroImage 7, P–0717.)
