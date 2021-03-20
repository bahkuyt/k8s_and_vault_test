#!/bin/bash

CMD="kubectl -n istio-system get service istio-ingressgateway -o jsonpath={.status.loadBalancer.ingress[0].ip}"

IP=$(${CMD})
until [[ ${IP} != "" ]]
do
  sleep 5
  IP=$(${CMD})
done

jq -n --arg ip ${IP} '{ip: $ip}'
