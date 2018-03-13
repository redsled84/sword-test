bump = require "bump"
world = bump.newWorld()

direction = "right"

maxTheta = math.pi / 3
maxRadius = 50
radius = maxRadius
theta = maxTheta
minTheta = -math.pi / 3.5
thetaStep = 6
radiusStep = 45
swordActive = false
hitEnemy = false
line = {
	x1 = love.graphics.getWidth()/2,
	y1 = love.graphics.getHeight()/2,
	x2 = 0,
	y2 = 0,
}

function updateLine(dt)
	if theta > minTheta and swordActive then
		theta = theta - thetaStep * dt
		radius = radius - radiusStep * dt
	else
		radius = maxRadius
		theta = maxTheta
		swordActive = false
	end

	line.x2 = radius * math.cos(theta) + line.x1
	line.y2 = -radius * math.sin(theta) + line.y1
	-- print(theta)
end

function testLine()
	local items, len = world:querySegment(line.x1, line.y1, line.x2, line.y2)
	hitEnemy = false
	if len > 0 and swordActive then
		hitEnemy = true
	end
end

function drawLine()
	if not swordActive then return end
	love.graphics.setColor(255, 255, 255)
	love.graphics.line(line.x1, line.y1, line.x2, line.y2)
end

block = {
	x = love.graphics.getWidth()/2 + 20,
	y = 295,
	width = 20,
	height = 40,
	xv = 0,
	yv = 0
}
world:add(block, block.x, block.y, block.width, block.height)

function updateBlock(dt)
	local dx, dy = 0, 0
	if hitEnemy then
		dx = (block.x + block.width / 2 - line.x1) * 10
		dy = (block.y + block.height / 2 - line.y1) * 10
	end
	block.xv = block.xv + dx * dt
	block.yv = block.yv + dy * dt

	block.x = block.x + block.xv * dt
	block.y = block.y + block.yv * dt

	world:update(block, block.x, block.y)
end

function drawBlock()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)
end

function love.update(dt)
	updateLine(dt)
	updateBlock(dt)
	testLine()
end

function love.draw()
	drawBlock()
	drawLine()
end

function love.keypressed(key)
	if key == "space" then
		swordActive = true
	end
end