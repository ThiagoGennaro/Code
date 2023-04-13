%% Create System Objects
% Create System objects used for reading the video frames, detecting
% foreground objects, and displaying results.

    function obj = setupSystemObjects(cameras)
        
        % Initialize Video I/O
        % Create objects for reading a video from a file, drawing the tracked
        % objects in each frame, and playing the video.

        % Create a video reader.
        
        obj.reader = VideoReader(strcat('C:\Users\Thiago\Dropbox\DoutoradoITA\TESE\Simulações\videos\videoCameras\video_',int2str(cameras),'.avi'));

        % Create two video players, one to display the video,
        % and one to display the foreground mask.
        obj.maskPlayer = vision.VideoPlayer('Position', [140, 200, 100, 100]);
        obj.videoPlayer = vision.VideoPlayer('Position', [20, 200, 100, 100]);

        % Create System objects for foreground detection and blob analysis
        % The foreground detector is used to segment moving objects from
        % the background. It outputs a binary mask, where the pixel value
        % of 1 corresponds to the foreground and the value of 0 corresponds
        % to the background.
        obj.detector = vision.ForegroundDetector('NumGaussians', 5, ...
                                                 'NumTrainingFrames', 40,...
                                                 'MinimumBackgroundRatio', 0.4);

        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis System object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.
        obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
                                               'AreaOutputPort', true,... 
                                               'CentroidOutputPort', true, ...
                                               'MinimumBlobArea', 300);     
    end