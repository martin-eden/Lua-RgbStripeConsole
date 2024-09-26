-- Send "Data.Stripe" contents to UART

package.path = package.path .. ';../../?.lua'
require('workshop.base')

local Teletype = request('Teletype.Interface')
local Whistles = request('Whistles.Interface')

local PortName = '/dev/ttyUSB0'
local PortSpeed = 115200

Teletype:Open(PortName, 115200)

-- Just read and echo initial greeting:
Whistles:ReadLines(Teletype.FileHandle)

local DataFileName = 'Data.Stripe'

Whistles:SendFile(DataFileName, Teletype)

Teletype:Close()
