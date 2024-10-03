-- Display() wrapper that sends cached pixels as strides

local GetListChunk = request('!.concepts.List.GetChunk')

return
  function(self)
    -- Let's get a list of strides in set of cached pixels
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

    -- Okay, now <Strides> contains {Start: int, Length: int} records
    for Index, Stride in ipairs(Strides) do
      -- Meh, just single pixel
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
        self.StripeWriter:Display()
      end
    end

    -- Flush our cache
    self.Pixels = {}
    self.MinIndex = 0
    self.MaxIndex = 0
  end

--[[
  2024-09-30
  2024-10-03
]]
