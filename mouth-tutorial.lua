local composer = require( "composer" )

local scene = composer.newScene()

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
local superD
local nucleum
local points = 0
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
local wallRight
local wallLeft
local widget
local punchButton
local jumpButton
local moveRightButton
local moveLeftButton
local died = false
local lives = 12
local lifeBarScale = 0.3
local nTsBarScale = 0.1
local alpha = 0.8
--local offsetSuperDParams = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
-- Sound settings
local musicTrack = audio.loadSound( "assets/audio/youCantHide.mp3" )
local moveTrack = audio.loadSound( "assets/audio/moveSound.mp3" )
local jumpTrack = audio.loadSound( "assets/audio/jumpSound.mp3" )
local punchTrack = audio.loadSound( "assets/audio/punchSound.mp3" )
local hitTrack = audio.loadSound( "assets/audio/hitSound.mp3" )
-- Font
local inputText = native.newFont( "Starjedi.ttf" )
-- Set up display groups
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for Super D, N-Ts etc
local uiGroup = display.newGroup()    -- Display group for UI objects

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
  if superD.x > display.contentWidth then
    superD.x = display.contentWidth - 10
  elseif superD.x < 0 then
    superD.x = 0
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

local function takeDamage( isPunchHit )
  if ( lives == 12 ) then
    if( isPunchHit ) then
      lifeThree:setSequence( "twoQuartersLife" )
      lifeThree:setFrame(1)
      lives = lives - 2
    else
      lifeThree:setSequence( "threeQuartersLife" )
      lifeThree:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 11 ) then
    if( isPunchHit ) then
      lifeThree:setSequence( "oneQuarterLife" )
      lifeThree:setFrame(1)
      lives = lives - 2
    else
      lifeThree:setSequence( "twoQuartersLife" )
      lifeThree:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 10 ) then
    if( isPunchHit ) then
      lifeThree:setSequence( "emptyLife" )
      lifeThree:setFrame(1)
      lives = lives - 2
    else
      lifeThree:setSequence( "oneQuarterLife" )
      lifeThree:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 9 ) then
    if( isPunchHit ) then
      lifeThree:setSequence( "emptyLife" )
      lifeThree:setFrame(1)
      lifeTwo:setSequence( "threeQuartersLife" )
      lifeTwo:setFrame(1)
      lives = lives - 2
    else
      lifeThree:setSequence( "emptyLife" )
      lifeThree:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 8 ) then
    if( isPunchHit ) then
      lifeTwo:setSequence( "twoQuartersLife" )
      lifeTwo:setFrame(1)
      lives = lives - 2
    else
      lifeTwo:setSequence( "threeQuartersLife" )
      lifeTwo:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 7 ) then
    if( isPunchHit ) then
      lifeTwo:setSequence( "oneQuarterLife" )
      lifeTwo:setFrame(1)
      lives = lives - 2
    else
      lifeTwo:setSequence( "twoQuartersLife" )
      lifeTwo:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 6 ) then
    if( isPunchHit ) then
      lifeTwo:setSequence( "emptyLife" )
      lifeTwo:setFrame(1)
      lives = lives - 2
    else
      lifeTwo:setSequence( "oneQuarterLife" )
      lifeTwo:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 5 ) then
    if( isPunchHit ) then
      lifeTwo:setSequence( "emptyLife" )
      lifeTwo:setFrame(1)
      lifeOne:setSequence( "threeQuartersLife" )
      lifeOne:setFrame(1)
      lives = lives - 2
    else
      lifeTwo:setSequence( "emptyLife" )
      lifeTwo:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 4 ) then
    if( isPunchHit ) then
      lifeOne:setSequence( "twoQuartersLife" )
      lifeOne:setFrame(1)
      lives = lives - 2
    else
      lifeOne:setSequence( "threeQuartersLife" )
      lifeOne:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 3 ) then
    if( isPunchHit ) then
      lifeOne:setSequence( "oneQuarterLife" )
      lifeOne:setFrame(1)
      lives = lives - 2
    else
      lifeOne:setSequence( "twoQuartersLife" )
      lifeOne:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 2 ) then
    if( isPunchHit ) then
      lifeOne:setSequence( "emptyLife" )
      lifeOne:setFrame(1)
      lives = lives - 2
      died = true
    else
      lifeOne:setSequence( "oneQuarterLife" )
      lifeOne:setFrame(1)
      lives = lives - 1
    end
  elseif( lives == 1 ) then
    lifeOne:setSequence( "emptyLife" )
    lifeOne:setFrame(1)
    lives = lives - 1
    died = true
  end
