require("vector")
require("flowMap")
require("vehicle")

function love.load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	
	flowMap = FlowMap:create(10)
	flowMap:init()
	vehicle = Vehicle:create(200, 100)
end

function love.update()
	vehicle:borders()	
	vehicle:update()
	vehicle:follow(flowMap)
end

function love.draw()
	flowMap:draw()
	vehicle:draw()
end