local players = game:GetService("Players")
local collectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local localPlayer = players.LocalPlayer or players:GetPlayers()[1]

local BROWN_BG = Color3.fromRGB(118, 61, 25)
local BROWN_LIGHT = Color3.fromRGB(164, 97, 43)
local BROWN_BORDER = Color3.fromRGB(51, 25, 0)
local ACCENT_GREEN = Color3.fromRGB(110, 196, 99)
local BUTTON_YELLOW = Color3.fromRGB(255, 214, 61)
local BUTTON_RED = Color3.fromRGB(255, 62, 62)
local BUTTON_GRAY = Color3.fromRGB(190, 190, 190)
local BUTTON_BLUE = Color3.fromRGB(66, 150, 255)
local BUTTON_BLUE_HOVER = Color3.fromRGB(85, 180, 255)
local BUTTON_GREEN = Color3.fromRGB(85, 200, 85)
local BUTTON_GREEN_HOVER = Color3.fromRGB(120, 230, 120)
local BUTTON_RED_HOVER = Color3.fromRGB(255, 100, 100)
local FONT = Enum.Font.FredokaOne
local TILE_IMAGE = "rbxassetid://15910695828"

local eggChances = {
    ["Common Egg"] = {["Dog"] = 33, ["Bunny"] = 33, ["Golden Lab"] = 33},
    ["Uncommon Egg"] = {["Black Bunny"] = 25, ["Chicken"] = 25, ["Cat"] = 25, ["Deer"] = 25},
    ["Rare Egg"] = {["Orange Tabby"] = 33.33, ["Spotted Deer"] = 25, ["Pig"] = 16.67, ["Rooster"] = 16.67, ["Monkey"] = 8.33},
    ["Legendary Egg"] = {["Cow"] = 42.55, ["Silver Monkey"] = 42.55, ["Sea Otter"] = 10.64, ["Turtle"] = 2.13, ["Polar Bear"] = 2.13},
    ["Mythic Egg"] = {["Grey Mouse"] = 37.5, ["Brown Mouse"] = 26.79, ["Squirrel"] = 26.79, ["Red Giant Ant"] = 8.93, ["Red Fox"] = 0},
    ["Bug Egg"] = {["Snail"] = 40, ["Giant Ant"] = 35, ["Caterpillar"] = 25, ["Praying Mantis"] = 0, ["Dragon Fly"] = 0},
    ["Night Egg"] = {["Hedgehog"] = 47, ["Mole"] = 23.5, ["Frog"] = 21.16, ["Echo Frog"] = 8.35, ["Night Owl"] = 0, ["Raccoon"] = 0},
    ["Bee Egg"] = {["Bee"] = 65, ["Honey Bee"] = 20, ["Bear Bee"] = 10, ["Petal Bee"] = 5, ["Queen Bee"] = 0},
    ["Anti Bee Egg"] = {["Wasp"] = 55, ["Tarantula Hawk"] = 31, ["Moth"] = 14, ["Butterfly"] = 0, ["Disco Bee"] = 0},
    ["Common Summer Egg"] = {["Starfish"] = 50, ["Seagull"] = 25, ["Crab"] = 25},
    ["Rare Summer Egg"] = {["Flamingo"] = 30, ["Toucan"] = 25, ["Sea Turtle"] = 20, ["Orangutan"] = 15, ["Seal"] = 10},
    ["Paradise Egg"] = {["Ostrich"] = 43, ["Peacock"] = 33, ["Capybara"] = 24, ["Scarlet Macaw"] = 3, ["Mimic Octopus"] = 1},
    ["Oasis Egg"] = {["Meerkat"] = 45, ["Sand Snake"] = 34.5, ["Axolotl"] = 15, ["Hyacinth Macaw"] = 5, ["Fennec Fox"] = 0},
    ["Dinosaur Egg"] = {["Raptor"] = 35, ["Triceratops"] = 32.5, ["Stegosaurus"] = 28, ["Pterodactyl"] = 3, ["Brontosaurus"] = 0, ["T-Rex"] = 0},
    ["Primal Egg"] = {["Parasaurolophus"] = 35, ["Iguanodon"] = 32.5, ["Pachycephalosaurus"] = 28, ["Dilophosaurus"] = 3, ["Ankylosaurus"] = 0, ["Spinosaurus"] = 0},
    ["Zen Egg"] = {["Shiba Inu"] = 40, ["Nihonzaru"] = 32, ["Tanuki"] = 20, ["Tanchozuru"] = 4.4, ["Kappa"] = 3.5, ["Kitsune"] = 0}
}
local realESP = {
    ["Common Egg"] = true, ["Uncommon Egg"] = true, ["Rare Egg"] = true,
    ["Common Summer Egg"] = true, ["Rare Summer Egg"] = true
}

