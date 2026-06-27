#!/bin/bash
if terraform apply -auto-approve; then
    echo "terraform finished ok!"
else
    echo "terraform failed!!!"
    exit
fi
export GCP_PEER_IP=$(terraform output gcp_tunnel_ip)
source ./.venv/bin/activate
if python3 configure_mikrotik.py; then
    echo "configuration script finished ok!"
else
    echo "python script failed!!!"
    exit
fi
deactivate
