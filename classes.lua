require "utils"

classes = {}

local colors = {"A", "B", "C", "D", "E", "F"}


classes.BaseCrystal= {}
function classes.BaseCrystal:new(color)

    local object = {}
      if utils.checkElement(colors,  color) or color == nil then
        object.color = color or colors[math.random(1, #colors)]
        object.status = true
      else
        error("Wrong color!")
      end
  
    function classes.BaseCrystal:setColor(colour)
      if utils.checkElement(colors,  colour)  then
        object.color = color or colors[math.random(1, #colors)]
      else
        error("Wrong color!")
      end
    end
  
    function classes.BaseCrystal:setRandomColor()
      self.color = colors[math.random(1, #colors)]
    end
    
    function classes.BaseCrystal:getColor()
      return self.color
    end
    
    function classes.BaseCrystal:Remove()
      self.status = false
    end
    
    function classes.BaseCrystal:Restore()
      self.status = true
    end
    
    function classes.BaseCrystal:isRemoved()
      return not self.status
    end
    
    setmetatable(object, self)
    self.__index = self;
    return object
end

return classes