lib_tomato_utils
=========

This role contains Ansible modules to manage Shibby Tomato WiFi routers.

More info:
http://tomato.groov.pl/

This role is only used to bring those modules into context.

Requirements
------------

Shibby Tomato doesn't have SFTPD, so you MUST set this value in your ansible.cfg file:
   scp_if_ssh = True

Role Variables
--------------

This role doesn't take any variables.

Dependencies
------------

None

Example Playbook
----------------

    - hosts: routers
      gather_facts: no
      user: root
      vars:
        shell_script: |-
          #!/bin/sh

          if curl -s freegeoip.net/json/ | grep -i 'North Carolina' &> /dev/null ; then
            echo
            echo "VPN Down, rebooting!!!"
            echo
            reboot
          else
            echo
            echo "VPN is up, doing nothing."
            echo
          fi
      roles:
      - role: lib_tomato_utils

      post_tasks:
      - nvram:
          state: present
          name: example_simple_data_type
          value: 40
        register: example_simple_data_type_out

      - debug: var=example_simple_data_type_out

      - nvram:
          state: present
          name: example_complex_data_type
          value: "{{ shell_script | b64encode }}"
          b64_encoded: true
        register: example_complex_data_type_out

      - debug: var=example_complex_data_type_out

License
-------

BSD

Author Information
------------------

Thomas Wiest <twiest+github@gmail.com>
