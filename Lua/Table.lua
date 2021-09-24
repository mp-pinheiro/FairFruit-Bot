--[[
  Contains useful functions for manipulating tables.
--]]
local Table = {}

_G.unpack = _G.unpack or table.unpack

function Table.append(t1, t2)
    local newTable = {}

    for _, value in ipairs(t1) do
        newTable[#newTable + 1] = value
    end
    for _, value in ipairs(t2) do
        newTable[#newTable + 1] = value
    end

    return newTable
end

-- TODO write tests for this
function Table.shallowCopy(t)
    local tCopy = {}
    for i, v in pairs(t) do
        tCopy[i] = v
    end
    return tCopy
end

function Table.reduce(t, callback)
    local total = t[1]

    for i = 2, #t do
        total = callback(total, t[i])
    end

    return total
end

function Table.map(t, callback)
    local newTable = {}

    for key, value in pairs(t) do
        newTable[key] = callback(value, key)
    end

    return newTable
end

function Table.toSet(t)
    local set = {}

    for _, value in pairs(t) do
        set[value] = true
    end

    return set
end

function Table.setToArray(set)
    local array = {}

    for value in pairs(set) do
        array[#array + 1] = value
    end

    return array
end

function Table.random(t)
    local randomIndex = math.random(1, #t)
    return t[randomIndex]
end

function Table.generateSets(elements)
    if #elements == 0 then
        -- array with the empty set
        return {
            {}
        }
    end

    -- generate subsets without last element
    local lastElement = elements[#elements]
    local lastIndex = #elements
    elements[lastIndex] = nil
    local setsWithoutElement = Table.generateSets(elements)
    local allSets = Table.shallowCopy(setsWithoutElement)

    -- duplicate sets, but with last element this time
    for _, setWithoutElement in ipairs(setsWithoutElement) do
        local setWithElement = Table.shallowCopy(setWithoutElement)
        setWithElement[lastElement] = true

        -- add new set to allSets
        allSets[#allSets + 1] = setWithElement
    end

    -- restore element to original array
    elements[lastIndex] = lastElement

    return allSets
end

function Table.generatePermutations(elements)
    if #elements <= 1 then
        return {elements}
    end

    -- generate permutations without last element
    local lastElement = elements[#elements]
    local lastIndex = #elements
    elements[lastIndex] = nil
    local permutationsWithoutElement = Table.generatePermutations(elements)

    -- place last element at the end of each permutation
    local permutationsWithElement = {}
    for _, permutation in ipairs(permutationsWithoutElement) do
        permutation[#permutation + 1] = lastElement
        permutationsWithElement[#permutationsWithElement + 1] = permutation
    end

    -- replicate permutations, swapping the last element with each of the other ones
    local allPermutations = Table.shallowCopy(permutationsWithElement)
    for _, permutation in ipairs(permutationsWithElement) do
        for elementIndex = 1, lastIndex - 1 do
            local newPermutation = Table.shallowCopy(permutation)

            -- swap elements
            newPermutation[elementIndex], newPermutation[lastIndex] =
                newPermutation[lastIndex],
                newPermutation[elementIndex]

            allPermutations[#allPermutations + 1] = newPermutation
        end
    end

    -- restore element to original array
    elements[lastIndex] = lastElement

    return allPermutations
end

return Table
