-----------------------------------------------------------------------------------------
--
-- results.lua
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

local nextLevelImage
local nextLevelImagePath
local previousLevelImage
local previousLevelImagePath
local feedBackImagePath = "assets/img/good.png"
local nextLevel
local previousLevel
local starOne
local starTwo
local starThree

local function goToNextLevel()
  audio.play( selected )
  composer.gotoScene( nextLevel, { time=800, effect="crossFade" } )
end

local function goToLevelsMenu()
  audio.play( selected )
  composer.gotoScene( "levels" )
end

local function goTryAgain()
  audio.play( selected )
  composer.removeScene( composer.getSceneName( "previous" ) )
  composer.gotoScene( composer.getSceneName( "previous" ) )
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

local function checkPlayerFeedBack( stars, nucleums )
end

local function checkLevelImages()
  local previousScene = composer.getSceneName( "previous" )
  if( previousScene == "mouth" ) then
    nextLevel = "lung"
    previousLevelImagePath = "assets/img/mouth-background.jpg"
    nextLevelImagePath = "assets/img/lung-background.png"
  elseif( previousScene == "lung" ) then
    nextLevel = "rs-boss"
    previousLevelImagePath = "assets/img/lung-background.png"
    nextLevelImagePath = "assets/img/rs-boss-background.png"
  end
end

-- create()
function scene:create( event )
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  -- Load background
  local background = display.newImageRect( sceneGroup, "assets/img/universe.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load Rank Feedback
  local feedBack = display.newImageRect( sceneGroup, feedBackImagePath, 295, 103 )
  feedBack.x = display.contentCenterX
  feedBack.y = display.contentCenterY - 230


  -- Load Obtained Stars text
  local obtainedStarsText = "Obtained Stars"
  local obtainedStarsTextEntity = display.newText( sceneGroup, obtainedStarsText, display.contentCenterX, display.contentHeight - 500, inputText, 40 )
  obtainedStarsTextEntity:setFillColor( 255, 255, 0 )

  -- Load Stars
  starOne = display.newImageRect( sceneGroup, "assets/img/star.png", 30, 30 )
  starOne.x = display.contentCenterX
  starOne.y = display.contentHeight - 457

  starTwo = display.newImageRect( sceneGroup, "assets/img/star.png", 30, 30 )
  starTwo.x = display.contentCenterX + 40
  starTwo.y = display.contentHeight - 457

  starThree = display.newImageRect( sceneGroup, "assets/img/star.png", 30, 30 )
  starThree.x = display.contentCenterX - 40
  starThree.y = display.contentHeight - 457

  local nucleum = display.newImageRect( sceneGroup, "assets/img/nucleum.png", 62, 72 )
  nucleum.x = display.contentCenterX - 70
  nucleum.y = display.contentCenterY + 20

  local hourGlass = display.newImageRect( sceneGroup, "assets/img/hourglass.png", 43, 72 )
  hourGlass.x = display.contentCenterX - 70
  hourGlass.y = display.contentCenterY + 100

  -- Load Next Level text
  local nextLevelText = "Next level"
  local nextLevelTextEntity = display.newText( sceneGroup, nextLevelText, display.contentCenterX + 350, display.contentCenterY + 50, inputText, 40 )
  nextLevelTextEntity:setFillColor( 255, 255, 0 )

  -- Load Levels Menu text
  local levelsMenuText = "Levels"
  local levelsMenuTextEntity = display.newText( sceneGroup, levelsMenuText, display.contentCenterX, display.contentCenterY + 220, inputText, 40 )
  levelsMenuTextEntity:setFillColor( 255, 255, 0 )

  -- Load Try Again text
  local tryAgainText = "Try Again"
  local tryAgainTextEntity = display.newText( sceneGroup, tryAgainText, display.contentCenterX - 350, display.contentCenterY + 50, inputText, 40 )
  tryAgainTextEntity:setFillColor( 255, 255, 0 )

  local tryAgainButton = display.newRect( sceneGroup, display.contentCenterX - 350, display.contentCenterY + 50, 220, 20 )
  tryAgainButton.strokeWidth = 30
  --tryAgainButton:setFillColor( 1, 0 )
  tryAgainButton:setFillColor( 0,0,0,0 )
  --tryAgainButton:setStrokeColor( 1, 0, 0 )
  tryAgainButton:setStrokeColor( 0, 0, 0, 0 )

  tryAgainButton:addEventListener( "tap", goTryAgain )
  tryAgainButton.isHitTestable = true

  local levelsButton = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + 220, 200, 10 )
  levelsButton.strokeWidth = 30
  --levelsButton:setFillColor( 1, 0 )
  levelsButton:setFillColor( 0,0,0,0 )
  --levelsButton:setStrokeColor( 1, 0, 0 )
  levelsButton:setStrokeColor( 0, 0, 0, 0 )

  levelsButton:addEventListener( "tap", goToLevelsMenu )
  levelsButton.isHitTestable = true

  local nextLevelButton = display.newRect( sceneGroup, display.contentCenterX + 350, display.contentCenterY + 50, 250, 20 )
  nextLevelButton.strokeWidth = 30
  --nextLevelButton:setFillColor( 1, 0 )
  nextLevelButton:setFillColor( 0,0,0,0 )
  --nextLevelButton:setStrokeColor( 1, 0, 0 )
  nextLevelButton:setStrokeColor( 0, 0, 0, 0 )

  nextLevelButton:addEventListener( "tap", goToNextLevel )
  nextLevelButton.isHitTestable = true
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    checkPlayerStars( event.params.lifePoints )
    checkLevelImages()
    print( event.params.time )
  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    -- Play music
    audio.play( musicTrack, { channel=1, loops=-1 } )

    --[[


    local t1 = os.date( '*t' )


    t1.sec  = t1.sec +60


    t1 = os.date( "%H:%M:%S", os.time( t1 ) )


    print(t1)


    --]]
    -- Load Next Level Image
    nextLevelImage = display.newImageRect( sceneGroup, nextLevelImagePath, 200, 120 )
    nextLevelImage.x = display.contentCenterX + 350
    nextLevelImage.y = display.contentCenterY - 60
    nextLevelImage:setStrokeColor( 1, 1, 0 )
    nextLevelImage.strokeWidth = 4

    -- Load Previous Level Image
    previousLevelImage = display.newImageRect( sceneGroup, previousLevelImagePath, 200, 120 )
    previousLevelImage.x = display.contentCenterX - 350
    previousLevelImage.y = display.contentCenterY - 60
    previousLevelImage:setStrokeColor( 1, 1, 0 )
    previousLevelImage.strokeWidth = 4

  end
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase
  local parent = event.parent  --reference to the parent scene object

  if ( phase == "will" ) then
  -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
  -- Code here runs immediately after the scene goes entirely off screen
  composer.removeScene( "results" )
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
