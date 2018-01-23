# Enterprise Linux Lab Report

- Student name: Heirbaut Stephan
- Github repo: <https://github.com/HStephan95/elnx-ha>

Voor deze iteratie gaan we LAMP-stack opstelling en er AB op los laten om de performance te checken.

## Requirements

- Doel: Het scheiden van de databank en de webapplicatie op 2 verschillende server. Zodat de load voor de CPU, RAM en cache minder groot worden en zo een performantie verhoging te zien.
- Geschatte tijd: 21/01/2018 tot 22/01/2018

## Test plan

|Objectief|Korte beschrijving|Behaald|
|---------|------------------|-------|
|Opstellen databankserver|Server toevoegen aan Vagrant-hosts, rollen verplaatsen, configuratie in eigen yml-bestand zetten|X|
|Verbinding maken tussen dbserver en webserver|Wijzig ip-adres databank in configuratie webserver en zet juiste poorten open|X|
|Performance hiervan loggen met de monitoringserver|Metricbeat installeren op databankserver en kijken op Kibana of hij gevonden wordt|X|
|Verdere performance tests uitvoeren|Dezelfde loadtests als voorheen uitvoeren en het verschil hiervan loggen|X|

## Documentation

Al eerste heb ik een nieuwe server toegevoegd aan het ´vagrant-hosts.yml´-bestand, alsook bij ´site.yml´.
Hierin heb ik dan de nodige rollen en variabelen toegevoegd en ook de nodige rollen en variabelen verwijdert of gewijzigd bij ´Web001.yml´.

    #Aanmaken databank en user
    mariadb_databases:
      - name: drupal
        # initialize db
        # init_script: /ansible/files/database_init.sql
    mariadb_users:
      - name: stephan
        password: Test12345
        priv: 'drupal.*:ALL'

    mariadb_root_password: Test12345
    
Alle andere info is immers al opgenomen in het ´all.yml´-bestand.
Ik heb wel enigzins de volgorde moeten aanpassen waarin de servers geïnstalleerd worden. Ik kan immers niet verwijzen naar een DB als ze nog niet bestaat.

Bij mijn eerste poging heb ik problemen ondervonden met de verbinding tussen de web- en de databankserver.

    PDOException: SQLSTATE[HY000] [1130] Host '192.168.56.11' is not allowed to connect to this MariaDB server in lock_may_be_available() (line 167 of /usr/share/drupal7/includes/lock.inc).

Zoals ik het lees is er een lock geplaatst door een bepaalde transactie en blokkeert dit nu het hele begin proces.

Ik dacht dat dit misschien kwam door een configuratiefout bij interfaces waar hij naar luisterd. Ik heb dit gewijzigd, maar dit blijkt helaas nog niet genoeg te zijn.

Ik heb een beetje opzoekingswerk gedaan en het kan liggen aan gebruikersrechten. Zodoende heb ik ze geweest naar een globaal niveau:

    - name: 'stephan'
      password: 'Test12345'
      priv: '*.*:ALL,GRANT'
      host: '192.168.56.%'
      
Dit bleek dus het probleem te zijn en nu werkt de connectie tussen Drupal en de databank wel.

Hierna heb ik nog enkele loadtests uitgevoerd om de opstelling te testen.
Van klein naar groot zijn de volgende tests uitgevoerd:

    ab -n 10 -c 10 http://192.168.56.10/drupal7/
    ab -n 100 -c 10 http://192.168.56.10/drupal7/
    ab -n 1000 -c 10 http://192.168.56.10/drupal7/
    ab -n 1000 -c 100 http://192.168.56.10/drupal7/
    
De load testen gingen al een pak beter.
Maar bij de zwaarste faalde hij alsnog, en doordat er nog geen loadbalancer voorstaat worden er ook nog packets gedropt. Maar, blijven ze in plaats daarvan onbeantwoord.

## Test report

De databank zelf opstellen bleek een vrij makkelijke taak. Gewoon een nieuwe server toevoegen aan ´vagrant-hosts.yml´, de rollen verplaatsen in het ´site.yml-bestand en een nieuw .yml-configuratiebestand aanmaken.

Over de connectie tussen deze nieuwe databank en de webserver heb ik even gestruikeld. Maar, was vrij rap opgelost door logisch en stapsgewijs te denken en testen.

Zodra dit dan ook in orde was kon ik de opstelling weer testen. Hardwarematig heb ik geen al te grote verschillen gemerkt. Omdat deze toch al niet overbelast waren om te beginnen.

Maar, bij de laatste test heeft de opstelling het wel net iets langer gehouden dan de eerste keer.

## Resources

[PDOException Drupal](https://www.drupal.org/forum/support/installing-drupal/2014-06-04/pdoexception-in-lock_may_be_available-line-167-of)

[Mariadb privileges](https://mariadb.com/kb/en/library/grant/)

[Metric fields](https://www.elastic.co/guide/en/beats/metricbeat/6.1/exported-fields-system.html)