end

local function restoreSuperD()
  if( died == false ) then
    superD:setLinearVelocity( 0,0 )
    superD.isBodyActive = false

    -- Fade in SuperD
    transition.to( superD, { alpha=1, time=225,
      onComplete = function()
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
    } )
  end
end

local function nTsFactory()
  if( nTsNumber ~= 0 ) then
    nT = nTentity:getNt( xScale, yScale, -60, math.random( 300 ) )
    mainGroup:insert( nT )
    nT:setFrame( 2 )
    table.insert( nTtable, nT )
    physics.addBody( nT, "dynamic", { radius=40, bounce=0.8 } )
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
    for i = #nTtable, 1, -2 do
      local nT = nTtable[i]
      nT:setSequence( "attackRight" )
      nT:play()
    end
  end
end

local function endGame()
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
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
      audio.play( hitTrack )

      if( ( superD.sequence == "attackRight" or superD.sequence == "attackLeft" ) and superD.frame ~= 7 ) then
        nTsNumber = nTsNumber - 1
        points = points + 1
        if( nTsNumber > 0 ) then
          display.remove( nTsLeft )
          display.remove( pontuation )
          nTsLeft = display.newText( uiGroup, nTsNumber, display.contentCenterX + 370, display.contentHeight - 640, inputText, 40 )
          nTsLeft:setFillColor( 255, 255, 0 )
          pontuation = display.newText( uiGroup, points, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
          pontuation:setFillColor( 255, 255, 0 )
        elseif( nTsNumber == 0 ) then
          died = true
          timer.performWithDelay( 200, endGame )
        end

        nT.isSensor = true
        display.remove( nT )

        for i = #nTtable, 1, -1 do
          if ( nTtable[i] == nT ) then
            table.remove( nTtable, i )
            break
          end
        end
      else
        if ( died == false ) then
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
          if( died == true ) then
            timer.performWithDelay( 200, endGame )
          else
            superD.alpha = 0.5
            timer.performWithDelay( 420, restoreSuperD )
          end
        end
      end
    end
    if ( nucleum ~= nil and superD ~= nil ) then
        nucleum:setSequence( "empty" )
        nucleum:setFrame(1)
    end
  end
end

local function gameLoop()
  nTsFactory()
  nTsAttackLoop = timer.performWithDelay( math.random( 2000, 3000 ), nTsAttack, 0 )
  removeDriftedNts()
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
  local background = display.newImageRect( backGroup, "assets/img/background.jpg", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load SuperD
  superD = superDentity:getSuperD( 400, 290 )
  mainGroup:insert( superD )

  -- Load nucleum
  nucleum = nucleumEntity:getNucleum( -400, 290 )
  mainGroup:insert( nucleum )

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
  physics.addBody( nucleum, "kinematic", { isSensor=false } )
  physics.addBody( ground, "static", { bounce=0.05 } )
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
  -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    system.activate( "multitouch" )
    audio.play( musicTrack )
    physics.start()
    nTsNumber = math.random( 40, 60 )
    nTsLeft = display.newText( uiGroup, nTsNumber, display.contentCenterX + 370, display.contentHeight - 640, inputText, 40 )
    nTsLeft:setFillColor( 255, 255, 0 )
    pontuation = display.newText( uiGroup, points, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
    pontuation:setFillColor( 255, 255, 0 )
    Runtime:addEventListener( "collision", onCollision )
    gameLoopTimer = timer.performWithDelay( 1200, gameLoop, 0 )

    -- Initialize widget
    widget = require("widget")

    -- Load gamepad start
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

    punchButton.alpha = alpha;
    jumpButton.alpha = alpha;
    moveLeftButton.alpha = alpha;
    moveRightButton.alpha = alpha;

    uiGroup:insert( punchButton )
    uiGroup:insert( jumpButton )
    uiGroup:insert( moveLeftButton )
    uiGroup:insert( moveRightButton )
    -- Load gamepad end
  end
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    timer.cancel( gameLoopTimer )
    timer.cancel( nTsAttackLoop )
    audio.stop()
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