local displayedEggs = {}
local autoStopOn = false

local function weightedRandom(options)
    local valid = {}
    for pet, chance in pairs(options) do
        if chance > 0 then table.insert(valid, {pet = pet, chance = chance}) end
    end
    if #valid == 0 then return nil end
    local total = 0
    for _, v in ipairs(valid) do total += v.chance end
    local roll = math.random() * total
    local cumulative = 0
    for _, v in ipairs(valid) do
        cumulative += v.chance
        if roll <= cumulative then return v.pet end
    end
    return valid[1].pet
end

local function getNonRepeatingRandomPet(eggName, lastPet)
    local pool = eggChances[eggName]
    if not pool then return nil end
    local tries, selectedPet = 0, lastPet
    while tries < 5 do
        local pet = weightedRandom(pool)
        if not pet then return nil end
        if pet ~= lastPet or math.random() < 0.3 then
            selectedPet = pet
            break
        end
        tries += 1
    end
    return selectedPet
end

local function createEspGui(object, labelText)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FakePetESP"
    billboard.Adornee = object:FindFirstChildWhichIsA("BasePart") or object.PrimaryPart or object
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText
    label.Parent = billboard

    billboard.Parent = object
    return billboard
end

local function addESP(egg)
    if egg:GetAttribute("OWNER") ~= localPlayer.Name then return end
    local eggName = egg:GetAttribute("EggName")
    local objectId = egg:GetAttribute("OBJECT_UUID")
    if not eggName or not objectId or displayedEggs[objectId] then return end

    local labelText, firstPet
    labelText = eggName

    local espGui = createEspGui(egg, labelText)
    displayedEggs[objectId] = {
        egg = egg,
        gui = espGui,
        label = espGui:FindFirstChild("TextLabel"),
        eggName = eggName,
        lastPet = firstPet
    }
end

local function removeESP(egg)
    local objectId = egg:GetAttribute("OBJECT_UUID")
    if objectId and displayedEggs[objectId] then
        displayedEggs[objectId].gui:Destroy()
        displayedEggs[objectId] = nil
    end
end

for _, egg in collectionService:GetTagged("PetEggServer") do
    addESP(egg)
end

collectionService:GetInstanceAddedSignal("PetEggServer"):Connect(addESP)
collectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(removeESP)

-- Update GUI style to match success.lua
local gui = Instance.new("ScreenGui")
gui.Name = "ZanjiEggRandomizer"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 160)
main.Position = UDim2.new(0.5, -120, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(24, 34, 38)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(80, 200, 180)
stroke.Thickness = 2

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(28, 44, 48)
Instance.new("UICorner", header)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "ZANJI: EGG RANDOMIZER"
title.TextColor3 = Color3.fromRGB(220, 240, 235)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 180)
closeBtn.TextColor3 = Color3.fromRGB(24, 34, 38)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local infoBtn = Instance.new("TextButton", header)
infoBtn.Size = UDim2.new(0, 20, 0, 20)
infoBtn.Position = UDim2.new(1, -55, 0, 8)
infoBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 210)
infoBtn.Text = "?"
infoBtn.Font = Enum.Font.GothamBold
infoBtn.TextColor3 = Color3.fromRGB(24, 34, 38)
infoBtn.TextSize = 13
Instance.new("UICorner", infoBtn)
infoBtn.MouseEnter:Connect(function()
    infoBtn.BackgroundColor3 = Color3.fromRGB(180, 240, 230)
end)
infoBtn.MouseLeave:Connect(function()
    infoBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 210)
end)

