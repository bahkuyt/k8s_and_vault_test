#!/bin/bash


CMD="kubectl get po -n vault -o jsonpath={.items[0].status.phase}"

until [[ $(${CMD}) = "Running" ]];
 do 
 echo vault service not yet available;
 sleep 5;
 done