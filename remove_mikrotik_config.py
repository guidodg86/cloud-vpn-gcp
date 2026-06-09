#Global imports
from netmiko import ConnectHandler
import os
from jinja2 import Environment, FileSystemLoader

# Get environment variables
MIKROTIK_IP = os.environ['mikrotik_mgmt_ip']
MIKROTIK_USER = os.environ['mikrotik_user']
MIKROTIK_PASS = os.environ['mikrotik_password']

#Create device dictionary for netmiko
home_mikrotik = {
    'device_type': 'mikrotik_routeros',
    'ip': MIKROTIK_IP,
    'username': MIKROTIK_USER,
    'password': MIKROTIK_PASS,
}

#Connect to the device
net_connect = ConnectHandler(**home_mikrotik)

#Clean up old configuration
output = net_connect.send_config_set(["/ip ipsec policy", "remove 1"])
print(output)
output = net_connect.send_config_set(["/ip ipsec identity", "remove 0"])
print(output)
output = net_connect.send_config_set(["/ip ipsec proposal", "remove 1"])
print(output)
output = net_connect.send_config_set(["/ip ipsec peer", "remove 0"])
print(output)
output = net_connect.send_config_set(["/ip ipsec profile", "remove 1"])
print(output)


net_connect.disconnect()