#!/bin/bash
terraform destroy -auto-approve
source ./.venv/bin/activate
python3 remove_mikrotik_config.py
deactivate
