local Boss = {}
local bossSprite
local spritesheetBoss = require("spritesheet.spritesheet-boss")
local bossObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-boss.png", spritesheetBoss.getSheet )

local sequencesRunBoss =
    {
      { name = "static", frames = {10, 21} },
      { name = "takingDamageRight", frames = {22} },
      { name = "takingDamageLeft", frames = {11} },
      { name = "attackRight", start = 12, count = 10, time = 350, loopCount = math.random( 15, 20 ) },
      { name = "attackLeft", start = 1, count = 10, time = 350, loopCount = math.random( 15, 20 ) }
    }

function Boss:getBoss( xScreen, yScreen )
  bossSprite = display.newSprite( bossObjectSheet, sequencesRunBoss )
  bossSprite.x = xScreen
  bossSprite.y = yScreen
  bossSprite.myName = "boss"

  return bossSprite
end

return Boss