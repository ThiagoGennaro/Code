function [model,resolution,frameRate] = camModel(camera)

switch camera
    
    case 1 % Progressive Scan
        model = 'AXIS 223M';
        Width = 768;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 2 % Progressive Scan
        model = 'AXIS 223M';
        Width = 768;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 3 % Progressive Scan
        model = 'PTZ AXIS 233D';
        Width = 768;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 4 % Progressive Scan
        model = 'PTZ AXIS 233D';
        Width = 768;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 5 % ffmpeg De-interlaced
        model = 'Sony DCR-PC1000E 3xCMOS';
        Width = 720;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 6 % ffmpeg De-interlaced
        model = 'Sony DCR-PC1000E 3xCMOS';
        Width = 720;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 7 % Progressive Scan
        model = 'Canon MV-1 1xCCD w';
        Width = 720;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
    case 8 % Progressive Scan
        model = 'Canon MV-1 1xCCD w';
        Width = 720;
        Heigth = 576;
        resolution.W = Width;
        resolution.H = Heigth;
        frameRate = 7;
        
end

end