-- weather module
-- !!global variale busy_flag needed
print "-- weather module has loaded"
wt = {}
link = "https://api.seniverse.com/v3/weather/now.json?key="..weather_sk.."&location=jiashan&language=zh-Hans&unit=c"
function wt.get(pin_status, pin_warning, busy_led)
    print('loading...')
    -- clear lights
    pwm.stop(pin_status)
    pwm.stop(pin_warning)
    print(link)
    busy_flag = 1
    pwm.setup(busy_led, 100, 10)
    pwm.start(busy_led)
    http.get(link, nil, function(code, data)
        print('complete')
        busy_flag = 0
        pwm.stop(busy_led)
        if (code < 0) then
          print("HTTP request failed")
        else
            print(code, data)
            if (code ~= 200) then
                -- blink 2 leds to show error
                pwm.setup(pin_status, 100, 20)
                pwm.start(pin_status)
                pwm.setup(pin_warning, 100, 20)
                pwm.start(pin_warning)
                local tobj = tmr.create()
                gpio.trig(pin_btn)
                tobj:alarm(1000, tmr.ALARM_SINGLE, function()
                    pwm.stop(pin_status)
                    pwm.stop(pin_warning)
                end)
            else
                -- show weather status
                local ret = sjson.decode(data)
                if (tonumber(ret['results'][1]['now']['code']) <= 9) then
                    -- nice day
                    pwm.setup(pin_status, 100, 20)
                    pwm.start(pin_status)
                else
                    -- others show warning
                    pwm.setup(pin_warning, 100, 20)
                    pwm.start(pin_warning)
                end
            end
        end
    end)
end
