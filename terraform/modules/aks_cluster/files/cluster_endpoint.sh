#!/bin/bash

CLUSTER_ENDPOINT=`kubectl config view -o jsonpath='{.clusters[].cluster.server}'`

jq -n --arg cluster_endpoint ${CLUSTER_ENDPOINT} '{cluster_endpoint: $cluster_endpoint}'