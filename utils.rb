#!/usr/bin/ruby

def build_dirs(cache_dir, config_dir)
  unless Dir::exist? cache_dir
    Dir::mkdir cache_dir
  end
  unless Dir::exist? config_dir
    Dir::mkdir config_dir
  end

  unless File::exist? "#{config_dir}/subreddits.txt"
    sf = File.new("#{config_dir}/subreddits.txt", "w+")
    sf.write 'linuxmemes'
  end
end

def get_subreddit(config_dir, opts)
  if opts.subreddit == nil
    dmenu = IO.popen "dmenu -p \"Select Subreddit r/\" < \"#{config_dir}/subreddits.txt\" | awk -F \"|\" '{print $1}'"
    opts.subreddit = dmenu.gets
    if opts.subreddit == nil
      puts 'no subreddit chosen'
      exit
    end
  end
end

def download_pics(opts, cache_dir)
  if opts.verbose?
    system 'notify-send "Rudy" "Downloading r/pics"'
  end

  dl = Fiber.new do |link|
    current = link
    loop do
      system "aria2c -d #{cache_dir} #{current}"
      current = Fiber.yield
    end
  end

  url_base = "https://www.reddit.com/r/#{opts.subreddit.strip}/top.json?t=month"
  memes = IO.popen("curl -s -H 'user-agent: bot' #{url_base}")
  memes = JSON.parse(memes.gets)

  memes["data"]["children"].each { |child|
    dl.resume child["data"]["url_overridden_by_dest"]
  }
end

