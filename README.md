Description
===========

Install redis from source.

Tested on
----

* ubuntu10.10
* ubuntu11.10
* ubuntu12.04


Requirements
============




Attributes
==========

* [:redis][:version] = "2.6.0" # redis version to install.
* [:redis][:src_cachedir] = "#{Chef::Config[:file_cache_path]}/redis" # path to download tarball and make working directory.

Usage
=====

* redis_src::default  
install redis-server

* redis_src::uninstall  
 remove redis-server