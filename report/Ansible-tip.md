# Ansible tip

1. Vermijd gebruik van tasks met *row:*, *command:* of *shell:*!  
Zoek naar geschikte Ansible modules.
Bv.:
  - name: XXX
    command: cp XXX
    
  - name: XXX
    copy: XXX
    src: foo
    dest: /foo/foo
