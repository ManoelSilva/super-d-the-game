--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:71cb991b49aae015a6e9bcb3c67e5169:5c017f47dc1625457b5e93ffcf4387e9:4c700f6557a664a4a9544b5e11d377e8$
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
            -- n-T-dead-counter-icon
            x=1,
            y=1,
            width=543,
            height=637,

        },
        {
            -- n-T-right
            x=546,
            y=1,
            width=488,
            height=461,

        },
        {
            -- superDisease-empty-life
            x=1,
            y=640,
            width=224,
            height=201,

        },
        {
            -- superDisease-full-life
            x=227,
            y=640,
            width=224,
            height=201,

        },
        {
            -- superDisease-one-quarter-life
            x=453,
            y=640,
            width=224,
            height=201,

        },
        {
            -- superDisease-three-quarters-life
            x=679,
            y=464,
            width=224,
            height=201,

        },
        {
            -- superDisease-two-quarters-life
            x=679,
            y=667,
            width=224,
            height=201,

        },
    },
    
    sheetContentWidth = 1035,
    sheetContentHeight = 869
}

SheetInfo.frameIndex =
{

    ["n-T-dead-counter-icon"] = 1,
    ["n-T-right"] = 2,
    ["superDisease-empty-life"] = 3,
    ["superDisease-full-life"] = 4,
    ["superDisease-one-quarter-life"] = 5,
    ["superDisease-three-quarters-life"] = 6,
    ["superDisease-two-quarters-life"] = 7,
}

function SheetInfo:getSheet()
    return SheetInfo.sheet;
end

function SheetInfo:getFrameIndex(name)
    return SheetInfo.frameIndex[name];
end

return SheetInfo
