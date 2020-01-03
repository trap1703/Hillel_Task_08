#
# Cookbook:: 777
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
include_recipe '777::server'
include_recipe '777::mysql'
include_recipe '777::conf'
