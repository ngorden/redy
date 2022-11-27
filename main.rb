#!/usr/bin/ruby
require 'fileutils'
require 'json'
require './options'
require './utils'

cache_dir = '/tmp/redy'
config_dir = "#{ENV['XDG_CONFIG_HOME']}/redy"
config_dir ||= "#{ENV['HOME']}/.config/redy"
opts = get_opts

build_dirs(cache_dir, config_dir)


get_subreddit(config_dir, opts)
download_pics(opts, cache_dir)

system 'notify-send "Rudy" "Download Complete"'
if opts.filter?
  IO.popen "sxiv -ao #{cache_dir}"
else
  system "sxiv -a #{cache_dir}"
end

unless opts.keep?
  FileUtils.rm_rf cache_dir
end

