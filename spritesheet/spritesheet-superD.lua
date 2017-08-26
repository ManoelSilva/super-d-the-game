--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:43c0246e0777ae865b4dd52eae18385d:1311cc670d56baba4f6a3b6043fc80f9:6e54ed8a7923a8c4b607dc97c08a32ca$
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
            -- superDisease-left-punching-1
            x=1077,
            y=855,
            width=449,
            height=525,

        },
        {
            -- superDisease-left-punching-2
            x=1077,
            y=1382,
            width=397,
            height=500,

        },
        {
            -- superDisease-left-punching-3
            x=1528,
            y=528,
            width=374,
            height=462,

        },
        {
            -- superDisease-left-punching-4
            x=1528,
            y=992,
            width=357,
            height=387,

        },
        {
            -- superDisease-left-punching-5
            x=568,
            y=1,
            width=473,
            height=323,

        },
        {
            -- superDisease-left-punching-6
            x=1,
            y=1121,
            width=536,
            height=375,

        },
        {
            -- superDisease-left
            x=1043,
            y=1,
            width=419,
            height=527,

        },
        {
            -- superDisease-move-left
            x=1,
            y=1,
            width=565,
            height=558,

        },
        {
            -- superDisease-move-right
            x=1,
            y=561,
            width=565,
            height=558,

        },
        {
            -- superDisease-right-punching-1
            x=1464,
            y=1,
            width=449,
            height=525,

        },
        {
            -- superDisease-right-punching-2
            x=1476,
            y=1382,
            width=397,
            height=500,

        },
        {
            -- superDisease-right-punching-3
            x=1,
            y=1498,
            width=374,
            height=462,

        },
        {
            -- superDisease-right-punching-4
            x=377,
            y=1498,
            width=357,
            height=387,

        },
        {
            -- superDisease-right-punching-5
            x=989,
            y=530,
            width=473,
            height=323,

        },
        {
            -- superDisease-right-punching-6
            x=539,
            y=1121,
            width=536,
            height=375,

        },
        {
            -- superDisease-right
            x=568,
            y=326,
            width=419,
            height=527,

        },
    },
    
    sheetContentWidth = 1914,
    sheetContentHeight = 1961
}

SheetInfo.frameIndex =
{

    ["superDisease-left-punching-1"] = 1,
    ["superDisease-left-punching-2"] = 2,
    ["superDisease-left-punching-3"] = 3,
    ["superDisease-left-punching-4"] = 4,
    ["superDisease-left-punching-5"] = 5,
    ["superDisease-left-punching-6"] = 6,
    ["superDisease-left"] = 7,
    ["superDisease-move-left"] = 8,
    ["superDisease-move-right"] = 9,
    ["superDisease-right-punching-1"] = 10,
    ["superDisease-right-punching-2"] = 11,
    ["superDisease-right-punching-3"] = 12,
    ["superDisease-right-punching-4"] = 13,
    ["superDisease-right-punching-5"] = 14,
    ["superDisease-right-punching-6"] = 15,
    ["superDisease-right"] = 16,
}

function SheetInfo:getSheet()
    return SheetInfo.sheet;
end

function SheetInfo:getFrameIndex(name)
    return SheetInfo.frameIndex[name];
end

return SheetInfo
