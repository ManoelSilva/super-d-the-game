-----------------------------------------------------------------------------------------
--
-- game-over.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

-- Initialize data lib
local loadsave
loadsave = require( "loadsave" )

local playerConfigDataTable = {}
local soundImage
local soundIcon

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )

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

-- Menu music
local musicTrack = audio.loadStream( "assets/audio/hollywood.mp3" )
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

local function goTryAgain()
  audio.play( selected )
  composer.removeScene( composer.getSceneName( "previous" ) )
  composer.gotoScene( composer.getSceneName( "previous" ) )
end

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  -- Load Font
  local inputText = native.newFont( "Starjedi.ttf" )

  -- Load background
  local background = display.newImageRect( sceneGroup, "assets/img/gameover.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  isSoundOnOrOf()

  soundIcon = display.newImageRect( sceneGroup, soundImage, 70, 70 )
  soundIcon.x = display.contentCenterX - 400
  soundIcon.y = display.contentCenterY - 220

  soundIcon:addEventListener( "tap", setSoundOnOrOff )

  -- Load Try Again text
  local tryAgainText = "Try Again"
  local tryAgainTextEntity = display.newText( sceneGroup, tryAgainText, display.contentCenterX, display.contentHeight - 425, inputText, 40 )
  tryAgainTextEntity:setFillColor( 255, 255, 0 )

  -- Load Main Menu text
  local mainMenuText = "Menu"
  local mainMenuTextEntity = display.newText( sceneGroup, mainMenuText, display.contentCenterX, display.contentHeight - 350, inputText, 40 )
  mainMenuTextEntity:setFillColor( 255, 255, 0 )

  local tryAgainButton = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight - 420, 200, 10 )
  tryAgainButton.strokeWidth = 30
  --tryAgainButton:setFillColor( 1, 0 )
  tryAgainButton:setFillColor( 0,0,0,0 )
  --tryAgainButton:setStrokeColor( 1, 0, 0 )
  tryAgainButton:setStrokeColor( 0, 0, 0, 0 )
  tryAgainButton.myName = "TryAgainButton"

  tryAgainButton:addEventListener( "tap", goTryAgain )
  tryAgainButton.isHitTestable = true

  local mainMenuButton = display.newRect( sceneGroup, display.contentCenterX - 2, display.contentHeight - 350, 200, 20 )
  mainMenuButton.strokeWidth = 30
  --mainMenuButton:setFillColor( 1, 0 )
  mainMenuButton:setFillColor( 0,0,0,0 )
  --mainMenuButton:setStrokeColor( 1, 0, 0 )
  mainMenuButton:setStrokeColor( 0, 0, 0, 0 )

  mainMenuButton:addEventListener( "tap", goBacktoMenu )
  mainMenuButton.isHitTestable = true
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    display.remove( soundIcon )
    isSoundOnOrOf()

    soundIcon = display.newImageRect( sceneGroup, soundImage, 70, 70 )
    soundIcon.x = display.contentCenterX - 400
    soundIcon.y = display.contentCenterY - 220
    soundIcon:addEventListener( "tap", setSoundOnOrOff )

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    -- Play music
    audio.play( musicTrack, { channel=1, loops=-1 } )
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
    display.remove( soundIcon )
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
