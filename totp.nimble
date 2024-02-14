# Package

version       = "0.1.0"
author        = "Matt Haggard"
description   = "A command-line totp tool"
license       = "MIT"
srcDir        = "src"
bin           = @["totp"]


# Dependencies

requires "nim >= 1.6.14"
requires "keyring == 0.4.1"
requires "nimcrypto == 0.6.0"
requires "otp == 0.3.3"
requires "argparse"
