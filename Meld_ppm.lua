-- Prepare pixmap for smooth scrolling

-- Last mod.: 2024-11-11

--[[
  What is smooth scrolling?

  RGB LED stripe length is one meter. Sixty pixels. So one pixel
  is like 17 millimeters.

  Suppose our pattern is "X..." - one white pixel and three black.
  We're scrolling to right, so next pattern will be "...X", then
  "..X.".

  Jumping 17 mm is noticeable change, especially at slow animation
  speeds.

  But what if we go to sub-pixel scrolling? Suppose white pixel value
  is 9 (and black pixel value is 0). And say we're shifting by
  1/3 pixel each time:

    9 0 0 0
    6 0 0 3
    3 0 0 6
    0 0 0 9
    ...

  A lot better! And in reality it produces surprisingly smooth
  scrolling (at least in my setup).

  Price for this is that we need to send N times more data in given
  time interval. So maximum speed will be N times less.
]]

--[[
  This code opens pixmap file, reads first line and shifts it N times.
  Writing each shift as separate line in result pixmap. Then it saves
  that result pixmap in another file.

  N is named NumTransitionsBetweenPixels.
]]

local Config =
  {
    InputFileName = 'Plasm_1d.ppm',
    OutputFileName = 'ScrollMe.ppm',
    NumTransitionsBetweenPixels = 4,
  }

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local InputFile = request('!.concepts.StreamIo.Input.File')
local OutputFile = request('!.concepts.StreamIo.Output.File')
local PpmCodec = request('!.concepts.Ppm.Interface')
local MixNumbers = request('!.number.mix_numbers')

local MeldValues =
  function(ValueA, ValueB, PartA)
    return math.floor(MixNumbers(ValueA, ValueB, PartA))
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

local MeldRow =
  function(Row, Offset)
    local Result = {}

    for Column = 1, #Row do
      local CurrentPixel = Row[Column]

      local NextColumn
      if (Column == #Row) then
        NextColumn = 1
      else
        NextColumn = Column + 1
      end

      local NextPixel = Row[NextColumn]

      local CurrentPixelPart = (1 - Offset)

      local MeldedPixel = MeldPixels(CurrentPixel, NextPixel, CurrentPixelPart)

      table.insert(Result, MeldedPixel)
    end

    return Result
  end

local MeldImage =
  function(InputImage, NumTransitions)
    local OutputImage = { Pixels = {} }

    local SamplingRow = InputImage.Pixels[1]
    table.insert(OutputImage.Pixels, SamplingRow)

    for Transition = 1, NumTransitions do
      local FractionalOffset = Transition / (NumTransitions + 1)
      local MeldedRow = MeldRow(SamplingRow, FractionalOffset)
      table.insert(OutputImage.Pixels, MeldedRow)
    end

    OutputImage.Width = InputImage.Width
    OutputImage.Height = #OutputImage.Pixels

    return OutputImage
  end

local InputImage
local OutputImage

-- Load input image
do
  InputFile:Open(Config.InputFileName)

  PpmCodec.Input = InputFile
  InputImage = PpmCodec:Load()

  InputFile:Close()

  if not InputImage then
    print('Failed to load image.')
    return
  end
end

do
  OutputImage = MeldImage(InputImage, Config.NumTransitionsBetweenPixels)
  if not OutputImage then
    print('Failed to shear image.')
    return
  end
end

-- Save output image
do
  OutputFile:Open(Config.OutputFileName)

  PpmCodec.Output = OutputFile
  PpmCodec:Save(OutputImage)

  OutputFile:Close()
end

--[[
  2024-11-11
]]
