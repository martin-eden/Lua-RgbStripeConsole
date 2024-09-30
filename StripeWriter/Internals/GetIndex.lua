-- Return given argument if it may be used as index or explode

local IsWord = request('!.number.is_word')

return
  function(Value)
    assert(IsWord(Value))

    return Value
  end
