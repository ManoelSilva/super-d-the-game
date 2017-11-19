local composer = require( "composer" )

local scene = composer.newScene()

local isMainCellFirstHit = false

function scene:resumeGame()
  physics.start()
  transition.resume( "animationPause" )
  transition.resume("bossMove")
  -- Clock
  timer.resume( timeCounterTimer )
  timer.resume( bossMovimentantionLoopTimer )
  timer.resume( bossStopAttackLoopTimer )
  timer.resume( nucleumsFactoryLoopTimer )
  if( isMainCellFirstHit == true ) then
    timer.resume( gameLoopTimer )
    timer.resume( nTsAttackLoopTimer )
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
local bossEntity = require("entities.boss" )
local mainCellEntity = require("entities.main-cell" )
local nTentity = require( "entities.nT" )
local nucleumEntity = require( "entities.nucleum" )

-- Initialize variables
-- Clock
local endTime = 0
local playerDataTable = {}
local superD
local nucleum
local nucleumTable = {}
local hasNucleumFull = true
local enemyPoints = 20
local bossMovingLeft = false
local generatedNucleums = 0
local enemyLifePoints
local boss
local isBossAttacking = false
local isBossTakingDamage = false
local mainCell
local isMainCellAlive = true
local nT
local nTtableRight = {}
local nTtableLeft = {}
local lifeOne
local lifeTwo
local lifeThree
local superDxPosition
local superDxReference = 192
local bossPointsLife
local points = 0
local ground
local platform
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

-- Sound settings
local musicTrack = audio.loadStream( "assets/audio/everyday.mp3" )
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
  -- Clock
  timer.pause( timeCounterTimer )
  transition.pause("animationPause")
  transition.pause("bossMove")
  if( isMainCellFirstHit == true ) then
    timer.pause( gameLoopTimer )
    timer.pause( nTsAttackLoopTimer )
  end
  timer.pause( nucleumsFactoryLoopTimer )

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
    superDxPosition = superD.x
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
    superDxPosition = superD.x
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

local function takeDamage( isPunchHit, isBossHit )
  if( isPunchHit ) then
    lives = lives - 2
  elseif( isBossHit ) then
    lives = lives - 3
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

    if( generatedNucleums < 9 )  then
      nucleum = nucleumEntity:getNucleum( math.random( -400, 400 ), 270 )
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
  local rightOrLeft = math.random( 0, 1 )
  if( isMainCellFirstHit ) then
    if( rightOrLeft == 0 ) then
      nT = nTentity:getNt( math.random( 900, 1200 ), math.random( 200, 400 ) )
      mainGroup:insert( nT )
      if( isMainCellAlive == false ) then
        nT:setSequence( "superDmovingLeft" )
        nT:setFrame( 1 )
      else
        nT:setFrame( 1 )
      end
      table.insert( nTtableRight, nT )
      physics.addBody( nT, "dynamic", { radius=80, bounce=0.8, filter={ groupIndex=-2 } } )
      nT:setLinearVelocity( math.random( -250,-120 ), math.random( 20,60 ) )
    else
      nT = nTentity:getNt( -60, math.random( 300 ) )
      mainGroup:insert( nT )
      if( isMainCellAlive == false ) then
        nT:setSequence( "superDmovingRight" )
        nT:setFrame( 1 )
      else
        nT:setFrame( 2 )
      end
      table.insert( nTtableLeft, nT )
      physics.addBody( nT, "dynamic", { radius=80, bounce=0.8, filter={ groupIndex=-2 } } )
      nT:setLinearVelocity( math.random( 120,250 ), math.random( 20,60 ) )
    end
  end
end

local function removeDriftedNts()
  for i = #nTtableRight, 1, -1 do
    local nT = nTtableRight[i]

    if ( nT.x < -100 or
      nT.x > display.contentWidth + 100 or
      nT.y < -100 or
      nT.y > display.contentHeight + 100 )
    then
      display.remove( nT )
      table.remove( nTtableRight, i )
    end
  end
  for i = #nTtableLeft, 1, -1 do
    local nT = nTtableLeft[i]

    if ( nT.x < -100 or
      nT.x > display.contentWidth + 100 or
      nT.y < -100 or
      nT.y > display.contentHeight + 100 )
    then
      display.remove( nT )
      table.remove( nTtableLeft, i )
    end
  end
end

