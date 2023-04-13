function [tracks,nextId] = createNewTracks( tracks,...
                                            unassignedDetections,... 
                                            centroids,... 
                                            bboxes,... 
                                            nextId,...
                                            intrinsec,...
                                            extrinsec,...
                                            TF,...
                                            k )

    
centroids = centroids(unassignedDetections, :);
bboxes = bboxes(unassignedDetections, :);

for i = 1:size(centroids, 1)

    centroid = centroids(i,:);
    bbox = bboxes(i, :);
    
    % Create a Kalman filter object.
    % kalmanFilter = configureKalmanFilter(MotionModel,...
    % InitialLocation,InitialEstimateError,MotionNoise,MeasurementNoise)
    kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
      centroid, [200, 50], [100, 25], 100);
 
    % Create target LoS. 
    Xc = pixToCam( centroid, intrinsec ); 
    Xpw = (extrinsec.R' * (Xc')).*(1e-3);
    los = [ extrinsec.t; Xpw ];
     
    % Create a new track.
    newTrack = struct(...
        'id', nextId, ...                    % target id 
        'bbox', bbox, ...                    % boxes around the targets
        'centroid', centroid, ...            % targets' centroids
        'kalmanFilter', kalmanFilter, ...    % kalman filter 
        'age', 1, ...                        % how long target has been tracking
        'totalVisibleCount', 1, ...          % count visible targets
        'consecutiveInvisibleCount', 0, ...  % count invisible targets
        'targetDetected', zeros(1,TF), ...   % target detected
        'bufferCentroids', NaN(2,TF), ...    % centroids
        'LoS', los, ...                      % line of sight
        'bufferLoS', zeros(7,TF), ...        % buffer: storage LoS  
        'measLoS', NaN(4,TF), ...            % mesurements buffer - LoS comparision
        'meas3Dto2D', NaN(2,TF), ...         % mesurements 3D trasformation to pixels
        'y' , zeros(6,TF), ...               % target state space
        'Y', zeros(6,6,TF), ...              % target covariance matrix
        'x', NaN(6,TF), ...                  % state estimated
        'xx', NaN(6,TF), ...                 % consensus state estimated 
        'x3Dto2D', NaN(2,TF), ...            % state estimated 3D to 2D
        'xx3Dto2D', NaN(2,TF), ...           % consensus state estimated 3D to 2D 
        'pf',[],...                          % particle filter
        'pf_x', NaN(6,TF), ...               % particle filter state estimated
        'pf_xx', NaN(6,TF), ...              % particle filter consensus state estimated 
        'pf_cov', NaN(6,6,TF), ...           % particle filter covariance matrix
        'pf_x3Dto2D', NaN(2,TF), ...         % particle filter 3D to 2D
        'pf_xx3Dto2D', NaN(2,TF), ...        % particle filter consensus state estimated 3D to 2D 
        'fz', zeros(1,1));                   % target ready to initialization: y and Y
    
    % Add it to the array of tracks.
    tracks(end + 1) = newTrack;
    
    % Storage centroids
    tracks(end).bufferCentroids(:,k) = centroid;
    
    % Storage LoS
    tracks(end).bufferLoS(:,k) = [k;tracks(end).LoS];
    
    %target detected
    tracks(end).targetDetected(1,k) = 1;
    
    % Increment the next id.
    nextId = nextId + 1;
    
end

