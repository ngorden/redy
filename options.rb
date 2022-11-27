require 'optparse'

def get_opts
  options = OpenStruct.new
  options.limit = 10
  options.filter = false
  options.keep = false
  options.verbose = false

  OptionParser.new do |opt|
    opt.on('-l', '--limit LIMIT', 'Photo count limit') { |o| options.limit = o }
    opt.on('-f', '--filter', 'Filter the photos that are downloaded') { |_| options.filter = true }
    opt.on('-k', '--keep', 'Keep the photos that are downloaded') { |_| options.keep = true }
    opt.on('-v', '--verbose', 'Print verbose messages') { |_| options.verbose = true }
    opt.on('Subreddit to scrape') { |o| options.subreddit = o }
  end.parse!

  options.subreddit = ARGV[0]
  options
end