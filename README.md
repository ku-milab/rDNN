# rDNN



## Title
Toward an Interpretable Alzheimer's Disease Diagnostic Model with Regional Abnormality Representation via Deep Learning


## Model description
- We proposed a network that provides deep learning-based diagnosis and interpretability for Alzheimer's disease.
- We used a 1.5-T T1-weighted MRI dataset with images from 801 subjects from the ADNI (Alzheimer's Disease Neuroimaging Initiative).
- We constructed a neural network to represent the abnormality of each subspace for each region.
- We pretrained our neural network with greedy layer-wise pretraining by constructing stacked denoising auto-encoders (SDAEs) (Vincent et al., 2010).
- The represented abnormality is finally classified by the SVM.

## Result
- We showed an accuracy of 89.22% for mild cognitive impairment (MCI) vs. cognitive normal (CN) and an accuracy of 88.52% for progressive MCI (pMCI) vs. stable MCI (sMCI) classification tasks.

## Example of individual regional abnormality map
- The closer to red, the greater the degree of abnormality (from a model perspective).

![image](https://user-images.githubusercontent.com/28587809/49801984-0a508580-fd8f-11e8-8917-ad5a798b1788.png)





## Requirements 
Implemented by MATLAB(R2017a)

### toolbox
	
	DeepLearnToolbox (https://github.com/rasmusbergpalm/DeepLearnToolbox)
	LIBSVM v3.21(https://www.csie.ntu.edu.tw/~cjlin/libsvm/)


### data preparation
	Used converted MRI (from .nii or .img to .mat)
	Used template Kabani's atlas (Kabani, N. J., 1998. 3D anatomical atlas of the human brain. NeuroImage 7, P–0717.)
