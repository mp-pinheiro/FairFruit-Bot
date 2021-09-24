local Class = {}

function Class.new(class, constructor, ...)
    local parents = {...}

    --object metatable
    class.__index = class
    class.new = function(self, ...)
        if self == class then
            --create new self
            self = {}
            setmetatable(self, class)
        end

        --call parents constructors
        for _, parent in ipairs(parents) do
            parent.new(self, ...)
        end

        --call class constructor
        constructor(self, ...)
        return self
    end

    --set parent class
    if #parents == 1 then
        --single inheritance, set metatable directly for efficiency
        setmetatable(class, parents[1])
    elseif #parents > 1 then
        --multiple inheritance, make special treatment for metatable
        setmetatable(
            class,
            {
                __index = function(_, key)
                    --find first parent that has the key, and return its value
                    for _, parent in ipairs(parents) do
                        local value = parent[key]
                        if value then
                            return value
                        end
                    end
                end
            }
        )
    end

    --add class attribute
    class.class = class

    return class
end

function Class.isInstanceOf(object, class)
    local objectType = type(object)
    if objectType == class then
        return true
    elseif objectType == "table" then
        return object.class == class
    end
end

return Class
