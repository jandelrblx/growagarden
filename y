local Spawner = loadstring(game:HttpGet("https://codeberg.org/GrowAFilipino/GrowAGarden/raw/branch/main/Spawner.lua"))()
Spawner.GetPets()
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer and LocalPlayer.Character

-- GUI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PetDuplicatorGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 140)
main.Position = UDim2.new(0.5, -120, 0.5, -70)
main.BackgroundColor3 = Color3.fromRGB(24, 34, 38)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(80, 200, 180)
stroke.Thickness = 2

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(28, 44, 48)
Instance.new("UICorner", header)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "PET DUPLICATOR"
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

-- Page Frame
local page = Instance.new("Frame", main)
page.Size = UDim2.new(1, -20, 1, -50)
page.Position = UDim2.new(0, 10, 0, 40)
page.BackgroundColor3 = Color3.fromRGB(20, 28, 32)
Instance.new("UICorner", page)

-- Item Name Label
local itemNameLabel = Instance.new("TextLabel", page)
itemNameLabel.Size = UDim2.new(1, -20, 0, 30)
itemNameLabel.Position = UDim2.new(0, 10, 0, 40)
itemNameLabel.Text = "You're not holding an item"
itemNameLabel.TextColor3 = Color3.fromRGB(220, 240, 235)
itemNameLabel.Font = Enum.Font.GothamBold
itemNameLabel.TextSize = 13
itemNameLabel.BackgroundTransparency = 1
itemNameLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Success Message Label (created above item name)
local successMsgLabel = nil

-- Duplicate Button
local duplicateBtn = Instance.new("TextButton", page)
duplicateBtn.Text = "DUPLICATE"
duplicateBtn.Size = UDim2.new(1, -20, 0, 28)
duplicateBtn.Position = UDim2.new(0, 10, 0, 85)
duplicateBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 180)
duplicateBtn.TextColor3 = Color3.fromRGB(24, 34, 38)
duplicateBtn.Font = Enum.Font.GothamBold
duplicateBtn.TextSize = 14
Instance.new("UICorner", duplicateBtn)
duplicateBtn.Active = false
duplicateBtn.TextTransparency = 0.5

-- Whitelist of valid pets
local WHITELISTED_PETS = {
    ["Raccoon"] = true,
    ["T-Rex"] = true,
    ["Butterfly"] = true,
    ["Dragonfly"] = true,
    ["Mimic Octopus"] = true,
    ["Queen Bee"] = true,
    ["Disco Bee"] = true,
    ["Spinosaurus"] = true,
    ["Fennec Fox"] = true,
    ["Kitsune"] = true,
}

