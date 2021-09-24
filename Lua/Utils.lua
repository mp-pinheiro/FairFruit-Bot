local Utils = {}

local function tostring2(elem)
    if type(elem) == "string" then
        return "'" .. elem .. "'"
    else
        return tostring(elem)
    end
end

function Utils.printTable(elem, hist, tabs)
    hist = hist or {}
    tabs = tabs or 0
    if type(elem) ~= "table" then
        print(tostring2(elem))
    else
        if not hist[elem] then
            hist[elem] = true
            print(tostring2(elem) .. " {")
            tabs = tabs + 1
            for i, e in pairs(elem) do
                io.write(string.rep("\t", tabs) .. "[" .. tostring2(i) .. "] ")
                Utils.printTable(e, hist, tabs)
            end
            tabs = tabs - 1
            print(string.rep("\t", tabs) .. "}")
        else
            print(tostring2(elem) .. " {...}")
        end
    end
end

return Utils