local function nTsAttack()
  local attackingNumber = 2
  if( #nTtableRight > 0  ) then
    attackingNumber = math.random( #nTtableRight )
  end
  for i = #nTtableRight, 1, -attackingNumber do
    local nT = nTtableRight[i]
    if( isMainCellAlive == false ) then
      nT:setSequence( "superDattackLeft" )
      nT:play()
    else
      if( nT.sequence ~= "nTtakingDamage" ) then
        nT:setSequence( "attackLeft" )
        nT:play()
      end
    end
  end
  if( #nTtableLeft > 0  ) then
    attackingNumber = math.random( #nTtableLeft )
  end
  for i = #nTtableLeft, 1, -attackingNumber do
    local nT = nTtableLeft[i]
    if( isMainCellAlive == false ) then
      nT:setSequence( "superDattackRight" )
      nT:play()
    else
      if( nT.sequence ~= "nTtakingDamage" ) then
        nT:setSequence( "attackRight" )
        nT:play()
      end
    end
  end
end

-- Clock
local function timeCounter()
  endTime = endTime + 1
end

local function gameLoop()
  nTsFactory()
  removeDriftedNts()
end

local function bossStopMovement()
  if( boss ~= nil ) then
    boss:setLinearVelocity( 0,0 )
  end
end

local function bossMoveRight( timeToMove )
  if boss ~= nil then
    if( bossMovingLeft == false and isBossTakingDamage == false ) then
      if( isBossAttacking == false ) then
        boss:setSequence( "static" )
        boss:setFrame(2)
      end
      timer.performWithDelay( timeToMove, function()
        if boss ~= nil then
          transition.to( boss, { tag="bossMove", time=timeToMove, x=( display.contentWidth-150 ),
            onComplete = function()
              if boss ~= nil then
                if( died == false ) then
                  --bossStopMovement()
                  bossMovingLeft = true
                end
              end
            end } )
        end
      end )
    end
  end
end

local function bossMoveLeft()
  if boss ~= nil then
    if( isBossTakingDamage == false ) then
      local timeToMove = math.random( 600, 1000 )
      if( isBossAttacking == false ) then
        boss:setSequence( "static" )
        boss:setFrame(1)
      end
      bossMovingLeft = true
      timer.performWithDelay( timeToMove, function()
        transition.to( boss, { tag="bossMove", time=timeToMove, x=( display.contentWidth - 540 ),
          onComplete = function()
            if boss ~= nil then
              if died == false and isBossTakingDamage == false then
                --bossStopMovement()
                bossMovingLeft = false
                bossMoveRight( timeToMove )
              end
            end
          end
        } )
      end )
    end
  end
end

local function bossStopAttack()
  if( boss ~= nil ) then
    if( isBossAttacking == true ) then
      boss:setSequence( "static" )
      if( bossMovingLeft ) then
        boss:setFrame(1)
      else
        boss:setFrame(2)
      end
      isBossAttacking = false
    end
  end
end

local function bossAttack()
  if( boss ~= nil ) then
    if( isBossAttacking == false and isBossTakingDamage == false ) then
      --bossStopMovement()
      boss:setSequence( "attackLeft" )
      boss:play()
      isBossAttacking = true
    end
  end
end

local function bossStartAttackRange()
  if( boss ~= nil ) then
    if( died == false and isBossTakingDamage == false ) then
      superDxReference = superDxPosition
      local bossAndSuperDdistance = boss.x - superDxReference
      if bossAndSuperDdistance <= 460 or bossAndSuperDdistance <= -460 then
        bossAttack()
      end
    end
  end
end

local function bossMovimentantion()
  if boss ~= nil then
    if( isBossTakingDamage == false ) then
      bossMoveLeft()
    end
  end
end

local function moveMainCellAfterBossDeath()
  timer.performWithDelay( 1, function()
    transition.to( mainCell, { tag="animationPause", time=4000, x=( display.contentCenterX + 100 ),
      onComplete = function()
        if mainCell ~= nil then
          transition.to( mainCell, { tag="animationPause", time=4000, y=( display.contentHeight - 560 ),
            onComplete = function()
              if mainCell ~= nil then
                mainCell.alpha = 1
                physics.addBody( mainCell, "static", { isSensor = false, bounce=0.1, filter={ groupIndex=-2 } } )
                mainCell.gravityScale = 0
                bossPointsLife:setSequence( "bossSubLevelMainCell" )
                bossPointsLife:setFrame( 1 )
                bossPointsLife.x = display.contentCenterX + 415
                enemyPoints = 20
                display.remove( enemyLifePoints )
                enemyLifePoints = display.newText( uiGroup, enemyPoints, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
                enemyLifePoints:setFillColor( 255, 255, 0 )
              end
            end } )
        end
      end } )
  end )
end

local function restoreBoss()
  if( boss ~= false ) then
    boss:setLinearVelocity( 0,0 )
    boss.isBodyActive = false

    -- Fade in Boss
    transition.to( boss, { tag="animationPause", alpha=1, time=500,
      onComplete = function()
        if( boss ~= nil and died == false ) then
          -- Tests
          if( enemyPoints == 0 ) then
            display.remove( boss )
            boss = nil
            moveMainCellAfterBossDeath()
          else
            isBossTakingDamage = false
            boss.isBodyActive = true
            boss:setSequence( "static" )
            boss:setFrame ("1")
            bossAttack()
          end
        end
      end
    } )
  end
end

local function endGame()
  composer.gotoScene( "game-over", { time=800, effect="crossFade" } )
end

local function passSubLevel()
  playerDataTable = loadsave.loadTable( "playerData.json" )

  if( playerDataTable.rsBossPontuation == nil ) then
    playerDataTable.isDigestiveLevel = true
    playerDataTable.rsBossPontuation = points
    playerDataTable.rsBossLifePoints = lives
    playerDataTable.rsBossUsedNucleums = generatedNucleums
  elseif( playerDataTable.rsBossLifePoints <= lives ) then
    playerDataTable.rsBossPontuation = points
    playerDataTable.rsBossLifePoints = lives
    playerDataTable.rsBossUsedNucleums = generatedNucleums
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

local function afterMainCellDeath()
  punchButton:setEnabled( false )
  jumpButton:setEnabled( false )
  moveLeftButton:setEnabled( false )
  moveRightButton:setEnabled( false )

  display.remove( superD )
  died = true
  mainCell:setSequence( "dominated" )
  mainCell:setFrame( 1 )
  bossPointsLife:setSequence( "bossSubLevelMainCellDominated" )
  bossPointsLife:setFrame( 1 )
  bossPointsLife.x = display.contentCenterX + 415
  enemyPoints = 20
  display.remove( enemyLifePoints )
  enemyLifePoints = display.newText( uiGroup, enemyPoints, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
  enemyLifePoints:setFillColor( 255, 255, 0 )

  isMainCellAlive = false
  timer.performWithDelay( 15000, function()
    passSubLevel()
  end )
end

local function restoreMainCell()
  if( mainCell ~= nil ) then
    mainCell:setLinearVelocity( 0,0 )
    mainCell.isBodyActive = false

    -- Fade in Main Cell
    transition.to( mainCell, { tag="animationPause", alpha=1, time=500,
      onComplete = function()
        if( mainCell ~= nil ) then
          -- Tests
          if( enemyPoints == 19 ) then
            isMainCellFirstHit = true
            gameLoopTimer = timer.performWithDelay( 1200, gameLoop, 0 )
            nTsAttackLoopTimer = timer.performWithDelay( math.random( 1000, 3000 ), nTsAttack, 0 )
          elseif( enemyPoints == 0 ) then
            afterMainCellDeath()
          end
          mainCell.isBodyActive = true
          if( isMainCellAlive ) then
            mainCell:setSequence( "static" )
            mainCell:setFrame("1")
          end
        end
      end
    } )
  end
end

local function onCollision( event )
  if ( event.phase == "began" ) then
    local superD
    local boss
    local mainCell
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

    if ( event.object1.myName == "boss" and event.object2.myName == "superD" ) then
      boss = event.object1
      superD = event.object2
    elseif ( event.object1.myName == "superD" and event.object2.myName == "boss" ) then
      boss = event.object2
      superD = event.object1
    end

    if ( event.object1.myName == "mainCell" and event.object2.myName == "superD" ) then
      mainCell = event.object1
      superD = event.object2
    elseif ( event.object1.myName == "superD" and event.object2.myName == "mainCell" ) then
      mainCell = event.object2
      superD = event.object1
    end

    if ( superD ~= nil and mainCell ~= nil ) then
      audio.play( hitTrack )
      if( ( superD.sequence == "attackRight" ) and superD.frame ~= 7 ) then
        mainCell:setSequence( "takingDamageRight" )
        mainCell:setFrame(1)
        mainCell.alpha = 0.5
        -- Tests
        enemyPoints = enemyPoints - 1
        --enemyPoints = 0
        display.remove( enemyLifePoints )
        enemyLifePoints = display.newText( uiGroup, enemyPoints, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
        enemyLifePoints:setFillColor( 255, 255, 0 )
        timer.performWithDelay( 1000 , restoreMainCell )
      elseif( ( superD.sequence == "attackLeft" ) and superD.frame ~= 7 ) then
        mainCell:setSequence( "takingDamageLeft" )
        mainCell:setFrame(1)
        mainCell.alpha = 0.5
        enemyPoints = enemyPoints - 1
        display.remove( enemyLifePoints )
        enemyLifePoints = display.newText( uiGroup, enemyPoints, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
        enemyLifePoints:setFillColor( 255, 255, 0 )
        timer.performWithDelay( 1000 , restoreMainCell )
      elseif ( died == false ) then
        punchButton:setEnabled( false )
        jumpButton:setEnabled( false )
        moveLeftButton:setEnabled( false )
        moveRightButton:setEnabled( false )

        if( ( superD.sequence == "static" and superD.frame == 2 ) or
          superD.sequence == "movingRight" or superD.sequence == "attackRight" ) then
          superD:setSequence( "superDtakingDamage" )
          superD:setFrame(1)
        else
          superD:setSequence( "superDtakingDamage" )
          superD:setFrame(2)
        end
        takeDamage( false, false )
        superD.alpha = 0.5
        timer.performWithDelay( 420 , restoreSuperD )
      end
    end

    if ( superD ~= nil and boss ~= nil ) then
      audio.play( hitTrack )
      if( ( superD.sequence == "attackRight" or superD.sequence == "attackLeft" ) and superD.frame ~= 7 and boss.sequence == "static" ) then
        isBossTakingDamage = true
        transition.cancel( "bossMove" )
        boss:setSequence( "takingDamageLeft" )
        boss:setFrame(1)
        boss.alpha = 0.5
        enemyPoints = enemyPoints - 1
        display.remove( enemyLifePoints )
        enemyLifePoints = display.newText( uiGroup, enemyPoints, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
        enemyLifePoints:setFillColor( 255, 255, 0 )
        timer.performWithDelay( 1000 , restoreBoss )
      end

      if( boss.sequence == "attackLeft" and died == false ) then
        punchButton:setEnabled( false )
        jumpButton:setEnabled( false )
        moveLeftButton:setEnabled( false )
        moveRightButton:setEnabled( false )

        if( ( superD.sequence == "static" and superD.frame == 2 ) or
          superD.sequence == "movingRight" or superD.sequence == "attackRight" ) then
          superD:setSequence( "superDtakingDamage" )
          superD:setFrame(1)
        else
          superD:setSequence( "superDtakingDamage" )
          superD:setFrame(2)
        end

        takeDamage( false, true )
        superD.alpha = 0.5
        timer.performWithDelay( 600, restoreSuperD )
      elseif( boss.sequence == "static" and ( superD.sequence == "movingRight" or superD.sequence == "movingLeft" or superD.sequence == "static" ) ) then
        if( ( superD.sequence == "static" and superD.frame == 2 ) or
          superD.sequence == "movingRight" or superD.sequence == "attackRight" ) then
          superD:setSequence( "superDtakingDamage" )
          superD:setFrame(1)
        else
          superD:setSequence( "superDtakingDamage" )
          superD:setFrame(2)
        end

        takeDamage( false, false )
        superD.alpha = 0.5
        timer.performWithDelay( 600, restoreSuperD )

      end
    end

    if ( superD ~= nil and nT ~= nil ) then
      if ( nT.sequence ~= "nTtakingDamage" ) then
        audio.play( hitTrack )

        if( ( superD.sequence == "attackRight" or superD.sequence == "attackLeft" ) and superD.frame ~= 7 ) then
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

            for i = #nTtableRight, 1, -1 do
              if ( nTtableRight[i] == nT ) then
                table.remove( nTtableRight, i )
                break
              end
            end
            for i = #nTtableLeft, 1, -1 do
              if ( nTtableLeft[i] == nT ) then
                table.remove( nTtableLeft, i )
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
  elseif ( event.phase == "ended" and ( superD ~= nil and nT ~= nil ) or ( superD ~= nil and boss ~= nil ) or ( superD ~= nil and mainCell ~= nil ) ) then
    if( died == true and lives == 0 or lives < 0 ) then
      timer.performWithDelay( 200, endGame )
    else
      timer.performWithDelay( 1, keepSuperDatScreen )
    end
  end
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
  local background = display.newImageRect( backGroup, "assets/img/rs-boss-background.png", display.actualContentWidth, display.actualContentHeight )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  -- Load SuperD
  superD = superDentity:getSuperD( -320, 400 )
  superDxPosition = superD.x
  superD:setFrame( 2 )
  mainGroup:insert( superD )

  -- Load Boss
  boss = bossEntity:getBoss( 900, 390 )
  mainGroup:insert( boss )
  --boss:setSequence( "attackLeft" )
  --boss:play()

  -- Load Main Cell
  mainCell = mainCellEntity:getMainCell( 700, 120 )
  backGroup:insert( mainCell )
  mainCell.alpha = alpha

  -- Load nucleum
  nucleum = nucleumEntity:getNucleum( -400, 270 )
  backGroup:insert( nucleum )
  table.insert( nucleumTable, nucleum )

  -- Load the ground
  ground = display.newRect( backGroup, display.contentCenterX, display.contentHeight - 280, display.contentWidth * 30, 10)
  ground:setFillColor(0,0,0,0)
  ground.strokeWidth = 0
  ground:setStrokeColor(0)
  ground.myName = "ground"

  -- Load platform
  platform = display.newRect( sceneGroup, display.contentCenterX-297, display.contentCenterY-13, 190, 30 )
  platform.strokeWidth = 30
  platform:setFillColor( 0,0,0,0 )
  platform:setStrokeColor( 0, 0, 0, 0 )
  platform.myName = "platform"

  -- Load LifeBar
  lifeOne = topBarEntity:getTopBar( lifeBarScale, lifeBarScale, 470, false )
  uiGroup:insert( lifeOne )

  lifeTwo = topBarEntity:getTopBar( lifeBarScale, lifeBarScale, 400, false )
  uiGroup:insert( lifeTwo )

  lifeThree = topBarEntity:getTopBar( lifeBarScale, lifeBarScale, 330, false )
  uiGroup:insert( lifeThree )

  bossPointsLife = topBarEntity:getTopBar( 0, 0, -430, false )
  uiGroup:insert( bossPointsLife )
  bossPointsLife:setSequence( "bossSubLevelBoss" )
  bossPointsLife:setFrame( 1 )

  -- Adding physics
  --physics.setGravity( 0, 20 )
  physics.addBody( superD, "dynamic", { radius=40, isSensor=false, bounce=0.1 } )
  physics.addBody( boss, "dynamic", { radius=90, isSensor=false, bounce=0.5 } )
  physics.addBody( nucleum, "static", { isSensor=true } )
  physics.addBody( ground, "static", { bounce=0.05 } )
  physics.addBody( platform, "static", { bounce=0.05, filter={ groupIndex=-2 } } )
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
    --physics.setDrawMode( "hybrid" )
    enemyLifePoints = display.newText( uiGroup, enemyPoints, display.contentCenterX + 485, display.contentHeight - 640, inputText, 40 )
    enemyLifePoints:setFillColor( 255, 255, 0 )
    Runtime:addEventListener( "collision", onCollision )
    Runtime:addEventListener( "enterFrame", bossStartAttackRange )
    -- Clock
    timeCounterTimer = timer.performWithDelay( 1000, timeCounter, 0 )
    nucleumsFactoryLoopTimer = timer.performWithDelay( math.random( 60000, 90000 ), nucleumsFactory, 0 )
    bossStopAttackLoopTimer = timer.performWithDelay( math.random( 500, 800 ), bossStopAttack, 0 )
    bossMovimentantionLoopTimer = timer.performWithDelay( math.random( 1000, 1200 ), bossMovimentantion, 0 )

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
end

-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    if( isMainCellFirstHit ) then
      timer.cancel( gameLoopTimer )
      timer.cancel( nTsAttackLoopTimer )
    end
    -- Clock
    timer.cancel( timeCounterTimer )
    timer.cancel( nucleumsFactoryLoopTimer )
    timer.cancel( bossStopAttackLoopTimer )
    timer.cancel( bossMovimentantionLoopTimer )
    -- Stop the music!
    audio.stop( 1 )
    display.remove(backGroup)
    display.remove(mainGroup)
    display.remove(uiGroup)
    boss = nil
  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    Runtime:removeEventListener( "collision", onCollision )
    Runtime:removeEventListener( "enterFrame", bossStartAttackRange )
    physics.pause()
    composer.removeScene( "rs-boss" )
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
