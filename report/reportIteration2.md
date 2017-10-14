# Enterprise Linux Lab Report

- Student name: Heirbaut Stephan
- Github repo: <https://github.com/HStephan95/elnx-ha>

Voor deze iteratie gaan we LAMP-stack opstelling en er AB op los laten om de performance te checken.

## Requirements

- Doel: Ik wil in 2 weken tijd in staat zijn om een complete LAMP-stack te hebben opgesteld en de performance check te hebben afgerond.
- Geschatte tijd: 7/10 tot 20/10

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
    
Hierna ben ik begonnen met rollen toevoegen aan srv001 vanop Ansible Galaxy.

    - bertvv.rh-base
    - sepolicy
    - bertvv.httpd
    - bertvv.mariadb
    - bertvv.wordpress
    - phpmyadmin
    - geerlingguy.drupal
    - geerlingguy.drush
    
Met rh-base wordt er een basic installatie uitgevoerd van een RedHat distributie.
Waarna deze beter wordt beveiligd met SELinux.
Vervolgens installeer ik de Apache webserver en de databank ervoor met MariaDB en Wordpress.
Als laatste installeer Drupal en Drush van Jeff Geerling voor het beheren van de php-applicatie.

De applicatie die ik gebruik is ...

    * applicatie zoeken *

Srv002 zal dienen als monitoring server. Vanaf hierop zal ik AB lanceren op srv001 en de applicatie die hij aan het draaien is.
Ik ga AB op verschillende sterktes uitvoeren en met verschillende gebruikers vanop verschillende terminals vanop srv002.

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

