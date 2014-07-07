import logging

log = logging.getLogger(__name__)

#__salt__ = {}
#__opts__ = {}


def role(default='default', role_prefix='haproxy'):
    """
    returns haproxy role from haproxy.* role defined in grain
    why? to have only one entry in grains for haproxy, instead of role definition and
    subrole/haproxy_role definition as two separate keys

    example grains:
    roles:
        - foo
        - haproxy.api

    will make this function return 'api'
    """
    for role in __salt__['grains.get']('roles', []):
        assert isinstance(role, basestring)
        if role.startswith(role_prefix):
            haproxy_role = role.lstrip(role_prefix).lstrip('.') or default
            return haproxy_role
    return default
