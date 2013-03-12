include:
  - postgresql.ppa

{% set pg_list = '/etc/apt/sources.list.d/postgresql.list' %}
{% set pg_pref = '/etc/apt/preferences.d/pgdg.pref' %}


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
