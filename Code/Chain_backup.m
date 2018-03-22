function [the_features_0,count] = Chain_0(I,pic)
%Building the pipeline
close all;
%This opens the image for processing and saves it to 
%the variable I, ensure that the image folder is added to Matlab pathI = imread('sal15_9-p-074.tif');
I = imread('62_32.tif');
I_bb = imread('62_49.tif');
% I_bb = imresize(I_bb,[2048 2048]);
% pic = 25;
% I = Im{1,1}{3*46,1};
% I = imresize(I,[2048 2048]);
%figure;imshow(I);
%denoise using contourlet transfrom
%the image is transformed to increase its signal to noise ratio, a 
%contourlet is a 2-D wavelet transform, this denoising process is very slow
% I_contour = denoise(I);
% 
% imshow(I_contour);
%I_contour = I;
%figure;
%contrast limited adaptive histogram equalisation (CLAHE)
%enhance the cell regions over local illumination within colony

%resize the image so that it mactches the contour based one
%this image, that is not denoised is useful for background estimation
%%
%close all
%I2_ = adapthisteq(I_contour);
I_contour = mat2gray(I);
I2_ = adapthisteq(I_contour,'NumTiles',[40 40],'clipLimit',0.01,'Distribution','rayleigh','Alpha',0.8);
% figure;imhist(I2_);
%I2 = adapthisteq(I_contour);m
%imshow(I2_);
%figure;
%%
%background estimation by rolling ball method
%This has the effect of "blurring" the image so that
% are more or less two distinct regions (no individual cells), colony or background
% I3_ = imclose(I2_, strel('ball',15,15));
I3_ = imdilate(I_contour, offsetstrel('ball',10,0));figure;imshow(I3_);
% imshow(I3_);
% figure;
[counts,x] = imhist(I3_,256);
stem(x,counts);
%%
close all
imshow(I_contour);figure; 
%otsu's global thresholding 
%turn the image into black and white image based 
%on the pixel intensity 
% thresh_ = maxentropie(I3_);
thresh_ = graythresh((I3_));
thresh_ = thresh_*1.1;

I4_ = (imbinarize(I3_,thresh_));

imshow(I4);figure; 
%figure;
% I4_ = bwareaopen(I4_,1190); 
I4_ = imfill(I4_,'holes');
imshow(I4_);
figure;

%adaptive thresholding for local background removal
%use the image from CLAHE to remove any local noise
I6 = imcomplement((adaptivethreshold(I_contour,22,thresh_/22.8)));
imshow(I6);
figure;

%multiply the background mask and the adaptive thresholded, noise reduced
%image
I7 = immultiply(I6,I4_);
% I7 = I6;
I7 = bwareaopen(I7, 1182);
imshow(I7);
hold on;
%%figure;
% %%
% % Label the disconnected foreground regions (using 8 conned neighbourhood)
% L_0=logical(I4);
% %1 get the bounding box of the connected regions, this extracts each
% %individual coloy
% bb=regionprops(L_0,'BoundingBox');
% %this returns the individual cell info to the bounding box created from the
% %mask above
% L = immultiply(L_0,I7);
% %Crop the individual objects and store them in a cell
% 
% %this would draw the bounding box
% for k = 1 : length(bb);
%   thisBB = bb(k).BoundingBox;
%   rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
%   'EdgeColor','r','LineWidth',2 )
% 
% end
% hold off;
% %store cropped images in a matrix
% siz=size(I); % image dimensions
% n=max(L(:)); % number of objects
% ObjCell=cell(n,1);
% ImCell = cell(n,1);
% for i=1:n
%       % Get the bb of the i-th object and offest by 2 pixels in all
%       % directions
%       bb_i=ceil(bb(i).BoundingBox);
%       idx_x=[bb_i(1)-2 bb_i(1)+bb_i(3)+2];
%       idx_y=[bb_i(2)-2 bb_i(2)+bb_i(4)+2];
%       if idx_x(1)<1, idx_x(1)=1; end
%       if idx_y(1)<1, idx_y(1)=1; end
%       if idx_x(2)>siz(2), idx_x(2)=siz(2); end
%       if idx_y(2)>siz(1), idx_y(2)=siz(1); end
%       % Crop the object and write to ObjCell
%       I4=L==i;
%       ObjCell{i}=I7(idx_y(1):idx_y(2),idx_x(1):idx_x(2));
%       ImCell{i} = I2_(idx_y(1):idx_y(2),idx_x(1):idx_x(2));
% end
% % Visualize the individual objects
% for i=1:n
%     subplot(1,n,i);
%     imshow(ObjCell{i});
% end
% 
% %figure;
% %%
% % 1.Steletonise the b and w image this prepares the images for checkng
% % whether they are complex or colinear
% %  Store each image in a matrix of skeletonised images
% SkelCell = cell(n,1);
% 
% for i=1:n
%     subplot(1,n,i);
%     SkelCell{i} = bwmorph(cell2mat(ObjCell(i)),'skel',Inf);
%     %imshow(SkelCell{i});
% end
% %figure;
%%
%from here on I only test with cluster 2,pick a particular cluster and test
%only witht that particular cluster
% I8 = SkelCell{1};
% I9 = ObjCell{1};
% I10 = ImCell{1};
I8 = bwmorph((I7),'skel',Inf);
I9 = I7;
I10 = I;
%show what are considered autonomous blobs

cc = bwconncomp(I9, 4);
labeled = labelmatrix(cc);
whos labeled;

