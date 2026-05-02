# frozen_string_literal: true

module Rcalc
  TERMINAL_TOGGLES = {
    mouse_button: '?1000;1006',
    mouse_event: '?1000;1003;1006',
    focus_event: '?1004',
    alt_buffer: '?1049',
    cursor: '?25'
  }.freeze
end
