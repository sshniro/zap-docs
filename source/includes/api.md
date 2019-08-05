API Catalogue
==============

Scan API
------------

Fuzzer API
------------

Core API
------------



Test API

> 3 ways to request Tokens

``` shell

#using "headers"
$ curl 'https://zap/v1/coverage' -H 'Authorization: 3b036afe-0110-4202-b9ed-99718476c2e0'

#using "users": don't forget ":" at the end of line !
$ curl https://zap/v1/coverage -u 3b036afe-0110-4202-b9ed-99718476c2e0:

#using "straight URL"
$ curl https://3b036afe-0110-4202-b9ed-99718476c2e0@api.zap.io/v1/coverage

```

Authentication is required to use zap. When you register we will give you
an authentication key that must accompany each API call you make.

