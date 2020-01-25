# LibreDNS Ansible Setup

<img src="https://libredns.gr/static/img/libredns.svg" width="250">

Ansible scripts for <a href="https://libredns.gr/">LibreDNS</a>.

## Requirements

1. Ansible
2. GPG
3. Running gpg-agent

## Verify

    ansible -i hosts -m ping libredns

## Usage

Assuming you have sudo access and `hosts.gpg` is decrypted, to run the whole thing:

```
ansible-playbook -v main.yml
```

## Support

[![OpenCollective](https://img.shields.io/opencollective/all/libreops?color=%23800&label=opencollective&style=flat-square)](https://opencollective.com/libreops/)

## Join

[![irc](https://img.shields.io/badge/Matrix-%23libreops:matrix.org-blue.svg?style=flat-square)](https://riot.im/app/#/room/#libreops:matrix.org)

## License

[![license](https://img.shields.io/badge/license-AGPL%203.0-6672D8.svg?style=flat-square)](LICENSE)
