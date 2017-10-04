-----------------------------------------------------------------------------------------
--
-- levels.lua
--
-----------------------------------------------------------------------------------------

-- Initialize player data lib
local loadsave
loadsave = require( "loadsave" )

local composer = require( "composer" )
local widget = require( "widget" )
local playerDataTable = {}
local background
local uiGroup
local backGroup
local backToMenuButton
local passLevelButton
local mouthSubLevel
local lungSubLevel
local bossSubLevel
local padLock
local padLockTwo
local padLockThree
local respiratorySystemText
local respiratorySystemTextEntity
local mouthText
local mouthTextEntity
local lungText
local lungTextEntity
local bossText
local bossTextEntity
local inputText = native.newFont( "Starjedi.ttf" )
local alpha = 0.8
local alphaToLocked = 0.3

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

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

local function goToLungSubLevel()
  audio.play( selected )
  --composer.gotoScene( "lung" )
end

local function goToBossSubLevel()
  audio.play( selected )
  --composer.gotoScene( "rs-boss" )
end

local function goToNextLevel()
  audio.play( selected )
  --composer.gotoScene( "levels-two" )
end

local function checkPlayerData()
  print( "loading data" )
  playerDataTable = loadsave.loadTable( "playerData.json" )
  if( playerDataTable ~= nil ) then
    if( playerDataTable.isLoungSubLevel == true ) then
      display.remove( padLock )
      lungSubLevel.alpha = 1
      lungSubLevel:addEventListener( "tap", goToLungSubLevel )
    end

    if( playerDataTable.isLungSubLevel == true ) then
      display.remove( padLock )
      lungSubLevel.alpha = 1
      lungSubLevel:addEventListener( "tap", goToLungSubLevel )
    end

    if( playerDataTable.isRsBossSubLevel == true ) then
      display.remove( padLockTwo )
      bossSubLevel.alpha = 1
      bossSubLevel:addEventListener( "tap", goToBossSubLevel )
    end

    if( playerDataTable.isDigestiveLevel == true ) then
      display.remove( padLockThree )
      passLevelButton.alpha = alpha
      passLevelButton:setEnabled( true )
    end
  end
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

  -- Load mouth text
  mouthText = "Mouth"
  mouthTextEntity = display.newText( uiGroup, mouthText, display.contentCenterX - 300, display.contentHeight - 290, inputText, 40 )
  mouthTextEntity:setFillColor( 255, 255, 0 )

  -- Load Mouth sub-level image
  mouthSubLevel = display.newImageRect( backGroup, "assets/img/mouth-background.jpg", 200, 150 )
  mouthSubLevel.x = display.contentCenterX - 300
  mouthSubLevel.y = display.contentCenterY
  mouthSubLevel:setStrokeColor( 1, 1, 0 )
  mouthSubLevel.strokeWidth = 4

  -- Load Lung text
  lungText = "Lung"
  lungTextEntity = display.newText( uiGroup, lungText, display.contentCenterX, display.contentHeight - 290, inputText, 40 )
  lungTextEntity:setFillColor( 255, 255, 0 )

  -- Load Lung sub-level image
  lungSubLevel = display.newImageRect( backGroup, "assets/img/lung-background.jpg", 200, 150 )
  lungSubLevel.x = display.contentCenterX
  lungSubLevel.y = display.contentCenterY
  lungSubLevel:setStrokeColor( 1, 1, 0 )
  lungSubLevel.strokeWidth = 4
  lungSubLevel.alpha = alphaToLocked

  -- Load Boss text
  bossText = "Boss"
  bossTextEntity = display.newText( uiGroup, bossText, display.contentCenterX + 300, display.contentHeight - 290, inputText, 40 )
  bossTextEntity:setFillColor( 255, 255, 0 )

  -- Load Boss sub-level image
  bossSubLevel = display.newImageRect( backGroup, "assets/img/boss-background.JPG", 200, 150 )
  bossSubLevel.x = display.contentCenterX + 300
  bossSubLevel.y = display.contentCenterY
  bossSubLevel:setStrokeColor( 1, 1, 0 )
  bossSubLevel.strokeWidth = 4
  bossSubLevel.alpha = alphaToLocked

  -- Load padlock image
  padLock = display.newImageRect( backGroup, "assets/img/pad-lock.png", 50, 72 )
  padLock.x = display.contentCenterX
  padLock.y = display.contentCenterY

  padLockTwo = display.newImageRect( backGroup, "assets/img/pad-lock.png", 50, 72 )
  padLockTwo.x = display.contentCenterX + 300
  padLockTwo.y = display.contentCenterY

  padLockThree = display.newImageRect( uiGroup, "assets/img/pad-lock.png", 50, 72 )
  padLockThree.x = display.contentCenterX + 436
  padLockThree.y = display.contentCenterY + 200

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

  passLevelButton = widget.newButton( {
    id = "passLevelButton",
    width = 100,
    height = 150,
    defaultFile = "assets/img/move-right-button.png",
    overFile = "assets/img/move-right-button-pressed.png",
    left = 900,
    top = 520,
    onEvent = goToNextLevel
  } )

  backToMenuButton.alpha = alpha
  passLevelButton.alpha = alphaToLocked
  passLevelButton:setEnabled( false )

  uiGroup:insert( backToMenuButton )
  uiGroup:insert( passLevelButton )
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

    checkPlayerData()

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
    if( playerDataTable ~= nil ) then
      if ( playerDataTable.isLoungSubLevel ) then
        lungSubLevel:removeEventListener( "tap", goToLungSubLevel )
      end
    end
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
