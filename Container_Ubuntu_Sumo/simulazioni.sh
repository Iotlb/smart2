#!/bin/bash

echo "AVVIO SIMULAZIONE"
/sumo/bin/sumo -e 90 --scale 20 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --netstate /root/Desktop/datiposiz.xml 
echo "FINE SIMULAZIONE DI SUMO"