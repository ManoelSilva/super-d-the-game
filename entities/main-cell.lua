local MainCell = {}
local mainCellSprite
local spritesheetMainCell = require("spritesheet.spritesheet-main-cell")
local mainCellObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-main-cell.png", spritesheetMainCell.getSheet )

local sequencesRunMainCell =
{
  { name = "static", frames = {4} },
  { name = "takingDamageRight", frames = {3} },
  { name = "takingDamageLeft", frames = {2} },
  { name = "dominated", frames = {1} }
}

function MainCell:getMainCell( xScreen, yScreen )
  mainCellSprite = display.newSprite( mainCellObjectSheet, sequencesRunMainCell )
  mainCellSprite.x = xScreen
  mainCellSprite.y = yScreen
  mainCellSprite.myName = "mainCell"

  return mainCellSprite
end

return MainCell