Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:create(x, y)
    local vehicle = {}
    setmetatable(vehicle, Vehicle)
    vehicle.velocity = Vector:create(0, 0)
    vehicle.acceleration = Vector:create(0, 0)
    vehicle.location = Vector:create(x, y)
    vehicle.r = 5
    vehicle.verticles = {0, -vehicle.r*2, 
                            -vehicle.r, vehicle.r*2,
                            vehicle.r, vehicle.r*2}
    vehicle.maxSpeed = 4
    vehicle.maxForce = 0.1
    vehicle.theta = 0

    return vehicle
end

function Vehicle:update()
	self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.location:add(self.velocity)
    self.acceleration:mul(0)
end

function Vehicle:appleForce(force)
	self.acceleration:add(force)
end

function Vehicle:borders()
	if self.location.x < - self.r then
        self.location.x = width + self.r
    end

    if self.location.y < - self.r then
        self.location.y = height + self.r
    end

    if self.location.x > width + self.r then
        self.location.x = - self.r
    end

    if self.location.y > height + self.r then
        self.location.y = - self.r
    end
end

function Vehicle:draw()
	local theta = self.velocity:heading() + math.pi / 2
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(theta)
    love.graphics.polygon("fill", self.verticles)
    love.graphics.pop()
end

function Vehicle:follow(flow)
	local desired = flow:lookup(self.location)
    desired:mul(self.maxSpeed)
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    self:appleForce(steer)
end

