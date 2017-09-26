local Nucleum = {}
local nucleumSprite
local spritesheetNucleum = require("spritesheet.spritesheet-nucleum")

local nucleumObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-nucleum.png", spritesheetNucleum.getSheet )

local sequenceNucleum =
  {
    { name = "full", frames = {2} },
    { name = "empty", frames = {1} }
  }

function Nucleum:getNucleum( xScreen, yScreen )
  nucleumSprite = display.newSprite( nucleumObjectSheet, sequenceNucleum )
  nucleumSprite.x = display.contentCenterX + xScreen
  nucleumSprite.y = display.contentHeight - yScreen
  nucleumSprite.myName = "nucleum"

  return nucleumSprite
end

return Nucleum
