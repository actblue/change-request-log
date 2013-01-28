require File.expand_path('config/change-request-log.rb', File.dirname(__FILE__))

desc "Install git hooks and init submodules"
task :setup do
  sh 'git', 'submodule', 'init'
  sh 'git', 'submodule', 'update'
  Dir['hooks/*'].each do |hook_path|
    hook = File.basename(hook_path)
    unless File.symlink?(".git/hooks/#{hook}")
      puts "installing #{hook} hook..."
      File.symlink("../../hooks/#{hook}", ".git/hooks/#{hook}")
    end
  end
end

desc "Add a new submodule"
task :add, :url, :path do |t, args|
  # Abuse URL by treating it like a path... eh... it works
  submod = args[:path] || File.basename(args[:url]).sub(/\.git$/, '')
  sh 'git', 'submodule', 'add', args[:url], submod
  sh 'git', 'add', submod
  sh 'git', 'commit'
end

desc "Update a submodule"
task :update, :submod, :revision do |t, args|
  orig_branch = `git symbolic-ref -q HEAD`.chomp.sub(%r[^refs/heads/], '')
  pull_req_branch = "req-#{ENV['USER']}-#{Time.now.to_i}"
  ref = args[:revision] || 'master'
  submod = args[:submod]
  sh 'git', 'checkout', '-b', pull_req_branch
  # Submodules tend to end up with a detached HEAD, so checkout first if we wanted a branch or tag
  sh "cd #{submod} && (git fetch; git checkout #{ref}; git symbolic-ref -q HEAD && git pull #{ENV['PULL_OPTIONS']})"
  sh 'git', 'add', submod
  unless `git status --porcelain #{submod}`.strip.empty?
    sh 'git', 'commit'
    sh 'git', 'checkout', orig_branch
    sh 'git', 'submodule', 'update'
    sh 'git', 'push', 'origin', pull_req_branch
    # We push to origin (normally, your org's shared private repo), so we must specify that for `hub pull-request`
    if `git config --get remote.origin.url` =~ /^git@github.com:(.+?)\//
      sh 'hub', 'pull-request', '-h', "#{$1}:#{pull_req_branch}"
    else
      puts "origin doesn't look like a GitHub repo, so skipping pull-request."
    end
  end
end
