% This script reads and displays the IMU data in form of a 
% trapazoidal prism

% Create serial object and connect device
s1 = serial('COM3','Baudrate',115200);
s1.Terminator = 10; 
fopen(s1);

% Teapot Model
ptCloud = pcread('teapot.ply');

% Center = H/2; % Rotate Model around this point

while (1)
    % Read sensor data and assign values to quaternion array
    SerialData = fscanf(s1); 
    flushinput(s1);
    t = strsplit(SerialData,'\t');
    t = str2double(t);

    % Make sure buffer is correct before we process the data
    if length(t) == 9
        quatArray = [t(1), t(2), t(3), t(4)];
        calArray = [t(5), t(6), t(7), t(8)];

    %     % Move figure so when rotated, it is rotated about the center
    %     for i = 1:length(P)
    %         P(i,:) = P(i,:) - Center;
    %     end

        % Convert quaternion to 4x4 dcm
        dcm = quat2dcm(quatArray);
        dcm = rotm2tform(dcm);

        % Check if dcm is finite - if not we can't process it
        if sum(sum(isnan(dcm))) > 0
            continue;
        end

        % Rotate vectors using dcm
        tform = affine3d(dcm);

    %     % Bring figure back to original coordinates
    %     for i = 1:length(P)
    %         P(i,:) = P(i,:) + Center;
    %     end

        % Transform
        ptCloudOut = pctransform(ptCloud,tform);

        % Plotting stuff
        pcshow(ptCloudOut);
        hold off;
        axis([-4 4 -4 4 -4 4]);
        grid on;
        view([1,1,1]);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        drawnow;
    end
end