infoBtn.MouseButton1Click:Connect(function()
    if gui:FindFirstChild("InfoModal") then
        return
    end
    local blur = Instance.new("BlurEffect")
    blur.Size = 16
    blur.Name = "ModalBlur"
    blur.Parent = game:GetService("Lighting")
    local modal = Instance.new("Frame", gui)
    modal.Name = "InfoModal"
    modal.Size = UDim2.new(0, 200, 0, 90)
    modal.Position = UDim2.new(0.5, -100, 0.5, -45)
    modal.BackgroundColor3 = Color3.fromRGB(28, 44, 48)
    modal.Active = true
    modal.ZIndex = 30
    Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 8)
    local modalStroke = Instance.new("UIStroke", modal)
    modalStroke.Color = Color3.fromRGB(80, 200, 180)
    modalStroke.Thickness = 2
    local titleBar = Instance.new("Frame", modal)
    titleBar.Size = UDim2.new(1, 0, 0, 22)
    titleBar.BackgroundColor3 = Color3.fromRGB(24, 34, 38)
    Instance.new("UICorner", titleBar)
    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -24, 1, 0)
    titleLabel.Position = UDim2.new(0, 8, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ZANJI: EGG RANDOMIZER"
    titleLabel.TextColor3 = Color3.fromRGB(220, 240, 235)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local closeBtn2 = Instance.new("TextButton", titleBar)
    closeBtn2.Size = UDim2.new(0, 18, 0, 18)
    closeBtn2.Position = UDim2.new(1, -20, 0, 2)
    closeBtn2.BackgroundColor3 = Color3.fromRGB(80, 200, 180)
    closeBtn2.TextColor3 = Color3.fromRGB(24, 34, 38)
    closeBtn2.Text = "✖"
    closeBtn2.Font = Enum.Font.GothamBold
    closeBtn2.TextSize = 13
    Instance.new("UICorner", closeBtn2)
    closeBtn2.MouseEnter:Connect(function()
        closeBtn2.BackgroundColor3 = Color3.fromRGB(120, 220, 210)
    end)
    closeBtn2.MouseLeave:Connect(function()
        closeBtn2.BackgroundColor3 = Color3.fromRGB(80, 200, 180)
    end)
    closeBtn2.MouseButton1Click:Connect(function()
        if blur then blur:Destroy() end
        if modal then modal:Destroy() end
    end)
    local infoLabel = Instance.new("TextLabel", modal)
    infoLabel.Size = UDim2.new(1, -16, 1, -30)
    infoLabel.Position = UDim2.new(0, 8, 0, 26)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(220, 240, 235)
    infoLabel.Text = "Auto Stop when found:\nRaccoon, Dragonfly, Queen Bee, Red Fox, Disco Bee, Butterfly."
    infoLabel.TextWrapped = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.ZIndex = 31
    infoLabel.TextStrokeTransparency = 0.5
end)

local contentFrame = Instance.new("Frame", main)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 28, 32)
Instance.new("UICorner", contentFrame)
contentFrame.ZIndex = 2
contentFrame.Parent = main

local function updateStopBtnColors(btn)
    if autoStopOn then
        btn.BackgroundColor3 = Color3.fromRGB(85, 200, 85)
        btn.Text = "[A] Auto Stop: ON"
        btn.TextColor3 = Color3.new(1,1,1)
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 62, 62)
        btn.Text = "[A] Auto Stop: OFF"
        btn.TextColor3 = Color3.new(1,1,1)
    end
end

local function makeStyledButton(text, yPos, color, hover, onHover, onUnhover)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(220, 240, 235)
    btn.TextSize = 14
    btn.TextStrokeTransparency = 0.25
    btn.ZIndex = 2
    btn.Parent = contentFrame
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 7)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(80, 200, 180)
    btnStroke.Thickness = 1
    btn.MouseEnter:Connect(function()
        if onHover then onHover(btn) else btn.BackgroundColor3 = hover end
    end)
    btn.MouseLeave:Connect(function()
        if onUnhover then onUnhover(btn) else btn.BackgroundColor3 = color end
    end)
    return btn
end

