% Find labels of all bordering regions

function feature_spread = region_stats(up, down, left, right, features, features_0,features_4, width, intensity, intensity_fl)

 all_labels = unique(vertcat(up,down,left,right));

 iter = size(all_labels);
 
 feature_ = zeros(iter(1)-1,6);
 for i = 2:iter(1)

        %extract lengths (1)
        feature_(i-1,1) = features(all_labels(i)).MajorAxisLength;
        %extract widths (2)
        feature_(i-1,2) = features(all_labels(i)).MinorAxisLength/width;
        %extract angles (3)
        feature_(i-1,3) = features(all_labels(i)).Orientation;
        %extract solidity (4)
        feature_(i-1,4) = features(all_labels(i)).Solidity;        
        %extract pixel intensity of regions (5)
        feature_(i-1,5) = (features_0(all_labels(i)).MeanIntensity)/intensity;
        %fluorescence of the regions
        feature_(i-1,6) = (features_4(all_labels(i)).MeanIntensity)/intensity_fl;
 
 end
feature_spread = zeros(1,6);
 for j= 1:6
     feature_spread(1,j) = var(feature_(:,j));
 end 
end