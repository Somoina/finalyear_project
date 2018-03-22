function plot_label(L, bw, colour)

s = regionprops(L, {'Centroid', 'PixelIdxList'});
% First, make an image with a light gray background instead
% of a black background, so that the numbers will be visible
% on top of it.
I = im2uint8(bw);
I(~bw) = 200;
I(bw) = 240;
I = imfuse(I, colour);
imshow(I, 'InitialMagnification', 'fit')

% Now plot the number of each sorted object at the corresponding
% centroid:
hold on
for k = 1:numel(s)
   centroid = s(k).Centroid;
   text(centroid(1), centroid(2), sprintf('%d', k));
end
hold off
end