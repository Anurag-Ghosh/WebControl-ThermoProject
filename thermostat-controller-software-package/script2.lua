heatTimer = 0
coolTimer = 0
fanTimer = 0
offTimer = 0
heatOnTime = time.seconds()
coolOnTime = time.seconds()
fanOnTime = time.seconds()
offTime = time.seconds()
heatFlag = 0
coolFlag = 0
fanFlag = 0
offFlag = 2

while true do
  --HVAC control logic
  --Manual Control
  if reg.day7 == 0 or reg.override == 1 then
    --OFF
    if reg.heatMode == 0 then
      if coolFlag == 2 then
        io.cool = 0
      	coolFlag = 0
      end
      if heatFlag == 2 then
        io.heat = 0
      	heatFlag = 0
      end
    --HEAT
    elseif reg.heatMode == 1 or io.heat == 1 then
      if coolFlag == 2 then
      	io.cool = 0
      end
      if reg.setTemp - 2 > io.curTemp and coolFlag == 0 and offFlag == 2 then
        io.heat = 1
      elseif reg.setTemp - reg.heatAnticipation < io.curTemp and heatFlag == 2 then
        io.heat = 0
        heatFlag = 0
      end
    --COOL
    elseif reg.heatMode == 2 then
      if heatFlag == 2 or io.cool == 1 then
      	io.heat = 0
      end
      if reg.setTemp + 2 < io.curTemp and heatFlag == 0 and offFlag == 2 then
        io.cool = 1
      elseif reg.setTemp + reg.coolAnticipation > io.curTemp and coolFlag == 2 then
        io.cool = 0
        coolFlag = 0
      end
    --AUTO
    elseif reg.heatMode == 3 then
      if reg.setTemp + 2 < io.curTemp and heatFlag == 0 and offFlag == 2 then
        io.cool = 1
        io.heat = 0
      end
      if reg.setTemp - 2 > io.curTemp and coolFlag == 0 and offFlag == 2 then
        io.heat = 1
        io.cool = 0
      end
      if reg.setTemp - reg.heatAnticipation < io.curTemp and heatFlag == 2 then
        io.heat = 0
        heatFlag = 0
      end
      if reg.setTemp + reg.coolAnticipation > io.curTemp and coolFlag == 2 then
        io.cool = 0
        coolFlag = 0
      end
      if io.heat == 1 and reg.setTemp > io.curTemp then
        io.cool = 0
      elseif io.cool == 1 and reg.setTemp < io.curTemp then
        io.heat = 0
      end
    end
    --7 Day Programming Control
  elseif reg.day7 == 1 and reg.override == 0 then
    --OFF
    if reg.heatMode == 0 then
      if coolFlag == 2 then
        io.cool = 0
      	coolFlag = 0
      end
      if heatFlag == 2 then
        io.heat = 0
      	heatFlag = 0
      end
    --HEAT
    elseif reg.heatMode == 1 then
      if coolFlag == 2 then
      	io.cool = 0
      end
      if reg.setHeat - 2 > io.curTemp and coolFlag == 0 and offFlag == 2 then
        io.heat = 1
      elseif reg.setHeat - reg.heatAnticipation < io.curTemp and heatFlag == 2 then
        io.heat = 0
        heatFlag = 0
      end
    --COOL
    elseif reg.heatMode == 2 then
      if heatFlag == 2 then
      	io.heat = 0
      end
      if reg.setCool + 2 < io.curTemp and heatFlag == 0 and offFlag == 2 then
        io.cool = 1
      elseif reg.setCool + reg.coolAnticipation > io.curTemp and coolFlag == 2 then
        io.cool = 0
        coolFlag = 0
      end
    --AUTO
    elseif reg.heatMode == 3 then
      if reg.setCool + 2 < io.curTemp and heatFlag == 0 and offFlag == 2 then
        io.cool = 1
        io.heat = 0
      end
      if reg.setHeat - 2 > io.curTemp and coolFlag == 0 and offFlag == 2 then
        io.heat = 1
        io.cool = 0
      end
      if reg.setHeat - reg.heatAnticipation < io.curTemp and heatFlag == 2 then
        io.heat = 0
        heatFlag = 0
      end
      if reg.setCool + reg.coolAnticipation > io.curTemp and coolFlag == 2 then
        io.cool = 0
        coolFlag = 0
      end
      if io.heat == 1 and reg.setHeat > io.curTemp then
        io.cool = 0
      elseif io.cool == 1 and reg.setCool < io.curTemp then
        io.heat = 0
      end
    end
  end
  
  --Minimum cycle time
  if io.heat == 1 then
    if heatFlag == 0 then
      heatOnTime = time.seconds();
      heatFlag = 1
    elseif heatFlag == 1 then
    	heatTimer = tonumber(time.seconds().lsw) - tonumber(heatOnTime.lsw)
      if heatTimer > reg.minCycleTime * 60 then
        heatFlag = 2
      end
    end
  else
    heatFlag = 0
  end
  
  if io.cool == 1 then
    if coolFlag == 0 then
      coolOnTime = time.seconds();
      coolFlag = 1
    elseif coolFlag == 1 then
    	coolTimer = tonumber(time.seconds().lsw) - tonumber(coolOnTime.lsw)
      if coolTimer > reg.minCycleTime * 60 then
        coolFlag = 2
      end
    end
  else
    coolFlag = 0
  end
  
  if io.cool == 0 and io.heat == 0 then
    if offFlag == 0 then
      offTime = time.seconds();
      offFlag = 1
    elseif offFlag == 1 then
    	offTimer = tonumber(time.seconds().lsw) - tonumber(offTime.lsw)
      if offTimer > reg.minCycleTime * 60 then
        offFlag = 2
      end
    end
  else
    offFlag = 0
  end
  --Fan mode
  if reg.fanMode == 0 then
    io.fan = 1
	--This is to turn the fan off(I added this)
	elseif reg.fanMode == 1 then
    io.fan = 0

	else
    if io.heat == 1 and reg.fanWithHeat == 1 then
      io.fan = 1
      fanFlag = 1
    elseif io.cool == 1 then
      io.fan = 1
      fanFlag = 1
    elseif io.cool == 0 and io.heat == 0 and fanFlag == 1 then
      fanOnTime = time.seconds();
      fanFlag = 2
    end
    
    if fanFlag == 2 then
      fanTimer = tonumber(time.seconds().lsw) - tonumber(fanOnTime.lsw)
      if fanTimer > reg.fanOffDelay then
        fanFlag = 0
      end
    elseif fanFlag == 0 then
      io.fan = 0
    end
  end
  
end