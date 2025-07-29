-- SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

math.randomseed(tick())

-- PET TABLE (EXTENDED)
local petChances = {
    ["Common Egg"] = {"Dog", "Bunny", "Golden Lab"},
    ["Uncommon Egg"] = {"Cat", "Chicken", "Black Bunny", "Deer"},
    ["Rare Egg"] = {"Pig", "Monkey", "Rooster", "Spotted Deer"},
    ["Night Egg"] = {"Frog", "Hedgehog", "Mole", "Echo Frog", "Night Owl", "Raccoon"},
    ["Dinosaur Egg"] = {"Raptor", "Triceratops", "Stegosaurus", "T-Rex"},
    ["Primal Egg"] = {"Parasaurolophus", "Iguanodon", "Pachycephalosaurus"},
    ["Zen Egg"] = {"Shiba Inu", "Nihonzaru", "Tanuki", "Kitsune"},
    ["Paradise Egg"] = {"Ostrich", "Peacock", "Capybara", "Mimic Octopus"},
    ["Bug Egg"] = {"Dragonfly"},
}

local ESP_ENABLED = true
local lastRandomizedPets = {} -- Store last randomized values

local divinePets = {
    ["Raccoon"] = true,
    ["Dragonfly"] = true,
    ["Mimic Octopus"] = true,
    ["Kitsune"] = true,
    ["T-Rex"] = true,
}

-- GUI SETUP
local mainGui = Instance.new("ScreenGui", CoreGui)
mainGui.Name = "EGG RANDOMIZER"
mainGui.ResetOnSpawn = false
mainGui.IgnoreGuiInset = true
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 240, 0, 120)
frame.Position = UDim2.new(0.5, -120, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header (Green Bar)
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "EGG RANDOMIZER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
local titleStroke = Instance.new("UIStroke", title)
titleStroke.Color = Color3.fromRGB(0, 0, 0)
titleStroke.Thickness = 2

-- Red X Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(function() mainGui:Destroy() end)

-- Yellow ? Info Button
local infoBtn = Instance.new("TextButton", header)
infoBtn.Text = "?"
infoBtn.Size = UDim2.new(0, 24, 0, 24)
infoBtn.Position = UDim2.new(1, -56, 0, 3)
infoBtn.BackgroundColor3 = Color3.fromRGB(255, 220, 90)
infoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
infoBtn.Font = Enum.Font.FredokaOne
infoBtn.TextSize = 14
Instance.new("UICorner", infoBtn)

infoBtn.MouseEnter:Connect(function()
    infoBtn.BackgroundColor3 = Color3.fromRGB(255, 240, 120)
end)
infoBtn.MouseLeave:Connect(function()
    infoBtn.BackgroundColor3 = Color3.fromRGB(255, 220, 90)
end)

-- Info Modal (Styled like main GUI)
infoBtn.MouseButton1Click:Connect(function()
    if mainGui:FindFirstChild("InfoModal") then return end
    frame.Visible = false
    local blur = Instance.new("BlurEffect")
    blur.Name = "ModalBlur"
    blur.Size = 16
    blur.Parent = game:GetService("Lighting")

    local modal = Instance.new("Frame", mainGui)
    modal.Name = "InfoModal"
    modal.Size = UDim2.new(0, 240, 0, 150)
    modal.Position = UDim2.new(0.5, -120, 0.5, -75)
    modal.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
    Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 8)

    local headerModal = Instance.new("Frame", modal)
    headerModal.Size = UDim2.new(1, 0, 0, 30)
    headerModal.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
    Instance.new("UICorner", headerModal).CornerRadius = UDim.new(0, 8)

    local titleModal = Instance.new("TextLabel", headerModal)
    titleModal.Size = UDim2.new(1, -30, 1, 0)
    titleModal.Position = UDim2.new(0, 10, 0, 0)
    titleModal.Text = "INFO"
    titleModal.Font = Enum.Font.FredokaOne
    titleModal.TextSize = 16
    titleModal.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleModal.TextXAlignment = Enum.TextXAlignment.Left
    titleModal.BackgroundTransparency = 1
    local titleStroke = Instance.new("UIStroke", titleModal)
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 2

    local close = Instance.new("TextButton", headerModal)
    close.Text = "X"
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -28, 0, 3)
    close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.FredokaOne
    close.TextSize = 14
    Instance.new("UICorner", close)
    close.MouseButton1Click:Connect(function()
        blur:Destroy()
        modal:Destroy()
        frame.Visible = true
    end)

    local infoLabel = Instance.new("TextLabel", modal)
    infoLabel.Size = UDim2.new(1, -20, 1, -40)
    infoLabel.Position = UDim2.new(0, 10, 0, 35)
    infoLabel.Text = "🎲 Randomize eggs to see what pets they contain!\n\n👁️ ESP shows pet info above eggs\n\n✨ Divine pets: Raccoon, Dragonfly, Mimic Octopus, Kitsune, T-Rex"
    infoLabel.TextWrapped = true
    infoLabel.Font = Enum.Font.FredokaOne
    infoLabel.TextSize = 13
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
end)

