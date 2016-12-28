apiKey = "xxxxx" -- Thingspeak api key

function sendData(tempout)
conn = nil
conn = net.createConnection(net.TCP, 0)
conn:on("receive",
    function(conn, payload)
    conn:close()
    print(payload)
    end)
	
conn:on("connection",
   function(conn)
   print("Connected")
   conn:send('GET /update?key='..apiKey..
   '&headers=false'..
   '&field1='..tempout..
   ' HTTP/1.1\r\n'..
   'Host: api.thingspeak.com\r\nAccept: */*\r\n'..
   'User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n\r\n')
   end)
conn:on("disconnection",
    function(conn, payload)
    print('Disconnected')
    --node.dsleep(DSLEEPTIME,4)
    end)
conn:connect(80,'api.thingspeak.com')
end


sendData(tempout)