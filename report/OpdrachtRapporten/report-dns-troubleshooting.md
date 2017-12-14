# Enterprise Linux Lab Report - Troubleshooting

- Student name: Stephan Heirbaut
- Class/group: TIN-TI-3B (Gent)

## Instructions

- Write a detailed report in the "Report" section below (in Dutch or English)
- Use correct Markdown! Use fenced code blocks for commands and their output, terminal transcripts, ...
- The different phases in the bottom-up troubleshooting process are described in their own subsections (heading of level 3, i.e. starting with `###`) with the name of the phase as title.
- Every step is described in detail:
    - describe what is being tested
    - give the command, including options and arguments, needed to execute the test, or the absolute path to the configuration file to be verified
    - give the expected output of the command or content of the configuration file (only the relevant parts are sufficient!)
    - if the actual output is different from the one expected, explain the cause and describe how you fixed this by giving the exact commands or necessary changes to configuration files
- In the section "End result", describe the final state of the service:
    - copy/paste a transcript of running the acceptance tests
    - describe the result of accessing the service from the host system
    - describe any error messages that still remain

## Report

### Phase 1: Fysieke laag

- Controleren kabel aangesloten
  - verwachte uitvoer: kabel aangesloten
  - bekomen resultaat: alle kabels aangesloten
  
- Booten netwerkinterfaces
  - verwachte resultaat: alle interfaces starten correct op
  - bekomen resultaat: fysieke interfaces niet gevonden
  - oplossing: nieuwe host only interface aangemaakt en ip adres aan gekoppelt.
  
- ip link
  - verwachte uitvoer: alle interfaces in een up-state
  - bekomen uitvoer: enp0s3 in UP mode, enp0s8 DOWN mode
  - oplossing: ip link set enp0s8 up

### Phase 2: Internet laag

- ip a
  - verwachte uitvoer: alle interfaces hebben een geldig ip adres
  - bekomen uitvoer: enp0s3 in orde, enp0s8 toont geldige configuratie /etc/sysconfig/network-scripts/ifcfg-enp0s8 en enp0s3 gecontroleerd voor de zekerheid. Configuratie in orde.
  
- ip route
  - verwachte uitvoer: alle default routes zijn in orde
  - bekomen uitvoer: alle default routes zijn in orde
  
- ping ip adressen VBox
  - verwachte uitvoer: reactie van DHCP, Default Gateway en DNS
  - bekomen uitvoer: reactie van DHCP, Default Gateway en DNS
  
- ping ip adressen host naar server
  - verwachte uitvoer: reactie van en naar host
  - bekomen uitvoer: ze kunnen elkaar bereiken
  
- dig www.google.com
  - verwachte uitvoer: ip informatie van de url
  - bekomen uitvoer: ip informatie van de url

### Phase 3: Transport laag

- sudo systemctl status named
  - verwachte uitvoer: named-service is aan het draaien
  - bekomen uitvoer: named-service active failed
  - oplossing:
    - Check /etc/named.conf:
      - syntax options: in orde
        - "/var/named": in orde
        - "/var/named/data/cache_dump.db": in orde
        - "/var/named/data/named_stats.txt": in orde
        - "/var/named/data/named.mem.stats.txt": in orde
        - "/etc/named.iscdlv.key": in orde
        - "/var/named/data/dynamic": in orde
        - "/run/named/data/named.pid": in orde
        - "/run/named/data/session.key": in orde
      - syntax logging: in orde
        - "data/named.run": in orde
      - syntax zone ".": in orde
        - "named.ca": in orde
      - syntax includes: in orde
        - "/etc/named.rfc1912.zones": in orde
        - "/etc/named.root.key": in orde
      - syntax zones: in orde
        - "cynalco.com": '.' op de juiste plaatsen zetten
        - "192.168.56.in-addr.arpa": zone 2.0.192.in-addr.arpa/IN: NS 'golbat.cyncalco.com.2.0.192.in-addr.apra' has no address records (A or AAAA), oplossing? Er stond geen '.' achter golbat.cyncalco.com. A record ook toegevoegd.
        - "56.168.192.in-addr.arpa": aanmaken
        - "2.0.192.in-addr.arpa": Fouten in de record, maar waar?
    - sudo systemctl start named opnieuw proberen en daarna logs checken:
      - sudo systemctl status named
      - sudo journalctl -xn
      
- sudo firewall-cmd --add-service=dns
  - verwachte uitvoer: success
  - bekomen uitvoer: success
  
- sudo firewall-cmd --permanent --add-service=dns
  - verwachte uitvoer: success
  - bekomen uitvoer: success
  
- sudo firewall-cmd --reload
  - verwachte uitvoer: success
  - bekomen uitvoer: success
  
- ss -tlunp
  - verwachte uitvoer: lijst van alle poorten waar er naar geluisterd wordt, waaronder poort 53
  - bekomen uitvoer: een lijst van alle poorten waar er naar geluisterd wordt, waaronder poort 53
  
### Phase 4: Applicatie laag

- sudo setsebool -P named_tcp_bind_http_port=1
  - verwachte uitvoer: toevoegen permissies
  - bekomen uitvoer: named_tcp_bind_http_port -> on

## End result

Ik heb de service werkende gekregen en ik kan ook pingen van en naar de localhost en een VM in hetzelfde netwerk. Maar, ik krijg geen enkele van de testen werkende. De fout met de interface en de service toevoegen aan de firewall was ook geen probleem. Maar, forward of reverse resolution is niet gelukt. Ik had wel door dat er fouten in de records zaten en dat er een record voor reverse lookups moest aangemaakt worden. Maar, ik zag de fouten in de records niet. Achteraf dan gehoord dat ik beter had moeten kijken, want er bleken niet één maar meerdere '.' te ontbreken. Beetje stom.

## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.

[DNS troubleshooting](https://github.com/HStephan95/elnx-ha/blob/master/report/Documentatie/DNS%20troubleshooting.md)
[Vorige oefening troubleshooting](https://github.com/HStephan95/elnx-ha/blob/master/report/OpdrachtRapporten/report-netwerk-troubleshooting.md)
[How to - troubleshooting](https://github.com/HStephan95/elnx-ha/blob/master/report/Documentatie/Netwerkproblemen%20troubleshooting%20-%20how%20to.md)
[Netwerk troubleshooting commando's](https://github.com/HStephan95/elnx-ha/blob/master/report/Documentatie/Netwerkproblemen%20troubleshooting%20-%20commando's.md)
[SELinux troubleshooting](https://github.com/HStephan95/elnx-ha/blob/master/report/Documentatie/SELinux%20troubleshooting.md)
[Computerhope](https://www.computerhope.com/)
[Dig](https://www.computerhope.com/unix/dig.htm)
[CentOS Zone files](https://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-bind-zone.html)