

import ./errnos
import ./clike
import ./varIfJs


when varNotConst:
  import ./loopErrnoUnchk
else:
  import ./loopErrno
export errnos

import std/enumutils
import std/macros

macro initErrorcodeMap*(K, V; res: untyped, initFunc: typed) =
  result = newStmtList()
  #[
  XXX: NIM-BUG: if using `let` in forErrno loop (in Windows):
  errorcodeInit.nim(18, 7) Error: redefinition of 'errName'; previous declaration here: errorcodeInit.nim(18, 7)
  ]#
  var
    errName: string
    errNameNode, errId: NimNode
  when varNotConst:
    let N = newLit ErrnoCount
    result.add quote do:
      var `res` = `initFunc`[`K`, `V`](`N`)
    forErrnoUnchk e:
      errName = symbolName e
      errNameNode = newLit errName
      errId = ident errName
      result.add quote do:
        `res`[`errId`] = `symbolName` `e`
  else:
    let lit = newNimNode nnkTableConstr
    forErrno e:
      errName = symbolName e
      errNameNode = newLit errName
      errId = ident errName
      lit.add nnkExprColonExpr.newTree(
        newCall("int", errId),
        errNameNode
      )
    result.add quote do:
      const `res` = `initFunc`[`K`, `V`](`lit`)

template declErrorcodeWith*[K, V](initFunc: typed) =
  bind initErrorcodeMap
  initErrorcodeMap K, V,errorcode, initFunc
