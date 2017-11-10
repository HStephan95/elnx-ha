# Check network settings

|commando|Parameters|beschrijving|
|--------|----------|------------|
|ip link|[device naam] vb.: em1, eno1, p1p1, enp0s3, w1p3s0b1|Geeft je informatie over je NIC|
|ip a|[device naam] vb.: em1, eno1, p1p1, enp0s3, w1p3s0b1|Toont informatie over de IP adressering van al je NIC's|
|ip route|/|Toont routering informatie|
|systemd-networkd|/|Traditioneel commando|

# Check services

## Systemtctl (bij alles sudo verplicht)

|commando|Parameters|beschrijving|
|--------|----------|------------|
|systemctl status|[naam]|Geeft informatie over een bepaalde service die aan het draaien is|
|systemctl start|[naam]|Start een bepaalde service op|
|systemctl stop|[naam]|Stopt een bepaalde service|
|systemctl restart|[naam]|Herstart een bepaalde service|
|systemctl enable|[naam]|Activeert de daemon die bij de service draait|
|systemctl disable|[naam]|Deactiveert de daemon die bij de service hoort|
|systemctl list-units|/|Toont alle units die systemd aan het draaien is of probeerde draaien|
|systemctl list-unit-files|/|Toont de files geassocieerd met alle units|
|systemctl --type=service|/|Maakt een lijst van alle services|
|systemctl --state=running,inactive,|/|Toont alle services die aan het draaien zijn|
|systemctl --failed|/|Toont alle gefaalde services|

# Check logs

## Journalctl (bij alles sudo verplicht)

|commando|Parameters|beschrijving|
|--------|----------|------------|
|journalctl -f|[var-log] vb.: /var/log/httpd/access_log|Toont het log files van dat bepaald var-log bestand en update continue (houdt terminal bezet|
|journalctl -u|[service]|Toont alle log bestanden geassocieerd met die bepaalde service|
|journalctl|[executable] vb.: /usr/sbin/dhclient| Toont alle entries die matchen met deze executable|
|journalctl|[device node] vb.: /dev/sda|Toont alle entries die matchen met die bepaalde node|
|journalctrl [_TRANSPORT=audit]|/|Toont auditd logs|
|journalctl -b|/|Alle logs sinds opstarten|
|journalctl -k|/|Alle kernel messages sinds opstarten|
|journalctl -r|/|Toont de logs in omgekeerde volgorde (eerst de oudste)|
|journalctl -p err|/|Toont alleen de ergste meldingen (errors enzo)|
|journalctl --since=[date] \ [--until=[date]]|/|Toont alle logs sinds dat bepaald tijdsstip, en eventueel tot een bepaald tijdstip|

# Show sockets

## netstat is obsolete (/prov/net/tcp), gebruik ss (direct aan de kernel)

### Combinaties mogelijk, bv.: ss -tunp

|commando|Parameters|beschrijving|
|--------|----------|------------|
|ss -l|/|Alle server sockets|
|ss -t|/|Alle TCP sockets|
|ss -u|/|Alle UDP sockets|
|ss -n|/|Alle poortnunmmers|
|sudo ss -p|/|Alle draaiende netwerkprocessen (sudo nodig)|

# Firewall settings

### Firewalld is dynamisch en werkt met zones (een lijst van regels voor een bepaalde situatie).

### firewall-cmd vereist root permissies

|commando|Parameters|beschrijving|
|--------|----------|------------|
|firewall-cmd --get-zones|/|Toont een lijst van alle zones|
|firewall-cmd --get-active-zones|/|Toont een lijst van alle actieve zones|
|firewall-cmd --add-interface=[interface]|/|Voeg een interface toe aan een bepaalde zone|

### Firewall configuratie (let op! bij het opstarten kunnen zone toekenningen overschreven worden)

|commando|Parameters|beschrijving|
|--------|----------|------------|
|firewall-cmd --list-all|/|Toont alle huidige regels|
|firewall-cmd --get-services|/|Toont een lijst van alle voorgedefinieerde services|
|firewall-cmd --add-service=[service]|--permanent, vereist dan wel reload|Voegt een voorgedefinieerde service toe aan de firewall|
|firewall-cmd --add-port=[poortnummer/tcp of udp]|--permanent, vereist dan wel reload|Voeg een poort bij aan de lijst van geopende poorten|
|firewall-cmd --reload|/|Herstart de firewall om de nieuwe regels toe te passen|
|firewall-cmd --panic-on|/|Blokkeer al het verkeer|
|firewall-cmd --panic-off|/|Schakelt panic-mode weer uit|


### Helpfull links

- [ComputerHope](https://www.computerhope.com/)  
- [Uitleg Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs)  
- [BertVV uitleg YT](https://www.youtube.com/watch?v=ciXpmDwJKOM&index=4&list=PLQax3yoBY5vsgZm9O5-bO2Q5rwARlKESd)  
- [BertVV troubleshooting presentation](https://bertvv.github.io/presentation-el7-basics/)  
- [BertVV troubleshooting repo](https://github.com/bertvv/linux-network-troubleshooting)  
