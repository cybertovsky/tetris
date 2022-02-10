function love.keypressed(key)
  if gameover then
    if key == "r" then
      restart()
    end
    return false
  end
  if key == "w" then

  end
  if key == "s" then
    updateNowPixels()
  end
  if key == "a" then
    left()
  end
  if key == "d" then
    right()
  end
end