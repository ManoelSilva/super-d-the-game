-----------------------------------------------------------------------------------------
--
-- pause-menu.lua
--
-----------------------------------------------------------------------------------------

-- Initialize player data lib
local loadsave
loadsave = require( "loadsave" )

local composer = require( "composer" )
local playerConfigDataTable = {}

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

-- Load Font
local inputText = native.newFont( "Starjedi.ttf" )

-- Menu music
local soundTextEntity
-- Select option sound effect
local selected = audio.loadSound( "assets/audio/menuClick.mp3" )

local isResume = true
local starOne
local starTwo
local starThree

local function goBacktoMenu()
  audio.play( selected )
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function goResumeGame()
  audio.play( selected )
  composer.hideOverlay( "fade", 100 )
end

local function goTryAgain()
  audio.play( selected )
  isResume = false
  composer.gotoScene( "try-again" )
end

local function isSoundOnOrOf()
  local soundText

  print( "loading data" )
  playerConfigDataTable = loadsave.loadTable( "playerConfig.json" )

  if( playerConfigDataTable ~= nil ) then
    if( playerConfigDataTable.isSoundOn ) then
      soundText = "Sound: on"
    else
      soundText = "Sound: off"
    end
  else
    soundText = "Sound: on"
  end

  return soundText
end

local function setSoundOnOrOff()
  print("loading data")
  playerConfigDataTable = loadsave.loadTable( "playerConfig.json" )

  if( playerConfigDataTable ~= nil ) then
    if( playerConfigDataTable.isSoundOn == true ) then
      playerConfigDataTable.isSoundOn = false
      audio.setVolume( 0.0, { channel=0 } )

      display.remove( soundTextEntity )
      local soundText = "Sound: off"
      soundTextEntity = display.newText( soundText, display.contentCenterX, display.contentHeight - 275, inputText, 40 )
      soundTextEntity:setFillColor( 255, 255, 0 )
    else
      playerConfigDataTable.isSoundOn = true
      audio.setVolume( 1, { channel=0 } )
      audio.setVolume( 0.5, { channel=1 } )

      display.remove( soundTextEntity )
      local soundText = "Sound: on"
      soundTextEntity = display.newText( soundText, display.contentCenterX, display.contentHeight - 275, inputText, 40 )
      soundTextEntity:setFillColor( 255, 255, 0 )
    end

    loadsave.saveTable( playerConfigDataTable, "playerConfig.json" )
  else
    playerConfigDataTable = {}
    playerConfigDataTable.isSoundOn = false
    audio.setVolume( 0.0, { channel=0 } )

    display.remove( soundTextEntity )
    local soundText = "Sound: off"
    soundTextEntity = display.newText( soundText, display.contentCenterX, display.contentHeight - 275, inputText, 40 )
    soundTextEntity:setFillColor( 255, 255, 0 )

    loadsave.saveTable( playerConfigDataTable, "playerConfig.json" )
  end
end

local function checkPlayerStars( stars )
  if( stars < 12 and stars >= 8 ) then
    starTwo.alpha = 0.4
  elseif( stars < 8) then
    starTwo.alpha = 0.4
    starOne.alpha = 0.4
  end  
