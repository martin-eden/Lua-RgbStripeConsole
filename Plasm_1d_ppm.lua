-- Generate 1-d gradient filling and write it to pixmap

-- Last mod.: 2024-11-11

-- Config:
local Config =
  {
    ImageWidth = 60,
    ImageHeight = 12,
    OutputFileName = 'Plasm_1d.ppm',
  }

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local PpmCodec = request('!.concepts.Ppm.Interface')
local OutputFile = request('!.concepts.StreamIo.Output.File')
local PlasmGenerator = request('LinearPlasmGenerator.Interface')

-- Table must conform to custom format of PPM codec
local Image =
  {
    Width = Config.ImageWidth,
    Height = Config.ImageHeight,
    Pixels = nil,
  }

local InitImage =
  function(Image)
    Image.Pixels = {}
    for Row = 1, Image.Height do
      Image.Pixels[Row] = {}
      for Column = 1, Image.Width do
        local InitialPixel = { Red = 0, Green = 0, Blue = 0 }
        Image.Pixels[Row][Column] = InitialPixel
      end
    end
  end

InitImage(Image)

-- Overriding pixel setting to set whole row to that color
local SetPixel =
  function(Pixel)
    local X = Pixel.Index + 1
    local Red = Pixel.Color.Red
    local Green = Pixel.Color.Green
    local Blue = Pixel.Color.Blue

    for Row = 1, Config.ImageHeight do
      local Pixel = Image.Pixels[Row][X]
      Pixel.Red = Red
      Pixel.Green = Green
      Pixel.Blue = Blue
    end
  end

local TransformDistance =
  function(Distance)
    -- return Distance ^ 0.7
    -- return (1 - (1 - Distance) ^ 2) ^ 0.5
    -- [[
    local Angle_Deg = Distance * 180 - 90
    local Angle_Rad = math.rad(Angle_Deg)
    return (math.sin(Angle_Rad) + 1) / 2
    --]]
  end

PlasmGenerator.SetPixel = SetPixel
PlasmGenerator.TransformDistance = TransformDistance

local Brightness = 0.3

PlasmGenerator.MaxColorComponentValue = math.floor(Brightness * 255)
PlasmGenerator.Scale = 180.0 / Config.ImageWidth

PlasmGenerator.OnCircle = true

PlasmGenerator:Run(0, Config.ImageWidth - 1)

OutputFile:Open(Config.OutputFileName)

PpmCodec.Output = OutputFile
PpmCodec:Save(Image)

OutputFile:Close()

--[[
  2024-11-06
]]