-- Page Content Area
local page = Instance.new("Frame", frame)
page.Size = UDim2.new(1, -20, 1, -40)
page.Position = UDim2.new(0, 10, 0, 35)
page.BackgroundColor3 = Color3.fromRGB(75, 50, 25)
Instance.new("UICorner", page).CornerRadius = UDim.new(0, 6)

-- RARITY TAGS
local function getRarityInfo(petName)
    if divinePets[petName] then
        return "[Divine]", Color3.fromRGB(255, 215, 0)
    end
    return "[Normal]", Color3.fromRGB(255, 255, 255)
end

-- Clear ESP
local function clearESP(model)
    local part = model:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    local old = part:FindFirstChild("PetESP")
    if old then old:Destroy() end
end

-- Show ESP
local function showPetESP(model, name)
    if not ESP_ENABLED then return end
    local part = model:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    clearESP(model)

    local espGui = Instance.new("BillboardGui", part)
    espGui.Name = "PetESP"
    espGui.Size = UDim2.new(0, 200, 0, 60)
    espGui.StudsOffset = Vector3.new(0, 3, 0)
    espGui.AlwaysOnTop = true

    local petOnly = name:match("→ (.+)")
    local rarityTag, textColor = getRarityInfo(petOnly)

    local line1 = Instance.new("TextLabel", espGui)
    line1.Size = UDim2.new(1, 0, 0.5, 0)
    line1.Position = UDim2.new(0, 0, 0, 0)
    line1.BackgroundTransparency = 1
    line1.Font = Enum.Font.GothamBold
    line1.TextScaled = true
    line1.TextColor3 = textColor
    line1.Text = rarityTag .. " " .. name

    local line2 = Instance.new("TextLabel", espGui)
    line2.Size = UDim2.new(1, 0, 0.5, 0)
    line2.Position = UDim2.new(0, 0, 0.5, 0)
    line2.BackgroundTransparency = 1
    line2.Font = Enum.Font.Gotham
    line2.TextScaled = true
    line2.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    for _, pet in ipairs(player.Character and player.Character:GetChildren() or {}) do
        if pet.Name == petOnly then
            local weight = pet:FindFirstChild("Weight")
            local age = pet:FindFirstChild("Age")
            if weight and age then
                line2.Text = "[" .. string.format("%.2f", weight.Value) .. " KG] [Age " .. age.Value .. "]"
            end
        end
    end

    if rarityTag == "[Divine]" then
        local glow = Instance.new("UIStroke", line1)
        glow.Color = textColor
        glow.Thickness = 2
        glow.Transparency = 0.2
    end
end

-- Egg Logic
local function getNearbyEggs(radius)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return {} end
    local eggs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and petChances[obj.Name] then
            local dist = (obj:GetModelCFrame().Position - root.Position).Magnitude
            if dist <= (radius or 60) then
                table.insert(eggs, obj)
            end
        end
    end
    return eggs
end

local function randomizeEggs()
    lastRandomizedPets = {} -- Clear previous values
    for _, egg in ipairs(getNearbyEggs()) do
        clearESP(egg)
        local pets = petChances[egg.Name]
        if pets then
            local pet = pets[math.random(1, #pets)]
            lastRandomizedPets[egg.Name] = pet -- Store the randomized pet
            showPetESP(egg, egg.Name .. " → " .. pet)
        end
    end
end

-- RANDOM BUTTON
local randomBtn = Instance.new("TextButton", page)
randomBtn.Size = UDim2.new(1, -20, 0, 28)
randomBtn.Position = UDim2.new(0, 10, 0, 10)
randomBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
randomBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
randomBtn.Font = Enum.Font.FredokaOne
randomBtn.TextSize = 14
randomBtn.Text = "🎲 RANDOMIZE"
Instance.new("UICorner", randomBtn)

randomBtn.MouseButton1Click:Connect(function()
    randomizeEggs()
end)

-- TOGGLE ESP
local espBtn = Instance.new("TextButton", page)
espBtn.Size = UDim2.new(1, -20, 0, 28)
espBtn.Position = UDim2.new(0, 10, 0, 45)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.FredokaOne
espBtn.TextSize = 14
espBtn.Text = "👁️ ESP: ON"
Instance.new("UICorner", espBtn)

espBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espBtn.Text = ESP_ENABLED and "👁️ ESP: ON" or "👁️ ESP: OFF"
    
    for _, egg in ipairs(getNearbyEggs()) do
        clearESP(egg)
        if ESP_ENABLED and lastRandomizedPets[egg.Name] then
            -- Use the last randomized pet value instead of generating new random
            showPetESP(egg, egg.Name .. " → " .. lastRandomizedPets[egg.Name])
        end
    end
end)