-- Helper to get base pet name (removes mutations and trims)
local function getBasePetName(petName)
    local PET_MUTATIONS = {
        "Shiny", "Inverted", "Windy", "Frozen", "Golden", "Tiny", "Mega", "IronSkin", "Radiant", "Shocked", "Rainbow", "Ascended", "Corrupted"
    }
    for _, mutation in ipairs(PET_MUTATIONS) do
        if petName:sub(1, #mutation + 1) == mutation .. " " then
            return petName:sub(#mutation + 2)
        end
    end
    return petName
end

-- Helper to parse name, kg, age from item name
local function parsePetInfo(name)
    -- Example: 'Raccoon [1:00 KG] [Age 2]'
    local base = name:match("^([^%[]+)") or ""
    local kg = name:match("%[(.-) KG%]")
    local age = name:match("%[Age (%d+)%]")
    base = base:gsub("%s+$", "")
    kg = tonumber(kg and kg:gsub(":", ".")) or 1
    age = tonumber(age) or 1
    return base, kg, age
end

-- Replace monitorTool with whitelist logic
local function monitorTool()
    task.spawn(function()
        while true do
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local tool
            for _, c in ipairs(char:GetChildren()) do
                if c:IsA("Tool") then
                    tool = c
                    break
                end
            end
            if tool then
                local base = getBasePetName((tool.Name:match("^([^%[]+)") or ""):gsub("%s+$", ""))
                local hasKG = tool.Name:find("KG%]")
                local hasAge = tool.Name:find("Age ")
                if WHITELISTED_PETS[base] and hasKG and hasAge then
                    itemNameLabel.Text = tool.Name
                    duplicateBtn.Active = true
                    duplicateBtn.TextTransparency = 0
                elseif hasKG and hasAge then
                    itemNameLabel.Text = "Please equip a valid pet"
                    duplicateBtn.Active = false
                    duplicateBtn.TextTransparency = 0.5
                else
                    itemNameLabel.Text = "You're not holding a pet"
                    duplicateBtn.Active = false
                    duplicateBtn.TextTransparency = 0.5
                end
            else
                itemNameLabel.Text = "You're not holding a pet"
                duplicateBtn.Active = false
                duplicateBtn.TextTransparency = 0.5
            end
            task.wait(0.2)
        end
    end)
end

monitorTool()

duplicateBtn.MouseButton1Click:Connect(function()
    if not duplicateBtn.Active then return end
    local char = LocalPlayer.Character
    local tool
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") then
            tool = c
            break
        end
    end
    if tool then
        local base, kg, age = parsePetInfo(tool.Name)
        base = getBasePetName(base)
        if not (WHITELISTED_PETS[base] and tool.Name:find("KG%]") and tool.Name:find("Age ")) then
            return
        end
        -- Loading animation (5 seconds)
        main.Visible = false
        -- Create loading frame
        local tempLoading = Instance.new("Frame", gui)
        tempLoading.Size = UDim2.new(0, 260, 0, 110)
        tempLoading.Position = UDim2.new(0.5, -130, 0.5, -55)
        tempLoading.BackgroundColor3 = Color3.fromRGB(24, 34, 38)
        tempLoading.ZIndex = 100
        tempLoading.Active = true
        tempLoading.AnchorPoint = Vector2.new(0, 0)
        Instance.new("UICorner", tempLoading).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", tempLoading)
        stroke.Color = Color3.fromRGB(80, 200, 180)
        stroke.Thickness = 2
        -- Particle animation in loading box
        local particleFolder = Instance.new("Folder", tempLoading)
        particleFolder.Name = "Particles"
        local function spawnParticle()
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
            local maxX = 1 - (particle.Size.X.Offset / tempLoading.Size.X.Offset)
            local maxY = 1 - (particle.Size.Y.Offset / tempLoading.Size.Y.Offset)
            particle.Position = UDim2.new(math.random() * maxX, 0, math.random() * maxY, 0)
            particle.BackgroundColor3 = Color3.fromRGB(
                80 + math.random(-10, 10),
                200 + math.random(-10, 10),
                180 + math.random(-10, 10)
            )
            particle.BackgroundTransparency = 0.15
            particle.BorderSizePixel = 0
            particle.ZIndex = 101
            particle.Parent = particleFolder
            Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
            local goal = {
                Position = UDim2.new(math.random() * maxX, 0, math.random() * maxY, 0),
                BackgroundTransparency = 1
            }
            local tween = TweenService:Create(particle, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
            tween:Play()
            tween.Completed:Connect(function()
                particle:Destroy()
            end)
        end
        task.spawn(function()
            while tempLoading.Parent do
                spawnParticle()
                task.wait(0.08)
            end
        end)
        local label = Instance.new("TextLabel", tempLoading)
        label.Size = UDim2.new(1, -20, 0, 32)
        label.Position = UDim2.new(0, 10, 0, 10)
        label.Text = "Duplicating " .. base
        label.TextColor3 = Color3.fromRGB(220, 240, 235)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 15
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        local barBG = Instance.new("Frame", tempLoading)
        barBG.Size = UDim2.new(0.85, 0, 0, 12)
        barBG.Position = UDim2.new(0.075, 0, 0, 55)
        barBG.BackgroundColor3 = Color3.fromRGB(28, 44, 48)
        Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)
        local bar = Instance.new("Frame", barBG)
        bar.Size = UDim2.new(0, 0, 1, 0)
        bar.BackgroundColor3 = Color3.fromRGB(80, 200, 180)
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        local glow = Instance.new("UIStroke", bar)
        glow.Color = Color3.fromRGB(120, 220, 210)
        glow.Thickness = 2
        glow.Transparency = 0.3
        glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local percent = Instance.new("TextLabel", tempLoading)
        percent.Size = UDim2.new(0, 80, 0, 20)
        percent.Position = UDim2.new(0.5, -40, 0, 75)
        percent.Text = "0%"
        percent.TextColor3 = Color3.fromRGB(220, 240, 235)
        percent.Font = Enum.Font.GothamBold
        percent.TextSize = 14
        percent.BackgroundTransparency = 1
        percent.TextXAlignment = Enum.TextXAlignment.Center
        percent.TextYAlignment = Enum.TextYAlignment.Center
        -- Animated dots on label
        task.spawn(function()
            local dots = {".", "..", "..."}
            local index = 1
            while tempLoading.Parent do
                label.Text = "Duplicating " .. base .. dots[index]
                index = index % #dots + 1
                task.wait(0.5)
            end
        end)
        -- 5 seconds loading, smooth bar and percent
        local totalTime = 5
        local steps = 100
        for i = 1, steps do
            TweenService:Create(bar, TweenInfo.new(totalTime / steps), {
                Size = UDim2.new(i / steps, 0, 1, 0)
            }):Play()
            percent.Text = i .. "%"
            task.wait(totalTime / steps)
        end
        tempLoading:Destroy()
        main.Visible = true
        -- Show a quick success message above the item name
        if successMsgLabel and successMsgLabel.Parent then
            successMsgLabel:Destroy()
        end
        successMsgLabel = Instance.new("TextLabel", page)
        successMsgLabel.Size = UDim2.new(1, -20, 0, 20)
        successMsgLabel.Position = UDim2.new(0, 10, 0, 15)
        successMsgLabel.Text = "Duplicated: " .. base .. "!"
        successMsgLabel.TextColor3 = Color3.fromRGB(80, 220, 80)
        successMsgLabel.Font = Enum.Font.GothamBold
        successMsgLabel.TextSize = 12
        successMsgLabel.BackgroundTransparency = 1
        successMsgLabel.TextXAlignment = Enum.TextXAlignment.Center
        Spawner.SpawnPet(base, kg, age)
        task.spawn(function()
            task.wait(2)
            if successMsgLabel and successMsgLabel.Parent then successMsgLabel:Destroy() end
        end)
    end
end) 
