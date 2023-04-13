    function displayTrackingResults( obj, frame, mask, tracks, camera )
    
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;

        minVisibleCount = 3;
        if ~isempty(tracks)

            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);

            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);

                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                centro = cat(1,reliableTracks(:).centroid);
                centroids = cat(2,centro, repmat(3,[size(centro,1) 1]));
                
                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                labels = cellstr(int2str(ids'));
                CamLabels = strcat('Camera ',num2str(camera));
                CamLabelPosition = [350 100];
                box_color = {'yellow'};
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);

                % Draw the objects on the frame.
                frame = insertText(frame, CamLabelPosition, CamLabels,'FontSize', 18, 'BoxColor', box_color, 'BoxOpacity', 0.5);

                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                frame = insertObjectAnnotation(frame, 'circle', ...
                   centroids, '', 'LineWidth', 3, 'Color', {'red'});

                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end

        % Display the mask and the frame.
        obj.maskPlayer.step(mask);
        obj.videoPlayer.step(frame);
    end
   