resource_name :redis
actions :install

#property :source, String
property :version, String, name_property: true

action :install do
    #source_url = source
    remote_file "/tmp/redis-#{new_resource.version}.tar.gz" do
    #source "http://download.redis.io/releases/redis-#{version}.tar.gz"
    #require 'pry' ; binding.pry
    source "http://download.redis.io/releases/redis-#{new_resource.version}.tar.gz"
  #  source source_url
    notifies :run, "execute[unzip_redis_archive]", :immediately
  end

  # unzip the archive
  execute "unzip_redis_archive" do
    command "tar xzf /tmp/redis-#{new_resource.version}.tar.gz"
    cwd "/tmp"
    action :nothing
    notifies :run, "execute[build_packages]", :immediately
  end

  # Configure the application: make and make install
  execute "build_packages" do
    command "make && make install"
    cwd "/tmp/redis-#{new_resource.version}"
    action :nothing
    notifies :run, "execute[install server]", :immediately
  end

  # Install the Server
  execute "install server" do
    command "echo -n | ./install_server.sh"
    cwd "/tmp/redis-#{new_resource.version}/utils"
    action :nothing
  end
end
