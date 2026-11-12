import std/unittest

import errno


template errnoEq(sym) =
  let s = astToStr(sym)
  check s == errorcode[sym]

suite "ErrnoAttributeTests":
  test "using_errorcode":
    # Every key value in errno.errorcode should be on the module.
    #for value in errno.errorcode.values(): check hasattr(errno, value)
    errnoEq EDOM
    errnoEq ERANGE

suite "strerror":
  test "invalid":
    check strerror(-1) == "Unknown error -1"
  test "static":
    check static(strerror(-1)) == "Unknown error -1"

  test "normal":
    check strerror(EINVAL) == "Invalid argument"

