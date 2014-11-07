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
