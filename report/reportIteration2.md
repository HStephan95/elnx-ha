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
|LAMP-stack opgestellen|De LAMP-stack lokaal clonen van GitHub.|X|
|Monitoring opgestellen|De ApacheBenchmark-tool opstellen|X|
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

Hierna ben ik begonnen met rollen toevoegen aan Web001 vanop Ansible Galaxy.

    - bertvv.rh-base
    - bertvv.httpd
    - bertvv.mariadb
    - geerlingguy.drupal
    - geerlingguy.drush
    
Met rh-base wordt er een basic installatie uitgevoerd van een RedHat distributie. Vervolgens installeer ik de Apache webserver en de databank ervoor met MariaDB en.
Als laatste installeer Drupal en Drush van Jeff Geerling voor het opstellen van een php-applicatie.

De applicatie die ik ga gebruiken wordt gecompileerd aan de hand van drush make en kan ik daarna opslaan in de databank in de vorm van een .sql-bestand. Hierdoor kan ik telkens exact dezelfde applicatie gebruiken voor het testen bij elke iteratie. Dit is nog mijn grootste to-do, want MariaDB, Drupal en Drush willen niet echt meewerken.

Monitoring001 zal dienen als monitoring server. Deze zal dan de performantie van Web001 en de applicatie testen zodra ik er AB op los laat.
Ik ga AB op verschillende sterktes uitvoeren en met verschillende gebruikers vanop verschillende terminals vanop Monitoring001.
De rollen die hierop staan zijn:
    
    - bertvv.rh-base
    - sirkjohannsen.metricbeat
    
MetricBeat is een applicatie van Elastic voor het capteren van performantie van verschillende componenten, waaronder network performance. Want, hoewel AB een goede tools is om te testen, is de output van het commando een vrij naakt rapport. Via MetricBeat zal het mogelijk zijn om de performance een beetje meer in kannen en kruiken te gieten.

Aan de host_vars zijn ook al gedefinieerd waar ik er één geschreven heb voor Web001 en Monitoring001.  

Voor Web001.yml zijn de services van http en https toegelaten, de verschillende gebruikers en hun wachtwoorden geïnstastieerd (RHBase, MariaDB en Drupal/Drush) en is de databank voor de applicatie ook aangemaakt. Later is het misschien praktisch om deze te instantiëren. Zodat het project zo gegenereert kan worden. Er wordt ook een .make.yml-file meegegeven. Hiervoor heb ik het [example.make.yml-file](https://www.drupal.org/docs/develop/packaging-a-distribution/example-drupalorg-make-file) gekozen van Drupal zelf. Het is al volledig gedocumenteerd en alle functies worden mooi één per één toegevoegd.

Voor Monitoring001 was er iets minder werk nodig. De rol heeft een kleiner aantal rollen en had minder configuratie nodig. Er is een user aangemaakt voor RHBase en MetricBeat en een config-file voor MetricBeat waarnaar ik verwijs, maar dat is alles.

Ik heb voor de opstelling ook gekozen om gebruik te maken van Drush Make. Hiermee kan ik telkens opnieuw dezelfde modules laden voor elke applicatie en gaat er dus geen variantie zijn tussen mijn verschillende verschillende webserver qua applicatie. Dit verwijdert dus al één gegeven dat een veranderlijke zou kunnen zijn. Composer was ook een optie om te gebruiken. Maar, deze leest zijn informatie in van een json-bestand. Persoonlijk, blijf ik liever verder werken met het .make.yml-bestandstype voor het moment. 

Vervolgens heb ik geprobeerd deze rollen werkende te krijgen aan de hand van de geschreven yml-files. Maar, hier beginnen de problemen dus.

Als eerste stonden de rollen in de verkeerde volgorde. Drupal was op zoek naar een file dat Drush meeneemt. Maar, Drush was nog niet geïnstaleerd. Dus, heb ik deze rollen moeten omkeren. Hierna kan ik de installatie verder zetten.

Maar, vervolgens krijg ik de ene foutboodschap na de andere. Allemaal met betrekking tot het niet in staat zijn van het downloaden en compileren van het example.make.yml-bestand. Dit is uitermate frusterend, aangezien dit een werkend .make.yml-bestand zou moeten zijn. Met daarbovenop dat mijn server wel werken en draaien. Maar, dat het deployen van een applicatie problemen blijft geven.

Momenteel schrijft Drush ook nog de bestanden weg naar de foute locatie. Maar, daarvoor heb ik al een fix gevonden: de default-locatie is immers */var/www/drupal*, terwijl Apache default zoekt onder */var/www/html*. Ik moet dus nog aan Drush meegegeven dat de bestanden op een andere locatie moeten komen.
    
    Drupal
    drupal_deploy_dir: "/var/www/drupal"
    
    HTTPD
    httpd_DocumentRoot: '/var/www/html'
    
Ik heb uiteindelijk besloten om een minimalistische variant van het .make.yml-bestand te gebruiken, in plaats van de uitgebreidde aangeboden door Drupal zelf. Deze compileerd gelukkig wel al. Maar, nog niet zonder fouten. Want, hoewel alles nu op de juiste locatie zat blijft mijn scherm nog wit. Wat ik wel eigenaardig vind.

Na een beetje zoeken heb ik de reden waarom gevonden:
By default tonen Drupal geschreven applicaties geen foutboodschappen op hun scherm. Dit met de veronderstelling dat het alleen maar de gebruiker meer verward en een last voor hen is. Terwijl een sys admin, vaak deze toch negeert en naar de sys logs gaat gaan kijken. Dit wordt door Drupal-gebruikers een [white screen of death(WSOD)][https://www.drupal.org/node/158043] genoemt. De manier waarop je foutboodschappen toch laat tonen is door deze lijntjes toe te voegen aan de index.php:
    
    <?php

    error_reporting(E_ALL);
    ini_set('display_errors', TRUE);
    ini_set('display_startup_errors', TRUE);

Hiermee kan ik nu wel de foutboodschap zien, maar veel had ik hier uiteindelijk niet aan. Want, het melde doodleuk dat er een fout zat in het bouwen van mijn applicatie...

Op dit moment is het uitzoeken van de verschillende rollen en het schrijven van de variabelen ervoor best nog meegevallen. Maar, met het bouwen van de applicatie zit ik stilaan met de handen in de haren. Zeker door gebrek aan tijd de laatste paar weken (Projecten en Databanken hebben een prioriteit genomen).

Gelukkig is er wel vooruitgang geboekt. Via Matti De Grauwe kwam ik te weten dat zij ook MetricBeat gebruiken bij Team Green en hij heeft me zijn geschreven Ansible-Rol en configuratie aangeboden, plus hulp bij het configureren ervan. Dus, ansig, werkt deze server toch al. Helaas heb ik het nog niet echt kunnen testen, bij gebrek aan webserver.

Na een laatste presentatie heeft Mr. Van Vreckem aangeraden om af te stappen van Mr. Geerling zijn rollen. Want, hoewel deze goed zijn, zijn ze misschien iets te uitgebreid (lees: moeilijk). Hij had ondertussen zelf al een Drupal rol geschreven en ik ben overgestapt op deze. Ik heb die dezelfde dag nog geïnstalleerd en alles loopt vrij foutloos nu. Mijn beide servers komen nu foutloos online.

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