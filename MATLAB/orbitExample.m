% Welcome ! In this tutorial we will create a simple animation using MATLAB. We will be using some MATLAB build-in function to make easier the task of rotating and translating an object. For this first tutorial we will just create a sphere, and a looking-like satellite object. The cube will be in translational motion with respect to the sphere. This tutorial assumes that you can already create a script file in MATLAB and that you are little bit familiar with the language.

% The satellite like object is composed of a cylinder and two sphere at the two ends of the cylinder and also two rectangular surfaces representing the solar panels. Here is the code to create the different objects.

[x,y,z] =sphere;   % create the sphere and store its coordinates.

[xs,ys,zs] = sphere;  % create sphere for the bottom and upper part of the satellite

[x1,y1,z1] = cylinder(1);  % create a cylinder as the body of the satellite.

% Some line of code to load images that will be used as texture of the different object. These images must already be in your computer. To make it easy to find theme we make the location of the images the current directory.

Earth_texture = imread(‘earth1.jpg’);                % image for earth texture. ‘earth1.jpg’ is the name of the image
Sat_texture = imread(‘spaceX.jpg’);                % image for satellite body texture.
solarpan = imread(‘solarpan.jpg’);         % image for solar panel texture.
topsat = imread(‘sky.jpg’);                 % image for the bottom sphere of satellite.
botsat = imread(‘sky.jpg’);                 % image for the upper sphere of satellite.

% by default, the sphere created by MATLAB function sphere has radius equals to one. We need to scale it up or down according to our need.

r = 2.5;   % scaling factor for the sphere of the earth

% To animate an object we can create an hgtransform and link the object we want to move to that hgtransform. The hgtransform can also be used to move multiple objects by the same amount. We just need to make the ghtransform the parent of the objects we want move. We can create multiple hgtranform. The fact that we can link several objects to one hgtransform and move them by the same amount is very convenient in the case where an object is composed of several other object. This is the case of our satellite here.

hgt = hgtransform;                                            % for drawing the satelitte and linking its elements together.
hgth = hgtransform(‘parent’,gca);                  % to move the earth

% Now let’s draw our earth and satellite and attach them to their corresponding hgtransform. The first line of code draw the earth, set the texture equals to the image we load, and attach it to the hgtransform hgth. The other line of code does the same thing for the satellite. You will remark that all the satellite items are attached to the same hgtransfom hgt.

% Earth

h = surf(x*r,y*r,z*r,’FaceColor’, ‘texturemap’, ‘CData’, Earth_texture, ‘FaceAlpha’, 1, ‘EdgeColor’, ‘none’, ‘Parent’,hgth);

% cylinder body of the satellite

h3 = surface(x1,y1,z1*3-1.5,’FaceColor’, ‘texturemap’, ‘CData’, cdata3, ‘FaceAlpha’, 1, ‘EdgeColor’, ‘none’,’parent’,hgt);

% Above and bellow sphere of the satellite.

h4 = surf(xs,ys,zs+1.5,’FaceColor’, ‘texturemap’, ‘CData’, topsat, ‘FaceAlpha’, 1, ‘EdgeColor’, ‘none’,’Parent’,hgt);
h5 = surf(xs,ys,zs-1.5,’FaceColor’, ‘texturemap’, ‘CData’, botsat, ‘FaceAlpha’, 1, ‘EdgeColor’, ‘none’,’Parent’,hgt);

% Solar panels of the satellite.

solpan1 = surf([0.5, 4;0.5, 4],[0, 0; 0, 0],[1, 1; -1, -1],’FaceColor’, ‘texturemap’, ‘CData’, solarpan, ‘FaceAlpha’, 1, ‘EdgeColor’, ‘none’,’Parent’,hgt);

solpan2 = surf([-4, -0.5; -4, -0.5],[0, 0; 0, 0],[1, 1; -1, -1],’FaceColor’, ‘texturemap’, ‘CData’, solarpan, ‘FaceAlpha’, 1, ‘EdgeColor’, ‘none’,’Parent’,hgt);

% Now that we have finish drawing all the objects and attach them to the corresponding hgtransform we need to generate translational and rotational data for the satellite and the earth. We will not make the satellite rotate on itself for this time. In the future I will introduce how to combine translation and rotation for a given body.

%Trajectory generation for satellite.

t = 0:0.1:20*pi;
X = 42*cos(t/1.6);
Y = 42*sin(t/1.6);

beta = pi/15;  %for rotation of the earth.

% We now set the axis and background color of the MATLAB figure

axis([-45, 45, -45, 45, -10, 10])
set(gca, ‘color’, ‘r’)

% Now lets get into the loop that do the animation

for i=1:length(X)

% Earth
RxTx = [cos(i*beta), -sin(i*beta), 0, 0; sin(i*beta), cos(i*beta), 0, 0; 0, 0, 1, 0; 0, 0, 0,1];  % rotation matrix along x-axis
set(hgth,’Matrix’,RxTx);
drawnow;
% Translation for satellite. Trans represent the translation.
Trans = [1, 0, 0, 0.7*X(i);
0, 1, 0, 0.7*Y(i);
0, 0, 1, 0.0000
0, 0, 0, 1.0000 ];
set(hgt,’Matrix’,Trans);
drawnow;

end