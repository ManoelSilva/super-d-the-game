local TopBar = {}
local topBarSprite
local spritesheetTopBar = require("spritesheet.spritesheet-superD-top-bar")
local spritesheetTopBarBossSublevel = require("spritesheet.spritesheet-superD-top-bar-boss-sublevel")

local topBarObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD-top-bar.png", spritesheetTopBar.getSheet )
local topBarBossSublevelObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD-top-bar-boss-sublevel.png", spritesheetTopBarBossSublevel.getSheet )

local sequencesTopBar =
  {
    { name = "fullLife", frames = {4} },
    { name = "threeQuartersLife", frames = {6} },
    { name = "twoQuartersLife", frames = {7} },
    { name = "oneQuarterLife", frames = {5} },
    { name = "emptyLife", frames = {3} },
    { name = "nTs", frames = {2, 1} },
    { name = "bossSubLevelBoss", sheet = topBarBossSublevelObjectSheet, frames = {1} },
    { name = "bossSubLevelMainCell", sheet = topBarBossSublevelObjectSheet, frames = {2} },
    { name = "bossSubLevelMainCellDominated", sheet = topBarBossSublevelObjectSheet, frames = {3} }
  }
local alpha = 0.8

function TopBar:getTopBar( xScale, yScale, xScreen, nT )
  topBarSprite = display.newSprite( topBarObjectSheet, sequencesTopBar )
  
  if(xScale ~= 0 and yScale ~= 0) then
    topBarSprite:scale(xScale, yScale)
  end
  
  if( nT ) then
    topBarSprite.x = display.contentCenterX + xScreen
  else
    topBarSprite.x = display.contentCenterX - xScreen
  end
  topBarSprite.y = display.contentHeight - 640
  topBarSprite.alpha = alpha
  return topBarSprite
end

return TopBar
