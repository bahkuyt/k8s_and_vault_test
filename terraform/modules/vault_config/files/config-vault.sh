#!/bin/bash

# get the CONTEXT and KES_NAMESPACE from the input json
#eval "$(jq -r '@sh KES_NAMESPACE=\(.kes_namespace)"')"

# get the token secret and token from k8s
KES_TOKEN_SECRET=$(kubectl get sa -n kes kes-kubernetes-external-secrets -o jsonpath='{.secrets[].name}')
KUBE_TOKEN=$(kubectl -n kes get secret ${KES_TOKEN_SECRET} -o jsonpath={.data.token})

# return a json string with the token
jq -n --arg kube_token "${KUBE_TOKEN}" '{kube_token: $kube_token}'
