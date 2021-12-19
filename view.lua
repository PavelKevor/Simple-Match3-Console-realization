view = {}


function view.writeFieldToConsole(field)
  io.write("  0 1 2 3 4 5 6 7 8 9\n")
  io.write("  -------------------\n")
  for x = 0, 9 do
    io.write(x.."|")
    for y = 0,  9 do
      if field[y][x] then
        io.write(field[y][x].." ")
      else
        io.write("  ")
      end
    end
    io.write("\n")
  end
end


function view.writePointsToConsole(points)
  io.write("Your points: "..points.."\n")
end


function view.writeFinalToConsole(points)
  io.write("Your final score: "..points..":)".."\n")
end


function view.writeTextToConsole(text)
  io.write(text.."\n")
end
  

return view