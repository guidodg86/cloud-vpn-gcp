#Global imports
from netmiko import ConnectHandler
import os
from jinja2 import Environment, FileSystemLoader

# Get environment variables
MIKROTIK_IP = os.environ['mikrotik_mgmt_ip']
MIKROTIK_USER = os.environ['mikrotik_user']
MIKROTIK_PASS = os.environ['mikrotik_password']
TUNNEL_SECRET = os.environ['TF_VAR_tunnel_secret']
GCP_PEER_IP = os.environ['GCP_PEER_IP']

#Create device dictionary for netmiko
home_mikrotik = {
    'device_type': 'mikrotik_routeros',
    'ip': MIKROTIK_IP,
    'username': MIKROTIK_USER,
    'password': MIKROTIK_PASS,
}

#Connect to the device
net_connect = ConnectHandler(**home_mikrotik)

#Generating mikrotik new config from jinja template
environment = Environment(loader=FileSystemLoader("jinja_templates/"))
template = environment.get_template("mikrotik_config.jinja")
gcp_ip_no_quotes = GCP_PEER_IP.replace('"', '')
content = template.render(
        peer_ip=gcp_ip_no_quotes,
        secret=TUNNEL_SECRET,
    )
print(content)
command_list = content.split("\n")
output = net_connect.send_config_set(command_list)
print(output)
net_connect.disconnect()
