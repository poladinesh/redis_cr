# motd/libraries/matchers.rb
if defined?(ChefSpec)
  def install_redis(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:redis, :install, resource_name)
  end
end

=begin
#sample for custom matcher
#Resource: https://github.com/chefspec/chefspec
# motd/libraries/matchers.rb
if defined?(ChefSpec)
  def write_foobar(message)
    ChefSpec::Matchers::ResourceMatcher.new(:motd_message, :write, message)
  end
end
=end
