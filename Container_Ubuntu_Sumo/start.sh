#!/bin/bash

clear
nohup /dev/dalpc/simulazioni.sh  &
/dev/dalpc/lettura.sh 
wait
