% Get the image
im=imread('http://i43.tinypic.com/2w1tlwh.jpg');
im=rgb2gray(im); % convert to gray scale
im=im>graythresh(im)*255; % covert to binary
siz=size(im); % image dimensions
% Label the disconnected foreground regions (using 8 conned neighbourhood)
L=bwlabel(im,8);
% Get the bounding box around each object
bb=regionprops(L,'BoundingBox');
% Crop the individual objects and store them in a cell
n=max(L(:)); % number of objects
ObjCell=cell(n,1);
for i=1:n
      % Get the bb of the i-th object and offest by 2 pixels in all
      % directions
      bb_i=ceil(bb(i).BoundingBox);
      idx_x=[bb_i(1)-2 bb_i(1)+bb_i(3)+2];
      idx_y=[bb_i(2)-2 bb_i(2)+bb_i(4)+2];
      if idx_x(1)<1, idx_x(1)=1; end
      if idx_y(1)<1, idx_y(1)=1; end
      if idx_x(2)>siz(2), idx_x(2)=siz(2); end
      if idx_y(2)>siz(1), idx_y(2)=siz(1); end
      % Crop the object and write to ObjCell
      im=L==i;
      ObjCell{i}=im(idx_y(1):idx_y(2),idx_x(1):idx_x(2));
end
% Visualize the individual objects
figure
for i=1:n
    subplot(1,n,i)
    imshow(ObjCell{i})
end
clear im L bb n i bb_i idx_x idx_y siz

%check the logic
%skeletonise
skel = bwmorph(bw,'skel',Inf);
%find branches
bra = bwmorph(skel, 'branchpoints');
%return blobs with branchpoints
[r,c] = find(bra);
blo_bra = bwselect(bw,c,r);
imshow(blo_bra);