local SuperD = {}
local superDsprite
local spritesheetSuperD = require("spritesheet.spritesheet-superD")
local spritesheetSuperDdamaged = require("spritesheet.spritesheet-superD-taking-damage")

local superDobjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD.png", spritesheetSuperD.getSheet() )
local superDdamagedObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD-taking-damage.png", spritesheetSuperDdamaged.getSheet() )

local sequencesRunSuperD =
  {
    { name = "static", frames = {7, 16} },
    { name = "movingRight", frames = {9} },
    { name = "movingLeft", frames = {8} },
    { name = "attackRight", start = 10, count = 7, time = 260, loopCount = 1 },
    { name = "attackLeft", start = 1, count = 7, time = 260, loopCount = 1 },
    { name = "superDtakingDamage", sheet = superDdamagedObjectSheet, frames = {2, 1} }
  }

function SuperD:getSuperD( xScale, yScale, xScreen, yScreen )
  superDsprite = display.newSprite( superDobjectSheet, sequencesRunSuperD )
  superDsprite:scale(xScale, yScale)
  superDsprite.x = display.contentCenterX + xScreen
  superDsprite.y = display.contentHeight - yScreen
  superDsprite.myName = "superD"

  return superDsprite
end

return SuperD
