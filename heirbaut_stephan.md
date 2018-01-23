# Evaluatie Enterprise Linux

|Field          |Value                                              |
| :---          | :---                                              |
| Student       | Stephan HEIRBAUT                                  |
| Klasgroep     | gent                                              |
| Email         | <mailto:stephan.heirbaut.w1409@student.hogent.be> |
| Hoofdopdracht | HA                                                |
| Repo          | <git@github.com:HStephan95/elnx-ha.git>           |

## Hoofdopdracht

W4:

- Iteratie 1: LAMP stack met Drupal (geerlingguy.drupal)
    - laat wordpress-rol en phpmyadmin vallen
- Apache ab + Metricbeat, al enkele load tests uitgevoerd
- Monitoring is nog niet actief
    - let op firewall-regels zodat hosts monitoring-data kunnen doorgeven

W9:

- 

### Eindbeoordeling

O1: <BEOORDELING>

## Troubleshooting

### Eerste troubleshooting-opdracht

Deskundig

### Tweede troubleshooting-opdracht

- "Fysieke laag" valt buiten TCP/IP-model. -> Datalinklaag
- Datalinklaag:
    - Aangesloten op HO-interface met correcte IP-instellingen? Welke instellingen heb je gebruikt voor die nieuwe interface?
- Internetlaag:
    - enp0s8 was niet correct geconfigureerd: `onboot=no`
    - Verwachte uitvoer is niet specifiek genoeg. Welke IP adressen verwacht je concreet?
    - pingen tussen hostsysteem en VM is onvoldoende aangetoond. Naar welke IP's heb je gepingd?
- Transportlaag:
    - bij controle poorten, kijk ook naar de interface waarop geluisterd wordt. In dit geval enkel loopback
- Resultaat:
    - "ik kan pingen van en naar de localhost" -> dit gaat altijd, dus nutteloos?
    - pingen van/naar VM in zelfde netwerk is niet aangetoond

Beoordeling voor deze opdracht: nog niet bekwaam omdat niet aangetoond is dat de service bereikbaar is vanaf het hostsysteem

### Eindbeoordeling

O2: Bekwaam

## Opdracht Actualiteit

### Eindbeoordeling

O3: <BEOORDELING>

## Rapportering

### Laboverslagen

W4:

- Rapport iteratie 1 getoond
- info over HA plugin van RHEL bekeken

R1: <BEOORDELING>

### Demonstraties

R2: <BEOORDELING>

### Cheat sheet

R3: <BEOORDELING>

