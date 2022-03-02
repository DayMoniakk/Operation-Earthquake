-- This is the list of the functions I use a lot, feel free to add them to your projects using the method below
-- Put inside of your code : Utils = require("yourPath/utils")
-- Then you can use the functions, for example Utils:log("Hello World !")

local Utils = {}

-- Returns the distance between 2 objects
-- x1, y1 -> your first position x and y
-- x2, y2 -> your second position x and y
function Utils:distance (x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

-- Returns true if object 1 is colliding with object 2 (without any physics calculations, only math)
-- ax, ay -> coords of the first object
-- aw, ah -> width and height of the first object
-- bx, by -> coords of the second object
-- bw, bh -> width and height of the second object
function Utils:collision(ax, ay, aw, ah, bx, by, bw, bh)
  local ax2, ay2, bx2, by2 = ax + aw, ay + ah, bx + bw, by + bh
  return ax < bx2 and ax2 > bx and ay < by2 and ay2 > by
end

-- Returns a rgb color value from a hex color value
-- example: Utils:hexToRgb("#FFFFFF")
function Utils:hexToRgb(hex, value)
	return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, value or 1}
end

-- Returns true if the mouse is colliding with a button
-- (you have to draw your button by yourself, this only detects if the mouse is inside a rectangle or square)
function Utils:button(mouseX, mouseY, btnX, btnY, btnWidth, btnHeight)
  return mouseX >= btnX and mouseX <= btnX + btnWidth and mouseY >= btnY and mouseY <= btnY + btnHeight
end

-- Prints a log with the time displayed
function Utils:log(content)
   print("[" .. os.date('%H:%M:%S') .. "] " .. content)
end

return Utils