-----------------------------------------------------------------------------------------
--
-- credits.lua
--
-----------------------------------------------------------------------------------------

-- Initialize player data lib
local loadsave
loadsave = require( "loadsave" )

local playerConfigDataTable = {}
local soundImage
local soundIcon

playerConfigDataTable = loadsave.loadTable( "playerConfig.json" )
if( playerConfigDataTable ~= nil ) then
  if( playerConfigDataTable.isSoundOn ) then
    -- Reduce the overall volume of the channel
    audio.setVolume( 1, { channel=0 } )
    audio.setVolume( 0.5, { channel=1 } )
  else
    audio.setVolume( 0.0, { channel=0 } )
  end
else
  -- Reduce the overall volume of the channel
  audio.setVolume( 0.5, { channel=1 } )
end

local composer = require( "composer" )
local widget = require( "widget" )
local soundButton
local playerDataTable = {}
local background
local uiGroup
local backGroup
local backToMenuButton
local creditsText
local creditsTextEntity
local inputText = native.newFont( "Starjedi.ttf" )
local alpha = 0.8

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

-- Select option sound effect
local selected = audio.loadSound( "assets/audio/menuClick.mp3" )

local function isSoundOnOrOf()
  print( "loading data" )
  playerConfigDataTable = loadsave.loadTable( "playerConfig.json" )

  if( playerConfigDataTable ~= nil ) then
    if( playerConfigDataTable.isSoundOn ) then
      soundImage = "assets/img/sound-on.png"
    else
      soundImage = "assets/img/sound-off.png"
    end
  else
    soundImage = "assets/img/sound-on.png"
  end
end

local function setSoundOnOrOff()
  print("loading data")
  playerConfigDataTable = loadsave.loadTable( "playerConfig.json" )

  if( playerConfigDataTable ~= nil ) then
    if( playerConfigDataTable.isSoundOn == true ) then
      playerConfigDataTable.isSoundOn = false
      audio.setVolume( 0.0, { channel=0 } )

      local soundOff = { type="image", filename="assets/img/sound-off.png" }
      soundIcon.fill = soundOff
      soundIcon.isShowing = "soundOff"
    else
      playerConfigDataTable.isSoundOn = true
      audio.setVolume( 1, { channel=0 } )
      audio.setVolume( 0.5, { channel=1 } )

      local soundOn = { type="image", filename="assets/img/sound-on.png" }
      soundIcon.fill = soundOn
      soundIcon.isShowing = "soundOn"
    end

    loadsave.saveTable( playerConfigDataTable, "playerConfig.json" )
  else
    playerConfigDataTable = {}
    playerConfigDataTable.isSoundOn = false
    audio.setVolume( 0.0, { channel=0 } )

    local soundOff = { type="image", filename="assets/img/sound-off.png" }
    soundIcon.fill = soundOff
    soundIcon.isShowing = "soundOff"

    loadsave.saveTable( playerConfigDataTable, "playerConfig.json" )
  end
end

local function goBacktoMenu()
  audio.play( selected )
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  backGroup = display.newGroup()  -- Display group for the background image
  sceneGroup:insert( backGroup )  -- Insert into the scene's view group
  uiGroup = display.newGroup()    -- Display group for UI objects
  sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

  -- Load background
  background = display.newImageRect( backGroup, "assets/img/credits.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load Credit text
  creditsText = "DEVELOPER:\nManoel Silva\n\nANIMATION/GRAPHICS:\nManoel Silva\n\nMUSIC:\nVintage Culture\n\nENGINE:\nCorona SDK"
  creditsTextEntity = display.newText( uiGroup, creditsText, display.contentCenterX + 30, display.contentHeight - 330, inputText, 40 )
  creditsTextEntity:setFillColor( 255, 255, 0 )

  backToMenuButton = widget.newButton( {
    id = "backToMenuButton",
    width = 100,
    height = 150,
    defaultFile = "assets/img/move-left-button.png",
    overFile = "assets/img/move-left-button-pressed.png",
    left = 10,
    top = 520,
    onEvent = goBacktoMenu
  } )

  backToMenuButton.alpha = alpha
  uiGroup:insert( backToMenuButton )
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    isSoundOnOrOf()

    soundIcon = display.newImageRect( sceneGroup, soundImage, 70, 70 )
    soundIcon.x = display.contentCenterX - 400
    soundIcon.y = display.contentCenterY - 220

    soundIcon:addEventListener( "tap", setSoundOnOrOff )
  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
  
  end
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Code here runs when the scene is on screen (but is about to go off screen)
  
  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    
    composer.removeScene( "credits" )
  end
end

-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene