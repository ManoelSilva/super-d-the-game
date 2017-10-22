-----------------------------------------------------------------------------------------
--
-- menu.lua
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

local function gotoMouthTutorialLevel()
  print("tapped mouthTutorial level button")
  audio.play( selected )
  composer.gotoScene( "mouth-tutorial", { time=800, effect="crossFade" } )
end

local function gotoLevels()
  audio.play( selected )
  composer.gotoScene( "levels" )
end

local function gotoCredits()
  print("tapped credits button")
  audio.play( selected )
  --composer.gotoScene( "credits" )
end

local function exitGame()
  print("tapped exit button")
  audio.play( selected )
  timer.performWithDelay( 1000,
    function()
      if( system.getInfo("platformName")=="Android" ) then
        native.requestExit()
      else
        os.exit()
      end
    end )
end

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  -- Load background
  local background = display.newImageRect( sceneGroup, "assets/img/menu.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load menu buttons
  local newGameOption = display.newRect( sceneGroup, display.contentCenterX+20, display.contentCenterY+15, 355, 10 )
  newGameOption.strokeWidth = 30
  --newGameOption:setFillColor( 1, 0 )
  newGameOption:setFillColor( 0,0,0,0 )
  --newGameOption:setStrokeColor( 1, 0, 0 )
  newGameOption:setStrokeColor( 0, 0, 0, 0 )
  newGameOption.isHitTestable = true
  newGameOption.myName = "newGame"

  local levelsOption = display.newRect( sceneGroup, display.contentCenterX+15, display.contentCenterY+74, 260, 10 )
  levelsOption.strokeWidth = 30
  --levelsOption:setFillColor( 1, 0 )
  levelsOption:setFillColor( 0, 0, 0, 0 )
  --levelsOption:setStrokeColor( 1, 0, 0 )
  levelsOption:setStrokeColor( 0, 0, 0, 0 )
  -- Make ShapeObject squeezable even if invisible
  levelsOption.isHitTestable = true
  levelsOption.myName = "levels"

  local creditsOption = display.newRect( sceneGroup, display.contentCenterX+10, display.contentCenterY+130, 270, 10 )
  creditsOption.strokeWidth = 30
  --creditsOption:setFillColor( 1, 0 )
  creditsOption:setFillColor( 0,0,0,0 )
  --creditsOption:setStrokeColor( 1, 0, 0 )
  creditsOption:setStrokeColor( 0, 0, 0, 0 )
  creditsOption.isHitTestable = true
  creditsOption.myName = "credits"

  local exitOption = display.newRect( sceneGroup, display.contentCenterX+9, display.contentCenterY+193, 140, 10 )
  exitOption.strokeWidth = 30
  --exitOption:setFillColor( 1, 0 )
  exitOption:setFillColor( 0,0,0,0 )
  --exitOption:setStrokeColor( 1, 0, 0 )
  exitOption:setStrokeColor( 0, 0, 0, 0 )
  exitOption.isHitTestable = true
  exitOption.myName = "exit"

  newGameOption:addEventListener( "tap", gotoMouthTutorialLevel )
  levelsOption:addEventListener( "tap", gotoLevels )
  creditsOption:addEventListener( "tap", gotoCredits )
  exitOption:addEventListener( "tap", exitGame )
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
