{% set pg_key_url = 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc' %}
{% set pg_list = '/etc/apt/sources.list.d/postgresql.list' %}
{% set pg_pref = '/etc/apt/preferences.d/pgdg.pref' %}


add_postgresql_apt_key:
  cmd.run:
    - name: wget -O - {{ pg_key_url }} | apt-key add -
    - unless: sudo apt-key list | grep -q 'PostgreSQL Debian Repository'


{% for file in [pg_list, pg_pref] %}
{{ file }}:
  file.managed:
    - source: salt://postgresql/files{{ file }}
    - user: root
    - group: root
    - mode: 0644
{% endfor %}


update_apt:
  cmd.wait:
    - name: apt-get update
    - watch:
      - file: {{ pg_list }}


postgresql:
  service:
    - running
    - require:
      - pkg: postgresql_packages


postgresql_packages:
  pkg.installed:
    - pkgs:
      - libpq5
      - libpq-dev
      - postgresql-client-9.2
      - postgresql-9.2
      - postgresql-server-dev-9.2
      - pgdg-keyring
    - require:
      - cmd.run: add_postgresql_apt_key
      - file: {{ pg_list }}
      - file: {{ pg_pref }}
