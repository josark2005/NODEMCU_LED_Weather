--[[
    请在使用前仔细阅读Readme文件！
    Please read the Readme file carefully before starting!
]]
-- configurations
wifi_ssid = "WIFI_SSID"
wifi_pwd = "WIFI_PASSWORD"

location = "yourCity"

-- 知心天气
weather_sk = ""

-- pins definition
pin_wifi = 2        -- pwm
pin_status = 1      -- pwm
pin_warning = 6     -- pwm
pin_btn = 7         -- pwm
pin_btn_led = 3

-- initialize
gpio.mode(pin_btn_led, gpio.OUTPUT)
gpio.write(pin_btn_led, gpio.LOW)

require("wifi_controller")
require("weather")

-- connect wifi
wf.conn(wifi_ssid, wifi_pwd)

-- weather
gpio.mode(pin_btn, gpio.INT)
busy_flag = 0
function onBtnUp()
    print('pressed')
    gpio.trig(pin_btn)
    local time = tmr.create()
    time:alarm(1000, tmr.ALARM_SINGLE, function()
        gpio.trig(pin_btn, 'up', onBtnUp)
    end)
    if (busy_flag == 0) then
        wt.get(pin_status, pin_warning, pin_btn_led)
    end
end
gpio.trig(pin_btn, 'up', onBtnUp)
