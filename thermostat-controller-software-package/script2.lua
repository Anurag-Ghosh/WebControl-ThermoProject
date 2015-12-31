

while true do
  --HVAC control logic
  
  --HEAT
    if reg.heatMode == 1 then
	 io.heat = 1
     elseif reg.heatMode == 0 then
      	io.heat = 0
      end
      
    --COOL
    if reg.coolMode == 1 then
      io.cool = 1
	  elseif reg.coolMode== 0 then
	  io.cool=0
        end
    
	--Fan mode
  if reg.fanMode == 1 then
    io.fan = 1
	--This is to turn the fan off(I added this)
	elseif reg.fanMode == 0  then
    io.fan = 0
    end
end