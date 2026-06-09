#!/bin/bash
terraform apply -auto-approve
export GCP_PEER_IP=$(terraform output gcp_tunnel_ip)
source ./.venv/bin/activate
python3 configure_mikrotik.py
deactivate
