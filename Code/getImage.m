%%extract .tif images from dv time-lapse videos
n_frames = 49;
time_lapse = bfopen('C:\Users\Nasha Meoli\Documents\EEE4022S\Test Images\ZelaMartin_Data\mIMMC01_65_R3D.dv');
series = time_lapse{1,1};

for ii=1:n_frames
   m= series{ii*3};
   imwrite(m, ['65_' num2str(ii) '.tif']);
  
end