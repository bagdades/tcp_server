-- main.lua --

-- Connect
print('\nAll About Circuits main.lua\n')
tmr.alarm(0, 1000, 1, function()
	if wifi.sta.getip() == nil  then
		print("Connecting to AP...\n")
	else
		ip, nm, gw = wifi.sta.getip()
		print("IP Info: \nIP Address: ",ip)
		print("Netmask: ",nm)
		print("Gateway Addr: ",gw , '\n')
		tmr.stop(0)
	end
end)

adc_id = 0
adc_value = 512
-- Amy from Gargantia on the Verdurous Planet
blink_open = "http://i.imgur.com/kzt3tO8.png"
blink_close = "http://i.imgur.com/KS1dPa7.png"
site_image = blink_open

--Start a simple http server
srv = net.createServer(net.TCP, 30)
srv:listen(80, function(conn)
	conn:on("receive", function(conn, payload)
	function esp_update()
		mcu_do = string.sub(payload, postparse[2] + 1, #payload)
		if mcu_do == "Update" then
			adc_value = adc.read(adc_id)
			if adc_value > 1023 then
				adc_value = 1023
			elseif adc_value < 0 then
				adc_value = 0
			end
			print("ADC: ", adc_value)
		end
	end
	print(payload)
	postparse = {string.find(payload, "update=")}
	print(postparse[1])
	print(postparse[2])
	if postparse[2]~=nil then
		esp_update()
	end
	--HTML Header Stuff
	conn:send('<!DOCTYPE html>\n')
	conn:send('<html>\n')
	conn:send('<head>\n')
	conn:send('<meta charset="UTF-8" />\n')
	conn:send('<meta name="viewport" content="width=device-width" />\n')
	conn:send('<title>ESP8266 Light</title>\n')
	conn:send('</head>\n')
	conn:send('<body style="background-color:powderblue">\n')
	conn:send('<h1 style="color:blue">Освітлення Рослин</h1>\n')
	conn:send('<p style="color:red">Температура приладу: </p>\n')
	conn:send('<p style="color:#800000">Рівень зовнішнього <br>освітлення: </p>\n')
	conn:send('<p>Поточний час:</p><br><br>\n')
	conn:send('<form action="" method="post" accept-charset="utf-8">\n')
	conn:send('<input  type="submit" value="Update" name="update" id="update" style="font-size:20px;border:2;background-color:#FFE4C4"/>\n')
	conn:send('</form>\n')
	conn:send('<h1 style="color:green">Налаштування:</h1>\n')
	conn:send('<form action="" method="post" accept-charset="utf-8">\n')
	conn:send('Температура аварійного <br>виключення: <input type="number" value="100" name="tempOff" id="tempOff" min="0" max="200"/>\n')
	conn:send('</form>\n')
	conn:send('</body>\n')
	conn:send('</html>\n')
	-- conn:send('HTTP/1.1 200 OK\n\n')
	-- conn:send('<!DOCTYPE HTML>\n')
	-- conn:send('<html>\n')	
	-- conn:send('<head><meta content="text/html; charset=utf-8">\n')
	-- conn:send('<title>ESP8266 Blinker Thing</title></head>\n')
	-- conn:send('<body><h1>ESP8266 Blinker Thing!</h1>\n')
    --
	-- --Image...
	-- conn:send('<IMG SRC="'..site_image..'" WIDTH="392" HEIGHT="196" BORDER="1"><br><br>\n')
	-- conn:on("sent", function(conn) conn:close() end)
    --
	-- --Labels
	-- conn:send('<p>ADC Value: '..adc_value..'</p><br>')
	-- --Buttons
	-- conn:send('<form action="" method="POST">\n')
	-- conn:send('<input type="submit" name="mcu_do" value="Read ADC"><br>\n')
	-- conn:send('<input type="text"><br>\n')
	-- conn:send('<input type="checkbox" name="Test"><br>\n')
	-- conn:send('<input type="submit" name="mcu_do" value="Update LED"><br>\n')
	-- conn:send('<input type="button" name="Proba" value="proba"><br>\n')
	-- conn:send('<input type="color"><br>\n')
	-- conn:send('<body></html>\n')
	conn:on("sent", function(conn) conn:close() end)
	end)
end)
