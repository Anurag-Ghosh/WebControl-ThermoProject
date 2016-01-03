--This script will calculate the sunrise and sunset time using the longitude, latitude, and UTC offset of a location.
--At the very end of the script (about line 80), there is a location to enter what you would like the script to do.
--You may directly turn on a relay, or turn on a register.

--Variables to edit to set location
local longitude = 111.82983 --west positive
local latitude = 41.73033 -- north positive
local UTCOffset = -7

--Variables
local dayOfYear
local isDST
local SunriseHours
local SunriseMins
local SunsetHours
local SunsetMins
local isDay -- variable is true when the sun is up

--Function to calculate the sunrise and sunset time
function calcSunriseSunset()
	local calcTime = time.getComponents(time.now())
 	local dayOfYear = calcTime.yday
	local isDST = calcTime.isdst
	X = -math.tan(math.rad(latitude))
	Y = math.sin(math.rad(360 * (dayOfYear + 284) / 365))
	Z = math.tan(math.rad(23.44 * Y))
	H = (1 / 15) * math.deg(math.acos(X * Z))
	Hours = math.floor(H)
	Mins = math.floor((H - Hours) * 60)
	print("Sunrise is "..Hours.." Hours and "..Mins.." Minutes before local noon")
	
	localNoon = (longitude - (-UTCOffset * 15)) / 15 + 0.123 + 12
	NoonHours = math.floor(localNoon)
	NoonMins = math.floor((localNoon - NoonHours) * 60)
	if isDST then
		NoonHours = NoonHours + 1
	end
	
	SunriseHours = NoonHours - Hours
	SunriseMins = NoonMins - Mins
	if SunriseMins < 0 then
		SunriseHours = SunriseHours - 1
		SunriseMins = 60 - math.abs(SunriseMins)
	end
	
	SunsetHours = NoonHours + Hours
	SunsetMins = NoonMins + Mins
	if SunsetMins >= 60 then
		SunsetHours = SunsetHours + 1
		SunsetMins = SunsetMins - 60
	end
	
	print("Local Noon is: "..string.format("%02d:%02d", NoonHours, NoonMins))
	print("Sunrise is: "..string.format("%02d:%02d", SunriseHours, SunriseMins))
	print("Sunset is: "..string.format("%02d:%02d", SunsetHours, SunsetMins))
end

--Call calcTime to calculate the Sunrise/Sunset before running main program
calcSunriseSunset()

--Main program below
while true do
  	--Get the current time for the X-600M system clock
	local calcTime = time.getComponents(time.now())
	
	--Calculate Sunrise and Sunset Times Every Day at Midnight
	if calcTime.hour == 0 and calcTime.min <= 5 then
		calcSunriseSunset()
	end
	
	
	--isDay will be on during daylight hours, and off during night-time hours.
	if calcTime.hour == SunsetHours and calcTime.min >= SunsetMins then
		isDay = 0
	elseif calcTime.hour > SunsetHours then
		isDay = 0
	elseif calcTime.hour == SunriseHours and calcTime.min <=SunriseMins then
		isDay = 0
	elseif calcTime.hour < SunriseHours then
		isDay = 0
	else
		isDay = 1
	end
	
	if isDay == 1 then
		--What to do if it is day (turn on/off relay or register)

		print("It is daytime")
	else
		--What to do if it is night (turn on/off relay or register)

		print("It is nighttime")
	end
	
	--Sleep for 5 Mins
	sleep(300000)

end