#
# Cookbook Name:: redis_src
# Recipe:: default
#
# Copyright 2012, HiganWork LLC.
#

## System User redis
user "redis" do
  comment "redis server"
  home "/usr/local/etc/redis"
  system true
  shell "/bin/false"
end

%w{/usr/local/etc/redis}.each do |w|
  directory w do
    action :create
    owner "redis"
    group "redis"
    mode  "0700"
  end
end


## tcl8.5 install for make test
package "tcl8.5" do
    action :install
end

script "make_redis_from_source" do
  interpreter "bash"
  flags "-e"
  user "root"
  Chef::Log.info("Start: make #{node[:redis][:version]}")
  code <<-"EOH"
    mkdir -p #{node[:redis][:src_cachedir]}
    cd #{node[:redis][:src_cachedir]}
    wget http://redis.googlecode.com/files/redis-#{node[:redis][:version]}.tar.gz
    tar zxvfp ./redis-#{node[:redis][:version]}.tar.gz
    cd redis-#{node[:redis][:version]}
    make
    ### Can't complete test on VM with message "Redis did not closed connection after protocol desync".
    ### Test will be skipped. Information =>  https://github.com/antirez/redis/issues/325
    # make test
    make install
    EOH

  only_if "test ! -f #{node[:redis][:src_cachedir]}/redis-#{node[:redis][:version]}.tar.gz"
  Chef::Log.info("End  : make #{node[:redis][:version]}")
  notifies :restart, "service[redis-server]"
end

template "/usr/local/etc/redis/redis.conf" do
  source "redis.conf.erb"
  owner "redis"
  notifies :restart, "service[redis-server]"
end

cookbook_file "/etc/init/redis-server.conf" do
  source "upstart_redis-server.conf"
  owner "root"
  notifies :restart, "service[redis-server]"
end

service "redis-server" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action [:enable, :start]
end