end

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  -- Load background
  local background = display.newImageRect( sceneGroup, "assets/img/pause.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load Current Stars text
  local currentStarsText = "Current Stars"
  local currentStarsTextEntity = display.newText( sceneGroup, currentStarsText, display.contentCenterX, display.contentHeight - 545, inputText, 40 )
  currentStarsTextEntity:setFillColor( 255, 255, 0 )

  starOne = display.newImageRect( sceneGroup, "assets/img/star.png", 30, 30 )
  starOne.x = display.contentCenterX
  starOne.y = display.contentHeight - 500

  starTwo = display.newImageRect( sceneGroup, "assets/img/star.png", 30, 30 )
  starTwo.x = display.contentCenterX + 40
  starTwo.y = display.contentHeight - 500

  starThree = display.newImageRect( sceneGroup, "assets/img/star.png", 30, 30 )
  starThree.x = display.contentCenterX - 40
  starThree.y = display.contentHeight - 500
  
  -- Load Resume text
  local resumeText = "Resume"
  local resumeTextEntity = display.newText( sceneGroup, resumeText, display.contentCenterX, display.contentHeight - 205, inputText, 40 )
  resumeTextEntity:setFillColor( 255, 255, 0 )

  -- Load Main Menu text
  local mainMenuText = "Menu"
  local mainMenuTextEntity = display.newText( sceneGroup, mainMenuText, display.contentCenterX, display.contentHeight - 425, inputText, 40 )
  mainMenuTextEntity:setFillColor( 255, 255, 0 )

  -- Load Try Again text
  local tryAgainText = "Try Again"
  local tryAgainTextEntity = display.newText( sceneGroup, tryAgainText, display.contentCenterX, display.contentHeight - 350, inputText, 40 )
  tryAgainTextEntity:setFillColor( 255, 255, 0 )

  local tryAgainButton = display.newRect( sceneGroup, display.contentCenterX - 2, display.contentHeight - 350, 200, 20 )
  tryAgainButton.strokeWidth = 30
  --tryAgainButton:setFillColor( 1, 0 )
  tryAgainButton:setFillColor( 0,0,0,0 )
  --tryAgainButton:setStrokeColor( 1, 0, 0 )
  tryAgainButton:setStrokeColor( 0, 0, 0, 0 )

  tryAgainButton:addEventListener( "tap", goTryAgain )
  tryAgainButton.isHitTestable = true

  local resumeButton = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight - 205, 200, 10 )
  resumeButton.strokeWidth = 30
  --resumeButton:setFillColor( 1, 0 )
  resumeButton:setFillColor( 0,0,0,0 )
  --resumeButton:setStrokeColor( 1, 0, 0 )
  resumeButton:setStrokeColor( 0, 0, 0, 0 )

  resumeButton:addEventListener( "tap", goResumeGame )
  resumeButton.isHitTestable = true

  local mainMenuButton = display.newRect( sceneGroup, display.contentCenterX - 2, display.contentHeight - 420, 200, 20 )
  mainMenuButton.strokeWidth = 30
  --mainMenuButton:setFillColor( 1, 0 )
  mainMenuButton:setFillColor( 0,0,0,0 )
  --mainMenuButton:setStrokeColor( 1, 0, 0 )
  mainMenuButton:setStrokeColor( 0, 0, 0, 0 )

  mainMenuButton:addEventListener( "tap", goBacktoMenu )
  mainMenuButton.isHitTestable = true

  -- Load Sound text
  local soundText = isSoundOnOrOf()
  soundTextEntity = display.newText( soundText, display.contentCenterX, display.contentHeight - 275, inputText, 40 )
  soundTextEntity:setFillColor( 255, 255, 0 )

  local soundButton = display.newRect( sceneGroup, display.contentCenterX - 2, display.contentHeight - 275, 210, 20 )
  soundButton.strokeWidth = 30
  --soundButton:setFillColor( 1, 0 )
  soundButton:setFillColor( 0,0,0,0 )
  --soundButton:setStrokeColor( 1, 0, 0 )
  soundButton:setStrokeColor( 0, 0, 0, 0 )

  soundButton:addEventListener( "tap", setSoundOnOrOff )
  soundButton.isHitTestable = true
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Code here runs when the scene is still off screen (but is about to come on screen)
  checkPlayerStars( event.params.currentLifePoints )
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
  local parent = event.parent  --reference to the parent scene object

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    if isResume == true then
      parent:resumeGame()
    end
    display.remove( soundTextEntity )

  elseif ( phase == "did" ) then
  -- Code here runs immediately after the scene goes entirely off screen
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
