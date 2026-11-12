
import std/tables
export tables.`[]`, tables.`[]=`
import ./errno/[errnoUtils, errnoConsts]
export errnoUtils except Errno, initErrorcodeMap

export errnoConsts

import ./errno/private/singleton_errno
export errno

{.push inline.}
proc initTable[K, V](x: openArray[(K, V)]): Table[K, V] = x.toTable[:K, V]
proc initTable[K, V](N: Natural): Table[K, V] = tables.initTable[K, V](N)
{.pop.}

declErrorcodeWith[int, string] initTable
export errorcode

