FlowMap = {}
FlowMap.__index = FlowMap

function FlowMap:create(size)
    local map = {}
    setmetatable(map, FlowMap)
    map.field = {}
    map.size = size
    love.math.setRandomSeed(10000)
    return map
end

function FlowMap:init()
    love.math.setRandomSeed(11000)
    
    local cols = width / self.size
    local rows = height / self.size
    local xoff = 0
    local yoff = 0

    local middle_x = math.floor(cols/2)
    local middle_y = math.floor(rows/2)

    for i = 1, cols do
        yoff = 0
        self.field[i] = {}
        for j = 1, rows do
            local dx = middle_x-i + 0.5
            local dy = middle_y-j + 0.5
            local dir = 1
            local loc_x = 1
            if dx ~= 0 then
                dir = math.abs(dx)/dx
                loc_x = dir*(dy)/dx
                if math.abs(loc_x) > 1 then
                    dir = dir/math.abs(loc_x)
                    loc_x = math.abs(loc_x)/loc_x
                end
            elseif dy ~= 0 then
                loc_x = math.abs(dy)/dy
            end


            if dir<0 and loc_x < 0 or dir>0 and loc_x < 0 then
                dir = dir + 0.5
            end

            self.field[i][j] = Vector:create(loc_x, -dir)

        end
        xoff = xoff + 0.1
    end
end

function FlowMap:lookup(v)
    local row = math.constrain(math.floor(v.x/self.size)+1, 1, #self.field)
	local col = math.constrain(math.floor(v.y/self.size)+1, 1, #self.field[1])
	return self.field[row][col]:copy()
end

function FlowMap:draw()
    for i = 1, #self.field do
        for j = 1, #self.field[1] do
            drawVector(self.field[i][j], (i-1) * self.size, j * self.size, self.size - 2)
        end
    end
end

function drawVector(v, x, y, s)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(v:heading())
    local len = v:mag() * s
    love.graphics.line(0, 0, len, 0)
    love.graphics.circle("fill", len, 0, 2)
	love.graphics.pop()
end
