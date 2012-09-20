#
# Cookbook Name:: redis_src
# Recipe:: uninstall
#
# Copyright 2012, Higanworks LLC.
#

# This recipe was written for repeat testing install.
# Therefore this is unstable. Don't use.

service "redis-server" do
  provider Chef::Provider::Service::Upstart
  action [:stop,:disable]
end

%W{/usr/local/etc/redis #{Chef::Config[:file_cache_path]}/redis}.each do |w|
  directory w do
    recursive true
    action :delete
  end
end

%w{redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server}.each do |w|
  file "/usr/local/bin/#{w}" do
    action :delete
  end
end

%w{/usr/local/etc/redis/redis.conf /etc/init/redis-server.conf}.each do |w|
  file w do
    action :delete
  end
end

user "redis" do
  action :remove
end
