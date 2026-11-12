import ./exportUtils

template forErrno*(err; body) =
  bind ValidErrnos
  for err{.inject.} in ValidErrnos:
    body

