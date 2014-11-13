{% from "haproxy/map.jinja" import haproxy with context %}

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
    - require:
        - pkg: haproxy


hatop:
  pkg.installed


/etc/haproxy/whitelist:
  file.managed:
    - source: salt://haproxy/templates/whitelist
    - template: jinja
    - watch_in:
      - service: haproxy


/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: {{haproxy.this.template}}
    - template: jinja
    - watch_in:
      - service: haproxy


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
{{ firewall_enable('haproxy', haproxy.this.http_port, proto='tcp') }}

{{ firewall_enable('haproxy-stats', haproxy.this.stats_port, proto='tcp') }}

{% if haproxy.this.ssl %}
  {{ firewall_enable('haproxy-ssl', haproxy.this.https_port, proto='tcp') }}
{% endif %}
