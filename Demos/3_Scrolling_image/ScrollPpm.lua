-- Open pixmap and scroll it horizontally, sending slices to LED stripe

-- Last mod.: 2024-12-24

--[[
  We're expecting that row below is smooth-shifted version of current
  row. So order of start coordinates for slice is determined by

    for X = 1, Width
      for Y = 1, Height
]]

-- Config:
local Config =
  {
    InputFileName = arg[1] or 'ScrollMe.ppm',
    DeviceName = arg[2] or '/dev/ttyUSB0',
    -- 55 ms is near hard limit
    Delay_ms = tonumber(arg[3]) or 70,
    NumCycles = tonumber(arg[4]) or math.huge,

    StripeLength = 60,

    ConnectionSpeed = 115200,
  }

package.path = package.path .. ';../../../../?.lua' .. ';../../?.lua'
require('workshop.base')

-- Imports:
local InputFile = request('!.concepts.StreamIo.Input.File')
local PpmCodec = request('!.concepts.Ppm.Interface')
local Device = request('!.concepts.StreamIo.Teletype.Interface')
local StripeWriter = request('StripeWriter.Interface')

local Image

do
  InputFile:Open(Config.InputFileName)

  PpmCodec.Input = InputFile
  Image = PpmCodec:Load()

  InputFile:Close()

  if not Image then
    print('Image loading failed.')
    return
  end

  -- Adding metainfo shortcuts
  Image.Width = #Image[1]
  Image.Height = #Image
end

--[[
  Get chunk from circular array

  We have Concepts.List:GetChunk() but it does not support wrap-around.
]]
local GetChunk =
  function(Line, StartPos, ChunkLen)
    local Result = {}

    local Column = StartPos
    local StepsDone = 0

    while (StepsDone < ChunkLen) do
      local Pixel = Line[Column]

      table.insert(Result, Pixel)

      if (Column >= Image.Width) then
        Column = Column - Image.Width + 1
      else
        Column = Column + 1
      end

      StepsDone = StepsDone + 1
    end

    return Result
  end

do
  Device:Open(Config.DeviceName, Config.ConnectionSpeed)

  StripeWriter.Output = Device

  for Iteration = 1, Config.NumCycles do
    for X = 1, Image.Width do
      for Y = 1, Image.Height do
        local Line = Image[Y]
        local Chunk = GetChunk(Line, X, Config.StripeLength)

        StripeWriter:SetPixels(0, Chunk)
        StripeWriter:Display()
        StripeWriter:Delay_Ms(Config.Delay_ms)
      end
    end
  end

  Device:Close()
end

--[[
  2024-11-06
  2024-11-07
  2024-11-11
  2024-12-24
]]
