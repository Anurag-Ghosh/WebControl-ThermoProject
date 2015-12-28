while true do
  --Update High and Low values as they change
  if io.outTemp > reg.todayHigh then
    reg.todayHigh = io.outTemp
    reg.todayHighTime = tonumber(string.format("%02d.%02d", time.getComponents(time.now()).hour, time.getComponents(time.now()).min))
  end
  if io.outTemp < reg.todayLow then
    reg.todayLow = io.outTemp
    reg.todayLowTime = tonumber(string.format("%02d.%02d", time.getComponents(time.now()).hour, time.getComponents(time.now()).min))
  end
  --Send Email Alerts
  if reg.email then
    if io.curTemp > reg.hTempAlarm then
      emailDef = {
       rcpt = "grp.admin",
       subj = [[High Temperature Alarm.]],
       body = [[The current temperature is too high.  Current Temperature: ]] .. io.curTemp
      }
      email(emailDef)
    end

    if io.curTemp < reg.lTempAlarm then
      emailDef = {
       rcpt = "grp.admin",
       subj = [[Low Temperature Alarm.]],
       body = [[The current temperature is too low.  Current Temperature: ]] .. io.curTemp
      }
      email(emailDef)
    end

    if event.resetFilter == 1 then
      emailDef = {
       rcpt = "grp.admin",
       subj = [[Time to change the filter.]],
       body = [[It's time to change the filter on your HVAC unit.]]
      }
      email(emailDef)
    end
  end
  --Sets the high and low values when settings are committed or on power up
  if reg.todayHigh == 0 and reg.todayLow == 0 then
    reg.todayHigh = io.outTemp
    reg.todayLow = io.outTemp
    reg.todayHighTime = tonumber(string.format("%02d.%02d", time.getComponents(time.now()).hour, time.getComponents(time.now()).min))
    reg.todayLowTime = tonumber(string.format("%02d.%02d", time.getComponents(time.now()).hour, time.getComponents(time.now()).min))
    --double check that values stuck
    if reg.todayHigh == 0 then
      reg.todayHigh = io.outTemp
    end
    if reg.todayLow == 0 then
      reg.todayLow = io.outTemp
    end
  end
end