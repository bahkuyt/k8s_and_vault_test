#!/bin/bash


CMD="kubectl get po -n cert-manager -o jsonpath={.items[2].status.phase}"

until [[ $(${CMD}) = "Running" ]];
 do 
 echo webhook-cert-manager not yet available;
 sleep 15;
 done
