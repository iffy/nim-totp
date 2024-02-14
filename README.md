# Installation

Requires Nim v2

```
nimble install https://github.com/iffy/nim-totp.git
```

# Usage

Add a TOTP secret:

```
totp add someservice
```

Get a TOTP token:

```
totp get someservice
```

# Security

It uses [the system keyring](https://github.com/iffy/nim-keyring) to store secrets. Use at your own risk.
