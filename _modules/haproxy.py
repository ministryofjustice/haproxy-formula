import logging

from salt.exceptions import CommandExecutionError


log = logging.getLogger(__name__)


def role(default='default', role_prefix='haproxy'):
    """
    returns haproxy role from haproxy.* role defined in grain
    why? to have only one entry in grains for haproxy, instead of role definition and
    subrole/haproxy_role definition as two separate keys

    In other words role for haproxy like `haproxy.foo.bar` means that I'm an haproxy for a service having role `foo.bar`

    example grains on haproxy:
    roles:
        - foo
        - haproxy.my-api

    example grains on downstream server:
    roles:
        - my-api

    will make this function return 'api'

    It will fail hard if you have more than one role starting from role_prefix
    """
    haproxy_role = None
    for role in __salt__['grains.get']('roles', []):
        assert isinstance(role, basestring)
        if role.startswith(role_prefix):
            if haproxy_role:
                raise CommandExecutionError('Error executing haproxy.role(default={0}, role_prefix={1}): ambiguous role prefix'.format(default, role_prefix))
            haproxy_role = role.lstrip(role_prefix).lstrip('.') or default

    if haproxy_role is None:
        haproxy_role = default
    return haproxy_role
