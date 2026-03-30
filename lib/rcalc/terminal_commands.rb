# frozen_string_literal: true

module Rcalc
  TERMINAL_COMMANDS = {
    home: 'H',

    erase_below: '0J',
    erase_above: '1J',
    erase_all: '2J',
    erase_saved: '3J',

    erase_right: '0K',
    erase_left: '1K',
    erase_line: '2K'
  }.freeze
end
