-- Send "Stripe commands.is" contents to UART

-- Last mod.: 2024-11-11

local Config =
  {
    DataFileName = arg[1] or 'Stripe commands.is',
    PortName = arg[2] or '/dev/ttyUSB0',
    PortSpeed = tonumber(arg[3]) or 115200,
  }

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local Teletype = request('!.concepts.StreamIo.Teletype.Interface')
local Whistles = request('Whistles.Interface')

-- Open UART
Teletype:Open(Config.PortName, Config.PortSpeed)

-- Attach whistles
Whistles.Input = Teletype
Whistles.Output = Teletype

-- Read and echo initial greeting
Whistles:ReadLines(Teletype)

-- Send items
Whistles:SendFile(Config.DataFileName, Teletype)

Teletype:Close()

--[[
  2024-09-18
  2024-10-24
  2024-11-11
]]
