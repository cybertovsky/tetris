require "key_event"

width = 160
height = 320
gameover = false
blockSize = width / 10

local mapPixels = {}
nowPixels = {}
local time = 0

local font = love.graphics.newFont("Roboto-Light.ttf",40)
local gameoverText = love.graphics.newText(font,"Game \n Over")
local scoreText = love.graphics.newText(font,"0")
local score = 0

function restart()
  time = 0
  score = 0
  scoreText:set(0)
  nowPixels = {}
  mapPixels = {}
  gameover = false
end

function love.load()
    x, y = 16, 16
    love.mouse.setVisible(false)
end

function fromNowPixelsIntoMapPixels()
  for k, v in pairs(nowPixels) do
    table.insert(mapPixels,v)
  end
  nowPixels = {}
end

function checkOverlap()
  local flag = false
  for k, v in pairs(nowPixels) do
    for kk, vv in pairs(mapPixels) do
      if v.x == vv.x and v.y == vv.y then
        flag = true
      end
    end
  end
  return flag
end

function checkOutOfScreen()
  local flag = false
  for k, v in pairs(nowPixels) do
    if v.x == -1 * blockSize then
      flag = true
    end
    if v.x == width then
      flag = true
    end
    if v.y == height then
      flag = true
    end
  end
  return flag
end

function up()
  for k, v in pairs(nowPixels) do
    v.y = v.y - blockSize
  end
end

function down()
  for k, v in pairs(nowPixels) do
    v.y = v.y + blockSize
  end
  if checkOverlap() or checkOutOfScreen() then
    up()
    fromNowPixelsIntoMapPixels()
  end
end

function left()
  for k, v in pairs(nowPixels) do
    v.x = v.x - blockSize
  end
  if checkOverlap() or checkOutOfScreen() then
    right()
  end
end

function right()  
  for k, v in pairs(nowPixels) do
    v.x = v.x + blockSize
  end
  if checkOverlap() or checkOutOfScreen() then
    left()
  end
end

function updateNowPixels()
  down()
end

function checkGameIsOver()
  for k, v in pairs(mapPixels) do
    if v.y == 0 then
      gameover = true
    end
  end
end

function mapPixelsDown(y)
  for k, v in pairs(mapPixels) do
    if v.y<y then
      v.y = v.y + blockSize
    end
  end
end

function checkClear()
  for y=height-blockSize ,0,-blockSize do
    local count = 0
    for x=width-blockSize,0,-blockSize do
      for k, v in pairs(mapPixels) do
        if v.x == x and v.y == y then
          count = count + 1
        end
      end
    end
    if count == width / blockSize then
      -- clean line blocks
      for x=width-blockSize,0,-blockSize do
        for k, v in pairs(mapPixels) do
          if v.x == x and v.y == y then
            mapPixels[k]=nil
          end
        end
      end
      score = score + 1
      scoreText:set(score)
      mapPixelsDown(y)
    end
  end
end

function makeOneIntoNowPixels()
  local r = 0
  local g = 0
  local b = 0
  
  local x = math.floor(math.random(0,width-blockSize*3)/blockSize)*blockSize
  
  local t = math.random(0,4)
  
  if t == 0 then
    r=0
    g=0
    b=1
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*3}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x+blockSize,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x+blockSize,y=-1*blockSize}
    table.insert(nowPixels,p)
  end
  
  if t == 1 then
    r=0
    g=1
    b=0
    p = {r=r,g=g,b=b,x=x+blockSize,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*3}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize}
    table.insert(nowPixels,p)
  end
  
  if t == 2 then
    r=0
    g=1
    b=1
    p = {r=r,g=g,b=b,x=x+blockSize,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x+blockSize,y=-1*blockSize}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize}
    table.insert(nowPixels,p)
  end
  
  if t == 3 then
    r=1
    g=1
    b=0
    p = {r=r,g=g,b=b,x=x+blockSize,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*3}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize}
    table.insert(nowPixels,p)
  end
  
  if t == 4 then
    r=1
    g=0.2
    b=0.2
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*4}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*3}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize*2}
    table.insert(nowPixels,p)
    p = {r=r,g=g,b=b,x=x,y=-1*blockSize}
    table.insert(nowPixels,p)
  end
  
end

function love.update(dt)
  
  if gameover then
    return false
  end
  
  checkClear()
  
  if #nowPixels == 0 then
    makeOneIntoNowPixels()
  end
  
  time = time + 1
  
  if time % 10 == 0 then
    updateNowPixels()
    checkGameIsOver()
  end
  
end

function drawMapPixels()
  for k, v in pairs(mapPixels) do
    love.graphics.setColor(v.r,v.g,v.b)
    love.graphics.rectangle("fill", v.x+1, v.y+1,blockSize-1,blockSize-1)
  end
end

function drawNowPixels()
  for k, v in pairs(nowPixels) do
    love.graphics.setColor(v.r,v.g,v.b)
    love.graphics.rectangle("fill", v.x+1, v.y+1,blockSize-1,blockSize-1)
  end
end

function drawNet()
  love.graphics.setColor(0.2, 0.2, 0.2)
  for x=0 ,width,blockSize do
    love.graphics.line(x,0,x,height)
  end
  for y=0 ,height,blockSize do
    love.graphics.line(0,y,width,y)
  end
end

function love.draw()
  drawNet()
  drawMapPixels()
  drawNowPixels()
  if gameover then
    love.graphics.setColor(1, 0, 0)
    love.graphics.draw(gameoverText, 30, 120)
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(scoreText, 5, 5)
end