require "../utils/shell_command"

module Citrin::Core
  class Executor
    include Citrin::Utils
    
    def run_all_test(paths)
      result = Hash(String, Time::Span).new
      paths.each do |path|
        result[path] = run_test path
      end
      result
    end

    def run_test(path)
      begin
        result = Shell.run "crystal spec #{path} --time"
        get_time result
      rescue
        Time::Span::MaxValue
      end
    end

    def get_time(output)
      result = Time::Span::MaxValue
      output.each_line do |line|
        if line.includes? "Execute: "
          time, milisec = line.split('.')
          execute, h, m, s = time.split(':')
          result = Time::Span.new(0, h.to_i, m.to_i, s.to_i, milisec.to_i)
        end
      end
      result
    end
  end
end
