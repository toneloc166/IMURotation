SerialPort mySerialPort = new SerialPort();
mySerialPort.BaudRate = ...  // Set your parameters;
...
mySerialPort.Open();
string xyz = coordinates;
mySerialPort.Write(xyz);
