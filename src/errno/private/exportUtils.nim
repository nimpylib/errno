
import ./clike
import ./loopErrnoUnchk
import ./varIfJs
import ./errnos
export errnos

import std/macros

import std/enumutils

const DEF_INT = low(int)

template ifHasErr(name: int; body) =
  if_var name != DEF_INT: body

#[template decl_c_int*(name, includeFile; defval) =
  bind decl_c_intImpl
  decl_c_intImpl(name, name, includeFile, defval)
  export name]#

template decl_err(variable, err){.dirty.} =
  bind decl_c_const, DEF_INT
  decl_c_const(variable, err, "<errno.h>", DEF_INT)

template declAndExp(err; nerr: int) =
  decl_var err, cast[cint](nerr)
  export err

when varNotConst:
  var ValidErrnos*: set[Errno]
else:
  var ValidErrnos*{.compileTime.}: set[Errno]

template addValidErrno(e) =
  with_var:
    ValidErrnos.incl Errno.e

template decl_err_cint(err){.dirty.} =
  ## generate:
  ##   if C: `const err*: int = ...` if err defined in `<errno.h>`
  ##   if JS: `let err* ...`
  bind declAndExp, decl_err, ifHasErr
  decl_err(`n err`, err)
  when varNotConst:
    declAndExp err, `n err`
    ifHasErr `n err`:
     addValidErrno err
  else:
    ifHasErr `n err`:
      declAndExp err, `n err`
      addValidErrno err

macro exportAllErrnos() =
  result = newStmtList()
  forErrnoUnchk e:
    result.add newCall(bindSym"decl_err_cint", ident symbolName e)    

exportAllErrnos()

