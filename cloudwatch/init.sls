logs:
  group.present:
    - gid: 5647

/var/log/{{ pillar.project }}/:
  file.directory:
    - user: root
    - group: logs
    - makedirs: True
    - mode: 2774

install_cloudwatch_agent:
  pkg.installed:
    - pkgs:
      - amazon-cloudwatch-agent

/opt/aws/amazon-cloudwatch-agent/bin/forumone.json:
  file.managed:
    - source: salt://cloudwatch/files/config.json
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: install_cloudwatch_agent

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/forumone.json:
  cmd.run:
    - success_retcodes: 0
    - watch:
      - /opt/aws/amazon-cloudwatch-agent/bin/forumone.json