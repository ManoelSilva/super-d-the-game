-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Configure image sheet
local spritesheetSuperD = require("spritesheet.spritesheet-superD")
local spritesheetSuperDdamaged = require("spritesheet.spritesheet-superD-taking-damage")
local spritesheetTopBar = require("spritesheet.spritesheet-superD-top-bar")
local spritesheetNt = require("spritesheet.spritesheet-nT")

local superDobjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD.png", spritesheetSuperD.getSheet() )
local superDdamagedObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD-taking-damage.png", spritesheetSuperDdamaged.getSheet() )
local superDtopBarObjectSheet = graphics.newImageSheet( "assets/img/spritesheet-superD-top-bar.png", spritesheetTopBar.getSheet() )
local nTobjectSheet = graphics.newImageSheet( "assets/img/spritesheet-nT.png", spritesheetNt.getSheet() )

local sequencesRunSuperDorNt =
  {
    { name = "static", frames = {7, 16} },
    { name = "movingRight", frames = {9} },
    { name = "movingLeft", frames = {8} },
    { name = "attackRight", start = 10, count = 7, time = 260, loopCount = 1 },
    { name = "attackLeft", start = 1, count = 7, time = 260, loopCount = 1 },
    { name = "superDtakingDamage", sheet = superDdamagedObjectSheet, frames = {2, 1} }
  }

local sequencesTopBar =
  {
    { name = "fullLife", frames = {4} },
    { name = "threeQuartersLife", frames = {6} },
    { name = "twoQuartersLife", frames = {7} },
    { name = "oneQuarterLife", frames = {5} },
    { name = "emptyLife", frames = {3} },
    { name = "nTs", frames = {2, 1} }
  }

-- Initialize variables
local superD
local nT
local nTtable = {}
local lifeOne
local lifeTwo
local lifeThree
local ground
local wallRight
local wallLeft
local physics
local widget
local punchButton
local jumpButton
local moveRightButton
local moveLeftButton
local died = false
local lives = 12
local xScale = 0.5
local yScale = 0.3
--local offsetSuperDParams = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
local musicTrack = audio.loadSound( "assets/audio/youCantHide.mp3" )
local moveTrack = audio.loadSound( "assets/audio/moveSound.mp3" )
local jumpTrack = audio.loadSound( "assets/audio/jumpSound.mp3" )
local punchTrack = audio.loadSound( "assets/audio/punchSound.mp3" )
local hitTrack = audio.loadSound( "assets/audio/hitSound.mp3" )

