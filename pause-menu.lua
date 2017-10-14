-----------------------------------------------------------------------------------------
--
-- pause-menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=1 } )

-- Menu music
local musicTrack = audio.loadStream( "assets/audio/hollywood.mp3" )
-- Select option sound effect
local selected = audio.loadSound( "assets/audio/menuClick.mp3" )

local function goBacktoMenu()
  audio.play( selected )
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function goResumeGame()
  audio.play( selected )
  composer.hideOverlay( "fade", 100 )
end

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  -- Load Font
  local inputText = native.newFont( "Starjedi.ttf" )

  -- Load background
  local background = display.newImageRect( sceneGroup, "assets/img/pause.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load Try Again text
  local resumeText = "Resume"
  local resumeTextEntity = display.newText( sceneGroup, resumeText, display.contentCenterX, display.contentHeight - 425, inputText, 40 )
  resumeTextEntity:setFillColor( 255, 255, 0 )

  -- Load Main Menu text
  local mainMenuText = "Menu"
  local mainMenuTextEntity = display.newText( sceneGroup, mainMenuText, display.contentCenterX, display.contentHeight - 350, inputText, 40 )
  mainMenuTextEntity:setFillColor( 255, 255, 0 )

  local resumeButton = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight - 420, 200, 10 )
  resumeButton.strokeWidth = 30
  --resumeButton:setFillColor( 1, 0 )
  resumeButton:setFillColor( 0,0,0,0 )
  --resumeButton:setStrokeColor( 1, 0, 0 )
  resumeButton:setStrokeColor( 0, 0, 0, 0 )
  resumeButton.myName = "TryAgainButton"

  resumeButton:addEventListener( "tap", goResumeGame )
  resumeButton.isHitTestable = true

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
  parent:resumeGame()
  
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
