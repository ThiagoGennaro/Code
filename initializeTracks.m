    function tracks = initializeTracks()
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...                              % target id 
            'bbox', {}, ...                            % boxes around the targets
            'centroid', {}, ...                        % targets' centroids
            'kalmanFilter', {}, ...                    % kalman filter 
            'age', {}, ...                             % how long target has been tracking
            'totalVisibleCount', {}, ...               % count visible targets
            'consecutiveInvisibleCount', {}, ...       % count invisible targets
            'targetDetected', {}, ....                 % detected targets
            'bufferCentroids', {}, ...                 % target centroids
            'LoS', {}, ...                             % line of sight corresponding to centroid position
            'bufferLoS', {}, ...                       % buffer to store LoS for every k instants
            'measLoS' , {}, ...                        % target measurements - LoS comparision
            'meas3Dto2D' , {}, ...                     % 3D mesurements (x,y,z) transformed in 2D (pixels)
            'y', {}, ...                               % state space
            'Y', {}, ...                               % covariânce matrix
            'x', {}, ...                               % state estimated
            'xx',{}, ...                               % consensus state estimated
            'x3Dto2D', {}, ...                         % state estimated 3D to 2D
            'xx3Dto2D', {}, ...                        % consensus state estimated 3D to 2D 
            'pf', {}, ...                              % particle filter
            'pf_x', {}, ...                            % particle filter state estimated
            'pf_xx', {}, ...                           % particle filter consensus state estimated 
            'pf_cov', {}, ...                          % particle filter covariance matrix
            'pf_x3Dto2D',{}, ...                       % particle filter 3D to 2D
            'pf_xx3Dto2D',{}, ...                      % particle filter consensus state estimated 3D to 2D 
            'fz', {} );                                % target ready to initialization: y and Y
    end
    