-- Set up display groups
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for Super D, N-Ts etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like gamepad ( I'm not using yet )

-- Load the background
local background = display.newImageRect( backGroup, "assets/img/background.jpg", display.actualContentWidth, display.actualContentHeight )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Load the ground
ground = display.newRect( backGroup, display.contentCenterX, display.contentHeight - 280, display.contentWidth * 30, 10)
ground:setFillColor(0,0,0,0)
ground.strokeWidth = 0
ground:setStrokeColor(0)
ground.myName = "ground"

-- Load SuperD
superD = display.newSprite( mainGroup, superDobjectSheet, sequencesRunSuperDorNt )
superD:scale(xScale, yScale)
superD.x = display.contentCenterX + 400
superD.y = display.contentHeight - 290
superD.myName = "superD"

-- Load LifeBar
lifeOne = display.newSprite( mainGroup, superDtopBarObjectSheet, sequencesTopBar )
lifeOne:scale(xScale, yScale)
lifeOne.x = display.contentCenterX - 450
lifeOne.y = display.contentHeight - 640
lifeOne.myName = "lifeOne"

lifeTwo = display.newSprite( mainGroup, superDtopBarObjectSheet, sequencesTopBar )
lifeTwo:scale(xScale, yScale)
lifeTwo.x = display.contentCenterX - 330
lifeTwo.y = display.contentHeight - 640
lifeTwo.myName = "lifeTwo"

lifeThree = display.newSprite( mainGroup, superDtopBarObjectSheet, sequencesTopBar )
lifeThree:scale(xScale, yScale)
lifeThree.x = display.contentCenterX - 210
lifeThree.y = display.contentHeight - 640
lifeThree.myName = "lifeThree"

lifeOne.alpha = 0.8
lifeTwo.alpha = 0.8
lifeThree.alpha = 0.8

-- Initialize physics
physics = require("physics")
physics.start()
physics.addBody( superD, "dynamic", { radius=30, isSensor=false, bounce=0.1 } )
--physics.addBody( superD, "dynamic", { shape=offsetSuperDParams isSensor=false } )
physics.addBody( ground, "static" )

-- Move superD when touched on
local function moveSuperD(event)
  local superD = event.target
  local phase = event.phase

  if ( "began" == phase ) then
    -- Set touch focus on the superD
    display.currentStage:setFocus( superD )
    -- Store initial offset position
    superD.touchOffsetX = event.x - superD.x
    superD.touchOffsetY = event.y - superD.y

  elseif ( "moved" == phase ) then
    if ( superD.touchOffsetX > 0 ) then
      superD:setSequence( "movingRight" )
      superD:setFrame(1)
    else
      superD:setSequence( "movingLeft" )
      superD:setFrame(1)
    end
    -- Move the superD to the new touch position
    superD.x = event.x - superD.touchOffsetX
    superD.y = event.y - superD.touchOffsetY

  elseif ( "ended" == phase or "cancelled" == phase ) then
    superD:setSequence( "static" )
    if ( superD.touchOffsetX > 0 ) then
      superD:setFrame(2)
    else
      superD:setFrame(1)
    end
    -- Release touch focus on the superD
    display.currentStage:setFocus( nil )
  end
  return true  -- Prevents touch propagation to underlying objects
end

-- Sprite listener function
local function spriteListener( event )
  local thisSprite = event.target  -- "event.target" references the sprite
  if ( event.phase == "ended" ) then
    if ( thisSprite.touchOffsetX > 0 ) then
      thisSprite:setSequence( "attackRight" )  -- switch to "attackRight" sequence
      thisSprite:play()  -- play the new sequence
    else
      thisSprite:setSequence( "attackLeft" )  -- switch to "attackLeft" sequence
      thisSprite:play()  -- play the new sequence
    end
  end
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

local function moveRight( event )
  if ( "began" == event.phase ) then
    audio.play( moveTrack )
    superD:setSequence( "movingRight" )
    superD:setFrame(1)
    -- start moving SuperD
    superD:applyLinearImpulse( 0.3, 0, superD.x, superD.y )
  elseif ( "ended" == event.phase ) then
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
    superD:applyLinearImpulse( -0.3, 0, superD.x, superD.y )
  elseif ( "ended" == event.phase ) then
    superD:setSequence( "static" )
    superD:setFrame(1)
    superD:setLinearVelocity( 0,0 )
  end
end

local function jump()
  audio.play( jumpTrack )
  superD:applyLinearImpulse( 0, 0.70, superD.x, superD.y )
end

local function takeDamage()
  if ( lives == 12 ) then
    lifeThree:setSequence( "threeQuartersLife" )
    lifeThree:setFrame(1)
    lives = lives - 1
  elseif( lives == 11 ) then
    lifeThree:setSequence( "twoQuartersLife" )
    lifeThree:setFrame(1)
    lives = lives - 1
  elseif( lives == 10 ) then
    lifeThree:setSequence( "oneQuarterLife" )
    lifeThree:setFrame(1)
    lives = lives - 1
  elseif( lives == 9 ) then
    lifeThree:setSequence( "emptyLife" )
    lifeThree:setFrame(1)
    lives = lives - 1
  elseif( lives == 8 ) then
    lifeTwo:setSequence( "threeQuartersLife" )
    lifeTwo:setFrame(1)
    lives = lives - 1
  elseif( lives == 7 ) then
    lifeTwo:setSequence( "twoQuartersLife" )
    lifeTwo:setFrame(1)
    lives = lives - 1
  elseif( lives == 6 ) then
    lifeTwo:setSequence( "oneQuarterLife" )
    lifeTwo:setFrame(1)
    lives = lives - 1
  elseif( lives == 5 ) then
    lifeTwo:setSequence( "emptyLife" )
    lifeTwo:setFrame(1)
    lives = lives - 1
  elseif( lives == 4 ) then
    lifeOne:setSequence( "threeQuartersLife" )
    lifeOne:setFrame(1)
    lives = lives - 1
  elseif( lives == 3 ) then
    lifeOne:setSequence( "twoQuartersLife" )
    lifeOne:setFrame(1)
    lives = lives - 1
  elseif( lives == 2 ) then
    lifeOne:setSequence( "oneQuarterLife" )
    lifeOne:setFrame(1)
    lives = lives - 1
  elseif( lives == 1 ) then
    lifeOne:setSequence( "emptyLife" )
    lifeOne:setFrame(1)
    lives = lives - 1
    died = true
  end
end

local function restoreSuperD()
  superD:setLinearVelocity( 0,0 )
  superD.isBodyActive = false
  --superD.x = display.contentCenterX + 400
  --superD.y = display.contentHeight - 330

  -- Fade in SuperD
  transition.to( superD, { alpha=1, time=250,
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

local function nTsFactory()
  nT = ( display.newSprite( mainGroup, nTobjectSheet, sequencesRunSuperDorNt ) )
  nT:scale(xScale, yScale)
  nT:setFrame( 2 )
  table.insert( nTtable, nT )
  physics.addBody( nT, "dynamic", { radius=40, bounce=0.8 } )
  nT.myName = "nT"

  --local whereFrom = math.random( 2 )
  --if ( whereFrom == 1 ) then
  nT.x = -60
  nT.y = math.random( 300 )
  nT:setLinearVelocity( math.random( 40,90 ), math.random( 20,60 ) )
  --end
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

local function nTsBehavior()
  removeDriftedNts()
end

local function onCollision( event )
  if ( event.phase == "began" ) then
    local superD
    local nT

    if ( event.object1.myName == "superD" and event.object2.myName == "nT" ) then
      superD = event.object1
      nT = event.object2
    elseif ( event.object1.myName == "nT" and event.object2.myName == "superD" ) then
      superD = event.object2
      nT = event.object1
    end

    if ( superD ~= nil or nT ~= nil ) then
      audio.play( hitTrack )

      if( ( superD.sequence == "attackRight" or superD.sequence == "attackLeft" ) and superD.frame ~= 7 ) then
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
          punchButton:setEnabled( false )
          jumpButton:setEnabled( false )
          moveLeftButton:setEnabled( false )
          moveRightButton:setEnabled( false )

          if ( ( superD.sequence == "static" and superD.frame == 2 ) or
            superD.sequence == "movingRight" or superD.sequence == "attackRight" ) then
            superD:setSequence( "superDtakingDamage" )
            superD:setFrame(1)
          else
            superD:setSequence( "superDtakingDamage" )
            superD:setFrame(2)
          end

          takeDamage()
          superD.alpha = 0.5
          timer.performWithDelay( 500, restoreSuperD )
        end
      end
    end

  end
end

local function gameLoop()
  nTsFactory()
  nTsBehavior()
end

audio.play( musicTrack )
system.activate( "multitouch" )
gameLoopTimer = timer.performWithDelay( 6000, gameLoop, 0 )
Runtime:addEventListener( "collision", onCollision )

--superD:addEventListener( "touch", moveSuperD )

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

punchButton.alpha = 0.8;
jumpButton.alpha = 0.8;
moveLeftButton.alpha = 0.8;
moveRightButton.alpha = 0.8;
-- Load gamepad end