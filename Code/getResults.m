function [feature_results, mean_results, pic_info] = getResults(label, Im_fl, pic)
    %find the number of objects to be labelled
    size = max(label(:));
    pic_info = zeros(size,2);
    features_fl = regionprops(label,Im_fl, 'MeanIntensity');
    features_l_w = regionprops(label, 'MajorAxisLength', 'MinorAxisLength');
    feature_results = zeros(size,3);
    mean_results = zeros(1,3);
    
    for j = 1:size
        feature_results(j,1) = features_fl(j).MeanIntensity;
        feature_results(j,2) = features_l_w(j).MajorAxisLength;
        feature_results(j,3) = features_l_w(j).MinorAxisLength;
        pic_info(j,:) = [pic, j];
    end
    
    mean_results(1,1) = mean([features_fl.MeanIntensity]);
    mean_results(1,2) = mean([features_l_w.MajorAxisLength]);
    mean_results(1,3) = mean([features_l_w.MinorAxisLength]);
    
    
end