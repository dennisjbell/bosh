module Bosh::Cli
  class ProgressRenderer
    def initialize
      @mutex = Mutex.new
      @indices = {}
    end

    def render(path, label)
      @mutex.synchronize do
        truncated_path = path.truncate(40)
        truncated_path_length = truncated_path.length + 1

        if !@indices.has_key?(path)
          say(truncated_path.make_yellow, " \n")
        end

        @indices[path] ||= @indices.count

        save_cursor_position
        up(@indices.count - @indices[path])

        right(truncated_path_length)
        clear_line

        say(label, "")

        restore_cursor_position
        Bosh::Cli::Config.output.flush # Ruby 1.8 compatibility
      end
    end

    private

    def save_cursor_position
      say("\033[s", "")
    end

    def restore_cursor_position
      say("\033[u", "")
    end

    def up(count = 1)
      say("\033[#{count}A", "")
    end

    def right(count = 1)
      say("\033[#{count}C", "")
    end

    def clear_line
      say("\033[K", "")
    end
  end
end
