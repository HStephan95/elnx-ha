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
|Opstellen loadbalancer||
|Configureren loadbalancer||
|Verdere performance tests uitvoeren||

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

## Test report

The test report is a transcript of the execution of the test plan, with the actual results. Significant problems you encountered should also be mentioned here, as well as any solutions you found. The test report should clearly prove that you have met the requirements.

## Resources

[RedHat documentatie - HAProxy](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/load_balancer_administration/ch-haproxy-setup-vsa)

[HAProxy configuration and load balancing - part 1](https://www.youtube.com/watch?v=L6U0PcESQ4Y)

[HAProxy configuration and load balancing - part 1](https://www.youtube.com/watch?v=mIOw4a34LCk&feature=youtu.be)

[HAProxy redic](https://serverfault.com/questions/126144/how-can-i-get-haproxy-backends-to-include-a-path)

[HAProxy intro](http://cbonte.github.io/haproxy-dconv/1.9/intro.html)

[HAProxy config manual](http://cbonte.github.io/haproxy-dconv/1.9/configuration.html)