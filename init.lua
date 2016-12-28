timeout=0

if pcall(function ()
   dofile("config.lc")
end) then
   print("Connecting to WIFI...")
   --realtype = wifi.sleeptype(wifi.MODEM_SLEEP)
   wifi.setmode(wifi.STATION)
   wifi.sta.config(ssid,password)
   wifi.sta.connect()

   tmr.alarm(1, 1000, 1, function()
      if wifi.sta.getip() == nil then       
         print("IP unavaiable, waiting... " .. timeout)
      timeout = timeout + 1
      if timeout >= 30 then
       file.remove('config.lc')
       node.restart()
      end
      else
         tmr.stop(1)
         print("Connected, IP is "..wifi.sta.getip())
         dofile("mainscript.lua")
      end
   end)
else
   print("Enter configuration mode")
   dofile("run_config.lua")
end
