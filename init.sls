include:
  - postgresql.ppa

{% set pg_list = '/etc/apt/sources.list.d/postgresql.list' %}
{% set pg_pref = '/etc/apt/preferences.d/pgdg.pref' %}


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


{% set postgresql_conf = '/etc/postgresql/9.2/main/postgresql.conf' %}
{{ postgresql_conf }}:
  file.managed:
    - source: salt://postgresql/files{{ postgresql_conf }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 0644
    - require:
      - pkg: postgresql_packages


{% set mem = 8192 if 8192 < (grains['mem_total'] / 4) else (grains['mem_total'] / 4) %}
kernel.shmmax:
  sysctl.present:
    - value: {{ (1024**2 * mem * 1.1)|int }}


postgresql:
  service:
    - running
    - require:
      - sysctl: kernel.shmmax
      - pkg: postgresql_packages
    - watch:
      - file: {{ postgresql_conf }}
