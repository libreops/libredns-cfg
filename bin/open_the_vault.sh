#!/bin/sh
# https://blog.andrewlorente.com/p/using-pgp-to-encrypt-the-ansible-vault
# https://benincosa.com/?p=3235
gpg --batch --use-agent --decrypt vault-passwd.txt.gpg
