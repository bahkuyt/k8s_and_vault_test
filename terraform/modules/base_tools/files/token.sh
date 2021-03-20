#!/bin/bash

TOKEN=`kubectl -n vault exec -it vault-0 -- vault operator init | grep 'Initial Root Token' | cut -d ' ' -f4`
jq -n --arg token $TOKEN '{token: $token}'