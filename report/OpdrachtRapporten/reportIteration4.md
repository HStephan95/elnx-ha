# Enterprise Linux Lab Report

- Student name: Heirbaut Stephan
- Github repo: <https://github.com/HStephan95/elnx-ha>

Voor deze iteratie gaan we LAMP-stack opstelling en er AB op los laten om de performance te checken.

## Requirements

- Doel: Het opstellen van een loadbalancer en verschillende webservers. Zodat deze de netwerklast kan verdelen over schillende de verschillende applicaties.
- Geschatte tijd: 22/01/2018 tot 23/01/2018

## Test plan

|Objectief|Korte beschrijving|Behaald|
|---------|------------------|-------|
|Opstellen loadbalancer|Server toevoegen aan vagrant-hosts en configuratiebestand toevoegen voor HAProxy|X|
|Configureren loadbalancer|De juiste ip adressen van de webservers toevoegen aan het configuratiebestand, alsook andere variabelen declareren|X|
|Verdere performance tests uitvoeren|Dezelfde loadtests als voorheen uitvoeren en de verschillen loggen|X|

## Documentation

Als eerste begonnen met de enkele YouTube-filmpjes te bekijken en de RedHat-documentatie te raadplegen.
Maar, het zag er vrij straight forward uit. Net zoals de nodige te definiëren variabelen van de rol.

Na een eerste poging heb ik wel al enkele problemen tegengekomen. Mijn webservers draaien, mijn databankserver draait, monitoring en haproxy ook. Maar, als ik probeer te surfen naar het adres van haproxy zelf krijg ik geen webapplicatie te zien.

Ik heb vervolgens dan maar eens mijn configuratievariabelen bekeken en ik denk dat ik al zie waar de fout zit.
Mijn applicatie draait op ´SERVERIP/drupal7/´, terwijl ik in de configuratie refereerde naar ´SERVERIP´. Ik heb deze aangepast en nogmaals geprobeert.

Een oplossing die ik heb gevonden is met ´redir´. Maar, deze vereist veel user input van mezelf

    server Web001 192.168.56.12 redir http://192.168.56.12:80/Drupal7
    
Op deze manier worden alle ´SERVERIP:80´ verwezen naar ´SERVERIP:80/Drupal7´. Ik ga verder zoeken naar een alternatieve oplossing. Maar, ik vrees ervoor.

Een andere mogelijke optie was door een redirect te plaatsen in het ´/var/html/www´-bestand. Maar, dit is nog omslachtiger en meer werk dan de redirects plaatsen.

Na enige verdere testing blijkt dat alles ook werkt als ik alles vanaf ´cookie´ weg doe:

    server Web001 192.168.56.12:80/drupal7/ cookie Web001 check
    server Web001 192.168.56.12:80/drupal7/

Na het verder controleren van de logs kan het misschien eerder aan de kant van mijn webserver liggen. Doordat deze mijn requests weigert. Ik heb evenwel nog geen oplossing gevonden hiervoor. Aangezien alle correcte poorten opstaan en zelfs ´setenforce 0´ niets doet.

Hierop zal ik dan mijn loadtesting uitvoeren. Bij gebrek aan het vinden van een nuttige oplossing.

Net zoals voorheen voer ik dezelfde loadtests uit, van klein naar groot:

    ab -n 10 -c 10 http://192.168.56.10/drupal7/
    ab -n 100 -c 10 http://192.168.56.10/drupal7/
    ab -n 1000 -c 10 http://192.168.56.10/drupal7/
    ab -n 1000 -c 100 http://192.168.56.10/drupal7/
    
Tijdens en na het uitvoeren van deze loadtests draaide alles nog steeds stabiel, in tegenstelling to vorige iteraties. Daarom ben ik nog één stapje verder.

    ab -n 10000 -c 1000 http://192.168.56.10/drupal7/
    
Ook deze requests heeft hij kunnen verwerken, albeit, moeizaam. Ik kon tijdens de test de webapplicatie wel nog openen via de browser vanop mijn eigen systeem.

## Test report

Het opstellen van HAProxy met de Ansible Rol van Mr. Geerling is vrij rechtoe-rechtaan. Zeker in combinatie met de documentatie die RedHat levert. Alleen voor ´error 503´, doordat het pad naar mijn webservers niet 100% klopt, heb ik geen oplossing gevonden.

De performantie van de opstelling zonder of met loadbalancer is gigantisch. Waarbij eerdere iteraties al neergingen bij 10 x 100 requests, crashte de servers nog steeds niet bij 10 x 1000 requests.
Toegegeven, het ging dan wel héél moeizaam en de applicatie die ik draai is héél basic. Maar, dat is mijn opstelling ook. Dus, om deze op grote schaal uit te werken is indrukwekkend.

## Resources

[RedHat documentatie - HAProxy](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/ch-haproxy-setup-vsa)

[HAProxy configuration and load balancing - part 1](https://www.youtube.com/watch?v=L6U0PcESQ4Y)

[HAProxy configuration and load balancing - part 1](https://www.youtube.com/watch?v=mIOw4a34LCk&feature=youtu.be)

[HAProxy redic](https://serverfault.com/questions/126144/how-can-i-get-haproxy-backends-to-include-a-path)

[HAProxy intro](http://cbonte.github.io/haproxy-dconv/1.9/intro.html)

[HAProxy config manual](http://cbonte.github.io/haproxy-dconv/1.9/configuration.html)

[Specific source IP](https://serverfault.com/questions/784438/haproxy-1-5-specific-source-ip-address-show-nosrv-503-sc-in-haproxy-log)
