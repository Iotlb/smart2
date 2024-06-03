#!/bin/bash
echo "Invio Dati tramite Mosquitto"
sleep 1

a=0
SECONDS=0
Linea=""
istante=""; idveicolo=""; posizione=0; velocita=0

while IFS= read -r Linea || [ -n "$Linea" ] ; do

 if [[ $Linea == *"<timestep"* ]] ; then
 istante="$(echo "$Linea" | awk -F ' time="' '{print $2}' )"; istante="$(echo "$istante" | awk -F '"' '{print $1}' )" ; 
 echo  -en "\r( Istante di riferimento attualmente in elaborazione: $istante ) "
 
 elif [[ $Linea == *"<lane"* ]] ; then
 let a++
 idstrada="$(echo "$Linea" | awk -F ' id="' '{print $2}' )" ; idstrada="$(echo "${idstrada}" | awk -F '"' '{print $1}' )" ;   
  
 elif [[ $Linea == *"<vehicle"* ]] ; then
 idveicolo="$(echo "$Linea" | awk -F ' id="' '{print $2}' )" ; idveicolo="$(echo "${idveicolo}" | awk -F '"' '{print $1}' )" ;   
 posizione="$(echo "$Linea" | awk -F ' pos="' '{print $2}' )" ; posizione="$(echo "${posizione}" | awk -F '" ' '{print $1}' )" ;   
 velocita="$(echo "$Linea" | awk -F ' speed="' '{print $2}' )" ; velocita="$(echo "${velocita}" | awk -F '"/' '{print $1}' )" ;   
 
 mosquitto_pub -h broker.emqx.io -m '{"Lane_id": "'$idstrada'", "Istante": "'$istante'", "Veicolo": "'$idveicolo'", "Posizione": '$posizione', "vel": '$velocita' }' -t topic1

 elif [[ $Linea == *"</netstate>" ]]; then
 echo -en "\nFine Lettura" ; break ; 
 fi  

done < /root/Desktop/datiposiz.xml

durata=$SECONDS
echo "$((durata / 60)) minuti e $((durata % 60)) secondi trascorsi."
echo "---INVIO MOSQUITTO TERMINATO---"