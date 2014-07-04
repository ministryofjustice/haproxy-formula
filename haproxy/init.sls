{% from "haproxy/map.jinja" import haproxy, haproxy_role with context %}

include:
  - .repo
  - firewall


haproxy:
  pkg.installed:
    - require:
      - pkgrepo: haproxy-pkgrepo
  service:
    - running
    - enable: True
    - watch:
        - file: /etc/haproxy/haproxy.cfg
    - require:
        - pkg: haproxy


/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/templates/{{haproxy_role}}.cfg
    - template: jinja


{% if salt['pillar.get']('deploy:ssl:key') and salt['pillar.get']('deploy:ssl:crt') %}

/etc/ssl/certs/ssl.pem:
  file:
    - managed
    - source: salt://haproxy/templates/ssl.pem
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: haproxy

{% endif %}


{% from 'firewall/lib.sls' import firewall_enable with context %}
{{ firewall_enable('haproxy', 80, proto='tcp') }}
