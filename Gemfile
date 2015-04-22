source 'https://rubygems.org'
gemspec

def get_local_if_exists(gem_name, path, git)
  if File.exists?(path)
    gem gem_name, :path => path
  else
    gem gem_name, :git => git
  end
end

args = ARGV.map {|str| str.gsub(/^:source$/, 'source') }

if (args & (excep = ["--without", "source"]) != excep)
  group :source do
    get_local_if_exists("vigilem-support", "../vigilem-support", "https://github.com/jtzero/vigilem-support.git")
    get_local_if_exists("vigilem-core", "../vigilem-core", "https://github.com/jtzero/vigilem-core.git")
    get_local_if_exists("vigilem-dom", "../vigilem-dom", "https://github.com/jtzero/vigilem-dom.git")
    get_local_if_exists("vigilem-x11-stat",  "../vigilem-x11-stat", "https://github.com/jtzero/vigilem-x11-stat.git")
    get_local_if_exists("vigilem-x11",  "../vigilem-x11", "https://github.com/jtzero/vigilem-x11.git")
  end
end
