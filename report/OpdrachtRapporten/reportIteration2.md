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

    [Test1.txt](https://github.com/HStephan95/elnx-ha/blob/master/report/OpdrachtRapporten/TestGoogle10100.txt)
    [Test2.txt](https://github.com/HStephan95/elnx-ha/blob/master/report/OpdrachtRapporten/TestMicrosoft10100.txt)
    [Test3.txt](https://github.com/HStephan95/elnx-ha/blob/master/report/OpdrachtRapporten/TestMicrosoft1001000.txt)

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

Tussendoor probeer ik ook eens mr. Geerling zijn Drupal-VM uit. Deze gebruikt al de benodigde Ansible rollen die hij zelf geschreven heeft + een voorbeeld .make.yml-file. Maar, ook dit gaat dus mis en zwaar. De VM heeft verschillende plug-ins nodig om te werken en deze hebben serieus gestoord met het werkende krijgen van al mijn andere rollen. Ik heb dus de VM maar weer verwijdert, en de plug-ins ook. Hierover ga ik nog een mail sturen naar mr. Geerling. Plus, daarin ga ik ook hulp vragen met betrekking tot het deployen van een applicatie. Gebruik ik nu beter Drush Make of Compose. Ik ga ook enige vragen stellen over het voorbeeld .make.yml-bestand en waarom dat mis ging op mijn applicatie. Ik ga wel moeten maken dat ik voeldoende documentatie erbij lever.

Gelukkig is er wel vooruitgang geboekt. Via Matti De Grauwe kwam ik te weten dat zij ook MetricBeat gebruiken bij Team Green en hij heeft me zijn geschreven Ansible-Rol en configuratie aangeboden, plus hulp bij het configureren ervan. Dus, ansig, werkt deze server toch al. Helaas heb ik het nog niet echt kunnen testen, bij gebrek aan webserver.

Na een laatste presentatie heeft mr. Van Vreckem aangeraden om af te stappen van mr. Geerling zijn rollen. Want, hoewel deze goed zijn, zijn ze misschien iets te uitgebreid (lees: moeilijk). Hij had ondertussen zelf al een Drupal rol geschreven en ik ben overgestapt op deze. Ik heb die dezelfde dag nog geïnstalleerd en alles loopt vrij foutloos nu. Mijn beide servers komen nu foutloos online.

Nu de installatie van de webserver verloopt zonder foutmeldingen. Is het mij gelukt om er een applicatie op te zetten. Voor de eerste ronde zal dit nog handmatig moeten gebeuren. Maar, hierna kan ik een export sql-bestand maken waarmee ik de databank telkens kan initializeren.

Maar, er is wel nog werk aan mijn monitoring server. Er was wat verwarring tussen Matti en mij, waardoor ik dacht dat alle prerequisite rollen ook al opgenomen waren bij hem. Dat is normaal nu aangepast. Alleen moet er misschien nog iets verandert worden aan de configuratie. Want, de default-poorten zijn nog steeds 9200 en 5601. 5601 zal ik waarschijnlijk het best herleiden naar 80, voor mijn dashboard.

In de tussentijd ook nog eens een foutje tegenkomen met Vagrant en VBox waarbij ik niet meer in staat was om te ssh-en in mijn servers. Gelukkig is dit relatief makkelijk opgelost met een kleine aanpassing met een textbestand. Voor de zekerheid heb ik ook een Bash-functie aangemaakt.
De 2 aangeboden workarounds zijn:

    export VAGRANT_PREFER_SYSTEM_BIN=1
    
of

    set terminal to xterm-256color
    
Verdere aanpassing gedaan van ssh.rb bestanden in  C:\HashiCorp\Vagrant\embedded\gems\gems\vagrant-1.8.1\lib\vagrant\util. Daar heb ik de volgende aanpassingen gedaan:

    # if Util::Platform.windows?
        # raise Errors::SSHUnavailableWindows, :host => ssh_info[:host],
                                             # :port => ssh_info[:port],
                                             # :username => ssh_info[:username],
                                             # :key_path => ssh_info[:private_key_path]
    # end

    which = Util::Platform.windows? ? "where ssh >NUL 2>&1" : "which ssh >/dev/null 2>&1"
    raise Errors::SSHUnavailable if !Kernel.system(which)

    
Voor de zekerheid heb ik ook deze functie nog aangemaakt:

    poort=$1
    naam=$2

    function sshing ()
    {
      ssh -p $poort -i /c/Users/$naam/.vagrant.d/insecure_private_key vagrant@127.0.0.1
    }

    sshing $naam $poort

Bij Kibana heb ik ook nog even '*' moeten aanuiden als Default Index Pattern.

Door nu handmatig een applicatie aangemaakt te hebben en met een beetje hulp van Matti De Grauwe voor het configureren van Kibana kan ik nu de eerste loadtesting beginnen uitvoeren.

Met mijn eerste test lukte het al om de applicatie neer te halen. Maar, misschien was ik er iets te aggresief in. Ik voerde namelijk het volgende in:

    ab -n 1000 -c 100 http://192.168.56.10/drupal7/
    
Er werden dus 1000 requests in totaal gevraagd, waarbij er 100 tegelijk verzonden werden. Voor deze basic opstelling was dit misschien al een beetje ambitieus.

    Usage: ab [options] [http[s]://]hostname[:port]/path
    Options are:
        -n requests     Number of requests to perform
        -c concurrency  Number of multiple requests to make
        -t timelimit    Seconds to max. wait for responses
        -b windowsize   Size of TCP send/receive buffer, in bytes
        -p postfile     File containing data to POST. Remember also to set -T
        -T content-type Content-type header for POSTing, eg.
            'application/x-www-form-urlencoded'
            Default is 'text/plain'
        -v verbosity    How much troubleshooting info to print
        -w              Print out results in HTML tables
        -i              Use HEAD instead of GET
        -x attributes   String to insert as table attributes
        -y attributes   String to insert as tr attributes
        -z attributes   String to insert as td or th attributes
        -C attribute    Add cookie, eg. 'Apache=1234. (repeatable)
        -H attribute    Add Arbitrary header line, eg. 'Accept-Encoding: gzip'
            Inserted after all normal header lines. (repeatable)
        -A attribute    Add Basic WWW Authentication, the attributes
            are a colon separated username and password.
        -P attribute    Add Basic Proxy Authentication, the attributes
            are a colon separated username and password.
        -X proxy:port   Proxyserver and port number to use
        -V              Print version number and exit
        -k              Use HTTP KeepAlive feature
        -d              Do not show percentiles served table.
        -S              Do not show confidence estimators and warnings.
        -g filename     Output collected data to gnuplot format file.
        -e filename     Output CSV file with percentages served
        -r              Don't exit on socket receive errors.
        -h              Display usage information (this message)
        -Z ciphersuite  Specify SSL/TLS cipher suite (See openssl ciphers)
        -f protocol     Specify SSL/TLS protocol (SSL2, SSL3, TLS1, or ALL)




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

[Goodbye Drush Make, Hello Composer!](https://www.lullabot.com/articles/goodbye-drush-make-hello-composer)

[https://projectricochet.com/blog/installing-drupal-using-drush-make#.Wh8WczdryUl](https://projectricochet.com/blog/installing-drupal-using-drush-make#.Wh8WczdryUl)

[Using Drush Make - building a base Drupal installation through automation](https://stonebergdesign.com/blog/using-drush-make-building-base-drupal-installation-through-automation)

[http://docs.drush.org/en/7.x/make/](http://docs.drush.org/en/7.x/make/)

[https://www.youtube.com/watch?v=CMcvJI0PBs0](https://www.youtube.com/watch?v=CMcvJI0PBs0)

[White Screen of Death](https://www.drupal.org/node/158043)

[https://cheekymonkeymedia.ca/blog/importing-and-exporting-databases-drush](https://cheekymonkeymedia.ca/blog/importing-and-exporting-databases-drush)

[Issues with shell when SSH-ing into Vagrant #9143 ](https://github.com/hashicorp/vagrant/issues/9143)

[Get SSH working on Vagrant/Windows/Git](https://gist.github.com/haf/2843680)