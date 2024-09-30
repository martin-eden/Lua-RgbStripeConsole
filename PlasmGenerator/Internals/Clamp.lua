-- Clamp value for range [MinValue, MaxValue]

--[[
  Input

    Value: float
    MinValue: float
    MaxValue: float

  Output

    float -- <Value> clamped to range [MinValue, MaxValue]
]]
return
  function(Value, MinValue, MaxValue)
    if (Value < MinValue) then
      return MinValue
    end

    if (Value > MaxValue) then
      return MaxValue
    end

    return Value
  end
