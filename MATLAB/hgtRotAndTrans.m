% Welcome ! In this tutorial we will create a simple animation using MATLAB. We will be using some MATLAB build-in function to make easier the task of rotating and translating an object. For this first tutorial we will just create a sphere, and a looking-like satellite object. The cube will be in translational motion with respect to the sphere. This tutorial assumes that you can already create a script file in MATLAB and that you are little bit familiar with the language.

% The satellite like object is composed of a cylinder and two sphere at the two ends of the cylinder and also two rectangular surfaces representing the solar panels. Here is the code to create the different objects.

[x,y,z] = sphere;   % create the sphere and store its coordinates.

% Now let's draw our earth.

% Earth

h = surf(x,y,z);

% We now set the axis and background color of the MATLAB figure

axis([-5, 5, -5, 5, -5, 5]);
set(gca, "color", "r")

% To animate an object we can create an hgtransform and link the object we want to move to that hgtransform. The hgtransform can also be used to move multiple objects by the same amount. We just need to make the ghtransform the parent of the objects we want move. We can create multiple hgtranform. The fact that we can link several objects to one hgtransform and move them by the same amount is very convenient in the case where an object is composed of several other object. This is the case of our satellite here.

tform = hgtransform("parent", gca);                  % to move the earth
set(h, "parent", tform);

% Now that we have finish drawing all the objects and attach them to the corresponding hgtransform we need to generate translational and rotational data for the satellite and the earth. We will not make the satellite rotate on itself for this time. In the future I will introduce how to combine translation and rotation for a given body.

%Trajectory generation for satellite.

t = 0:0.1:20*pi;
X = 4*cos(t/1.6);
Y = 4*sin(t/1.6);

beta = pi/15;  %for rotation of the earth.

% Now lets get into the loop that do the animation

for i=1:length(X)

% Earth
RxTx = [cos(i*beta), -sin(i*beta), 0, 0.7*X(i); sin(i*beta), cos(i*beta), 0, 0.7*Y(i); 0, 0, 1, 0; 0, 0, 0,1];  % rotation matrix along x-axis
set(tform,"Matrix",RxTx);
drawnow;
% Translation for satellite. Trans represent the translation.
% Trans = [1, 0, 0, 0.7*X(i);
% 0, 1, 0, 0.7*Y(i);
% 0, 0, 1, 0.0000
% 0, 0, 0, 1.0000 ];
% set(tform,"Matrix",Trans);
% drawnow;

pause(0.1);

end