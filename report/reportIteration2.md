# Enterprise Linux Lab Report

- Student name: Heirbaut Stephan
- Github repo: <https://github.com/HStephan95/elnx-ha>

Voor deze iteratie gaan we LAMP-stack opstelling en er AB op los laten om de performance te checken.

## Requirements

- Doel: Ik wil in 2 weken tijd in staat zijn om een complete LAMP-stack te hebben opgesteld en de performance check te hebben afgerond.
- Geschatte tijd: 7/10 tot 27/10

## Test plan

|Objectief|Korte beschrijving|Behaald|
|---------|------------------|-------|
|LAMP-stack opgestellen|De LAMP-stack lokaal clonen van GitHub.||
|Monitoring opgestellen|De ApacheBenchmark-tool opstellen||
|Monitoring uitvoeren|De nodige commando's uitvoeren voor het testen van de LAMP-stack||
|Monitoring loggen|De output van de comando's in een bestand opslaan en dit bestand analyseren||

## Documentation

Describe *in detail* how you completed the assignment, with main focus on the "manual" work. It is of course not necessary to copy/paste your code in this document, but you can refer to it with a hyperlink.

Make sure to write clean Markdown code, so your report looks good and is clearly structured on Github.

Als eerste ben ik beginnen experimenteren met ApacheBench. Hiervoor heb ik een Fedora24 geïnstalleerd en enkele tests heb uitgevoerd.

    [Test1.txt](TestGoogle10100.txt)
    [Test2.txt](TestMicrosoft10100.txt)
    [Test3.txt](TestMicrosoft1001000.txt)

Vervolgens heb ik vagrant-hosts.yml aangepast zodat ik 2 servers had voor mijn opstelling, met ip adressen in dezelfde range.

Hierna ben ik begonnen met rollen toevoegen aan HTTP001 vanop Ansible Galaxy.

    - bertvv.rh-base
    - bertvv.httpd
    - bertvv.mariadb
    - geerlingguy.drupal
    - geerlingguy.drush
    
Met rh-base wordt er een basic installatie uitgevoerd van een RedHat distributie. Vervolgens installeer ik de Apache webserver en de databank ervoor met MariaDB en.
Als laatste installeer Drupal en Drush van Jeff Geerling voor het opstellen van een php-applicatie.

De applicatie die ik ga gebruiken wordt gecompileerd aan de hand van drush make en kan ik daarna opslaan in de databank in de vorm van een .sql-bestand. Hierdoor kan ik telkens exact dezelfde applicatie gebruiken voor het testen bij elke iteratie. Dit is nog mijn grootste to-do, want MariaDB, Drupal en Drush willen niet echt meewerken.

Monitoring001 zal dienen als monitoring server. Vanaf hierop zal ik AB lanceren op HTTP001 en de applicatie die erop aan het draaien is.
Ik ga AB op verschillende sterktes uitvoeren en met verschillende gebruikers vanop verschillende terminals vanop Monitoring001.
De rollen die hierop staan zijn:
    
    - bertvv.rh-base
    - sirkjohannsen.metricbeat
    
MetricBeat is een applicatie van Elastic voor het capteren van performantie van verschillende componenten, waaronder network performance. Want, hoewel AB een goede tools is om te testen, is de output van het commando een vrij naakt rapport. Via MetricBeat zal het mogelijk zijn om de performance een beetje meer in kannen en kruiken te gieten.

Aan de host_vars zijn ook al gedefinieerd waar ik er één geschreven heb voor HTTP001 en Monitoring001.  

Voor HTTP001.yml en Monitoring001.yml heb ik de services van http en https toegelaten en de verschillende gebruikers geïnstastieerd. Bij HTTP001 kwam er dan ook nog eens bij dat ik de database ook nog geïnstastieerd heb.

## Test report

The test report is a transcript of the execution of the test plan, with the actual results. Significant problems you encountered should also be mentioned here, as well as any solutions you found. The test report should clearly prove that you have met the requirements.

Dit zijn de resultaten van de testopstellingen:

    * de struggle is real *

## Resources

[Gebruikte LAMP-stack opstelling](https://github.com/bertvv/lampstack)

[Geerling Guy op Galaxy Roles](https://github.com/geerlingguy)

[Drupal App voor Apache](https://galaxy.ansible.com/geerlingguy/drupal/)

[Stress-test your PHP App with ApacheBench](https://www.sitepoint.com/stress-test-php-app-apachebench/)

[Apache benchmarking using AB in linux](https://www.youtube.com/watch?v=jgb-OFJyaG8&t=182s)

[Drupal](https://www.drupal.org/docs/8)

[Drush](http://www.drush.org/en/master/)

[MetricBeats](https://www.elastic.co/downloads/beats/metricbeat)