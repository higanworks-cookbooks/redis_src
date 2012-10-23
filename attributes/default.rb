default[:redis][:version] = "2.6.0"

default[:redis][:src_cachedir] = "#{Chef::Config[:file_cache_path]}/redis"
