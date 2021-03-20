cat << EOF | kubectl -n vault exec -it vault-0 -- vault policy write kes -
path "kes/data/*" {
  capabilities = ["read", "list"]
}
EOF