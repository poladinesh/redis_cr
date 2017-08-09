#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on Ubuntu 14.04' do
    let(:chef_run) do
      #runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner = ChefSpec::ServerRunner.new(step_into: ['redis'])
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs necessary packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'installs redis' do
      expect(chef_run).to install_redis('2.8.9')
    end

    #let helper method to create version variable to use inside this file
    #let(:version) {'2.8.9'}

    it 'pulls down the remote file' do
      expect(chef_run).to create_remote_file("/tmp/redis-2.8.9.tar.gz")
    end

    it 'unzips redis from source' do
      #expect(chef_run).to run_execute('tar xzf /tmp/redis-2.8.9.tar.gz')
      resource = chef_run.remote_file("/tmp/redis-2.8.9.tar.gz")
      expect(resource).to notify('execute[unzip_redis_archive]').to(:run).immediately
    end

    it 'builds and install redis' do
      #expect(chef_run).to run_execute('make && make install')
      resource1 = chef_run.execute('unzip_redis_archive')
      expect(resource1).to notify('execute[build_packages]').to(:run).immediately
    end

    it 'installs the redis server' do
      #expect(chef_run).to run_execute('install server')
      resource = chef_run.execute('build_packages')
      expect(resource).to notify('execute[install server]').to(:run).immediately
    end

    it 'starts the service' do
      expect(chef_run).to start_service('redis_6379')
    end


  end
end
