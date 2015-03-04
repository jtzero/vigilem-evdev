require "bundler/gem_tasks"

def source_dependencies
  deps = Bundler.require(:dev)
  arg = deps.select do |d|
    d.groups.include?(:dev) and d.source and 
                          d.source.class <= Bundler::Source::Path
    # don't want Rubygems or git projects only projects built here
  end
end

namespace :build do
  task :all do
    puts `#{command = 'rake build'}`
    source_dependencies.each do |dep|
      Dir.chdir dep.source.path do
        puts `#{command}`
      end
    end
  end
  
end

namespace :test do
  task :all do
    current_spec_name = Bundler.load_gemspec(Dir['./*.gemspec'].first).name
    
    line_width = 50
    line = ('=' * line_width)
    end_line = ('-' * line_width)
    
    name_paths = [[current_spec_name, './'], *source_dependencies.map {|sd| [sd.name, sd.source.path] }]
    stat_name_paths = name_paths.select {|name, path| name =~ /stat/ }
    stat_name_paths.each {|name, path| require "#{name.gsub('-', File::SEPARATOR)}.rb" }
    @stats = Vigilem::Core::Stat.all
    
    name_paths.each do |name, path|
      Bundler.with_clean_env do
        Dir.chdir path do
          puts line, (dir = Dir.getwd), line
          
          stat = @stats.find {|s| s.gem_name == name }
          if stat.nil? or (stat and stat.available?)
            system(command = "bundle exec rspec spec")
            if $?.exitstatus == 7 
              puts `bundle install`
              system(command)
            end
            puts end_line
          else
            puts end_line, 'not available on this system, need to make more os agnostic tests, skipping', end_line
          end
        end
      end #with_clean_env
    end
  end #task
end

task :test do
  system(command = "bundle exec rspec spec")
  if $?.exitstatus == 7 
    puts `bundle install`
    system(command)
  end
end
