-- wifi module
print "-- wifi module has loaded"
wf = {}
function wf.conn(ssid, pwd)
    local msg = "-- start wifi connection:"..ssid;
    print(msg)
    wifi.setmode(wifi.STATION, false)
    local cfg = {}
    cfg.ssid = wifi_ssid
    cfg.pwd = wifi_pwd
    cfg.auto = auto
    wifi.sta.config(cfg)
end
-- listen
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED,function(t)
    print('-- wifi connected')
    pwm.setup(pin_wifi, 100, 5)
    pwm.start(pin_wifi)
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,function(t)
    print('-- wifi disconnected')
    pwm.stop(pin_wifi)
end)
