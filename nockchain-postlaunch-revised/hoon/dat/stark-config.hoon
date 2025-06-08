:: Import zeke library as z
/=  z  /common/zeke
:: Does not correspond to a rune? Looks like structure versioning.
/#  constraints-0=constraints
::
::  We place constraints in a different file
::  so the stark parameters can be modified
::  without blowing the cache

:: Typecast as a stark-config structure from zeke library
:: COnfig includes a polynomial table, a map to polys, and exp for log, and security level.
: a=. b=*stark (bunted), c=prep, d=contraints-0
^-  stark-config:z
%*  .  *stark-config:z
  prep  constraints-0
==
