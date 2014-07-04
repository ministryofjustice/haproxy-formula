haproxy-formula
---------------
Load balancing with SSL termination (haproxy >= 1.5)

 - adds 1.5 haproxy pkg repo
 - installs haproxy
 - checks grains to select haproxy configuration (configuration namespacing)
 - detect downstream servers to pass traffic to
 - log unique request_id


configuration
-------------

example loadbalancer gains::

    roles:
      - haproxy
    haproxy:
      default


example pillar::

    haproxy:
      loglevel: debug
      roles:
        default:
          downstream_port: 81
          downstream_role: myapp
          ssl: True
          http_port: 80
          https_port: 443


grains on application server::

    roles:
      - myapp





TODO
----
 - statsd integration
   https://gist.github.com/phobos182/3132793
 - enable haproxy stats page (safely)
