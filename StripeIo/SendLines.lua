-- Write list of lines to output

return
  function(self, Lines, Output)
    assert_table(Lines)
    for Index, Line in ipairs(Lines) do
      print(string.format('[%d] Writing [%s].', Index, Line))
      Output:Write(Line)
      Output:Write('\n')
    end
  end
