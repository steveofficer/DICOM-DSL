# DICOM-DSL
A Boo based DSL for creating well formed DICOM images

This project is an experiment in using Boo to build a DSL based on meta-programming to construct well-formed DICOM images for use in 
medical imaging applications.
The aim is to allow developers to construct DICOM objects in source code that is then compiled as a binary resource inside a .NET assembly.
The applicability would be for maintaining test data sets with the advantage of maintaining the images as source code rather than binary files.
