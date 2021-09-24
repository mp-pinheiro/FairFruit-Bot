--[[
  Documentation
--]]
local Class = require("Class")

local Queue =
    Class.new(
    {},
    function(self, limit)
        self.list = {}
        self.first = 0
        self.last = -1
        self.limit = limit
    end
)

function Queue:push(value)
    local size = self.last - self.first + 1
    if size < self.limit then
        local first = self.first - 1
        self.first = first
        self.list[first] = value
    end
end

function Queue:isEmpty()
    return self.first > self.last
end

function Queue:pop()
    local last = self.last
    if self:isEmpty() then
        error("queue is empty")
    end
    local value = self.list[last]
    self.list[last] = nil -- to allow garbage collection
    self.last = last - 1
    return value
end

return Queue
