# Enterprise Linux Lab Report

- Student name: Heirbaut Stephan
- Github repo: <https://github.com/HStephan95/elnx-ha>

In iteratie 1 ga ik op zoek naar de nodige documentatie voor het kunnen opbouwen van mijn opdracht.

## Requirements

- Doel: Ik wil het e-book van Geerling Guy hebben en 10 verschillende links naar bronnen met uitleg voor LAMP-stack, High Availability en Roles.
- Geschatte tijd: 29/09 tot 06/10
- Benodige tijd: 29/09 tot 06/10

## Test plan

|Objectief|Korte beschrijving|Behaald|
|---------|------------------|-------|
|YouTube-links|De nodige ondersteunende filmpjes zoeken op YouTube, om toch al eens (half) te zien hoe andere mensen het doen|x|
|RHEL sources|De pdf rade aan om zeker de bronnen van RHEL7 te gebruiken, dus deze moet ik zeker eens nakijken en de praktische eruit halen en opslaan|x|
|Galaxy Roles|Op Galaxy Roles staat zo goed als alles al klaar. Je moet gewoon de juiste roles voor de juiste job nog vinden.|x|
|E-book aangekocht|Het e-book van Geerling Guy werdt ook aangeraden. Aangezien deze continue geupdate wordt en aan een deftige prijs verkocht, ga ik deze ook aanschaffen.|x|

## Documentation

Als eerste ben ik de bronnen beginnen raadplegen die in de pdf staat met de uitleg. Ik heb de verschillende documentaties opgezocht voor High Availability en Load Balancing van Red Hat zelf, waarna ik op Google ben beginne rondkijken naar de beste manier om monitoring en performance tests te doen. Vooral voor het laatste vond ik veel, maar ik heb uiteindelijk gekozen voor AB. Vervolgens ben ik naar YouTube gegaan en heb ik gekeken naar verschillende YouTube-walkthrough voor het installeren van een testopstelling en High Availability servers. Ik heb ook het eBook van Geerling Guy gekocht over Ansible. Ik heb ook een link opgeslaan naar zijn Galaxy Roles repo en hem beginnen volgen op GitHub. Ik heb ook gekozen om uw opstelling van een LAMP-stack te gebruiken als testopstelling. Alternatief had ik ook nog opdracht 2 van Projecten 2 in gedachte, maar dit hebt u mij afgeraden aangezien alles via Ansible moet. Als laatste heb ik nog documentatie opgezocht over Caching en Reserve-lookup-zones.

## Test report

De meeste informatie heb ik vrij makkelijk kunnen bekomen door de pdf van de cursus te lezen en naar RHEL7 te gaan of Galaxy Roles. De YouTube filmpjes en caching en reverse-lookup-zones waren moeilijker te bekomen. Vooral omdat de informatie nogal gefragmenteerd is of niet compleet genoeg was naar mijn smaak. Vooral voor de testopstelling en high availability zijn er veel mensen die filmpjes hebben gemaakt, maar het net iets anders aanpakken. Caching en Reverse-lookup-zones ken ik al van Windows, maar daar werdt alles met een GUI gedaan.

## Resources

### LAMP-stack test opstelling
[Gebruikte LAMP-stack opstelling](https://github.com/bertvv/lampstack)

[Geerling Guy op Galaxy Roles](https://github.com/geerlingguy)

[Drupal App voor Apache](https://galaxy.ansible.com/geerlingguy/drupal/)

[Stress-test your PHP App with ApacheBench](https://www.sitepoint.com/stress-test-php-app-apachebench/)

[Apache benchmarking using AB in linux](https://www.youtube.com/watch?v=jgb-OFJyaG8&t=182s)

### High Availability
[System Administrator's Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/index)

[High Availability Add-On Overview](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/High_Availability_Add-On_Overview/s1-rhcs-intro-HAAO.html)

[Load Balancer Administration](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Load_Balancer_Administration/index.html)

[Anisble Galaxy Roles](https://galaxy.ansible.com/list#/roles?page=1&page_size=10)

[Caching](https://www.digitalocean.com/community/tutorials/how-to-configure-apache-content-caching-on-centos-7)

[Reserve-lookup-zones](http://www.philchen.com/2007/04/04/configuring-reverse-dns)

[Getting Started with Pacemaker - Linux High Availability & Clustering](https://www.youtube.com/watch?v=Ow5rhYTbT34)

[Netwerk monitoring met Net-SNMP](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sect-System_Monitoring_Tools-Net-SNMP.html)

[Anisble vault](https://leucos.github.io/articles/transparent-vault-revisited/)

[Getting started with Kibana & Elastic](https://www.elastic.co/guide/en/kibana/current/getting-started.html)