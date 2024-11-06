-- Open pixmap and scroll it horizontally, sending slices to LED stripe

-- Last mod.: 2024-11-06

-- Config:
local Config =
  {
    InputFileName = 'Plasm_1d.ppm',
    NumCycles = math.huge,
    StripeLength = 60,
    Delay_ms = 500,
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

local GetChunk =
  function(Image, StartPos, ChunkLen)
    local Result = {}

    local SamplingRow = (Image.Height // 2) + 1

    local Column = StartPos
    local StepsDone = 0
    while (StepsDone < ChunkLen) do
      local Pixel = Image.Pixels[SamplingRow][Column]

      table.insert(Result, Pixel)

      if (Column == Image.Width) then
        Column = 1
      else
        Column = Column + 1
      end

      StepsDone = StepsDone + 1
    end

    return Result
  end

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

-- Exports:
StripeWriter.Output = StringOutput

Device:Open(Config.DeviceName, Config.ConnectionSpeed)

for Iteration = 1, Config.NumCycles do
  for StartPos = 1, Image.Width do
    local Chunk = GetChunk(Image, StartPos, Config.StripeLength)
    assert(#Chunk == Config.StripeLength)
    DisplayChunk(Chunk)
  end
end

Device:Close()

--[[
  2024-11-06
]]
