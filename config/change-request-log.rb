module ChangeRequestLog

  def self.all_submods
    `git submodule foreach --quiet 'echo "$path"'`.split("\n")
  end

  def self.suppressed?(submod)
    `git config --local --get 'submodule.#{submod}.suppress-template'`.strip == 'true'
  end

  def self.compare_url(repo_url, old_rev, new_rev)
    web_url = repo_url.sub('git@github.com:', 'https://github.com/').sub(/\.git$/, '')
    "#{web_url}/compare/#{old_rev}...#{new_rev}"
  end

end
