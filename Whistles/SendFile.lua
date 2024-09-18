-- Print file linewise

local OpenForReading = request('!.file_system.file.OpenForReading')
local CloseFile = request('!.file_system.file.Close')

local PrintFile =
  function(self, FileName, Output)
    local FileHandle = OpenForReading(FileName)

    assert(FileHandle)

    print(string.format('( Sending file "%s".', FileName))

    for Line in FileHandle:lines() do
      self:SendLine(Line, Output)
    end

    print(string.format(') Sent file "%s".', FileName))


    CloseFile(FileHandle)
  end

return PrintFile
