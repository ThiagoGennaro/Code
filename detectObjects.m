%% Detect Objects
% The |detectObjects| function returns the centroids and the bounding boxes
% of the detected objects. It also returns the binary mask, which has the 
% same size as the input frame. Pixels with a value of 1 correspond to the
% foreground, and pixels with a value of 0 correspond to the background.   
%
% The function performs motion segmentation using the foreground detector. 
% It then performs morphological operations on the resulting binary mask to
% remove noisy pixels and to fill the holes in the remaining blobs.  

function [centroids, bboxes, mask, groundPoint  ] = detectObjects( obj, frame )

    % Detect foreground.
    mask = obj.detector.step(frame);

    % Apply morphological operations to remove noise and fill in holes.
    mask = imopen(mask, strel('rectangle', [4,4]));
    mask = imclose(mask, strel('rectangle', [15, 15])); 
    mask = imfill(mask, 'holes');

    % Perform blob analysis to find connected components.
    [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
    
    % find the groundPoint 
    groundPoint = [(bboxes(:,1) + bboxes(:,3)./2) (bboxes(:,2) + bboxes(:,4)) ];
    
end