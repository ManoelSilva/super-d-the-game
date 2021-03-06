local composer = require( "composer" )

local scene = composer.newScene()

local stillInTutorial = true

function scene:resumeGame()
  physics.start()
  transition.resume( "animationPause" )
  if( stillInTutorial == false ) then
    -- Clock
    timer.resume( timeCounterTimer )
    timer.resume( gameLoopTimer )
    timer.resume( nTsAttackLoopTimer )
    timer.resume( nucleumsFactoryLoopTimer )
  end
end

-- Initialize data lib
local loadsave
loadsave = require( "loadsave" )

local playerConfigDataTable = {}

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

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize physics
local physics
physics = require("physics")
physics.start()

-- Sprite sheet entities
local topBarEntity = require( "entities.topBar" )
local superDentity = require("entities.superD" )
local nTentity = require( "entities.nT" )
local nucleumEntity = require( "entities.nucleum" )

-- Initialize variables
-- Clock
local endTime = 0
local playerDataTable = {}
local passTutorialText = true
local superD
local nucleum
local nucleumTable = {}
local hasNucleumFull = true
local points = 0
local generatedNucleums = 0
local pontuation
local nT
local nTsNumber
local nTsLeft
local nTtable = {}
local lifeOne
local lifeTwo
local lifeThree
local nTsToKill
local nTsKilled
local ground
local widget
local pauseButton
local punchButton
local jumpButton
local moveRightButton
local moveLeftButton
local died = false
local lives = 12
local lifeBarScale = 0.3
local nTsBarScale = 0.1
local alpha = 0.6
--local offsetSuperDParams = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
-- Sound settings
local musicTrack = audio.loadStream( "assets/audio/youCantHide.mp3" )
local moveTrack = audio.loadSound( "assets/audio/moveSound.mp3" )
local jumpTrack = audio.loadSound( "assets/audio/jumpSound.mp3" )
local punchTrack = audio.loadSound( "assets/audio/punchSound.mp3" )
local hitTrack = audio.loadSound( "assets/audio/hitSound.mp3" )
-- Font
local inputText = native.newFont( "Starjedi.ttf" )
-- Set up display groups variables
local backGroup
local mainGroup
local uiGroup

local function pauseMenu()
  -- Pause game
  physics.pause()
  transition.pause("animationPause")

  if( stillInTutorial == false ) then
    -- Clock
    timer.pause( timeCounterTimer )
    timer.pause( gameLoopTimer )
    timer.pause( nTsAttackLoopTimer )
    timer.pause( nucleumsFactoryLoopTimer )
  end

  local options = {
    isModal = true,
    effect = "fade",
    time = 100,
    params = { currentLifePoints = lives }
  }
  composer.showOverlay( "pause-menu", options )
end

local function punch()
  audio.play( punchTrack )
  if (  ( superD.sequence == "static" and superD.frame == 2 ) or
    superD.sequence == "movingRight" or superD.sequence == "attackRight" ) then
    superD:setSequence( "attackRight" )  -- switch to "attackRight" sequence
    superD:play()  -- play the new sequence
  else
    superD:setSequence( "attackLeft" )  -- switch to "attackLeft" sequence
    superD:play()  -- play the new sequence
  end
end

local function keepSuperDatScreen()
  if( died == false ) then
    if superD.x > display.contentWidth then
      superD.x = display.contentWidth - 10
    elseif superD.x < 0 then
      superD.x = 0
    end
  end
end

local function moveRight( event )
  if ( "began" == event.phase ) then
    audio.play( moveTrack )
    superD:setSequence( "movingRight" )
    superD:setFrame(1)
    -- start moving SuperD
    superD:applyLinearImpulse( 0.8, 0, superD.x, superD.y )
  elseif ( "ended" == event.phase ) then
    keepSuperDatScreen()
    superD:setSequence( "static" )
    superD:setFrame(2)
    -- stop moving SuperD
    superD:setLinearVelocity( 0,0 )
  end
end

