-- Open pixmap and scroll it horizontally, sending slices to LED stripe

-- Last mod.: 2024-11-07

-- Config:
local Config =
  {
    InputFileName = 'Plasm_1d.ppm',
    NumCycles = math.huge,
    StripeLength = 60,

    NumTransitionsBetweenPixels = 5,
    -- 55 ms is near hard limit
    Delay_ms = 55,

    DeviceName = '/dev/ttyUSB0',
    ConnectionSpeed = 115200,
  }

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local PpmCodec = request('!.concepts.Ppm.Interface')
local InputFile = request('!.concepts.StreamIo.Input.File')
local PlasmGenerator = request('LinearPlasmGenerator.Interface')
local StripeWriter = request('StripeWriter.Interface')
local StringOutput = request('!.concepts.StreamIo.Output.String')
local StringInput = request('!.concepts.StreamIo.Input.String')
local Device = request('Teletype.Interface')
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

    Sender:SendItem(ItemsIs, Device)
  end

local Image

do
  InputFile:OpenFile(Config.InputFileName)

  PpmCodec.Input = InputFile
  Image = PpmCodec:Load()

  InputFile:CloseFile()
end

if not Image then
  print('Image loading failed.')
  return
end

local MeldValues =
  function(Value_A, Value_B, Part_A)
    return math.floor(Part_A * Value_A + (1 - Part_A) * Value_B)
  end

local MeldPixels =
  function(PixelA, PixelB, PartA)
    return
      {
        Red = MeldValues(PixelA.Red, PixelB.Red, PartA),
        Green = MeldValues(PixelA.Green, PixelB.Green, PartA),
        Blue = MeldValues(PixelA.Blue, PixelB.Blue, PartA),
      }
  end

local SamplePixel =
  function(X, Row)
    local IntPart = math.floor(X)
    local FracPart = X % 1

    local LeftPixel = Row[IntPart]

    local RightPixelIndex

    if (IntPart == #Row) then
      RightPixelIndex = 1
    else
      RightPixelIndex = IntPart + 1
    end

    local RightPixel = Row[RightPixelIndex]

    local LeftPart = 1 - FracPart

    return MeldPixels(LeftPixel, RightPixel, LeftPart)
  end

local GetChunk =
  function(Image, StartPos, ChunkLen)
    local Result = {}

    local SamplingRow = Image.Pixels[(Image.Height // 2) + 1]

    local Column = StartPos
    local StepsDone = 0
    while (StepsDone < ChunkLen) do
      local Pixel = SamplePixel(Column, SamplingRow)

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
    for StartPos = 1, Image.Width do

      local Chunk = GetChunk(Image, StartPos, Config.StripeLength)
      DisplayChunk(Chunk)

      for Transition = 1, Config.NumTransitionsBetweenPixels do
        local FractionalOffset = Transition / (Config.NumTransitionsBetweenPixels + 1)
        local Position = StartPos + FractionalOffset
        local Chunk = GetChunk(Image, Position, Config.StripeLength)
        DisplayChunk(Chunk)
      end
    end
  end

  Device:Close()
end

--[[
  2024-11-06
  2024-11-07
]]
