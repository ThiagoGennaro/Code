    function tracks = updateAssignedTracks( tracks,...
                                            assignments,...
                                            centroids,...
                                            bboxes,...
                                            intrinsec,...
                                            extrinsec,...
                                            k )
                                        
    
        numAssignedTracks = size(assignments, 1);
        
        for i = 1:numAssignedTracks
            
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            
            %% Kalman Filter
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);

            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;
            
            % Replace predicted centroid with detected centroid
            tracks(trackIdx).centroid = centroid;

            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % Update track's centroids
            tracks(trackIdx).bufferCentroids(:,k) = centroid;
                       
            % Update LOS - Line of sigth
            Xc = pixToCam( centroid, intrinsec ); 
            Xpw = (extrinsec.R' * (Xc')).*(1e-3);
            los = [ extrinsec.t; Xpw ];
            tracks(trackIdx).LoS = los;
            
            % Storage LoS
            tracks(trackIdx).bufferLoS(:,k) = [k;tracks(trackIdx).LoS];
            
            %target detected
            tracks(trackIdx).targetDetected(1,k) = 1;
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
            
        end
    end