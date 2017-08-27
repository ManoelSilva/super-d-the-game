--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7c6428ff691cd022edbf40691379eef6:a0c449a1cd6ebbe3f52d5b2f67c587c3:0a0d5beabe6654e361ed596fe9de3938$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- superDisease-taking-damage-left
            x=1,
            y=1,
            width=426,
            height=498,

        },
        {
            -- superDisease-taking-damage-right
            x=429,
            y=1,
            width=426,
            height=498,

        },
    },
    
    sheetContentWidth = 856,
    sheetContentHeight = 500
}

SheetInfo.frameIndex =
{

    ["superDisease-taking-damage-left"] = 1,
    ["superDisease-taking-damage-right"] = 2,
}

function SheetInfo:getSheet()
    return SheetInfo.sheet;
end

function SheetInfo:getFrameIndex(name)
    return SheetInfo.frameIndex[name];
end

return SheetInfo
