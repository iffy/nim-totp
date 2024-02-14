import std/strutils
import std/terminal

import keyring
import argparse
import otp

proc addService(service: string, optsecret: string) =
  setPassword("totpcli", service, optsecret)

proc getCode(service: string): string =
  let secret = getPassword("totpcli", service).get()
  let totp = Totp.init(secret)
  align($totp.now(), 6, '0')

when isMainModule:
  doAssert keyringAvailable()
  import argparse
  var p = newParser:
    command("add"):
      help("Add a TOTP secret for a service")
      arg("service")
      run:
        let secret = readPasswordFromStdin("OTP Secret: ").strip()
        addService(opts.service, secret)
    command("get"):
      help("Get a TOTP token for a service")
      arg("service")
      run:
        echo getCode(opts.service)
  try:
    p.run()
  except UsageError as e:
    stderr.writeLine getCurrentExceptionMsg()
    quit(1)
