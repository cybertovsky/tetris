-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "tetris"
VERSION = "1.0.0"

-- 引入必要的库文件(lua编写), 内部库不需要require
local sys = require "sys"

print(_VERSION)

spi_lcd = spi.deviceSetup(0, pin.PB04, 0, 0, 8, 20 * 1000 * 1000, spi.MSB, 1, 1)
log.info("lcd.init", lcd.init("st7735", {
    port = "device",
    pin_dc = pin.PB01,
    pin_pwr = pin.PB00,
    pin_rst = pin.PB03,
    direction = 2,
    w = width,
    h = height,
    xoffset = 24,
    yoffset = 0
}, spi_lcd))

width = 80
height = 160
gameover = false
blockSize = width / 10

local mapPixels = {}
nowPixels = {}
local score = 0

function restart()
    score = 0
    nowPixels = {}
    mapPixels = {}
    gameover = false
end

function fromNowPixelsIntoMapPixels()
    for k, v in pairs(nowPixels) do
        table.insert(mapPixels, v)
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
        if v.y < y then
            v.y = v.y + blockSize
        end
    end
end

function checkClear()
    for y = height - blockSize, 0, -blockSize do
        local count = 0
        for x = width - blockSize, 0, -blockSize do
            for k, v in pairs(mapPixels) do
                if v.x == x and v.y == y then
                    count = count + 1
                end
            end
        end
        if count == width / blockSize then
            -- clean line blocks
            for x = width - blockSize, 0, -blockSize do
                for k, v in pairs(mapPixels) do
                    if v.x == x and v.y == y then
                        mapPixels[k] = nil
                    end
                end
            end
            score = score + 1
            mapPixelsDown(y)
        end
    end
end

function makeOneIntoNowPixels()
    local x = math.floor(math.random(0, width - blockSize * 3) / blockSize) * blockSize
    local t = math.random(0, 4)

    if t == 0 then
        p = {
            color = 0xF800,
            x = x,
            y = -1 * blockSize * 3
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xF800,
            x = x,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xF800,
            x = x + blockSize,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xF800,
            x = x + blockSize,
            y = -1 * blockSize
        }
        table.insert(nowPixels, p)
    end

    if t == 1 then
        p = {
            color = 0xFEA0,
            x = x + blockSize,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xFEA0,
            x = x,
            y = -1 * blockSize * 3
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xFEA0,
            x = x,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xFEA0,
            x = x,
            y = -1 * blockSize
        }
        table.insert(nowPixels, p)
    end

    if t == 2 then
        p = {
            color = 0x03DF,
            x = x + blockSize,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0x03DF,
            x = x + blockSize,
            y = -1 * blockSize
        }
        table.insert(nowPixels, p)
        p = {
            color = 0x03DF,
            x = x,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0x03DF,
            x = x,
            y = -1 * blockSize
        }
        table.insert(nowPixels, p)
    end

    if t == 3 then
        p = {
            color = 0xAF4D,
            x = x + blockSize,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xAF4D,
            x = x,
            y = -1 * blockSize * 3
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xAF4D,
            x = x,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xAF4D,
            x = x,
            y = -1 * blockSize
        }
        table.insert(nowPixels, p)
    end

    if t == 4 then
        p = {
            color = 0xC37D,
            x = x,
            y = -1 * blockSize * 4
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xC37D,
            x = x,
            y = -1 * blockSize * 3
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xC37D,
            x = x,
            y = -1 * blockSize * 2
        }
        table.insert(nowPixels, p)
        p = {
            color = 0xC37D,
            x = x,
            y = -1 * blockSize
        }
        table.insert(nowPixels, p)
    end

end

function drawMapPixels()
    for k, v in pairs(mapPixels) do
        lcd.fill(v.x + 1, v.y + 1, v.x + blockSize - 1, v.y + blockSize - 1, v.color)
    end
end

function drawNowPixels()
    for k, v in pairs(nowPixels) do
        lcd.fill(v.x + 1, v.y + 1, v.x + blockSize - 1, v.y + blockSize - 1, v.color)
    end
end

function drawNet()
    -- for x = 0, width, blockSize do
    --     lcd.drawLine(x, 0, x, height, 0x18C3)
    -- end
    -- for y = 0, height, blockSize do
    --     lcd.drawLine(0, y, width, y, 0x18C3)
    -- end
    lcd.drawRectangle(0, 0, 80 - 1, 160 - 1, 0x18C3)
end

sys.taskInit(function()
    gpio.setup(pin.PA04, function(val)
        if gameover then
            restart()
            return
        end
    end, gpio.PULLUP) -- 按键按下接地，因此需要上拉

    gpio.setup(pin.PA01, function(val)
        -- up
        if val == 0 then

        end
    end, gpio.PULLUP) -- 按键按下接地，因此需要上拉

    gpio.setup(pin.PA00, function(val)
        -- down
        if val == 0 then
            down()
        end
    end, gpio.PULLUP) -- 按键按下接地，因此需要上拉

    gpio.setup(pin.PB11, function(val)
        -- left
        if val == 0 then
            left()
        end
    end, gpio.PULLUP) -- 按键按下接地，因此需要上拉

    gpio.setup(pin.PA07, function(val)
        -- right
        if val == 0 then
            right()
        end
    end, gpio.PULLUP) -- 按键按下接地，因此需要上拉
    lcd.setFont(lcd.font_opposansm8)
end)

sys.timerLoopStart(function()
    -- update
    if gameover then
        return false
    end
    checkClear()
    if #nowPixels == 0 then
        makeOneIntoNowPixels()
    end
    updateNowPixels()
    checkGameIsOver()
    -- draw
    lcd.clear(0x0000)
    drawNet()
    drawMapPixels()
    drawNowPixels()
    if gameover then
        lcd.setFont(lcd.font_opposansm18)
        lcd.drawStr(2, 70, "GAME", 0x001F) -- 0x001F是蓝色，0xF800是红色。但是合宙101 颜色R和B反了，所以这里用0x001F刚好屏幕是红色。
        lcd.drawStr(2, 110, "OVER", 0x001F) -- 同上
    end
    lcd.setFont(lcd.font_opposansm8)
    lcd.drawStr(5, 20, "SCORE: " .. score, 0xFFFF)
end, 300)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
