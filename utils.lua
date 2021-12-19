utils = {}

function utils.checkElement(t, elem)
    for i, v in ipairs(t) do
        if v == elem then
            return true
        end
    end

    return false
end


function utils.copy(t)
  local copy = { }
  for k, v in pairs(t) do copy[k] = v end
  return setmetatable(copy, getmetatable(t))
end

return utils