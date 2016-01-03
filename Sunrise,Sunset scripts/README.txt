This script was written to allow the X-600M to calculate the approximate times of the sunrise and sunset, 
based on the latitude and longitude entered into it.  

This script requires three inputs:  
The latitude, with locations in the northern hemisphere being positive.  
The longitude, with numbers in the western hemisphere being positive. 
The UTC offset.

Currently the script will output the times into the debug console. You can use the isDay variable and if 
statement to set relays, registers, and variables depending on whether the sun is up or not.