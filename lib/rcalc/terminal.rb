module Rcalc
  ##
  # This class contains utilities related to terminal. Its initializer does not take any arguments.
  #
  class Terminal
    ##
    # Performs a blocking console query. Used by other functions in this class
    #
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

    ##
    # Gets the cursor position in the terminal. Returns two variables, x and y. Takes no arguments.
    #
    # @return [Integer, Integer] x and y, or column, row in that order.
    #
    # @example
    #   t = Rcalc::Terminal.new
    #   x, y = t.pos
    #
    def pos
      m = blocking_console_query('6n', 'R').match(/(?<row>\d+);(?<column>\d+)/)
      [Integer(m[:column]), Integer(m[:row])]
    end

    ##
    # Gets the size of the terminal in characters. Returns two variables, width and height. Takes no arguments.
    #
    # @return [Integer, Integer] width and height, or columns, rows in that order.
    # @example
    #   t = Rcalc::Terminal.new
    #   w, h = t.size
    #
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

    ##
    # Function to get the CSI sequence. Used by other functions in the class
    #
    def esc
      "\e["
    end

    ##
    # Function to print the CSI sequence followed by some command. Used by other functions in the class
    #
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

    ##
    # Sets the current text color to a number
    #
    # @example set text color to red
    #   t = Rcalc::Terminal.new
    #   t.color!(Rcalc::TERMINAL_COLORS[:red])
    #
    def color!(id)
      e! "38;5;#{id}m"
    end

    ##
    # Sets the current background color to a number
    #
    # @example set background color to red
    #   t = Rcalc::Terminal.new
    #   t.bgcolor!(Rcalc::TERMINAL_COLORS[:red])
    #
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

    ##
    # Sets the current text color to a RGB value
    #
    # @example set text color to red
    #   t = Rcalc::Terminal.new
    #   t.rgb!(255,0,0)
    #
    def rgb!(r, g, b)
      e! "38;2;#{r};#{g};#{b}m"
    end

    ##
    # Sets the current background color to a RGB value
    #
    # @example set background color to red
    #   t = Rcalc::Terminal.new
    #   t.bgrgb!(255,0,0)
    #
    def bgrgb!(r, g, b)
      e! "48;2;#{r};#{g};#{b}m"
    end

    ##
    # Sets cursor position
    #
    # @example set cursor to 10,10
    #   t = Rcalc::Terminal.new
    #   t.goto!(10, 10)
    #
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

    ##
    # Listen for keypresses on the terminal
    #
    # @example
    #   t = Rcalc::Terminal.new
    #   t.listen! do |key|
    #     print key
    #   end
    #
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
