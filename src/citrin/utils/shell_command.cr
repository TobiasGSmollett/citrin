module Citrin::Utils

  module Shell extend self
    def run(command)
      stdout, stderr = IO::Memory.new, IO::Memory.new
      status = Process.run(command, shell: true, output: stdout, error: stderr).exit_code
      raise stderr.to_s if status != 0
      stdout.to_s
    end
  end

  module Git extend self
    def clone(url)
      Shell.run("git clone " + url)
    end
  end

end