
import std/tables
export tables.`[]`
import ./errno/[errnoUtils, errnoConsts]
export errnoUtils except Errno, initErrorcodeMap

export errnoConsts

import ./errno/private/singleton_errno
export errno

declErrorcodeWith[int, string] initTable
export errorcode

