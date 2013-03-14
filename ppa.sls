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
    - require:
      - cmd: add_postgresql_apt_key
{% endfor %}


update_apt:
  cmd.wait:
    - name: apt-get update
    - watch:
      - file: {{ pg_list }}