local function moveLeft( event )
  if ( "began" == event.phase ) then
    audio.play( moveTrack )
    superD:setSequence( "movingLeft" )
    superD:setFrame(1)
    superD:applyLinearImpulse( -0.8, 0, superD.x, superD.y )
  elseif ( "ended" == event.phase ) then
    keepSuperDatScreen()
    superD:setSequence( "static" )
    superD:setFrame(1)
    superD:setLinearVelocity( 0,0 )
  end
end

local function jump()
  audio.play( jumpTrack )
  superD:applyLinearImpulse( 0, 6, superD.x, superD.y )
end

local function changeLifeBar( lives )
  if ( lives == 12 ) then
    lifeThree:setSequence( "fullLife" )
    lifeTwo:setSequence( "fullLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 11 ) then
    lifeThree:setSequence( "threeQuartersLife" )
    lifeTwo:setSequence( "fullLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 10 ) then
    lifeThree:setSequence( "twoQuartersLife" )
    lifeTwo:setSequence( "fullLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 9 ) then
    lifeThree:setSequence( "oneQuarterLife" )
    lifeTwo:setSequence( "fullLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 8 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "fullLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 7 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "threeQuartersLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 6 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "twoQuartersLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 5 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "oneQuarterLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 4 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "emptyLife" )
    lifeOne:setSequence( "fullLife" )
  elseif( lives == 3 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "emptyLife" )
    lifeOne:setSequence( "threeQuartersLife" )
  elseif( lives == 2 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "emptyLife" )
    lifeOne:setSequence( "twoQuartersLife" )
  elseif( lives == 1 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "emptyLife" )
    lifeOne:setSequence( "oneQuarterLife" )
  elseif( lives == 0 or lives < 0 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeTwo:setSequence( "emptyLife" )
    lifeOne:setSequence( "emptyLife" )
  end
  lifeThree:setFrame(1)
  lifeTwo:setFrame(1)
  lifeOne:setFrame(1)
end

local function increaseLife()
  lives = lives + 4
  if( lives > 12 ) then
    lives = 12
  end
  changeLifeBar( lives )
end

local function takeDamage( isPunchHit )
  if( isPunchHit ) then
    lives = lives - 2
  else
    lives = lives - 1
  end
  changeLifeBar( lives )
  if( lives == 0 or lives < 0) then
    died = true
  end
end

local function restoreSuperD()
  if( died == false and superD ~= nil ) then
    superD:setLinearVelocity( 0,0 )
    superD.isBodyActive = false

    -- Fade in SuperD
    transition.to( superD, { tag="animationPause", alpha=1, time=225,
      onComplete = function()
        if( died == false and superD ~= nil ) then
          superD.isBodyActive = true
          punchButton:setEnabled( true )
          jumpButton:setEnabled( true )
          moveLeftButton:setEnabled( true )
          moveRightButton:setEnabled( true )
          if ( superD.sequence == "superDtakingDamage" and superD.frame == 1 ) then
            superD:setSequence( "static" )
            superD:setFrame ("2")
          else
            superD:setSequence( "static" )
            superD:setFrame ("1")
          end
          died = false
        end
      end
    } )
  end
end

local function nucleumsFactory()
  if( not hasNucleumFull ) then

    if( generatedNucleums < 3 )  then
      nucleum = nucleumEntity:getNucleum( math.random( -400, 400 ), 290 )
      backGroup:insert( nucleum )
      physics.addBody( nucleum, "static", { isSensor=true } )
      table.insert( nucleumTable, nucleum )

      hasNucleumFull = true
    end
  end
end

local function removeNucleumUsed( nucleum )
  for i = #nucleumTable, 1, -1 do
    if ( nucleumTable[i] == nucleum ) then
      transition.to( nucleumTable[i], { tag="animationPause", alpha=1, time=2000,
        onComplete = function()
          display.remove( nucleum )
        end
      } )
      table.remove( nucleumTable, i )
      break
    end
  end
end

local function nTsFactory()
  if( nTsNumber ~= 0 ) then
    nT = nTentity:getNt( -60, math.random( 300 ) )
    mainGroup:insert( nT )
    nT:setFrame( 2 )
    table.insert( nTtable, nT )
    physics.addBody( nT, "dynamic", { radius=80, bounce=0.8 } )
    nT:setLinearVelocity( math.random( 120,250 ), math.random( 20,60 ) )
  end
end

local function removeDriftedNts()
  for i = #nTtable, 1, -1 do
    local nT = nTtable[i]

    if ( nT.x < -100 or
      nT.x > display.contentWidth + 100 or
      nT.y < -100 or
      nT.y > display.contentHeight + 100 )
    then
      display.remove( nT )
      table.remove( nTtable, i )
    end
  end
end

local function nTsAttack()
  if( died ~= true ) then
    local attackingNumber = 2
    if( #nTtable > 0  ) then
      attackingNumber = math.random( #nTtable )
    end
    for i = #nTtable, 1, -attackingNumber do
      local nT = nTtable[i]
      if( nT.sequence ~= "nTtakingDamage" ) then
        nT:setSequence( "attackRight" )
        nT:play()
      end
    end
  end
end

local function endGame()
  composer.gotoScene( "game-over", { time=800, effect="crossFade" } )
end

local function passSubLevel()
  playerDataTable = loadsave.loadTable( "playerData.json" )

  if( playerDataTable == nil ) then
    playerDataTable = {}
    playerDataTable.isLungSubLevel = true
    playerDataTable.mouthPontuation = points
    playerDataTable.mouthLifePoints = lives
    playerDataTable.mouthUsedNucleums = generatedNucleums
  elseif( playerDataTable.mouthLifePoints <= lives ) then
    playerDataTable.mouthPontuation = points
    playerDataTable.mouthLifePoints = lives
    playerDataTable.mouthUsedNucleums = generatedNucleums
  end

  loadsave.saveTable( playerDataTable, "playerData.json" )
  -- Results
  timer.pause( timeCounterTimer )

  composer.gotoScene( "results", {
    time=800, effect="crossFade", params = {
      lifePoints = lives, timeEnd = endTime, nucleums = generatedNucleums
    }
  } )
end

local function onCollision( event )
  if ( event.phase == "began" ) then
    local superD
    local nT
    local nucleum

    if ( event.object1.myName == "superD" and event.object2.myName == "nT" ) then
      superD = event.object1
      nT = event.object2
    elseif ( event.object1.myName == "nT" and event.object2.myName == "superD" ) then
      superD = event.object2
      nT = event.object1
    end

    if ( event.object1.myName == "nucleum" and event.object2.myName == "superD" ) then
      nucleum = event.object1
      superD = event.object2
    elseif ( event.object1.myName == "superD" and event.object2.myName == "nucleum" ) then
      nucleum = event.object2
      superD = event.object1
    end

    if ( superD ~= nil and nT ~= nil ) then
      if ( nT.sequence ~= "nTtakingDamage" ) then
        audio.play( hitTrack )

        if( ( superD.sequence == "attackRight" or superD.sequence == "attackLeft" ) and superD.frame ~= 7 ) then
          nTsNumber = nTsNumber - 1
          points = points + 1
          if( nTsNumber > 0 ) then
            display.remove( nTsLeft )
            display.remove( pontuation )
            nTsLeft = display.newText( uiGroup, nTsNumber, display.contentCenterX + 378, display.contentHeight - 640, inputText, 40 )
            nTsLeft:setFillColor( 255, 255, 0 )
            pontuation = display.newText( uiGroup, points, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
            pontuation:setFillColor( 255, 255, 0 )
          elseif( nTsNumber == 0 ) then
            died = true
            timer.performWithDelay( 200, passSubLevel )
          end

          if( nT.sequence == "attackRight" or ( nT.sequence == "static" and nT.frame == 2 ) ) then
            nT:setSequence( "nTtakingDamage" )
            nT:setFrame(2)
          else
            nT:setSequence( "nTtakingDamage" )
            nT:setFrame(1)
          end
          nT.alpha = 0.5
          nT.isSensor = true
          timer.performWithDelay( 1000, function()
            display.remove( nT )

            for i = #nTtable, 1, -1 do
              if ( nTtable[i] == nT ) then
                table.remove( nTtable, i )
                break
              end
            end
          end )
        elseif ( died == false ) then
          local punchHit = false

          punchButton:setEnabled( false )
          jumpButton:setEnabled( false )
          moveLeftButton:setEnabled( false )
          moveRightButton:setEnabled( false )

          if( nT.sequence == "attackRight" and nT.frame ~= 7 ) then
            punchHit = true
          end

          if( ( superD.sequence == "static" and superD.frame == 2 ) or
            superD.sequence == "movingRight" or superD.sequence == "attackRight" ) then
            superD:setSequence( "superDtakingDamage" )
            superD:setFrame(1)
          else
            superD:setSequence( "superDtakingDamage" )
            superD:setFrame(2)
          end
          takeDamage( punchHit )
          superD.alpha = 0.5
          timer.performWithDelay( 420 , restoreSuperD )
        end
      end
    end

    if( nucleum ~= nil and superD ~= nil and lives ~= 12 ) then
      if( nucleum.sequence == "full" ) then
        increaseLife()
      end
      nucleum:setSequence( "empty" )
      nucleum:setFrame(1)
      removeNucleumUsed( nucleum )
      hasNucleumFull = false
      generatedNucleums = generatedNucleums + 1
    end
  elseif ( event.phase == "ended" and superD ~= nil and nT ~= nil ) then
    if( died == true and lives == 0 or lives < 0 ) then
      timer.performWithDelay( 200, endGame )
    else
      timer.performWithDelay( 1, keepSuperDatScreen )
    end
  end
end

local function gameLoop()
  nTsFactory()
  removeDriftedNts()
end

-- Clock
local function timeCounter()
  endTime = endTime + 1
end

local function afterGameTutorial()
  superD.isBodyActive = true
  punchButton:setEnabled( true )
  jumpButton:setEnabled( true )
  moveLeftButton:setEnabled( true )
  moveRightButton:setEnabled( true )

  Runtime:addEventListener( "collision", onCollision )
  -- Clock
  timeCounterTimer = timer.performWithDelay( 1000, timeCounter, 0 )
  gameLoopTimer = timer.performWithDelay( 1200, gameLoop, 0 )
  nucleumsFactoryLoopTimer = timer.performWithDelay( math.random( 60000, 90000 ), nucleumsFactory, 0 )
  nTsAttackLoopTimer = timer.performWithDelay( math.random( 1000, 3000 ), nTsAttack, 0 )

  stillInTutorial = false
end

local function gameTutorial()
  superD.isBodyActive = false
  punchButton:setEnabled( false )
  jumpButton:setEnabled( false )
  moveLeftButton:setEnabled( false )
  moveRightButton:setEnabled( false )

  -- Load tutorial textbox
  local tutorialTextBox = display.newRect( backGroup, display.contentCenterX, display.contentCenterY-100, 400, 200 )
  tutorialTextBox:setFillColor( 0, 0, 1 )
  tutorialTextBox:setStrokeColor( 1, 1, 0 )
  tutorialTextBox.strokeWidth = 1

  -- Load pass text button
  local passText = display.newImageRect( backGroup, "assets/img/arrow-right.png", 30, 26 )
  passText.x = display.contentCenterX + 160
  passText.y = display.contentHeight - 415

  local endTutorial = false
  local contentTextOne = "Welcome to inside human's body! You're SuperD, the strongest virus of the universe."
  local startTextTwo = true
  local startTextThree = false
  local animationOne = false
  local animationTwo = false
  local animationThree = false
  local startTextFour = false
  local startTextFive = false
  local startTextSix = false
  local startTextSeven = false
  local startTextEight = false
  local contentTextEntity = display.newText( backGroup, contentTextOne, display.contentCenterX+05, display.contentHeight-505, 300, 0, inputText, 20 )
  contentTextEntity:setFillColor( 1, 1, 0 )

  -- Load pass tutorial button
  local passTutorialButtonText = "Pass Tutorial"
  local passTutorialButton = display.newText( mainGroup, passTutorialButtonText, display.contentCenterX-100, display.contentHeight-400, inputText, 20 )
  passTutorialButton:setFillColor( 1, 1, 0 )

  passTutorialButton:addEventListener( "tap", function( event )
    endTutorial = true
    display.remove( contentTextEntity )
    display.remove( tutorialTextBox )
    display.remove( passText )
    display.remove( passTutorialButton )
    passText = nil
    afterGameTutorial()
  end )

  passText:addEventListener( "tap", function( event )
    local contentText
    local infoPointer

    if( passTutorialText == true ) then
      if( startTextTwo == true ) then
        contentText = "Your mission here is simple: kill all N-Ts and dominate human's body."
        startTextThree = true
        startTextTwo = false
      elseif( startTextThree == true ) then
        contentText = "To achieve such a task, Super D has some skills that may help."
        startTextThree = false
        animationOne = true
      elseif( animationOne == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        contentText = "Jump for example."
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-down.png", 50, 57);
        infoPointer.x = display.contentCenterX + 450
        infoPointer.y = display.contentHeight - 300
        superD.isBodyActive = true
        passTutorialText = false
        jump()
        transition.to( superD, { tag="animationPause", time=2500,
          onComplete = function()
            display.remove( infoPointer )
            passTutorialText = true
            animationOne = false
            animationTwo = true
            if passText ~= nil then
              passText:toFront()
            end
          end
        } )
      elseif( animationTwo == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        contentText = "Move arround fast!"
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-down.png", 50, 57);
        infoPointer.x = display.contentCenterX - 395
        infoPointer.y = display.contentHeight - 250
        passTutorialText = false
        audio.play( moveTrack )
        superD:setSequence( "movingLeft" )
        superD:setFrame(1)
        transition.to( superD, { tag="animationPause", time=500, x=( display.contentWidth-600 ),
          onComplete = function()
            superD:setSequence( "static" )
            superD:setFrame(2)
            audio.play( moveTrack )
            superD:setSequence( "movingRight" )
            superD:setFrame(1)
            transition.to( superD, { tag="animationPause", time=500, x=( display.contentWidth-80 ),
              onComplete = function()
                superD:setSequence( "static" )
                superD:setFrame(1)
                display.remove( infoPointer )
                passTutorialText = true
                animationTwo = false
                animationThree = true
                if passText ~= nil then
                  passText:toFront()
                end
              end
            } )
          end
        } )
      elseif( animationThree == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        passTutorialText = false
        contentText = "And your strongest weapon, your boxing glove!!!"
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-down.png", 50, 57);
        infoPointer.x = display.contentCenterX + 320
        infoPointer.y = display.contentHeight - 300
        transition.to( superD, { tag="animationPause", time=2900,
          onComplete = function()
            audio.play( punchTrack )
            punch()
            passTutorialText = true
            animationThree = false
            startTextFour = true
            display.remove( infoPointer )
            if passText ~= nil then
              passText:toFront()
            end
          end
        } )
      elseif( startTextFour == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        passTutorialText = false
        contentText = "This is your life bar"
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-up.png", 50, 57);
        infoPointer.x = display.contentCenterX - 400
        infoPointer.y = display.contentHeight - 550
        transition.to( infoPointer, { tag="animationPause", time=2900,
          onComplete = function()
            passTutorialText = true
            startTextFour = false
            startTextFive = true
            display.remove( infoPointer )
            if passText ~= nil then
              passText:toFront()
            end
          end
        } )
      elseif( startTextFive == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        passTutorialText = false
        contentText = "The counter that shows how many N-Ts you have to kill to go to another sub-level or level"
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-up.png", 50, 57);
        infoPointer.x = display.contentCenterX + 370
        infoPointer.y = display.contentHeight - 550
        transition.to( infoPointer, { tag="animationPause", time=2900,
          onComplete = function()
            passTutorialText = true
            startTextFive = false
            startTextSix = true
            display.remove( infoPointer )
            if passText ~= nil then
              passText:toFront()
            end
          end
        } )
      elseif( startTextSix == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        passTutorialText = false
        contentText = "The counter that shows how many N-Ts you have already killed"
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-up.png", 50, 57);
        infoPointer.x = display.contentCenterX + 490
        infoPointer.y = display.contentHeight - 550
        transition.to( infoPointer, { tag="animationPause", time=2900,
          onComplete = function()
            passTutorialText = true
            startTextSix = false
            startTextSeven = true
            display.remove( infoPointer )
            if passText ~= nil then
              passText:toFront()
            end
          end
        } )
      elseif( startTextSeven == true ) then
        if passText ~= nil then
          passText:toBack()
        end
        passTutorialText = false
        contentText = "This is a core of life that will increase one point of life, if you need it. It appears randomly."
        infoPointer = display.newImageRect(mainGroup, "assets/img/arrow-down.png", 50, 57);
        infoPointer.x = display.contentCenterX - 395
        infoPointer.y = display.contentHeight - 350
        transition.to( infoPointer, { tag="animationPause", time=2900,
          onComplete = function()
            passTutorialText = true
            startTextSeven = false
            startTextEight = true
            display.remove( infoPointer )
            if passText ~= nil then
              passText:toFront()
            end
          end
        } )
      elseif( startTextEight == true ) then
        contentText = "Let's get started!"
        startTextEight = false
        endTutorial = true
        display.remove( contentTextEntity )
        contentTextEntity = display.newText( backGroup, contentText, display.contentCenterX+05, display.contentHeight-505, 300, 0, inputText, 20 )
        contentTextEntity:setFillColor( 1, 1, 0 )
      elseif( endTutorial == true ) then
        display.remove( contentTextEntity )
        display.remove( tutorialTextBox )
        display.remove( passText )
        display.remove( passTutorialButton )
        afterGameTutorial()
      end
      if( endTutorial == false ) then
        display.remove( contentTextEntity )
        contentTextEntity = display.newText( backGroup, contentText, display.contentCenterX+05, display.contentHeight-505, 300, 0, inputText, 20 )
        contentTextEntity:setFillColor( 1, 1, 0 )
      end
    end
  end
  );
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  physics.pause()  -- Temporarily pause the physics engine

  -- Set up display groups
  backGroup = display.newGroup()  -- Display group for the background image
  sceneGroup:insert( backGroup )  -- Insert into the scene's view group

  mainGroup = display.newGroup()  -- Display group for the superD, N-Ts, etc.
  sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

  uiGroup = display.newGroup()    -- Display group for UI objects like the score
  sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

  -- Load the background
  local background = display.newImageRect( backGroup, "assets/img/mouth-background.jpg", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load SuperD
  superD = superDentity:getSuperD( 400, 290 )
  mainGroup:insert( superD )

  -- Load nucleum
  nucleum = nucleumEntity:getNucleum( -400, 290 )
  backGroup:insert( nucleum )
  table.insert( nucleumTable, nucleum )

  -- Load the ground
  ground = display.newRect( backGroup, display.contentCenterX, display.contentHeight - 280, display.contentWidth * 30, 10)
  ground:setFillColor(0,0,0,0)
  ground.strokeWidth = 0
  ground:setStrokeColor(0)
  ground.myName = "ground"

  -- Load LifeBar
  lifeOne = topBarEntity:getTopBar( lifeBarScale, lifeBarScale, 470, false )
  uiGroup:insert( lifeOne )

  lifeTwo = topBarEntity:getTopBar( lifeBarScale, lifeBarScale, 400, false )
  uiGroup:insert( lifeTwo )

  lifeThree = topBarEntity:getTopBar( lifeBarScale, lifeBarScale, 330, false )
  uiGroup:insert( lifeThree )

  nTsToKill = topBarEntity:getTopBar( nTsBarScale, nTsBarScale, 320, true )
  uiGroup:insert( nTsToKill )
  nTsToKill:setSequence( "nTs" )
  nTsToKill:setFrame( 1 )

  nTsKilled = topBarEntity:getTopBar( nTsBarScale, nTsBarScale, 430, true )
  uiGroup:insert( nTsKilled )
  nTsKilled:setSequence( "nTs" )
  nTsKilled:setFrame( 2 )

  -- Adding physics
  --physics.setGravity( 0, 20 )
  physics.addBody( superD, "dynamic", { radius=40, isSensor=false, bounce=0.1 } )
  physics.addBody( nucleum, "static", { isSensor=true } )
  physics.addBody( ground, "static", { bounce=0.05 } )

  -- Initialize widget
  widget = require("widget")

  -- Load gamepad start
  pauseButton = widget.newButton( {
    -- The id can be used to tell you what button was pressed in your button event
    id = "pauseButton",
    -- Size of the button
    width = 130,
    height = 150,
    -- This is the default button image
    defaultFile = "assets/img/pause-menu-button.png",
    -- This is the pressed button image
    overFile = "assets/img/pause-menu-button-pressed.png",
    -- Position of the button
    left = display.contentCenterX - 70,
    top = 520,
    -- This tells it what function to call when you press the button
    onPress = pauseMenu
  } )

  punchButton = widget.newButton( {
    -- The id can be used to tell you what button was pressed in your button event
    id = "punchButton",
    -- Size of the button
    width = 130,
    height = 150,
    -- This is the default button image
    defaultFile = "assets/img/punch-button.png",
    -- This is the pressed button image
    overFile = "assets/img/punch-button-pressed.png",
    -- Position of the button
    left = 760,
    top = 520,
    -- This tells it what function to call when you press the button
    onPress = punch
  } )

  jumpButton = widget.newButton( {
    id = "jumpButton",
    width = 120,
    height = 150,
    defaultFile = "assets/img/jump-button.png",
    overFile = "assets/img/jump-button-pressed.png",
    left = 900,
    top = 520,
    onPress = jump
  } )

  moveRightButton = widget.newButton( {
    id = "moveRightButton",
    width = 100,
    height = 150,
    defaultFile = "assets/img/move-right-button.png",
    overFile = "assets/img/move-right-button-pressed.png",
    left = 120,
    top = 520,
    onEvent = moveRight
  } )

  moveLeftButton = widget.newButton( {
    id = "moveLeftButton",
    width = 100,
    height = 150,
    defaultFile = "assets/img/move-left-button.png",
    overFile = "assets/img/move-left-button-pressed.png",
    left = 10,
    top = 520,
    onEvent = moveLeft
  } )

  pauseButton.alpha = alpha;
  punchButton.alpha = alpha;
  jumpButton.alpha = alpha;
  moveLeftButton.alpha = alpha;
  moveRightButton.alpha = alpha;

  uiGroup:insert( pauseButton )
  uiGroup:insert( punchButton )
  uiGroup:insert( jumpButton )
  uiGroup:insert( moveLeftButton )
  uiGroup:insert( moveRightButton )
  -- Load gamepad end
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    audio.stop( 1 )
  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    system.activate( "multitouch" )
    audio.play( musicTrack, { channel=1, loops=-1 } )
    physics.start()
    nTsNumber = math.random( 40, 60 )
    nTsLeft = display.newText( uiGroup, nTsNumber, display.contentCenterX + 378, display.contentHeight - 640, inputText, 40 )
    nTsLeft:setFillColor( 255, 255, 0 )
    pontuation = display.newText( uiGroup, points, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
    pontuation:setFillColor( 255, 255, 0 )
    -- Start tutorial
    gameTutorial()
  end
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    if( stillInTutorial == false ) then
      -- Clock
      timer.cancel( timeCounterTimer )
      timer.cancel( gameLoopTimer )
      timer.cancel( nTsAttackLoopTimer )
      timer.cancel( nucleumsFactoryLoopTimer )
    end
    -- Stop the music!
    audio.stop( 1 )
    display.remove(backGroup)
    display.remove(mainGroup)
    display.remove(uiGroup)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    Runtime:removeEventListener( "collision", onCollision )
    physics.pause()
    composer.removeScene( "mouth-tutorial" )
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
