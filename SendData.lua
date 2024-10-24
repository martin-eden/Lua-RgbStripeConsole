-- Send "Stripe commands.is" contents to UART

-- Last mod.: 2024-10-24

-- Config:
local DataFileName = 'Stripe commands.is'
local PortName = '/dev/ttyUSB0'
local PortSpeed = 115200

package.path = package.path .. ';../../?.lua'
require('workshop.base')

-- Imports:
local Teletype = request('Teletype.Interface')
local Whistles = request('Whistles.Interface')

-- Open UART
Teletype:Open(PortName, PortSpeed)

-- Read and echo initial greeting
Whistles:ReadLines(Teletype.FileHandle)

-- Send items
Whistles:SendFile(DataFileName, Teletype)

Teletype:Close()

--[[
  2024-09-18
  2024-10-24
]]
