# Secrets

Password storage and access control through GPG.

# Setup

First you should set up GPG. See http://zacharyvoase.com/2009/08/20/openpgp/ .

In a multi-user environment you should export all keys to `pubkeys/`. Example:

```bash
gpg --output pubkeys/<YOUR_KEY_EMAIL>.asc --armor --export '<YOUR_KEY_EMAIL>'
```

Finally, do this:

```bash
echo '<YOUR_KEY_EMAIL>' > whoami
```

# Creating your first secret

```bash
./add-secret.sh
```

# Viewing secrets you have access to

See "vim integration". Otherwise:

```bash
./decrypt.sh encrypted/example.gpg
$EDITOR decrypted/example.txt
```

# Updating secrets (data and access to them)

If you use the vim integration don't forget to use `:GPGEditRecipients`. Otherwise:

```bash
$EDITOR decrypted/example.txt
./encrypt.sh decrypted/example.txt
```

# vim integration

Install https://github.com/jamessan/vim-gnupg . This allows you to directly open
and update `.pgp` files. It screws up editing `.asc` files though...

# High-availability

`git-push` to several remotes.
