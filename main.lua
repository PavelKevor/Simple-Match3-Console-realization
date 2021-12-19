require("model")
require("view")
require("utils")

local commands = {"m", "p", "q"}
local directions = {"l", "r", "u", "d"}
local numbers = {}
for i = 0, 9 do
  numbers[#numbers+1] = tostring(i)
end

local is_running = true

function readFromConsole()
  local input = {} 
  local from = {}
  local to = {}
    
  while true do
    local str = io.read()
    for i, _ in ipairs(input) do input[i] = nil end
    
    for i in string.gmatch(str, "%S+") do
      input[#input+1] = i
    end
    
    if input[1] == "p" and not input[2] then
      return "p"
    elseif input[1] == "q" and not input[2] then
      return "q"
    elseif input[1] == "m" and utils.checkElement(directions, input[4])
      and utils.checkElement(numbers, input[2]) and utils.checkElement(numbers, input[3]) then
        from = {tonumber(input[2]), tonumber(input[3])}
        if input[4] == "r" then
          to[1] = from[1]+1
          to[2] = from[2]
        elseif input[4] == "l" then
          to[1] = from[1]-1
          to[2] = from[2]
        elseif input[4] == "u" then
          to[1] = from[1]
          to[2] = from[2]-1
        elseif input[4] == "d" then
          to[1] = from[1]
          to[2] = from[2]+1
        end
         
         
        if to[1] < 0 or to[1] > 9 or to[2] < 0 or to[2] > 9 then
          io.write("Impossible move! Plz, try again:)", "\n")

        else
          return "m", from, to
        end
        
    else
      io.write("Wrong command! Plz, try again :)", "\n")
    end
  end

end



function startGame()
  
  model.init()
  while not model.hasMoves() do
    model.mix()
  end
  view.writeFieldToConsole(model.dump())
  
  while is_running do
    local cmd, fst, snd
    cmd, fst, snd = readFromConsole()
    
    if cmd == "m" then
      model.move(fst, snd)
      view.writeFieldToConsole(model.dump())
      local tick = model.tick()
      while tick do
        view.writeFieldToConsole(model.dump())
        tick = model.tick()
      end
      view.writeFieldToConsole(model.dump())
      while not model.hasMoves() do
        view.writeTextToConsole("Возможных ходов нет, поле изменено!")
        model.mix()
      end
      
    elseif cmd == "p" then
      view.writePointsToConsole(model.points())
      
    elseif cmd == "q" then
      view.writeFinalToConsole(model.points())
      is_running = false
    end
  end
end



startGame()
  