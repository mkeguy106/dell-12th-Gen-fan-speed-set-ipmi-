



#!/bin/bash
#
# chmod +x /scripts/dell_ipmi_fan_control.sh
#
#
# Hex to Decimal: http://www.hexadecimaldictionary.com/hexadecimal/0x1a/
#
# print temps and fans rpms
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD sensor reading "Ambient Temp" "FAN 1 RPM" "FAN 2 RPM" "FAN 3 RPM"
#
# print fan info
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD sdr get "Fan1 RPM" "FAN 2 RPM" "FAN 3 RPM"
#
#<EXAMPLE MANUAL COMMANDS>
# enable manual/static fan control
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD raw 0x30 0x30 0x01 0x00
#
# disable manual/static fan control
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD raw 0x30 0x30 0x01 0x01
#
# set fan speed to 0 rpm
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff 0x00
#
# set fan speed to 20 %
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff 0x14
#
# set fan speed to 30 %
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff 0x1e
#
# set fan speed to 100 %
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD raw 0x30 0x30 0x02 0xff 0x64
#
#List all Sesors
#ipmitool -I lanplus -H 192.168.0.229 -U root -P IDRAC_PASSWORD sdr list 
#</EXAMPLE MANUAL COMMANDS>
#
#
#
DATE=$(date +%Y-%m-%d-%H:%M:%S)
echo "" && echo "" && echo "" && echo "" && echo ""
echo "$DATE"
#
IDRACIP="192.168.0.229"
IDRACUSER="root"
IDRACPASSWORD="IDRAC_PASSWORD"
STATICSPEEDBASE16="0x0f"
SENSORNAME="Exhaust"
TEMPTHRESHOLD="38"
#
T=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD sdr type temperature | grep $SENSORNAME | cut -d"|" -f5 
| cut -d" " -f2)
# T=$(ipmitool -I lanplus -H $IDRACIP2 -U $IDRACUSER -P $IDRACPASSWORD sdr type temperature | grep $SENSORNAME2 | cut -d"|" 
-f5 | cut -d" " -f2 | grep -v "Disabled")
echo "$IDRACIP: -- current temperature --"
echo "$T"
#
if [[ $T > $TEMPTHRESHOLD ]]
  then
    echo "--> enable dynamic fan control"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x01
  else
    echo "--> disable dynamic fan control"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x00
    echo "--> set static fan speed"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff $STATICSPEEDBASE16
fi
