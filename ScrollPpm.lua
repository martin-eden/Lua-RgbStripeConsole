-- Open pixmap and scroll it horizontally, sending slices to LED stripe

-- Last mod.: 2024-11-11

--[[
  We're expecting that row below is smooth-shifted version of current
  row. So order of start coordinates for slice is determined by

    for X = 1, Width
      for Y = 1, Height
]]

-- Config:
local Config =
  {
    NumCycles = tonumber(arg[1]) or math.huge,
    InputFileName = arg[2] or 'ScrollMe.ppm',

    StripeLength = 60,

    -- 55 ms is near hard limit
    Delay_ms = 57,

    DeviceName = '/dev/ttyUSB0',
    ConnectionSpeed = 115200,
  }

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local PpmCodec = request('!.concepts.Ppm.Interface')
local InputFile = request('!.concepts.StreamIo.Input.File')
local StripeWriter = request('StripeWriter.Interface')
local StringOutput = request('!.concepts.StreamIo.Output.String')
local StringInput = request('!.concepts.StreamIo.Input.String')
local Device = request('!.concepts.StreamIo.Teletype.Interface')
local IntessParser = request('!.concepts.Itness.Parser.Interface')
local Sender = request('Whistles.Interface')

local DisplayChunk =
  function(Chunk)
    StringOutput:Flush()

    local SetPixelsArg =
      {
        StartIndex = 0,
        StopIndex = #Chunk - 1,
        Colors = Chunk,
      }

    StripeWriter:SetPixels(SetPixelsArg)
    StripeWriter:Display()
    StripeWriter:MakeDelay_Ms(Config.Delay_ms)

    local CommandsIs = StringOutput:GetString()

    -- print(CommandsIs)

    StringInput:Init(CommandsIs)

    IntessParser.Input = StringInput
    local ItemsIs = IntessParser:Run()

    Sender.Output = Device
    Sender:SendItem(ItemsIs)
  end

local Image

do
  InputFile:Open(Config.InputFileName)

  PpmCodec.Input = InputFile
  Image = PpmCodec:Load()

  InputFile:Close()
end

if not Image then
  print('Image loading failed.')
  return
end

--[[
  Get chunk from circular array

  We have Concepts.List:GetChunk() but it does not support wrap-around.
]]
local GetChunk =
  function(Row, StartPos, ChunkLen)
    local Result = {}

    local Column = StartPos
    local StepsDone = 0

    while (StepsDone < ChunkLen) do
      local Pixel = Row[Column]

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
  StripeWriter.Output = StringOutput

  Device:Open(Config.DeviceName, Config.ConnectionSpeed)

  for Iteration = 1, Config.NumCycles do
    for X = 1, Image.Width do
      for Y = 1, Image.Height do
        local Line = Image.Pixels[Y]
        local Chunk = GetChunk(Line, X, Config.StripeLength)
        DisplayChunk(Chunk)
      end
    end
  end

  Device:Close()
end

--[[
  2024-11-06
  2024-11-07
  2024-11-11
]]
