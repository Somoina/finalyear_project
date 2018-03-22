%Building the pipeline
I = imread('sal15_9_uint16-p-074.tif');
%denoise using contourlet transfrom

%contrast limited adaptive histogram equalisation
I2 = adapthisteq(I);
imshow(I2);
figure

%background estimation by rolling bal method
I3 = imdilate(I2, strel('ball',8,7));
imshow(I3);
figure

%otsu's global thresholding 
thresh = graythresh(I3);
I4 = im2bw(I3,thresh);
imshow(I4);
figure

%and canny's edge detector
I5 = edge(I4,'canny');
imshow(I5);

%adaptive thresholding for local background removal
