default[:redis][:version] = "2.4.17"

default[:redis][:src_cachedir] = "#{Chef::Config[:file_cache_path]}/redis"
