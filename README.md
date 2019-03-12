
install IPMI tools first.

```sudo apt install ipmitool```


Don't forget to make .sh file excutable

```sudo chmod +x /scripts/dell_ipmi_fan_control.sh```


Example crontab 

```#Check Temp, if too hot.. let ipmi dynamically set fan speed & log```

```* * * * * /scripts/dell_ipmi_fan_control.sh  >> /tmp/cron.log```
