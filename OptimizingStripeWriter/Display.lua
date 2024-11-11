-- Display() wrapper that sends cached pixels as strides

-- Last mod.: 2024-10-14

local GetListChunk = request('!.concepts.List.GetChunk')

return
  function(self)
    -- Let's get a list of strides in a set of cached pixels
    local Strides = {}

    local IsInStride = false
    local StrideStart
    local StrideLength

    local CurrentIndex = self.MinIndex

    while (CurrentIndex <= self.MaxIndex) do
      if self.Pixels[CurrentIndex] then
        -- Stride just started. Init counters.
        if not IsInStride then
          IsInStride = true
          StrideStart = CurrentIndex
          StrideLength = 1
        else
          StrideLength = StrideLength + 1
        end
      end

      if
        is_nil(self.Pixels[CurrentIndex]) or
        (CurrentIndex == self.MaxIndex)
      then
        -- Stride just ended. Store it.
        if IsInStride then
          IsInStride = false
          table.insert(
            Strides,
            { Start = StrideStart, Length = StrideLength }
          )
          StrideStart = nil
          StrideLength = nil
        end
      end

      CurrentIndex = CurrentIndex + 1
    end

    -- Connect real stripe writer to our output (1)
    self.StripeWriter.Output = self.Output

    -- Okay, now <Strides> contains {Start: int, Length: int} records
    for Index, Stride in ipairs(Strides) do
      -- Meh, just a single pixel
      if (Stride.Length == 1) then
        self.StripeWriter:SetPixel(
          {
            Index = Stride.Start,
            Color = self.Pixels[Stride.Start],
          }
        )
      else
        local StartIndex = Stride.Start
        local StopIndex = Stride.Start + Stride.Length - 1
        local StrideColors =
          GetListChunk(self.Pixels, StartIndex, StopIndex)

        self.StripeWriter:SetPixels(
          {
            StartIndex = StartIndex,
            StopIndex = StopIndex,
            Colors = StrideColors,
          }
        )
      end
    end

    self.StripeWriter:Display()

    -- Flush our cache
    self.Pixels = {}
    self.MinIndex = 0
    self.MaxIndex = 0
  end

--[[
  [1]: self.StripeWriter.Output = self.Output

    Actually we want to set output for implementer just once,
    when our own self.Output is assigned.

    But this will require attaching metatable on our interface.
    Or adding SetOutput() method and forcing others to use it.

    All three options are either redundant or increase implementation
    complexity or not convenient. We're settled on way (1)
    as a minimal-hassle solution for our case.
]]

--[[
  2024-09-30
  2024-10-03
  2024-10-14
]]
