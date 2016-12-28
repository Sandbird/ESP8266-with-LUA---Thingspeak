t = require("ds18b20")
-- GPIO0 is pin 3
pin = 3
lasttemp = 0
t.setup(pin)
temperature=t.read()
if temperature == nil then
  print("No value returned.")
else
  lasttemp = temperature
  t1 = lasttemp / 10000
  t2 = (lasttemp >= 0 and lasttemp % 10000) or (10000 - lasttemp % 10000)
  tempout=(string.format("%2d", t1) .. "." .. string.sub(t2, 1, 1))
  print("Temperature: "..tempout.."'C")
end