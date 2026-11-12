import ./errnos

const ErrnoHigh = high(Errno)
template forErrnoUnchk*(err; body) =
  bind Errno, ErrnoHigh
  for err{.inject.} in succ(Errno.E_SUCCESS)..ErrnoHigh:
    # XXX: NIM-BUG: with `bind Errno` above, use `high(Errno)` here makes Nim
    #  consider Errno as a value instead of a type, thus leading to a warning
    #[Deprecated since v1.4; there should not be `high(value)`. Use `high(type)`.; high is deprecated]#

    #if err == Errno.E_SUCCESS: continue
    body

