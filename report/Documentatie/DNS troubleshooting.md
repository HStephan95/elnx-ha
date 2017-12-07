# DNS
## Resource records

Correct voorbeeld van een resource record:

    bob.sales.example.com
    resourceRecord.subdomain.subdomain.top-level domain
    
Elke sectie (behalve de uiterst linkse), is een zone dat een namespace definieert.
Deze worden gedefinieert door authorative nameservers door zonefiles. Elke zonefile wordt opgeslaan op primary nameservers in resource records.

## Primary (Master) vs Seconday (Slave)

Een Master DNS krijgt zijn zone data van een lokale bron. In tegenstelling tot een Slave DNS die zijn zone data van een externe (networked) source krijgt.

## Authorative vs Recursive

Authorative DNS beantwoord alle request die behoren tot hun zones. Dit geldt voor primary als secondary nameservers.

Recursive nameservers beieden alleen resolution services aan. Maar, zijn geen authoratives voor bepaalde zones. Elke request die zij krijgen wordt voor even gecached voor een bepaalde duur, maar is niet permanent.

Hoewel een DNS zowel authorative als recursive kan zijn, is dit geen goed idee. Aangezien hij dan kwetsbaar wordt voor DDoS aanvallen.

## /etc/named.conf & /etc/named/

BIND slaat zijn configuratie bestanden op in /etc/named.conf & /etc/named/.
'/etc/named.conf' bezat het hoofd configuratiebestand.
'/etc/named/*' is een auxiliary directory voor alle configuratie bestanden die worden vermeld in '/etc/named.conf'.

Correct voorbeeld van een named service:

    statement-1 ["statement-1-name"] [statement-1-class] {
    option-1;
    option-2;
    option-N;
    };
    statement-2 ["statement-2-name"] [statement-2-class] {
    option-1;
    option-2;
    option-N;
    };
    statement-N ["statement-N-name"] [statement-N-class] {
    option-1;
    option-2;
    option-N;
    };

### ACL's

Hiermee kun je een group van hosts definiëren en ze toegang geven of weigeren tot de nameserver.

Voorbeeld ACL:

    // Definiëren eerste ACL
    acl black-hats {
      10.0.2.0/24;
      192.168.0.0/24;
      1234:5678::9abc/24;
    };
    // Definiëren tweede ACL
    acl red-hats {
      10.0.1.0/24;
    };
    // ACL's toepassen
    options {
      # blackholes worden geblockeerd
      blackhole { black-hats; };
      allow-query { red-hats; };
      allow-query-cache { red-hats; };
    };
    
|KEYWORD|BESCHRIJVING|
|-------|------------|
|any|Matched met eender welk IP adres|
|localhost|Matched met elk IP adres van het lokaal systeem|
|localnets|Matched met elk IP adres van een netwerk waarmee het lokaal systeem verbonden is|
|none|Mag niet matchen met dit IP adres|

### include

Met dit keyword kun je een bestand toevoegen aan 'named.conf' voor eventueel gevoelige data af te scheiden.

Voorbeeld include:

    include "/etc/named.rfc1912.zones";

### Options

Met options kun je globale server configuraties definiëren, alsook default waarden opgeven.

Voorbeeld options:

    options {
      allow-query       { localhost; };
      listen-on port    53 { 127.0.0.1; };
      listen-on-v6 port 53 { ::1; };
      max-cache-size    256M;
      directory         "/var/named";
      statistics-file   "/var/named/data/named_stats.txt";

      recursion         yes;
      dnssec-enable     yes;
      dnssec-validation yes;
    };

