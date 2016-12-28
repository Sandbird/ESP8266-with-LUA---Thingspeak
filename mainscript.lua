tempout = 0 -- Initialize value that holds temp
dofile("ds.lua")

tmr.alarm(1, 600000, 1, function() -- Check every  600000 10 minutes  - 15000 - 15sec
	dofile("ds.lua")
	dofile("send.lua")
	tmr.wdclr()
end)

local unescape = function (s)
   s = string.gsub(s, "+", " ")
   s = string.gsub(s, "%%(%x%x)", function (h)
         return string.char(tonumber(h, 16))
      end)
   return s
end

if srv~=nil then
  srv:close()
end

srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
	conn:on("receive", function(conn, payload)
		local buf = ""
		local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP");
		if(method == nil)then
		   _, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP")
		end
		local _GET = {}
		if (vars ~= nil)then
		   for k, v in string.gmatch(vars, "(%w+)=([^%&]+)&*") do
			   _GET[k] = unescape(v)
		   end
		end
		-- Now we can use _GET['name'] or _GET.name
        if (_GET.senddata ~= nil) then
            if (tonumber(_GET.senddata) == 1) then
                if (tempout == 0 or tempout == 85) then
                    dofile("ds.lua")
                end
                dofile("send.lua")
            elseif (tonumber(_GET.senddata) == 2) then
                file.remove('config.lc')
            end
        end
        
	  dofile("ds.lua")
		print(payload)
		conn:send('HTTP/1.1 200 OK\r\nConnection: keep-alive\r\nCache-Control: private, no-store\r\n\r\n')
		conn:send('<!DOCTYPE HTML>')
		conn:send('<html lang="en">')
		conn:send('<head>')
		conn:send('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">')
		conn:send('<meta http-equiv="refresh" content="60">')
		conn:send('<meta name="viewport" content="width=device-width, initial-scale=1">')
		conn:send('<title>(ESP8266 & DS18B20)</title>')
		conn:send('</head>')
		conn:send('<body>')
		conn:send('<h1>(ESP8266 & DS18B20)</h1>')
		conn:send('<h2>')
		conn:send('<input style="text-align: center" type="text" size=4 name="p" value="' .. tempout .. '"> C <br><br>')
		conn:send('</h2>')
    conn:send('<form method="get" onsubmit="return confirm(\'Are you sure you want to delete the config file?\');" action="http://' .. wifi.sta.getip() ..'">')
		conn:send('<button onclick="location.href=\'http://' .. wifi.sta.getip() ..'/?senddata=1\'" type="button">Send to ThingSpeak</button>&nbsp;&nbsp;&nbsp;') 
    conn:send('<button type="submit" name="senddata" value="2">Delete ConfFile</button>&nbsp;&nbsp;&nbsp;')
		conn:send('<button onclick="location.href=\'http://' .. wifi.sta.getip() ..'\'" type="button">Refresh</button><br><br>') 
		conn:send('</body></html>')		
		conn:close()
		collectgarbage()
	end)
	conn:on("sent", function(conn) conn:close() end)
end)
