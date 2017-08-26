--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:167bc7606b8bd5ebc48a1995383da659:aeea05787440a10966f4786194af0565:203455747d7cad84f1dd6996362be62b$
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
            -- n-T-left-punching-1
            x=566,
            y=464,
            width=451,
            height=463,

        },
        {
            -- n-T-left-punching-2
            x=975,
            y=1431,
            width=503,
            height=409,

        },
        {
            -- n-T-left-punching-3
            x=1,
            y=1578,
            width=485,
            height=364,

        },
        {
            -- n-T-left-punching-4
            x=1537,
            y=657,
            width=420,
            height=375,

        },
        {
            -- n-T-left-punching-5
            x=1019,
            y=657,
            width=516,
            height=385,

        },
        {
            -- n-T-left-punching-6
            x=1056,
            y=1,
            width=590,
            height=326,

        },
        {
            -- n-T-left
            x=566,
            y=1,
            width=488,
            height=461,

        },
        {
            -- n-T-move-left
            x=1,
            y=1,
            width=563,
            height=555,

        },
        {
            -- n-T-move-right
            x=1,
            y=558,
            width=563,
            height=555,

        },
        {
            -- n-T-right-punching-1
            x=566,
            y=929,
            width=451,
            height=463,

        },
        {
            -- n-T-right-punching-2
            x=1480,
            y=1431,
            width=503,
            height=409,

        },
        {
            -- n-T-right-punching-3
            x=488,
            y=1578,
            width=485,
            height=364,

        },
        {
            -- n-T-right-punching-4
            x=1537,
            y=1034,
            width=420,
            height=375,

        },
        {
            -- n-T-right-punching-5
            x=1019,
            y=1044,
            width=516,
            height=385,

        },
        {
            -- n-T-right-punching-6
            x=1056,
            y=329,
            width=590,
            height=326,

        },
        {
            -- n-T-right
            x=1,
            y=1115,
            width=488,
            height=461,

        },
    },
    
    sheetContentWidth = 1984,
    sheetContentHeight = 1943
}

SheetInfo.frameIndex =
{

    ["n-T-left-punching-1"] = 1,
    ["n-T-left-punching-2"] = 2,
    ["n-T-left-punching-3"] = 3,
    ["n-T-left-punching-4"] = 4,
    ["n-T-left-punching-5"] = 5,
    ["n-T-left-punching-6"] = 6,
    ["n-T-left"] = 7,
    ["n-T-move-left"] = 8,
    ["n-T-move-right"] = 9,
    ["n-T-right-punching-1"] = 10,
    ["n-T-right-punching-2"] = 11,
    ["n-T-right-punching-3"] = 12,
    ["n-T-right-punching-4"] = 13,
    ["n-T-right-punching-5"] = 14,
    ["n-T-right-punching-6"] = 15,
    ["n-T-right"] = 16,
}

function SheetInfo:getSheet()
    return SheetInfo.sheet;
end

function SheetInfo:getFrameIndex(name)
    return SheetInfo.frameIndex[name];
end

return SheetInfo
