# Enterprise Linux Lab Report - Troubleshooting

- Student name: Heirbaut Stephan
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

- Bij Oracle VM VirtualBox Manager, 'Netwerk' aanklikken en naar 'Adapater 2' gaan 'Geavanceerd' aanklikken en 'Kabel aangesloten' aanvinken.

- ip link:
  - verwachte uitvoer: alle interfaces in UP
  - bekomen uitvoer: alle interface in UP

### Phase 2: Internet laag

- ip a
  - verwachte uitvoer: geldige IP adressen voor alle interfaces.
    - 10.0.2.15 default voor de VBox NAT interface
    - 192.168.56.42 voor de VBOX Host-only interface
  - bekomen uitvoer: alle interfaces zijn goed geconfigureerd.
  
- ip r
  - verwachte uitvoer: geldige default gateway voor alle interfaces.
    - 10.0.2.2 voor de VBOX NAT interface
    - 192.168.56.254 voor de VBOX Host-only interface
  - bekomen uitvoer:
    - 10.0.2.0/24 dev enp0s3 proto static metric 100
    - 169.254.0.0 /16 dev enp0s8 scope link metric 1003
    - 192.168.56.0/24 dev proto kernel scope link src 192.168.56.42
    - Waarom? Route 169.254.0.0/16 hoort niet thuis in de tabel en moet verwijdert worden.
  - Oplossing: sudo ip route del 169.254.0.0/16 dev enp0s8
  
- dig google.com
  - verwachte uitvoer: ip adres naar google.com
  - bekomen uitvoer: - bash: dig : command not found
    - Waarom? Dig is niet geïnstalleerd.
  - Oplossing: sudo yum install dig utils. Hierna krijgen we wel de verwachte uitkomst.
  

### Phase 3: Transport laag

- sudo systemctl start firewalld.service
  - verwachte uitvoer: het opstarten van de firewall
  - bekomen uitvoer: firewall is opgestart (gecontroleerd met sudo systemctl status firewalld)
  
- sudo systemctl enable firewalld.service
  - verwachte uitvoer: firewall zal opstarten na herstart
  - bekomen uitvoer: systeem herstart
  
- sudo systemctl start nginx.service
  - verwachte uitvoer: opstarten nginx.service
  - bekomen uitvoer: foutmelding met als boodschap: "Job for nginx.service failed because the control process exited with error code."
  - oplossing?
    - sudo systemctl status -l nginx.service
    - sudo journalctl -xe
    - sudo nginx -t
    - Fout in /etc/nginx/nginx.conf: "/etc/pki/tls/certs/nignx.pem" in plaats van  "/etc/pki/tls/certs/nginx.pem"
    - Fout in /etc/nginx/nginx.conf: server{ listen 8443 ssl; ... } in plaats server {listen 443 ssl; ... }
    - sudo systemctl restart nginx.service
    - sudo systemctl enable nginx.serivce
    
- sudo firewall-cmd --permanent -zone=public --add-service=http
  - verwachte uitvoer: toevoegen van http bij de toe te laten services.
  - bekomen uitvoer: success
  
- sudo firewall-cmd --permanent -zone=public --add-service=https
  - verwachte uitvoer: toevoegen van https bij de toe te laten services.
  - bekomen uitvoer: success
  
- sudo firewall-cmd --reload
  - verwachte uitvoer: Firewall policies herladen na toevoeging.
  - bekomen uitvoer: success
  
- ss -tulnp
  - verwachte uitvoer: een lijst van alle poorten waar het systeem naar luisterd.
  - bekomen uitvoer: een lijst van alle poorten waar het systeem naar luisterd.

### Phase 4: Applicatie laag

- sudo semanage permissive -a httpd_t
  - verwachte uitvoer: toevoegen permissies
  - bekomen uitvoer: sudo: semanage: command not found
  - oplossing: sudo yum install policycoreutils-python. Hierna kunnen we wel permissies toevoegen met semanage.

## End result

- Transcript van de acceptance tests:
  - Running test /home/vagrant/01-whitebox.bats
    - The SELinux status should be 'enforcing'
    - The firewall should be running
    - Apache should not be installed
    - Apache should not be running
    - 4 tests, 0 failures
  
  - Running tests /home/vagrant/02-blackbox.bats
    - The web server host should be reachable
    - The website should be accessible through HTTP
    - The website should be accessible through HTTPS
    - 3 tests, 0 failures  
- HTTP en HTTPS lukten beide
- Geen error messages.

## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.

[Computerhope](https://www.computerhope.com/)
[Route verwijderen](https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/)
[Nginx Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7)