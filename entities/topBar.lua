local TopBar = {}
local topBarSprite
local spritesheetTopBar = require("spritesheet.spritesheet-superD-top-bar")
local topBarObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD-top-bar.png", spritesheetTopBar.getSheet )
local sequencesTopBar =
  {
    { name = "fullLife", frames = {4} },
    { name = "threeQuartersLife", frames = {6} },
    { name = "twoQuartersLife", frames = {7} },
    { name = "oneQuarterLife", frames = {5} },
    { name = "emptyLife", frames = {3} },
    { name = "nTs", frames = {2, 1} }
  }
local alpha = 0.8

function TopBar:getTopBar( xScale, yScale, xScreen, nT )
  topBarSprite = display.newSprite( topBarObjectSheet, sequencesTopBar )
  topBarSprite:scale(xScale, yScale)
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
