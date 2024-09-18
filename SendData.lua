-- Send "Data.Stripe" contents to UART

package.path = package.path .. ';../../?.lua'
require('workshop.base')

local Teletype = request('Teletype.Interface')
local Whistles = request('Whistles.Interface')

local PortName = '/dev/ttyUSB0'

Teletype:Open(PortName)

-- Just read and echo initial greeting:
Whistles:ReadLines(Teletype.FileHandle)

local DataFileName = 'Data.Stripe'

Whistles:SendFile(DataFileName, Teletype)

Teletype:Close()
