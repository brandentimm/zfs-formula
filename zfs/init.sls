{% from 'zfs/map.jinja' import zfs with context %}
# Completely ignore non-RHEL or Debian based systems
{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease'][0] in [6, 7] %}
include:
  - epel-formula

Install ZoL rpm repository:
  pkg.installed
    - sources:
      - zfs-release: {{ zfs.rpmrepo }}
    - skip_verify: True
    - require:
      - pkg: epel_release

Install kernel-devel:
  pkg.installed

Install zfs:
  pkg.{{ zfs.pkgstate }}:
    - name: {{ zfs.pkg }}
    - require:
      - pkg: zfs_release
{%- elif grains['os_family'] == 'Debian' %}
Install ZoL PPA:
  pkgrepo.managed:
    ppa: zfs-native/stable 

Install zfs:
  pkg.installed:
    - require:
      - pkg: zfs_repo
{% endif %}