|KEYWORD|BESCHRIJVING|
|-------|------------|
|allow-query|Specifieert welke hosts toegang hebben om te queryen|
|allow-query-cache|Specifieert welke hosts recursive queries mogen uitvoeren|
|blackhole|Specifieert welke hosts géén verbinding mogen maken met de nameserver|
|directory|Specifieert de working directory voor ne named service (default: /var/named/|
|dnssec-enable|Specifieert of DNSSEC related resource worden gereturned(default: yes)|
|dnssec-validation|Specifieert of er validatie op DNSSEC related resources moet gebeuren (default: yes)|
|forwarders|Specifieert een lijst van IP adressen die requests moeten forwarden naar de nameserver|
|forward|Specifieert het gedrag van de forwarders (first: eerst de nameservers queryen, voor zelf resolven. only: als de nameserver niet toegankelijk is, de query niet resolven|
|listen-on|Specifieer naar welke interfaces er geluisterd moet worden voor queries|
|listen-on-v6|Same, maar IPv6|
|max-cache-size|Max grote van de cache voor queries op te slaan|
|notify|Specifieert of er een notificatie moet komen wanneer een zone wordt geupdate (yes: alle secondary. no: geen enkele secondary. master-only: alleen de primary server voor die zone. explicit: alleen de secondary die specifiek vermeld worden in de 'also-notify' lijst in de zone-statement.|
|pid-file|Specifieert de locatie van het process ID file gecreëerd door de named service|
|recursion|Specifieert of de nameserver een recursive server is (default: yes)|
|statistics-file|Specifieren van een alternatieve locatie voor het opslaan van statistieken (default: /var/named/named.stats)|

Belangrijk!
Om DDoS-aanvallen te verkomen is het slim om de 'allow-query-cache'-regel alleen toe te passen op een beperkt aantal clients.

### Zone

Met de 'zone'-statement kun je specifieke karakteristieken toewijzen aan zones, zoals bv. locatie van het configuratie bestand of de zone-specifieke opties. Deze zullen de globale 'options'-statements overschrijven, dus let op.

|KEYWORD|BESCHRIJVING|
|-------|------------|
|allow-query|Specifieert welke clients informatie mogen requesten over de zone.|
|allow-transfer|Specifieert welke secondary servers requests mogen overdragen voor zone informatie (default: iedereen)|
|allow-update|Specifieert welke hosts dynamisch zones mogen updaten|
|file|Specifieert de locatie van het bestand voor de zone's configuratie data|
|masters|Specifieert van welk IP adres authorative zone informatie moeten komen als het type slave is.|
|notify|Specifieert of er een notificatie moet komen wanneer een zone wordt geupdate (yes: alle secondary. no: geen enkele secondary. master-only: alleen de primary server voor die zone. explicit: alleen de secondary die specifiek vermeld worden in de 'also-notify' lijst in de zone-statement.|
|type|Specifieert het zone type (delegation-only, forward, hint, master, slave)|

#### Primary zone statement

Voorbeeld primary zone statement:

    zone "example.com" IN {
      type master;
      file "example.com.zone";
      allow-transfer { 192.168.0.2; };
    };

#### Secondary zone statement

Voorbeeld secondary zone statement:

    zone "example.com" {
      type slave;
      file "slaves/example.com.zone";
      masters { 192.168.0.1; };
    };

## BIND-chroot

Als je deze package goed hebt geïnstalleerd zal de BIND-service in de '/var/named/chroot'-omgeving worden uitgevoerd. Hierdoor zullen de bovenvermelde bestanden gemount worden met het 'mount --bind'-commando.

Als er fouten zijn, kijk of deze directories leeg zijn:

    /var/named
    /etc/pki/dnssec-keys
    /etc/named
    /usr/lib64/bind or /usr/lib/bind (architecture dependent).
    
Deze bestanden worden allemaal gemount:

    /etc/named.conf
    /etc/rndc.conf
    /etc/rndc.key
    /etc/named.rfc1912.zones
    /etc/named.dnssec.keys
    /etc/named.iscdlv.key
    /etc/named.root.key 
    
    
### Verdere statement types

Deze worden minder gebruikt, maar worden ook gebruikt in '/etc/named.conf'.

|KEYWORD|BESCHRIJVING|
|-------|------------|
|controls|Voor het configureren van verschillende security requirements, die nodig zijn voor 'rndc' voor de 'named'-service|
|key|Laat je toe om een gegeven statement te definiëren als een key. Deze worden gebruikt om verschillende acties te authorizeren (algorithm "algorithm-name" en secret "key-value")|
|logging|Laat je toe om verschillende type van logs te bouwen (channels). Door channel optie te gebruiken in deze statement kun je een eigen bestand, grote, versie en severity definiëren. Deze worden ook gecategoriseerd door een category-option|
|server|Hiermee kun je definiëren hoe de named-service moet reageren op remote namedservers.|
|trusted-keys|Hiermee kun je trusted-keys definiëren.|
|view|Met de view statement kun je speciale views creëeren. Hiermee kun je voor elke host een verschillend antwoord definiëren die zij ontvangen als ze dezelfde request sturen.|

## Editing Zone files

Zone files bevatten informatie over een namespace. Standaard worden ze opgeslaan in /var/named/.
Een overzicht van alle directories:

|PAD|BESCHRIJVING|
|---|------------|
|/var/named/|The working directory for the named service. The nameserver is not allowed to write to this directory.|
|/var/named/slaves/|The directory for secondary zones. This directory is writable by the named service.|
|/var/named/dynamic/|The directory for other files, such as dynamic DNS (DDNS) zones or managed DNSSEC keys. This directory is writable by the named service.|
|/var/named/data/|The directory for various statistics and debugging files. This directory is writable by the named service.|

Met ´$INLCUDE´ kun je een bestand toelaten dat op een andere plaats dan de aangewezen plaats.
Voorbeeld:
    
    $INCLUDE /var/named/penguin.example.com
    
Met ´$ORIGIN´ kun je een domain name appenden zodat ook unqualified records worden toegelaten.
Voorbeeld:
    
    $ORIGIN example.com.
    
Met ´$TTL´ kun je time to live van een zone aanpassen. Dit bepaald hoelang een record van een zone valid wordt beschouwd.
Voorbeeld:
    
    $TTL 1D
    
## RNDC

Met RNDC kun je in de command-line de ´named´ service beheren. Zowel lokaal als remote.
Om unauthorized access te vermijden wordt ´named´ geconfigureerd worden op een geselecteerde poort (default: 953). Deze poort moet doorgegeven worden aan ´rndc´ en daar bovenop moet ook nog een identieke key gegenereerd worden. De configuratie van ´rndc´ is in ´/etc/rndc.conf´ en de key zit in ´/etc/rndc.key´. Deze wordt automatisch gegenereert door ´rndc-confgen -a´.

Voorbeeld waarbij unprivileged users geen control commands mogen sturen naar de service. Alleen root, mag nog lezen.:
    
    # chmod o-rwx /etc/rndc.key
    
## Dig

Dig is één van de sterkste tool voor DNS, omdat je hiermee lookups kunt uitvoeren en zo kunt debuggen waar er iets mis is.

Voorbeeld opzoeken nameserver:

    $ dig example.com NS
    
Format voorbeeld:

    dig [@server] [option...] name type
    
## Voorbeelden van veel voorkomende fouten:

- Semicolons en curly brackets niet vergeten
- Periods op de juiste plek zetten
  - In zone files dienen punten om het einde van een domain name aan te duiden als FQDN. ´named´-service zal de name van zone aanpassen naar de value of ´$ORIGIN´ om het af te werken.
- Het serial number incrementeren wanneer je een zone bewerkt
  - Hierdoor krijgt alleen de primary nameserver de juiste informatie, maar worden de secondary nameservers niet verwittigd over de wijzingen.?µ
- De firewall configureren zodat de ´named´-service niet wordt geblokkeerd
- SELinux configureren zodat de ´named´-service niet wordt geblokkeerd

## Protips

- /usr/share/doc/bind-version/
    - The main directory containing the most recent documentation. 
- /usr/share/doc/bind-version/arm/
    - The directory containing the BIND 9 Administrator Reference Manual in HTML and SGML formats, which details BIND resource requirements, how to configure different types of nameservers, how to perform load balancing, and other advanced topics. For most new users of BIND, this is the best place to start. 
- /usr/share/doc/bind-version/draft/
    - The directory containing assorted technical documents that review issues related to the DNS service, and propose some methods to address them. 
- /usr/share/doc/bind-version/misc/
    - The directory designed to address specific advanced issues. Users of BIND version 8 should consult the migration document for specific changes they must make when moving to BIND 9. The options file lists all of the options implemented in BIND 9 that are used in /etc/named.conf. 
- /usr/share/doc/bind-version/rfc/
    - The directory providing every RFC document related to BIND. 
- man rndc
    - The manual page for rndc containing the full documentation on its usage. 
- man named
    - The manual page for named containing the documentation on assorted arguments that can be used to control the BIND nameserver daemon. 
- man lwresd
    - The manual page for lwresd containing the full documentation on the lightweight resolver daemon and its usage. 
- man named.conf
    - The manual page with a comprehensive list of options available within the named configuration file. 
- man rndc.conf
    - The manual page with a comprehensive list of options available within the rndc configuration file. 