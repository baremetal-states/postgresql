include:
  - postgresql.ppa

{% set pg_list = '/etc/apt/sources.list.d/postgresql.list' %}
{% set pg_pref = '/etc/apt/preferences.d/pgdg.pref' %}


postgresql-client-9.2:
  pkg.installed:
    - require:
      - file: {{ pg_list }}
      - file: {{ pg_pref }}
