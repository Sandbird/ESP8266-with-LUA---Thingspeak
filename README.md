# **ESP8266 Thermometer using NodeMCU and DS18B20** #
Tested on version: nodemcu_integer_0.9.6-dev_20150704 bin

# Info
- [Thingspeak channel](https://thingspeak.com/channels/70619)
- [NodeMCU dev download](https://github.com/nodemcu/nodemcu-firmware/releases/)
- Use nodemcu float version to get float numbers, integer versions to get integer numbers (i used the integer version)

# Bugs
- Sometimes the DS reports a temperature of 85 degrees. Reasking for the temp fixes this error.

# Config

#### Edit ds.lua
```lua
--Edit 3 line to change GPIO
pin = 3;
```

#### Edit send.lua
```lua
--Edit 1 line to change your Thingspeak apikey
apiKey = "Thingspeak apikey"
```

# HowTo
- Upload the code on your ESP, fire it up then scan with your phone, laptop, etc the networks around you.
- Connect to ESP8266-Setup, then open your browser and go to : http://192.168.0.1 (if you need to change this address edit run_config.lua)
- Find you router in the list then use that name and password in the fields bellow and press save.
- Done. The ESP will create a config file (config.lc) and reboot. It will then connect to the selected router, and update your Thingspeak channel every 10 minutes with the temp value.
- If for any reason it cant find the router on reboot, it will delete the conf file and back back into setup mode.

#### Example connections
![Schematic](https://raw.githubusercontent.com/Sandbird/ESP8266-with-LUA---Thingspeak/master/schematic.png)

# Change log
28.12.2016
- Added autoreseter in case the ESP cant find the router anymore.