-- Add checkboxes for Auto Stop and Automatic Reroll above their respective buttons
local function makeCheckbox(labelText, yPos, initial, onToggle)
    local frame = Instance.new("Frame", contentFrame)
    frame.Size = UDim2.new(0.9, 0, 0, 22)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 2
    local box = Instance.new("TextButton", frame)
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(0, 0, 0, 1)
    box.BackgroundColor3 = Color3.fromRGB(28, 44, 48)
    box.Text = initial and "✔" or ""
    box.Font = Enum.Font.GothamBold
    box.TextColor3 = Color3.fromRGB(80, 200, 180)
    box.TextSize = 16
    Instance.new("UICorner", box)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -28, 1, 0)
    label.Position = UDim2.new(0, 28, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 240, 235)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    local checked = initial
    box.MouseButton1Click:Connect(function()
        checked = not checked
        box.Text = checked and "✔" or ""
        onToggle(checked)
    end)
    return function(val)
        checked = val
        box.Text = checked and "✔" or ""
    end
end

-- Remove Auto Stop checkbox and Stop button
-- Only keep Automatic Reroll checkbox and a START / STOP button

-- Remove autoStopChecked and stopBtn
-- Only keep autoRerollChecked and a startStopBtn

-- Restore Auto Stop checkbox above START/STOP button
local autoStopOn = false
local autoStopChecked = makeCheckbox("Auto Stop", 0, autoStopOn, function(val)
    autoStopOn = val
end)

local autoRerollOn = false
-- Remove the custom autoRerollChecked function and use a variable for the checked state
local autoRerollCheckedState = false
local autoRerollChecked = makeCheckbox("Auto Reroll", 32, autoRerollCheckedState, function(val)
    autoRerollCheckedState = val
end)

local autoRerollThread = nil

local function doReroll()
    for objectId, data in pairs(displayedEggs) do
        local pet = getNonRepeatingRandomPet(data.eggName, data.lastPet)
        if pet and data.label then
            data.label.Text = data.eggName .. " | " .. pet
            data.lastPet = pet
        end
    end
end

local function updateStartStopBtn(btn)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    if autoRerollOn then
        btn.Text = "STOP"
        btn.BackgroundColor3 = Color3.fromRGB(255, 62, 62)
        btn.TextColor3 = Color3.fromRGB(24, 34, 38)
    else
        btn.Text = "START"
        btn.BackgroundColor3 = Color3.fromRGB(80, 200, 180)
        btn.TextColor3 = Color3.fromRGB(24, 34, 38)
    end
end

local startStopBtn = makeStyledButton(
    "START",
    68,
    Color3.fromRGB(80, 200, 180),
    Color3.fromRGB(120, 220, 210)
)

updateStartStopBtn(startStopBtn)

startStopBtn.MouseButton1Click:Connect(function()
    if not autoRerollOn then
        if autoRerollCheckedState then
            autoRerollOn = true
            updateStartStopBtn(startStopBtn)
            autoRerollThread = task.spawn(function()
                while autoRerollOn do
                    doReroll()
                    for i = 1, 40 do -- 4 seconds cooldown
                        if not autoRerollOn then break end
                        task.wait(0.1)
                    end
                end
            end)
        else
            doReroll()
        end
    else
        autoRerollOn = false
        updateStartStopBtn(startStopBtn)
    end
end)

-- Update the autoRerollChecked function to return the current checked state
-- local autoRerollCheckedState = false
-- local oldAutoRerollChecked = autoRerollChecked
-- autoRerollChecked = function(val)
--     if val ~= nil then
--         autoRerollCheckedState = val
--         oldAutoRerollChecked(val)
--     end
--     return autoRerollCheckedState
-- end

-- Reroll logic (runs every 2 seconds if enabled)
task.spawn(function()
    while true do
        if autoRerollOn then
            for objectId, data in pairs(displayedEggs) do
                local pet = getNonRepeatingRandomPet(data.eggName, data.lastPet)
                if pet and data.label then
                    data.label.Text = data.eggName .. " | " .. pet
                    data.lastPet = pet
                end
            end
        end
        task.wait(2)
    end
end)

local camera = workspace.CurrentCamera
local originalFOV
local zoomFOV = 60
local tweenTime = 0.4
local currentTween

-- Remove infoBtn and its related code
