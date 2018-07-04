% Communicate with arduino through serial connection

s = serial("COM3");

fopen(s);

while (1)
  disp(fscanf(s));
end