module Rcalc
  class Terminal
    def initialize
      @continuous_listen = false
    end

    def blocking_console_query(query, listen_until)
      # send query and block wait for response
      res = ''
      $stdin.raw do |stdin|
        $stdout << "#{esc}#{query}"
        $stdout.flush

        finished = false
        loop do
          c = stdin.getc
          res << c if c
          listen_until.split.each do |d|
            finished = true if c == d
          end
          break if finished
        end
      end
      res
    end

    def pos
      m = blocking_console_query('6n', 'R').match(/(?<row>\d+);(?<column>\d+)/)
      [Integer(m[:column]), Integer(m[:row])]
    end

    def size
      # get current position
      x, y = pos

      # try go to the ends of the earth
      goto!(9999, 9999)

      # get that position
      tx, ty = pos

      # go back to current pos
      goto!(x, y)

      [tx, ty]
    end

    def esc
      "\e["
    end

    def e!(command)
      print "#{esc}#{command}"
    end

    TERMINAL_COMMANDS.each do |name, code|
      define_method "#{name}!" do
        e! code
      end
    end

    TERMINAL_TOGGLES.each do |name, code|
      define_method "enable_#{name}!" do
        e! "#{code}h"
      end

      define_method "disable_#{name}!" do
        e! "#{code}l"
      end
    end

    def color!(id)
      e! "38;5;#{id}m"
    end

    def bgcolor!(id)
      e! "48;5;#{id}m"
    end

    TERMINAL_COLORS.each do |name, code|
      define_method "color_#{name}!" do
        color!(code)
      end

      define_method "bgcolor_#{name}!" do
        bgcolor!(code)
      end
    end

    def rgb!(r, g, b)
      e! "38;2;#{r};#{g};#{b}m"
    end

    def goto!(x, y)
      e! "#{y};#{x}f"
    end

    def split(collect)
      res = []

      inside_esc = false
      current = ''
      collect.each_char do |chr|
        # start of esc
        if chr == "\e"
          inside_esc = true

          # if there already is escaped content in the buffer,
          #  send it out and clear the buffer
          unless current.empty?
            res << current
            current = ''
          end
        end

        if inside_esc
          # if we are inside an escape, add chars to the buffer
          current << chr
        else
          # for all other characters, we just
          res << chr
        end
      end

      # if we were inside an escape, we need to send out the final set
      res << current if inside_esc

      res
    end

    def listen!(&block)
      $stdin.raw do |stdin|
        collect = ''

        finished = false
        loop do
          c = stdin.getch(min: 0, time: 0.01)

          if c.nil?
            if collect.length.positive?

              # sometimes multiple tokens appear inside a result
              # so we split it out and send them to the block
              split(collect).each do |token|
                finished = block.call(token)
              end
            end
            collect = ''

          else
            collect += c
          end

          break if finished
        end
      end
    end
  end
end
