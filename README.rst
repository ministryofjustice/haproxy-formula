haproxy-formula
---------------
Load balancing with SSL termination (haproxy >= 1.5)

 - adds 1.5 haproxy pkg repo
 - installs haproxy
 - checks grains to select haproxy configuration (configuration namespacing)
 - detects downstream servers to pass traffic to
 - logs unique request_id


configuration
-------------

example loadbalancer grains::

    roles:
      - haproxy.my.app


example application server grains::

    roles:
      - my.app


example pillar::

    haproxy:
      loglevel: debug
      roles:
        my.app:
          downstream_port: 81
          ssl: True
          http_port: 80
          https_port: 443


throttling
----------
To enable throttling create pillar like::

    haproxy:
      roles:
        yourapp:
          throttling: True


Please consult `map.jinja` for other options.

On defaults:
As browser nowadays are opening 5 to 7 TCP connections per domain name, to keep on safe side we are setting
10 as maximum concurrent connections.
On top of it we are assuming that user will need at least 3s to open a next page, so we allow for rate of
10 requests per 3 seconds window.
Taking into account that users are ofter natted behind a single ip, our default configuration assumes maximum
5 users natted behind a single IP.

Therefore::

    connection_concurrently_open = 10*5 = 50
    connection_rate_over_3s_window = 10*5 = 50


In case you want to whitelist specific ips. Please supply your salt://haproxy/templates/whitelist file.

Note that all throttling is happening on layer 4 (transport - tcp).
Additionally we also protect from slowloris type attack. By waiting max 5s for connection and 5s for http-request.
It might impact big POST requests.

Basic Auth support
------------------

It is possible to lock the haproxy instance down via Basic Auth, for example
for non-public instances of a site.

This can be done by setting the following pillar values in your haproxy role::

    haproxy.haproxy_role.basic_auth_enabled: True
    haproxy.haproxy_role.basic_auth_user: 'admin'
    haproxy.haproxy_role.basic_auth_password: '$5$boguscryptpasswordstringblahblah'

The value of basic_auth_password should be a string parsable by crypt(3). The
'mkpasswd' tool (in 'whois' package on Ubuntu) can be useful for this task::

    mkpasswd -m sha-256


salt mine configuration
-----------------------

As we are depending on salt mine to detect servers don't forget to enable it in salt minion config

minion::

    mine_functions:
      network.ip_addrs: []

    mine_interval: 1


TODO
----
 - statsd integration
   https://gist.github.com/phobos182/3132793
 - enable haproxy stats page (safely)
