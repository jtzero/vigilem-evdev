if $0 != "irb"
  require 'io/console'
  begin
    $stdout.echo= false 
    at_exit { $stdout.echo = true }
  rescue Errno::EINVAL
  end
end