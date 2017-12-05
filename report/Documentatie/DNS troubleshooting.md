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
|any||
|localhost||
|localnest||
|none||

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
|allow-query||
|allow-query-cache||
|blackhole||
|directory||
|dnssec-enable||
|dnssec-validation||
|forwarders||
|forward||
|listen-on||
|listen-on-v6||
|max-cache-size||
|notify||
|pid-file||
|recursion||
|statistics-file||

Belangrijk!
Om DDoS-aanvallen te verkomen is het slim om de 'allow-query-cache'-regel alleen toe te passen op een beperkt aantal clients.

### Zone

Met de 'zone'-statement kun je specifieke karakteristieken toewijzen aan zones, zoals bv. locatie van het configuratie bestand of de zone-specifieke opties. Deze zullen de globale 'options'-statements overschrijven, dus let op.

|KEYWORD|BESCHRIJVING|
|-------|------------|
|allow-query||
|allow-transfer||
|allow-update||
|file||
|masters||
|notify||
|type||

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

|KEYWORD|BESCHRIJVING|
|-------|------------|
|controls||
|key||
|logging||
|server||
|trusted-keys||
|view||