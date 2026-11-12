## `varIfJs` means when js, decl_var is for var; otherwise, it's for const
const varNotConst* = defined(js)
when varNotConst:
  import pkg/jsbuiltins/[consts, denoDetect]
  template decl_var(name, val){.used.} =
    let name = val
  template decl_c_const(variable, name, _; defval) =
    bind inDeno, from_js_const
    decl_var variable,
      if inDeno: Errno.name.ord
      else: from_js_const(name, defval)
  template if_var(cond: bool; body) =
    if cond: body
  template with_var(body) =
    body
else:
  #import ../../pyconfig/util
  import pkg/autoconf_sugars/util
  template decl_var(name, val){.used.} =
    const name = val
  template decl_c_const(variable, name, includeFile; defval) =
    bind from_c_int
    decl_var variable, from_c_int(name, includeFile, defval)
  template if_var(cond: bool; body) =
    when cond: body
  template with_var(body) =
    static: body

export decl_var, decl_c_const, if_var, with_var

