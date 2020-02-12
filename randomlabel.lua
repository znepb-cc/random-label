local args = { ... }

local function downloadFiles()
  shell.run("wget https://raw.githubusercontent.com/znepb-cc/random-label/master/adjectives.txt adjectives.txt")
  shell.run("wget https://raw.githubusercontent.com/znepb-cc/random-label/master/animals.txt animals.txt")
end

local function deleteFiles()
  fs.delete(shell.dir() .. "/adjectives.txt")
  fs.delete(shell.dir() .. "/animals.txt")
end

downloadFiles()

local function generateAdj()
  local adjectivesFile = fs.open(shell.dir() .. "/adjectives.txt", "r")
  local adjectives = textutils.unserialize(adjectivesFile.readAll())
  adjectivesFile.close()
  return string.lower(adjectives[math.random(1, #adjectives)])
end

local function generateAnimal()
  local animalsFile = fs.open(shell.dir() .. "/animals.txt", "r")
  local animals = textutils.unserialize(animalsFile.readAll())
  animalsFile.close()
  return string.lower(animals[math.random(1, #animals)])
end

if args[1] == "--dump" then
  local list = {}
  local labels = fs.open(shell.dir() .. "/labels.txt", "a")
  for i = 1, tonumber(args[2]) do
    labels.writeLine(generateAdj() .. " " .. generateAdj() .. " " .. generateAnimal())
  end
  labels.close()

  print("Dumped " .. args[2] .. " labels to labels.txt")
else
  local label = generateAdj() .. " " .. generateAdj() .. " " .. generateAnimal()

  os.setComputerLabel(label)
  print("Your new label has been created! It is " .. label)
  sleep(0.1)
end

deleteFiles()
