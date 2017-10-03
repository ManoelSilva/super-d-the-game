-----------------------------------------------------------------------------------------
--
-- levels.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local background
local uiGroup
local backGroup
local backToMenuButton
local mouthSubLevel
local respiratorySystemText
local respiratorySystemTextEntity
local mouthText
local mouthTextEntity
local inputText = native.newFont( "Starjedi.ttf" )
local alpha = 0.8

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

local function gotoMouthSubLevel()
  audio.play( selected )
  composer.gotoScene( "mouth" )
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
  background = display.newImageRect( backGroup, "assets/img/levels.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY
 
  -- Load Respiratory System text
  respiratorySystemText = "Respiratory System"
  respiratorySystemTextEntity = display.newText( uiGroup, respiratorySystemText, display.contentCenterX, display.contentHeight - 550, inputText, 40 )
  respiratorySystemTextEntity:setFillColor( 255, 255, 0 )
  
  -- Load Respiratory System text
  mouthText = "Mouth"
  mouthTextEntity = display.newText( uiGroup, mouthText, display.contentCenterX - 300, display.contentHeight - 290, inputText, 40 )
  mouthTextEntity:setFillColor( 255, 255, 0 )
  
  -- Load Mouth sub-level image
  mouthSubLevel = display.newImageRect( backGroup, "assets/img/mouth-background.jpg", 200, 150 )
  mouthSubLevel.x = display.contentCenterX - 300
  mouthSubLevel.y = display.contentCenterY
  mouthSubLevel:setStrokeColor( 1, 1, 0 )
  mouthSubLevel.strokeWidth = 4
  
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

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    mouthSubLevel:addEventListener( "tap", gotoMouthSubLevel )
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
    mouthSubLevel:removeEventListener( "tap", gotoMouthSubLevel )
    composer.removeScene( "levels" )
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