--------------------------------------------------------
-- GLOBAL VARIABLES
--------------------------------------------------------
tiles = {}


--------------------------------------------------------
-- PLAYER
--------------------------------------------------------

Player = {}
Player.__index = Player

function Player.new(x, y, width, height)
  -- Create metatable
  local self = {}
  setmetatable(self, Player)
  
  -- Initialize variables
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  
  self.velocityX = 0
  self.velocityY = 0
  self.moveSpeed = 7
  self.jumpPower = 10
  self.gravity = 0.5
  self.isOnGround = false
  
  -- Return with object
  return self
end

-- Returns 1 if greater than 0, -1 if lower than 0, and 0 if it's just 0
function Player:sign(num)
  if num > 0 then
    return 1
  elseif num < 0 then
    return -1
  else
    return 0
  end
end


-- Returns true if a tile is overlapping with the player
function Player:tileMeeting(offsetX, offsetY)
  for i = 0, table.getn(tiles) do
    local tile = tiles[i]
    -- If tile is touching, return true and stop loop
    if (self.x + offsetX) < tile.x + tile.width and 
       (self.x + self.width) + offsetX > tile.x and 
       (self.y + offsetY) < tile.y + tile.height and 
       (self.y + self.height) + offsetY > tile.y then
      return true
    end
  end
  
  -- If no tiles were detected, return false
  return false
end



-- Update player
function Player:update()
  -- Check if on ground
  local isGrounded = self:tileMeeting(0, 1)
  
  -- Inputs
  local inputLeft = love.keyboard.isDown("left")
  local inputRight = love.keyboard.isDown("right")
  local inputJump = love.keyboard.isDown("space")
  
  -- Moving left and right
  self.velocityX = ((inputRight and 1 or 0) - (inputLeft and 1 or 0)) * self.moveSpeed
  
  -- Jumping
  if isGrounded and inputJump then
    self.velocityY = -self.jumpPower
  end
  
  -- Falling
  self.velocityY = self.velocityY + self.gravity
  
  -- Horizontal collision
  local onePixel = self:sign(self.velocityX)
  if self:tileMeeting(self.velocityX, 0) then
    -- Move as close as it can
    while not self:tileMeeting(onePixel, 0) do
      self.x = self.x + onePixel
    end
    self.velocityX = 0
  end
  -- Update x position
  self.x = self.x + self.velocityX
  
  -- Vertical collision
  onePixel = self:sign(self.velocityY)
  if self:tileMeeting(0, self.velocityY) then
    -- Move as close as it can
    while not self:tileMeeting(0, onePixel) do
      self.y = self.y + onePixel
    end
    self.velocityY = 0
  end
  -- Update y position
  self.y = self.y + self.velocityY
end


-- Draw function
function Player:draw()
  -- Draw the player
  love.graphics.setColor(255, 0, 255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  
  -- Draw text saying if the tile has been touched
  local isGroundedString = tostring(self:tileMeeting(0, 1))
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Is grounded: " .. isGroundedString, 10, 10)
end

--------------------------------------------------------
-- TILE
--------------------------------------------------------

Tile = {}
Tile.__index = Tile

function Tile.new(x, y, width, height)
  -- Create metatable
  local self = {}
  setmetatable(self, Tile)
  
  -- Initialize variables
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  
  -- Return with object
  return self
end


-- Draw tile
function Tile:draw()
  -- Draw the tile
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


--------------------------------------------------------
-- GAME LOOP
--------------------------------------------------------

-- Initialize map (Not a good way to do it, but I'm not making a level editor just for this)
for i = 0, 24 do -- Floor
  table.insert(tiles, table.getn(tiles), Tile.new(i * 32, (15 * 32), 32, 32))
end
table.insert(tiles, table.getn(tiles), Tile.new(8 * 32, (14 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(8 * 32, (13 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(4 * 32, (14 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(4 * 32, (13 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(4 * 32, (12 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(5 * 32, (11 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(4 * 32, (11 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(3 * 32, (11 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(0 * 32, (14 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(0 * 32, (13 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(15 * 32, (14 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(16 * 32, (13 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(17 * 32, (12 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(18 * 32, (11 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(19 * 32, (10 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(20 * 32, (9 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(21 * 32, (11 * 32), 32, 32))
table.insert(tiles, table.getn(tiles), Tile.new(22 * 32, (13 * 32), 32, 32))



-- Create player
local player = Player.new(400, 300, 32, 32)

-- Update function
function love.update()
  -- Update player logic
  player:update()
end


-- Draw function
function love.draw()
  -- Set clear color
  love.graphics.clear(0, 200, 255)
  
  -- Draw player position
  player:draw()
  
  -- Draw tiles
  for i = 0, table.getn(tiles) do
    tiles[i]:draw()
  end
end