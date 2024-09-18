-- Write list of lines to output

return
  function(self, Lines, Output)
    assert_table(Lines)

    print(string.format('( Sending %d lines.', #Lines))

    for Index, Line in ipairs(Lines) do
      self:SendLine(Line, Output)
    end

    print(string.format(') Sent %d lines.', #Lines))
  end
