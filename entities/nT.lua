local Nt = {}
local nTsprite
local spritesheetNt = require("spritesheet.spritesheet-nT")
local nTobjectSheet = graphics.newImageSheet( "assets/img/spritesheet-nT.png", spritesheetNt.getSheet() )

local sequencesRunNt =
  {
    { name = "static", frames = {7, 16} },
    { name = "movingRight", frames = {9} },
    { name = "movingLeft", frames = {8} },
    { name = "attackRight", start = 10, count = 7, time = 260, loopCount = 1 },
    { name = "attackLeft", start = 1, count = 7, time = 650, loopCount = math.random( 2, 6 ) }
  }

function Nt:getNt( xScale, yScale, xScreen, yScreen )
  nTsprite = display.newSprite( nTobjectSheet, sequencesRunNt )
  nTsprite:scale(xScale, yScale)
  nTsprite.x = xScreen
  nTsprite.y = yScreen
  nTsprite.myName = "nT"

  return nTsprite
end

return Nt
