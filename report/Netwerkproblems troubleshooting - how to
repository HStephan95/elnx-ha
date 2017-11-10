# Troubleshooting

## Volg Het TCP/IP van beneden naar boven

### Fysieke en data link laag

- Bekabeling
- Switched en NIC LED's
- ip link voor instellingen NIC's

### Internet laag

- ip a voor adressering
- ip r voor default gateway
- ip route add 192.168.1.0/24 via 192.168.1.254 vb. aanpassen default gateway
- ping tussen hosts en GW/DNS
- dig voor query DNS
- nslookup voor query DNS
- getent voor query DNS
- cat /etc/resolv.conf
- VBOX default NAT interface: 10.0.2.15
- VBOX Default Gateway: 10.0.2.2
- VBOX DNS: 10.2.3

### Transport laag

- sudo systemctl status [service] is de benodige service aan het draaien?
- sudo ss -tulpn op de juiste poort of interface?
- sudo ps -ef toont alle (e) processen met de volledige uitleg (f)
- sudo firewall-cmd --list-all laat de firewall het verkeer toe?
- sudo iptables -L -n -v vooral voor oudere systemen zonder systemd, ook firewall instellingen
- /etc/service/conf poortnummer controleren
- /var/log/service/...

### Applicatie laag
- sudo journalctl -l -f -u [service] check de log bestanden (error en access)
- sudo journalctl -f [service] open een 2de terminal met een constante stroom van logs
- config file syntax
- programmeurs
- curl, wget webbrowser
- apachectl, configtest webbrowser testen
- smbclient, nmblookup, net use(Windows) fileserver
- testparm fileserver
- named-checkconf, named-checkzone DNS
