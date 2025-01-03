-- Compile named Lua table to anonymous structure (list of strings/lists)

-- Last mod.: 2024-12-12

-- Exports:
return
  {
    -- Main: Convert table with .ppm to anonymous tree
    Run = request('Run'),

    -- [Config]

    -- Color component serialization format
    ColorComponentFmt = '%03d',

    -- [Internal]

    -- Format constants
    Constants = request('^.Constants.Interface'),

    -- Compile image data
    CompileImage = request('CompileImage'),

    -- Compile color
    CompileColor = request('CompileColor'),

    -- Serialize color component
    CompileColorComponent = request('CompileColorComponent'),
  }

--[[
  2024-11-03
  2024-11-04
  2024-11-06
  2024-11-25
  2024-12-12
]]
