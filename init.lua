-- init.lua --
ssid = "home"
pass = "ttyjjuj0"

print('\nAll About Curcuits init.lua\n')
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.heap(),'\n')
--wifi config start
wifi.sta.config(ssid, pass)
--wifi config end

--Run the main file
dofile("main.lua")