RGB_label = label2rgb(labeled, @spring, 'c', 'shuffle');
imshow(RGB_label);

%% 2. Check whether there are branches in the new sub object system
figure;
branches = bwmorph(I8, 'branchpoints');
%%
%3 a.return blobs with branches; these are classfied as the complex objects
[rowsBP, columnsBP] = find(branches);
%blob_branch = bwselect(I9, columnsBP, rowsBP);
blob_branch = I9;
%imshow(blob_branch);
%figure;


%3 b. Return objects without branches; these are classified as colinear
%objects; these will then be split
% blob_colin = xor(blob_branch,I9);
% imshow(blob_colin);
% %figure;

%%
%4 a. apply watershed transform to complex objects, the watershed transform
%results in an oversegmented image
D = bwdist(~I9);
% figure; imshow(D,[],'InitialMagnification','fit');

D = -D;
D(~blob_branch) = Inf;

M = watershed(D);
M(~I9) = 0;
rgb = label2rgb(M,'jet',[.5 .5 .5]);
%figure;
%imshow(rgb,'InitialMagnification','fit');
title('Watershed transform of D');

stats = regionprops(M);
% figure;

% D = -bwdist(~I9);
% D(~I9) = -Inf;
% L = watershed(D);
% imshow(label2rgb(L,'jet','w'));
%% 4 b. Deep valley alogorithm implementation


%% 5. Dealing with oversegmentation

% see the proper commentary for this on this blog: 
% https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/

bw2 = I9;
bw2(M == 0) = 0;
%imshow(bw2);

mask = imextendedmin(D,0.95);
figure;imshowpair(I9,mask,'blend');

%figure;
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = I9;
bw3(Ld2 == 0) = 0;
%imshow(bw3);

%figure;
cc_0 = bwconncomp(bw3, 4);
label_0 = labelmatrix(cc_0);
RGB_label_0 = label2rgb(label_0, @spring, 'c', 'shuffle');
%imshow(RGB_label_0);

%% 
% To find where there have been watersheds; need to find places where blak has been added and was
% not previously present.
%figure;
%Perfrom an XOR
IM_border = xor(bw3,I9);
%imshow(IM_border);
%figure;

%label these borders
cc_1 = bwconncomp(IM_border, 4);
[label_1] = labelmatrix(cc_1);
RGB_label_1 = label2rgb(label_1, @spring, 'c', 'shuffle');
%imshow(RGB_label_1);
%get avaerage image intensity for everything
mean_intensity_0 = regionprops(I9,I10, 'MeanIntensity');
mean_intensity = mean([mean_intensity_0.MeanIntensity]);
%iterate through each partition

m = max(label_1(:));
%feature 1 Length
feature_length = zeros(m,2);
features = regionprops(label_0, 'MajorAxisLength', 'Orientation', 'Solidity', 'MinorAxisLength');

%feature 2 Orientation
feature_angle = zeros(m,2);
%feature 3 Solidity
feature_solidity = zeros(m,2);
%feature 6 width
feature_width = zeros(m,2);
%feature 4 (region) pixel intensity
features_0 = regionprops(label_0,I10, 'MeanIntensity');
features_intensity_0 = zeros(m,2);
% feature 5 (border) pixel intensity and feature 7 Width
features_1 = regionprops(label_1,I10, 'MeanIntensity');
features_intensity_1 = zeros(m,1);
%feature 7 border width
features_2 = regionprops(label_1, 'MajorAxisLength');
feature_width_1 = zeros(m,1);
%get the final five features
features_final = zeros(m,7);
spread = zeros(m,5);
%iterate through each boundary
no_info = zeros(m,2);

for i = 1:m
    %boundary features
    features_intensity_1(i,1) = features_1(i).MeanIntensity/mean_intensity; 
    feature_width_1(i,1) = features_2(i).MajorAxisLength;
    %find regions bordering the boundary
    [juu, chini, kushoto, kulia] = find_cell_frag(i, label_0, label_1);
    spread(i,:) = region_stats(juu, chini, kushoto, kulia, features, features_0, feature_width_1(i,1), mean_intensity);
    no_info(i,:) = [pic, i];
          
end


features_final(features_final ==0) = NaN;
the_features_0 =  horzcat(spread, features_intensity_1,feature_width_1,no_info);
the_features_1 =  horzcat(spread,features_intensity_1,feature_width_1);
figure;
plot_label(label_1, IM_border, RGB_label_0);
%xlswrite('6_fea.xlsx',the_features_0);

%% Visual Outputs
v = evalin('base', 'trainedClassifier');
% z = myNeuralNetworkFunction_2(the_features_1);

class = v.predictFcn(the_features_1);
%class = boundary_class(z);
for i = 1:m
    IM_border(class(i) == 0) = 0;
    if (class(i) == 0)
    IM_border(label_1 == i) = 0;
    end
end
figure;
IM_NN = and(imcomplement(IM_border),I9);
IM_NN = bwareaopen(IM_NN, 482);
IM_NN = imfill(IM_NN,'holes');
%imshow(IM_NN);
%figure;
B = bwboundaries(IM_NN,4);
cc_2 = bwconncomp(IM_NN, 4);
[label_2] = labelmatrix(cc_2);
count = max(label_2(:));
RGB_label_2 = label2rgb(label_2, @spring, 'c', 'shuffle');
%imshow(RGB_label_2);
imshow(I_contour);
hold on;
visboundaries(B);


% figure; plot_label(label_2, IM_NN, RGB_label_2);
end