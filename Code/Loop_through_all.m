% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
n_frames =49;
%access time lapse images
time_lapse = bfopen('C:\Users\Nasha Meoli\Documents\EEE4022S\Test Images\ZelaMartin_Data\mIMMC01_65_R3D.dv');
series = time_lapse{1,1};

feat_0 = zeros(3500,11);
num = zeros(3500,1);
no_cells = zeros(n_frames,1);
pos=1;
for ii=1:n_frames
%    currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
%    images{ii} = currentimage;
 
   m= series{ii*3};
   m_fl = series{ii*3-1};
   [q, count] = Chain_f(m,m_fl,ii);
%    [q] = Chain_f(m,ii);
   size_ = size(q);
   for i= 1:size_(1)
   feat_0(pos,:) = q(i,:);
   pos= pos+1;
   end
   num(ii)= size_(1);
    no_cells(ii,1) = count;
   %pos=pos+size_(1);
   %imwrite(Image_Label, ['Results' num2str(ii) '.tif']);
    saveas(gcf,['Result_f_0' num2str(ii) '.fig']);
end