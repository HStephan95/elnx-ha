# SELinux troubleshooting

## SELinux verstevigd de beveiliging van de Linux kernel doormiddel van access control

Dit gebeurt door verschillende methodes:
- Flags: getsebool, setsebool
- Contexts of labels: ls -Z, chcon
- Policy modules: sepolicy

|Commando|Parameters|Beschrijving|
|--------|----------|------------|
|sestatus|/|Vraagt de huidige status op van SELinux|
|getenforce|/|Vraagt de modus op van SELinux|
|setenforce Enforcing|/|Enable SELinux|
|/etc/sysconfig/selinux|/|Om SELinux permanent te enforcen|
|getsebool -a|/|Toont een lijst van alle flags|
|getsebool -a [pipe] grep [service]|/|Toont een lijst van alle flags gerelateerd aan een bepaalde service|
|getsebool [var]|/|Toont waarde van een bepaalde value|
|setsebool [var] on|/|Stelt een bepaalde value aan|
|setsebool -P [var] on|/|Maakt de waarde van een bepaalde value permanent|
|ls -Z|/|Toont de context van SELinux|
|restorecon [pad]|/|Reset context|
|restorecon -R [pad]|/|Reset context recursief|
|chcon -t [context] -R [pad]|/|Wijzigt de context recursief|

    Voorbeeld van een context rule toevoegen:
    $ sudo semanage fcontext -a -t httpd_sys_content_t "/srv/www(/.*)?"
    $ cat /etc/selinux/targeted/contexts/files/file_contexts.local
    
    Voorbeeld van een policy creeren
    $ sudo vi /etc/httpd/conf/httpd.conf
    $ ls -Z /vagrant/www/
    -rw-rw-r--. vagrant vagrant system_u:object_r:vmblock_t:s0   test.php
    $ sudo chcon -R -t httpd_sys_content_t /vagrant/www/
    chcon: failed to change context of ‘test.php’ to ‘system_u:object_r:httpd_sys_content_t:s0’: Operation not supported
    chcon: failed to change context of ‘/vagrant/www/’ to ‘system_u:object_r:httpd_sys_content_t:s0’: Operation not supported
    
    Apache in permissive mode
    $ sudo semanage permissive -a httpd_t
    Type enforcement file
    $ sudo audit2allow -a -m httpd-vboxsf > httpd-vboxsf.te
    (Indien nodig, policy aanpassen
    $ sudo vi httpd-vboxsf.te)
    
    Converteren naar policy module (.pp)
    $ sudo checkmodule -M -m -o httpd-vboxsf.mod https-vboxsf.te
    $ sudo semodule_package -o httpd-vboxsf.pp -m httpd-vboxsf.mod
    Module installeren
    $ sudo semodule -i httpd-vboxsf.pp
    Verwijder permissive domain uitzonderingen
    $ sudo semanage permissive -d httpd_t
