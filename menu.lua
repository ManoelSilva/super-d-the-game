-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

-- Menu music
local musicTrack = audio.loadSound( "assets/audio/hollywood.mp3" )
-- Select option sound effect
local selected = audio.loadSound( "assets/audio/menuClick.mp3" )

local function gotoMouthTutorialPhase()
  print("tapped mouthTutorial phase button")
  audio.play( selected )
  composer.gotoScene( "mouth-tutorial", { time=800, effect="crossFade" } )
end

local function gotoPhases()
  print("tapped phases button")
  audio.play( selected )
  --composer.gotoScene( "phases" )
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

  local phasesOption = display.newRect( sceneGroup, display.contentCenterX+15, display.contentCenterY+74, 260, 10 )
  phasesOption.strokeWidth = 30
  --phasesOption:setFillColor( 1, 0 )
  phasesOption:setFillColor( 0, 0, 0, 0 )
  --phasesOption:setStrokeColor( 1, 0, 0 )
  phasesOption:setStrokeColor( 0, 0, 0, 0 )
  -- Make ShapeObject squeezable even if invisible
  phasesOption.isHitTestable = true
  phasesOption.myName = "phases"

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

  newGameOption:addEventListener( "touch", gotoMouthTutorialPhase )
  phasesOption:addEventListener( "touch", gotoPhases )
  creditsOption:addEventListener( "touch", gotoCredits )
  exitOption:addEventListener( "touch", exitGame )
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
    audio.play( musicTrack )
  end
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    audio.stop()

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