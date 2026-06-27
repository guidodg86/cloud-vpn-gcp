#!/bin/bash
if terraform destroy -auto-approve; then
    echo "terraform finished ok!"
else
    echo "terraform failed!!!"
    exit
fi
source ./.venv/bin/activate
if python3 remove_mikrotik_config.py; then
    echo "removal script ok!"
else
    echo "deletion script failed!!!"
    exit
fi
deactivate
