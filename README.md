# rDNN



## Title
Toward an Interpretable Alzheimer's Disease Diagnostic Model with Regional Abnormality Representation via Deep Learning



- We proposed a network that provides deep learning-based diagnosis and interpretability for Alzheimer's disease.
- We used a 1.5-T T1-weighted MRI dataset with images from 801 subjects from the ADNI (Alzheimer's Disease Neuroimaging Initiative).
- We pretrined our network with greedy layer-wise pretraining by first constructing stacked denoising auto-encoders (SDAEs) Vincent et al., 2010).

## Result
- We showed an accuracy of 89.22% for MCI vs. CN classification and an accuracy of 88.52% for pMCI vs. sMCI classification tasks.

## Example of regional abnormality map




Requirements 
Implemented by MATLAB(R2017a)

used toolbox
	
	DeepLearnToolbox (https://github.com/rasmusbergpalm/DeepLearnToolbox)
	LIBSVM v3.21(https://www.csie.ntu.edu.tw/~cjlin/libsvm/)


preparation data 

	Used converted MRI (from .nii or .img to .mat)
	Used template Kabani's atlas (Kabani, N. J., 1998. 3D anatomical atlas of the human brain. NeuroImage 7, P–0717.)
