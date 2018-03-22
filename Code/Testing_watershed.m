I = imread('62_28.tif');
% L = watershed(imcomplement(I));
I2 = imcomplement(I);
I3 = imhmin(I2,90); %20 is the height threshold for suppressing shallow minima
L = watershed(I3);
I8 = bwmorph(cell2mat(I7),'skel',Inf);
I9 = I7;
I10 = I;