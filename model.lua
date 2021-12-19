require("classes")
require("utils")

model = {}
local Field = {}
local Last_move = {}
local Points = 0
local States = {"move", "falling", "new", "check"}
local State = States[1]


local function findHorisontal(check)
  check = check or false 
  local len_of_group
  local color_of_group
  local num_of_groups = 0
  local num_of_points = 0
  
  for y = 0, 9 do
    len_of_group = 0
    for x = 0, 9 do
      if x == 0 then color_of_group = Field[x][y]:getColor() end
      if Field[x][y]:getColor() == color_of_group then
        len_of_group = len_of_group + 1
      else
        if len_of_group > 2 then
          for i = 0, len_of_group-1 do
            if not check then
              Field[x-len_of_group+i][y]:Remove()
            end
            num_of_points = num_of_points + 1
          end
        end
        color_of_group = Field[x][y]:getColor()
        len_of_group = 1
      end
      if x == 9 and len_of_group > 2 then
        for i = 0, len_of_group-1 do
          if not check then
            Field[x-i][y]:Remove()
          end
          num_of_points = num_of_points + 1
        end
      end
    end
  end
  
  return num_of_points
end


local function findVertical(check)
  check = check or false
  local len_of_group
  local color_of_group
  local num_of_groups = 0
  local num_of_points = 0
  
  for x = 0, 9 do
    len_of_group = 0
    for y = 0, 9 do
      if y == 0 then color_of_group = Field[x][y]:getColor() end
      if Field[x][y]:getColor() == color_of_group then
        len_of_group = len_of_group + 1
      else
        if len_of_group > 2 then
          for i = 0, len_of_group-1 do
            if not check then
              Field[x][y-len_of_group+i]:Remove()
            end
            num_of_points = num_of_points + 1
          end
        end
        color_of_group = Field[x][y]:getColor()
        len_of_group = 1
      end
      if y == 9 and len_of_group > 2 then
        for i = 0, len_of_group-1 do
          if not check then
            Field[x][y-i]:Remove()
          end
          num_of_points = num_of_points + 1
        end
      end
    end
  end
  
  return num_of_points
end




local function fallingCrystals()
    local num_of_removed = 0
    local lower_y
    
    for x = 0, 9 do
      num_of_removed = 0
      for y = 9, 0, -1 do
        if Field[x][y]:isRemoved() then
          num_of_removed = num_of_removed + 1
          if num_of_removed == 1 then lower_y = y end
        end
        
        if not Field[x][y]:isRemoved() and num_of_removed > 0 then
          Field[x][lower_y] = utils.copy(Field[x][y])
          lower_y = lower_y - 1
          Field[x][y]:Remove()
        end
      end
    end
end


local function addNewCrystalls()
  for x = 0, 9 do
    for y = 0, 9 do
      crystal = Field[x][y]
      if crystal:isRemoved() then
        crystal:setRandomColor()
        crystal:Restore()
      end
    end
  end
end


function model.hasMoves()
  for y = 0, 9 do
    for x = 0, 8 do
      model.move({x, y} , {x+1, y})
      local out = findHorisontal(true) + findVertical(true)
      model.move({x+1, y} , {x, y})
      
      if out > 0 then
        return true
      end
    end
  end
  
  for x = 0, 9 do
    for y = 0, 8 do
      model.move({x, y} , {x, y+1})
      local out = findHorisontal(true) + findVertical(true)
      model.move({x, y+1} , {x, y})
      
      if out > 0 then
        return true
      end
    end
  end
  
  return false
  
end


function model.init()
  Points = 0
  State = States[1]
  Last_move = {}
  math.randomseed(os.time())
  local isGenerated = false
  
  while not isGenerated do
    for i = 0, 9 do
      Field[i] = {}
      for j = 0,  9 do
        local new_crystal = classes.BaseCrystal:new()
        Field[i][j] = new_crystal
      end
    end

    if findVertical(true) == 0 then
      if findHorisontal(true) == 0  then
        isGenerated = true
      end
    end
  end
end
   
  

function model.tick()
  local new_points = 0
  
  if State == States[1] then
    new_points = findHorisontal() + findVertical()
    if new_points > 0 then
      Points = Points + new_points
      State = States[2]
      return true
    else
      model.move(Last_move[2], Last_move[1])
      return false
    end
    
  elseif State == States[2] then 
    fallingCrystals()
    State = States[3]
    return true
    

  elseif State == States[3] then
    addNewCrystalls()
    State = States[4]
    new_points = findHorisontal(true) + findVertical(true)
    if new_points == 0 then
      State = States[1]
      return false
    else
      return true
    end
    
  elseif State == States[4] then
    new_points = findHorisontal() + findVertical() 
    State = States[2]
    Points = Points + new_points
    return true

  else
    error("Wrong state of model!")
  end
end


function model.move(from, to)
  Field[from[1]][from[2]], Field[to[1]][to[2]] = Field[to[1]][to[2]], Field[from[1]][from[2]]
  Last_move[1] = from
  Last_move[2] = to
end


function model.mix()
  local isGenerated = false
  while not isGenerated do
    for i = 0, 9 do
      for j = 0,  9 do
        Field[i][j]:setRandomColor()
        Field[i][j]:Restore()
      end
    end
    
    if findVertical() == 0 then
      if findHorisontal() == 0  then
        isGenerated = true
      end
    end
  end
end


function model.points()
  return Points
end


function model.dump()
  local res = {}
  for i = 0, 9 do
    res[i] = {}
    for j = 0,  9 do
      if not Field[i][j]:isRemoved() then
        res[i][j] = Field[i][j]:getColor()
      else
        res[i][j] = " "
      end
    end
  end
  return res
end


return model