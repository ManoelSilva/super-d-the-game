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

-- Creates a variable that holds a Composer scene object
local scene = composer.newScene()

-- Load Font
local inputText = native.newFont( "Starjedi.ttf" )

-- Menu music
local musicTrack = audio.loadStream( "assets/audio/hollywood.mp3" )

-- Select option sound effect
local selected = audio.loadSound( "assets/audio/menuClick.mp3" )

local nextLevelText
local nextLevelTextEntity
local nextLevelButton
local nextLevelImage
local nextLevelImagePath
local previousLevelImage
local previousLevelImagePath
local happySuperD
local feedBack
local feedBackText
local feedBackImagePath
local nextLevel
local previousLevel
local starOne
local starTwo
local starThree

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
  local previousScene = composer.getSceneName( "previous" )
  if( previousScene == "mouth-tutorial" ) then
    composer.removeScene( previousScene )
    composer.gotoScene( "mouth" )
  else
    composer.removeScene( previousScene )
    composer.gotoScene( previousScene )
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

local function checkPlayerFeedBack( lifePoints, nucleums )
  feedBackText = "good"
  feedBackImagePath = "assets/img/good.png"

  if( lifePoints == 12 and nucleums == 0 ) then
    feedBackText = "excelent"
    feedBackImagePath = "assets/img/excelent.png"
  elseif( lifePoints == 12 and nucleums ~= 0 ) then
    feedBackText = "very-good"
    feedBackImagePath = "assets/img/very-good.png"
  end
end

local function checkLevelImages()
  local previousScene = composer.getSceneName( "previous" )
  if( previousScene == "mouth" or previousScene == "mouth-tutorial" ) then
    nextLevel = "lung"
    previousLevelImagePath = "assets/img/mouth-background.jpg"
    nextLevelImagePath = "assets/img/lung-background.png"
  elseif( previousScene == "lung" ) then
    nextLevel = "rs-boss"
    previousLevelImagePath = "assets/img/lung-background.png"
    nextLevelImagePath = "assets/img/rs-boss-background.png"
  else
    nextLevel = nil
    previousLevelImagePath = "assets/img/rs-boss-background.png"
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
  nucleum.y = display.contentCenterY

  local hourGlass = display.newImageRect( sceneGroup, "assets/img/hourglass.png", 43, 72 )
  hourGlass.x = display.contentCenterX - 70
  hourGlass.y = display.contentCenterY + 100

  -- Load Nucleums used text
  local nucleumsUsed = tostring( event.params.nucleums )
  local nucleumsUsedText = "x " .. nucleumsUsed
  local nucleumsUsedTextEntity = display.newText( sceneGroup, nucleumsUsedText, display.contentCenterX + 10, display.contentCenterY, inputText, 40 )
  nucleumsUsedTextEntity:setFillColor( 255, 255, 0 )

  local timeToPassLevelText = os.date( "%M:%S",  event.params.timeEnd )
  local timeToPassLevelTextEntity = display.newText( sceneGroup, timeToPassLevelText, display.contentCenterX + 27, display.contentCenterY + 100, inputText, 40 )
  timeToPassLevelTextEntity:setFillColor( 255, 255, 0 )

  -- Load Levels Menu text
  local levelsMenuText = "Levels"
  local levelsMenuTextEntity = display.newText( sceneGroup, levelsMenuText, display.contentCenterX, display.contentCenterY + 220, inputText, 40 )
  levelsMenuTextEntity:setFillColor( 255, 255, 0 )

  -- Load Try Again text
  local tryAgainText = "Try Again"
  local tryAgainTextEntity = display.newText( sceneGroup, tryAgainText, display.contentCenterX - 350, display.contentCenterY + 220, inputText, 40 )
  tryAgainTextEntity:setFillColor( 255, 255, 0 )

  local tryAgainButton = display.newRect( sceneGroup, display.contentCenterX - 350, display.contentCenterY + 220, 220, 20 )
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

    checkPlayerStars( event.params.lifePoints )
    checkPlayerFeedBack( event.params.lifePoints, event.params.nucleums )
    checkLevelImages()

    if( nextLevel ~= nil ) then
      -- Load Next Level text
      nextLevelText = "Next level"
      nextLevelTextEntity = display.newText( sceneGroup, nextLevelText, display.contentCenterX + 350, display.contentCenterY + 220, inputText, 40 )
      nextLevelTextEntity:setFillColor( 255, 255, 0 )

      nextLevelButton = display.newRect( sceneGroup, display.contentCenterX + 350, display.contentCenterY + 220, 250, 20 )
      nextLevelButton.strokeWidth = 30
      --nextLevelButton:setFillColor( 1, 0 )
      nextLevelButton:setFillColor( 0,0,0,0 )
      --nextLevelButton:setStrokeColor( 1, 0, 0 )
      nextLevelButton:setStrokeColor( 0, 0, 0, 0 )

      nextLevelButton:addEventListener( "tap", goToNextLevel )
      nextLevelButton.isHitTestable = true

      -- Load Next Level Image
      nextLevelImage = display.newImageRect( sceneGroup, nextLevelImagePath, 200, 120 )
      nextLevelImage.x = display.contentCenterX + 350
      nextLevelImage.y = display.contentCenterY + 130
      nextLevelImage:setStrokeColor( 1, 1, 0 )
      nextLevelImage.strokeWidth = 4
      nextLevelImage:addEventListener( "tap", goToNextLevel )
    end

    -- Load Previous Level Image
    previousLevelImage = display.newImageRect( sceneGroup, previousLevelImagePath, 200, 120 )
    previousLevelImage.x = display.contentCenterX - 350
    previousLevelImage.y = display.contentCenterY + 130
    previousLevelImage:setStrokeColor( 1, 1, 0 )
    previousLevelImage.strokeWidth = 4
    previousLevelImage:addEventListener( "tap", goTryAgain )

    -- Load Rank Feedback
    if( feedBackText == "good" ) then
      feedBack = display.newImageRect( sceneGroup, feedBackImagePath, 295, 103 )
    elseif( feedBackText == "excelent" ) then
      feedBack = display.newImageRect( sceneGroup, feedBackImagePath, 526, 103 )
      happySuperD = display.newImageRect( sceneGroup, "assets/img/happy-superD.png", 145, 170 )
      happySuperD.x = display.contentCenterX + 340
      happySuperD.y = display.contentCenterY - 80
    else
      feedBack = display.newImageRect( sceneGroup, feedBackImagePath, 591, 103 )
    end
    feedBack.x = display.contentCenterX
    feedBack.y = display.contentCenterY - 230

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
