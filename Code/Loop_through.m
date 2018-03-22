% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
imagefiles = dir('*.tif');      
nfiles = length(imagefiles);    % Number of files found
feat_0 = zeros(12000,9);
num = zeros(12000,1);
no_cells = zeros(nfiles,1);
pos=1;
for ii=1:49
%    currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
%    images{ii} = currentimage;
    if (ii == 26)
        continue
    end
   m=imread(['C:\Users\Nasha Meoli\Documents\EEE4022S\Test Images\ZelaMartin_Data\62_CH_3\original\62_' num2str(ii) '.tif']);
%    [q, count] = Chain_0(m,ii);
   [q] = Chain_0(m,ii);
   size_ = size(q);
   for i= 1:size_(1)
   feat_0(pos,:) = q(i,:);
   pos= pos+1;
   end
   num(ii)= size_(1);
%    no_cells(ii,1) = count;
   %pos=pos+size_(1);
   %imwrite(Image_Label, ['Results' num2str(ii) '.tif']);
   saveas(gcf,['Result_f_0' num2str(ii) '.fig']);
end