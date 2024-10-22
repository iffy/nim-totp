import std/strutils
import std/terminal
import std/times

import keyring
import argparse
import otp

proc addService(service: string, optsecret: string) =
  let upper = optsecret.toUpperAscii()
  if upper != optsecret:
    stderr.writeLine("Warning: secret wasn't all uppercase, but it probably should be")
  setPassword("totpcli", service, optsecret)

proc getCode(service: string): tuple[code: string, expires: int] =
  let secret = getPassword("totpcli", service).get()
  let totp = Totp.init(secret)
  let code = align($totp.now(), 6, '0')
  let expires = 30 - epochTime().int mod 30
  return (code, expires)

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
        let code = getCode(opts.service)
        echo code.code
        stderr.writeLine("Expires in " & $code.expires & "s")

  try:
    p.run()
  except UsageError as e:
    stderr.writeLine getCurrentExceptionMsg()
    quit(1)
