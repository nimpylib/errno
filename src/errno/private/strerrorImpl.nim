
when defined(js):
  import std/enumutils
  import ./loopErrnoUnchk
import ./errnos

when defined(nimPreviewSlimSystem):
  import std/assertions
static:assert Errno is Ordinal

proc strerrorAux*[Tab](c: int; errorcode: Tab): string =
  template retInv =
    return "Unknown error " & $c
  when nimvm:
    if c not_in Errno.low.ord .. Errno.high.ord:
      retInv
    result = strerror Errno(c)
  else:
    when defined(js):
      let name = try: errorcode[c]
      except KeyError:
        retInv
      # parseEnum cannot be used. as Errno has string repr
      var e: Errno
      forErrnoUnchk i:
        if i.symbolName == name:
          e = i
          break
      result = strerror e
    else:
      proc c_strerror(c: cint): cstring {.importc: "strerror", header: "<string.h>".}
      result = $c_strerror(cint c)
