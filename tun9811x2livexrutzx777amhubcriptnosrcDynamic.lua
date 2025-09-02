print("Executor "..identifyexecutor())
Time = 1
repeat wait() until game:IsLoaded()
wait(Time)
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
function TPReturner()
    local Site
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' ..
            PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' ..
            PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0
    for i, v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _, Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end
function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
function Rejoin()
    local TeleportService = game:GetService("TeleportService")
    local player = game.Players.LocalPlayer
    if player then
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end
end
function Pirates()
    local args = {
        [1] = "SetTeam",
        [2] = "Pirates",
    }

    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end
function Marines()
    local args = {
        [1] = "SetTeam",
        [2] = "Marines",
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end
local Noclip = nil
local Clip = nil
function noclip()
    if Noclip then Noclip:Disconnect() end
    Clip = false
    Noclip = game:GetService('RunService').Stepped:Connect(function()
        if game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
                    v.CanCollide = false
                end
            end
        end
    end)
end
function unnoclip()
    if Noclip then Noclip:Disconnect() end
    Clip = true
    if game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA('BasePart') and v.Name ~= floatName then
                v.CanCollide = true
            end
        end
    end
end
local PlayerName = {}
local players = {}
function refreshPlayers()
    table.clear(PlayerName)
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        table.insert(PlayerName, v.Name)
    end
end
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
local blackScreen = Instance.new("Frame")
local PlayerName = {}
for i, v in pairs(game.Players:GetChildren()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
        table.insert(PlayerName, v.Name)
    end
end
local player = game.Players.LocalPlayer
local function getPlayers()
    local players = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name ~= player.Name then
            table.insert(players, v.Name)
        end
    end
    return players
end
if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
getgenv().Config = {
    Save_Member = true
}

_G.Check_Save_Setting = "CheckSaveSetting"
getgenv()['JsonEncode'] = function(msg)
    return game:GetService("HttpService"):JSONEncode(msg)
end

getgenv()['JsonDecode'] = function(msg)
    return game:GetService("HttpService"):JSONDecode(msg)
end
getgenv()['Check_Setting'] = function(Name)
    if not _G.Dis then
        if not isfolder('Dynamic Hub') then
            makefolder('Dynamic Hub')
        end
        if not isfolder('Dynamic Hub/Blox Fruit') then
            makefolder('Dynamic Hub/Blox Fruit')
        end
        if not isfile('Dynamic Hub/Blox Fruit/'..Name..'.json') then
            writefile('Dynamic Hub/Blox Fruit/'..Name..'.json', JsonEncode(getgenv().Config))
        end
    end
end
getgenv()['Get_Setting'] = function(Name)
    if not _G.Dis then
        if isfolder('Dynamic Hub') and isfile('Dynamic Hub/Blox Fruit/'..Name..'.json') then
            getgenv().Config = JsonDecode(readfile('Dynamic Hub/Blox Fruit/'..Name..'.json'))
            return getgenv().Config
        else
            getgenv()['Check_Setting'](Name)
        end
    end
end
getgenv()['Update_Setting'] = function(Name)
    if not _G.Dis then
        if isfolder('Dynamic Hub') and isfile('Dynamic Hub/Blox Fruit/'..Name..'.json') then
            writefile('Dynamic Hub/Blox Fruit/'..Name..'.json', JsonEncode(getgenv().Config))
        else
            getgenv()['Check_Setting'](Name)
        end
    end
end
getgenv()['Check_Setting'](_G.Check_Save_Setting)
getgenv()['Get_Setting'](_G.Check_Save_Setting)
if getgenv().Config.Save_Member then
    getgenv()['MyName'] = game.Players.LocalPlayer.Name
elseif getgenv().Config.Save_All_Member then
    getgenv()['MyName'] = "AllMember"
else
    getgenv()['MyName'] = "None"
    _G.Dis = true
end
getgenv()['Check_Setting'](getgenv()['MyName'])
getgenv()['Get_Setting'](getgenv()['MyName'])
getgenv().Config.Key = _G.wl_key
getgenv()['Update_Setting'](getgenv()['MyName'])
function UpdateIslandESP()
    for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then
                if v.Name ~= "Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(7, 236, 240)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)
function UpdatePlayerChams()
    for i, v in pairs(game:GetService 'Players':GetChildren()) do
        pcall(function()
            if not isnil(v.Character) then
                if ESPPlayer then
                    if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v.Character.Head)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. ' Distance')
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Team == game.Players.LocalPlayer.Team then
                            name.TextColor3 = Color3.new(0, 255, 0)
                        else
                            name.TextColor3 = Color3.new(255, 0, 0)
                        end
                    else
                        v.Character.Head['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' | ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. ' Distance\nHealth : ' .. round(v.Character.Humanoid.Health * 100 / v.Character.Humanoid.MaxHealth) .. '%')
                    end
                else
                    if v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        v.Character.Head:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateChestChams()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:FindFirstChild("Head")
    if not head then return end
    for _, chest in pairs(game.Workspace.ChestModels:GetChildren()) do
        pcall(function()
            if string.find(chest.Name, "Chest") then
                local distance = (head.Position - chest.PrimaryPart.Position).Magnitude / 3
                local distanceText = string.format("\n%d Distance", math.floor(distance))
                if ChestESP then
                    local espName = "NameEsp_ESP"
                    local existingBillboard = chest:FindFirstChild(espName)
                    if not existingBillboard then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = espName
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = chest.PrimaryPart
                        bill.AlwaysOnTop = true
                        bill.Parent = chest
                        local name = Instance.new("TextLabel")
                        name.Font = Enum.Font.GothamSemibold
                        name.TextSize = 14
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = Enum.TextYAlignment.Top
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.Parent = bill
                        existingBillboard = bill
                    end
                    local textLabel = existingBillboard:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        if chest.Name == "SilverChest" then
                            textLabel.TextColor3 = Color3.fromRGB(109, 109, 109)
                            textLabel.Text = "Silver Chest" .. distanceText
                        elseif chest.Name == "GoldChest" then
                            textLabel.TextColor3 = Color3.fromRGB(173, 158, 21)
                            textLabel.Text = "Gold Chest" .. distanceText
                        elseif chest.Name == "DiamondChest" then
                            textLabel.TextColor3 = Color3.fromRGB(85, 255, 255)
                            textLabel.Text = "Diamond Chest" .. distanceText
                        else
                            textLabel.Text = chest.Name .. distanceText
                        end
                    end
                else
                    local existingBillboard = chest:FindFirstChild("NameEsp_ESP")
                    if existingBillboard then
                        existingBillboard:Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateDevilChams()
    for i, v in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if DevilFruitESP then
                if string.find(v.Name, "Fruit") then
                    if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v.Handle)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                    else
                        v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateFlowerChams()
    for i, v in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if FlowerESP then
                    if not v:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        if v.Name == "Flower1" then
                            name.Text = ("Blue Flower" .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                            name.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if v.Name == "Flower2" then
                            name.Text = ("Red Flower" .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                            name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    else
                        v['NameEsp' .. Number].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                    end
                else
                    if v:FindFirstChild('NameEsp' .. Number) then
                        v:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateRealFruitChams()
    for i, v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitESP then
                if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                else
                    v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end
    end
    for i, v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitESP then
                if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 174, 0)
                    name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                else
                    v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end
    end
    for i, v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitESP then
                if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(251, 255, 0)
                    name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                else
                    v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end
    end
end
function UpdateIslandESP()
    for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then
                if v.Name ~= "Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(7, 236, 240)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)
function UpdatePlayerChams()
    for i, v in pairs(game:GetService 'Players':GetChildren()) do
        pcall(function()
            if not isnil(v.Character) then
                if ESPPlayer then
                    if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v.Character.Head)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. ' Distance')
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Team == game.Players.LocalPlayer.Team then
                            name.TextColor3 = Color3.new(0, 255, 0)
                        else
                            name.TextColor3 = Color3.new(255, 0, 0)
                        end
                    else
                        v.Character.Head['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' | ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude / 3) .. ' Distance\nHealth : ' .. round(v.Character.Humanoid.Health * 100 / v.Character.Humanoid.MaxHealth) .. '%')
                    end
                else
                    if v.Character.Head:FindFirstChild('NameEsp' .. Number) then
                        v.Character.Head:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateChestChams()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:FindFirstChild("Head")
    if not head then return end
    for _, chest in pairs(game.Workspace.ChestModels:GetChildren()) do
        pcall(function()
            if string.find(chest.Name, "Chest") then
                local distance = (head.Position - chest.PrimaryPart.Position).Magnitude / 3
                local distanceText = string.format("\n%d Distance", math.floor(distance))
                if ChestESP then
                    local espName = "NameEsp_ESP"
                    local existingBillboard = chest:FindFirstChild(espName)
                    if not existingBillboard then
                        local bill = Instance.new("BillboardGui")
                        bill.Name = espName
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = chest.PrimaryPart
                        bill.AlwaysOnTop = true
                        bill.Parent = chest
                        local name = Instance.new("TextLabel")
                        name.Font = Enum.Font.GothamSemibold
                        name.TextSize = 14
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = Enum.TextYAlignment.Top
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.Parent = bill
                        existingBillboard = bill
                    end
                    local textLabel = existingBillboard:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        if chest.Name == "SilverChest" then
                            textLabel.TextColor3 = Color3.fromRGB(109, 109, 109)
                            textLabel.Text = "Silver Chest" .. distanceText
                        elseif chest.Name == "Gold Chest" then
                            textLabel.TextColor3 = Color3.fromRGB(173, 158, 21)
                            textLabel.Text = "Gold Chest" .. distanceText
                        elseif chest.Name == "DiamondChest" then
                            textLabel.TextColor3 = Color3.fromRGB(85, 255, 255)
                            textLabel.Text = "Diamond Chest" .. distanceText
                        else
                            textLabel.Text = chest.Name .. distanceText
                        end
                    end
                else
                    local existingBillboard = chest:FindFirstChild("NameEsp_ESP")
                    if existingBillboard then
                        existingBillboard:Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateDevilChams()
    for i, v in pairs(game.Workspace:GetChildren()) do
        pcall(function()
            if DevilFruitESP then
                if string.find(v.Name, "Fruit") then
                    if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v.Handle)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                    else
                        v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateFlowerChams()
    for i, v in pairs(Workspace:GetChildren()) do
        pcall(function()
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if FlowerESP then
                    if not v:FindFirstChild('NameEsp' .. Number) then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name = 'NameEsp' .. Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        if v.Name == "Flower1" then
                            name.Text = ("Blue Flower" .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                            name.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if v.Name == "Flower2" then
                            name.Text = ("Red Flower" .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                            name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    else
                        v['NameEsp' .. Number].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                    end
                else
                    if v:FindFirstChild('NameEsp' .. Number) then
                        v:FindFirstChild('NameEsp' .. Number):Destroy()
                    end
                end
            end
        end)
    end
end
function UpdateRealFruitChams()
    for i, v in pairs(Workspace.AppleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitESP then
                if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                else
                    v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end
    end
    for i, v in pairs(Workspace.PineappleSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitESP then
                if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 174, 0)
                    name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                else
                    v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end
    end
    for i, v in pairs(Workspace.BananaSpawner:GetChildren()) do
        if v:IsA("Tool") then
            if RealFruitESP then
                if not v.Handle:FindFirstChild('NameEsp' .. Number) then
                    local bill = Instance.new('BillboardGui', v.Handle)
                    bill.Name = 'NameEsp' .. Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1, 200, 1, 30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel', bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1, 0, 1, 0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(251, 255, 0)
                    name.Text = (v.Name .. ' \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                else
                    v.Handle['NameEsp' .. Number].TextLabel.Text = (v.Name .. ' ' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. ' Distance')
                end
            else
                if v.Handle:FindFirstChild('NameEsp' .. Number) then
                    v.Handle:FindFirstChild('NameEsp' .. Number):Destroy()
                end
            end
        end
    end
end
spawn(function()
    while wait() do
        pcall(function()
            if MobESP then
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild('HumanoidRootPart') then
                        if not v:FindFirstChild("MobEap") then
                            local BillboardGui = Instance.new("BillboardGui")
                            local TextLabel = Instance.new("TextLabel")
                            BillboardGui.Parent = v
                            BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            BillboardGui.Active = true
                            BillboardGui.Name = "MobEap"
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.LightInfluence = 1.000
                            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                            BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                            TextLabel.Parent = BillboardGui
                            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            TextLabel.BackgroundTransparency = 1.000
                            TextLabel.Size = UDim2.new(0, 200, 0, 50)
                            TextLabel.Font = Enum.Font.GothamBold
                            TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
                            TextLabel.Text.Size = 35
                        end
                        local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position)
                            .Magnitude)
                        v.MobEap.TextLabel.Text = v.Name .. " - " .. Dis .. " Distance"
                    end
                end
            else
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("MobEap") then
                        v.MobEap:Destroy()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if SeaESP then
                for i, v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                    if v:FindFirstChild('HumanoidRootPart') then
                        if not v:FindFirstChild("Seaesps") then
                            local BillboardGui = Instance.new("BillboardGui")
                            local TextLabel = Instance.new("TextLabel")
                            BillboardGui.Parent = v
                            BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            BillboardGui.Active = true
                            BillboardGui.Name = "Seaesps"
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.LightInfluence = 1.000
                            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                            BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                            TextLabel.Parent = BillboardGui
                            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            TextLabel.BackgroundTransparency = 1.000
                            TextLabel.Size = UDim2.new(0, 200, 0, 50)
                            TextLabel.Font = Enum.Font.GothamBold
                            TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
                            TextLabel.Text.Size = 35
                        end
                        local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position)
                            .Magnitude)
                        v.Seaesps.TextLabel.Text = v.Name .. " - " .. Dis .. " Distance"
                    end
                end
            else
                for i, v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                    if v:FindFirstChild("Seaesps") then
                        v.Seaesps:Destroy()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if NpcESP then
                for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    if v:FindFirstChild('HumanoidRootPart') then
                        if not v:FindFirstChild("NpcEspes") then
                            local BillboardGui = Instance.new("BillboardGui")
                            local TextLabel = Instance.new("TextLabel")
                            BillboardGui.Parent = v
                            BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            BillboardGui.Active = true
                            BillboardGui.Name = "NpcEspes"
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.LightInfluence = 1.000
                            BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                            BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                            TextLabel.Parent = BillboardGui
                            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            TextLabel.BackgroundTransparency = 1.000
                            TextLabel.Size = UDim2.new(0, 200, 0, 50)
                            TextLabel.Font = Enum.Font.GothamBold
                            TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
                            TextLabel.Text.Size = 35
                        end
                        local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position)
                            .Magnitude)
                        v.NpcEspes.TextLabel.Text = v.Name .. " - " .. Dis .. " Distance"
                    end
                end
            else
                for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    if v:FindFirstChild("NpcEspes") then
                        v.NpcEspes:Destroy()
                    end
                end
            end
        end)
    end
end)
function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)
function UpdateIslandMirageESP()
    for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if MirageIslandESP then
                if v.Name == "Mirage Island" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)
function UpdateAfdESP()
    for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        pcall(function()
            if AfdESP then
                if v.Name == "Advanced Fruit Dealer" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui', v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel', bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name .. '   \n' .. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude / 3) .. ' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function UpdateIslandPrehistoricESP() 
    if PrehistoricESP then
        pcall(function()
            for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
                if v.Name == "Prehistoric Island" then
                    if not v:FindFirstChild("NameEsp") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")
                        BillboardGui.Parent = v
                        BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active = true
                        BillboardGui.Name = "NameEsp"
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.LightInfluence = 1.000
                        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                        TextLabel.Parent = BillboardGui
                        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency = 1.000
                        TextLabel.Size = UDim2.new(0, 200, 0, 50)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                        TextLabel.FontSize = "Size14"
                        TextLabel.TextStrokeTransparency = 0.5
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude / 10)
                    v.PrehistoricESPPart.TextLabel.Text = v.Name.."\n".."["..Dis..".."..Distance.."]"
                end
            end
        end)
    else
        for i,v in pairs (game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name == "Prehistoric Island" then
                if v:FindFirstChild("NameEsp") then
                    v.PrehistoricESPPart:Destroy()
                end
            end
        end
    end
end
function UpdateIslandKisuneESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if KitsuneIslandEsp then 
                if v.Name == "Kitsune Island" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function InfAb()
    if InfAbility then
        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            local inf = Instance.new("ParticleEmitter")
            inf.Acceleration = Vector3.new(0, 0, 0)
            inf.Archivable = true
            inf.Drag = 20
            inf.EmissionDirection = Enum.NormalId.Top
            inf.Enabled = true
            inf.Lifetime = NumberRange.new(0, 0)
            inf.LightInfluence = 0
            inf.LockedToPart = true
            inf.Name = "Agility"
            inf.Rate = 500
            local numberKeypoints2 = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 4),
            }
            inf.Size = NumberSequence.new(numberKeypoints2)
            inf.RotSpeed = NumberRange.new(9999, 99999)
            inf.Rotation = NumberRange.new(0, 0)
            inf.Speed = NumberRange.new(30, 30)
            inf.SpreadAngle = Vector2.new(0, 0, 0, 0)
            inf.Texture = ""
            inf.VelocityInheritance = 0
            inf.ZOffset = 2
            inf.Transparency = NumberSequence.new(0)
            inf.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
            inf.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end
    else
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
        end
    end
end
if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811/Fluent/refs/heads/main/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811/Fluent/refs/heads/main/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811/Fluent/refs/heads/main/InterfaceManager.lua"))()
--// Anti AFK
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(180)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
if game.PlaceId == 2753915549 then
    L_2753915549_ = true
elseif game.PlaceId == 4442272183 then
    L_4442272183_ = true
elseif game.PlaceId == 7449423635 then
    L_7449423635_ = true
end
function CheckQuest()
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if L_2753915549_ then
        if MyLevel == 1 or MyLevel <= 9 or SelectMonster == "Bandit" then
            Mon = "Bandit"
            NameQuest = "BanditQuest1"
            LevelQuest = 1
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0,
                0.341998369, 0, 0.939700544)
        elseif MyLevel == 10 or MyLevel <= 14 or SelectMonster == "Monkey" then
            Mon = "Monkey"
            NameQuest = "JungleQuest"
            LevelQuest = 1
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
        elseif MyLevel == 15 or MyLevel <= 29 or SelectMonster == "Gorilla" then
            Mon = "Gorilla"
            NameQuest = "JungleQuest"
            LevelQuest = 2
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
        elseif MyLevel == 30 or MyLevel <= 39 or SelectMonster == "Pirate" then
            Mon = "Pirate"
            NameQuest = "BuggyQuest1"
            LevelQuest = 1
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.0752, 4.10001278, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0,
                0.258804798, 0, 0.965929627)
        elseif MyLevel == 40 or MyLevel <= 59 or SelectMonster == "Brute" then
            Mon = "Brute"
            NameQuest = "BuggyQuest1"
            LevelQuest = 2
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.0752, 4.10001278, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0,
                0.258804798, 0, 0.965929627)
        elseif MyLevel == 60 or MyLevel <= 74 or SelectMonster == "Desert Bandit" then
            Mon = "Desert Bandit"
            NameQuest = "DesertQuest"
            LevelQuest = 1
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0,
                0.573571265, 0, 0.819155693)
        elseif MyLevel == 75 or MyLevel <= 89 or SelectMonster == "Desert Officer" then
            Mon = "Desert Officer"
            NameQuest = "DesertQuest"
            LevelQuest = 2
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0,
                0.573571265, 0, 0.819155693)
        elseif MyLevel == 90 or MyLevel <= 99 or SelectMonster == "Snow Bandit" then
            Mon = "Snow Bandit"
            NameQuest = "SnowQuest"
            LevelQuest = 1
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1387.18835, 86.6207504, -1295.04456, -0.25917995, 0, 0.965829313, 0, 1, 0,
                -0.965829313, 0, -0.25917995)
        elseif MyLevel == 100 or MyLevel <= 119 or SelectMonster == "Snowman" then
            Mon = "Snowman"
            NameQuest = "SnowQuest"
            LevelQuest = 2
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1387.18835, 86.6207504, -1295.04456, -0.25917995, 0, 0.965829313, 0, 1, 0,
                -0.965829313, 0, -0.25917995)
        elseif MyLevel == 120 or MyLevel <= 149 or SelectMonster == "Chief Petty Officer" then
            Mon = "Chief Petty Officer"
            NameQuest = "MarineQuest2"
            LevelQuest = 1
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, -0.422094226, -0, -0.906552136, 0, 1, -0,
                0.906552136, 0, -0.422094226)
        elseif MyLevel == 150 or MyLevel <= 174 or SelectMonster == "Sky Bandit" then
            Mon = "Sky Bandit"
            NameQuest = "SkyQuest"
            LevelQuest = 1
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.139098823, 0, 0.990278423, 0, 1, 0,
                -0.990278423, 0, 0.139098823)
        elseif MyLevel == 175 or MyLevel <= 189 or SelectMonster == "Dark Master" then
            Mon = "Dark Master"
            NameQuest = "SkyQuest"
            LevelQuest = 2
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.139098823, 0, 0.990278423, 0, 1, 0,
                -0.990278423, 0, 0.139098823)
        elseif MyLevel == 190 or MyLevel <= 209 or SelectMonster == "Prisoner" then
            Mon = "Prisoner"
            NameQuest = "PrisonerQuest"
            LevelQuest = 1
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0,
                -0.999846935, 0, 0.0175017118)
        elseif MyLevel == 210 or MyLevel <= 249 or SelectMonster == "Dangerous Prisoner" then
            Mon = "Dangerous Prisoner"
            NameQuest = "PrisonerQuest"
            LevelQuest = 2
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0,
                -0.999846935, 0, 0.0175017118)
        elseif MyLevel == 250 or MyLevel <= 274 or SelectMonster == "Toga Warrior" then
            Mon = "Toga Warrior"
            NameQuest = "ColosseumQuest"
            LevelQuest = 1
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0,
                0.857167721, 0, -0.515037298)
        elseif MyLevel == 275 or MyLevel <= 299 or SelectMonster == "Gladiator" then
            Mon = "Gladiator"
            NameQuest = "ColosseumQuest"
            LevelQuest = 2
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0,
                0.857167721, 0, -0.515037298)
        elseif MyLevel == 300 or MyLevel <= 324 or SelectMonster == "Military Soldier" then
            Mon = "Military Soldier"
            NameQuest = "MagmaQuest"
            LevelQuest = 1
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.363785148, 0, 0.93148309, 0, 1, 0,
                -0.93148309, 0, -0.363785148)
        elseif MyLevel == 325 or MyLevel <= 374 or SelectMonster == "Military Spy" then
            Mon = "Military Spy"
            NameQuest = "MagmaQuest"
            LevelQuest = 2
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.363785148, 0, 0.93148309, 0, 1, 0,
                -0.93148309, 0, -0.363785148)
        elseif MyLevel == 375 or MyLevel <= 399 or SelectMonster == "Fishman Warrior" then
            Mon = "Fishman Warrior"
            NameQuest = "FishmanQuest"
            LevelQuest = 1
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61121.1094, 17.953125, 1564.52637, -0.913477898, 0, -0.406888306, 0, 1, 0,
                0.406888306, 0, -0.913477898)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel == 400 or MyLevel <= 449 or SelectMonster == "Fishman Commando" then
            Mon = "Fishman Commando"
            NameQuest = "FishmanQuest"
            LevelQuest = 2
            NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61121.1094, 17.953125, 1564.52637, -0.913477898, 0, -0.406888306, 0, 1, 0,
                0.406888306, 0, -0.913477898)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel == 450 or MyLevel <= 474 or SelectMonster == "God's Guard" then
            Mon = "God's Guard"
            NameQuest = "SkyExp1Quest"
            LevelQuest = 1
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0,
                0.0871884301, 0, 0.996191859)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif MyLevel == 475 or MyLevel <= 524 or SelectMonster == "Shanda" then
            Mon = "Shanda"
            NameQuest = "SkyExp1Quest"
            LevelQuest = 2
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0,
                -0.906319618, 0, -0.422592998)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif MyLevel == 525 or MyLevel <= 549 or SelectMonster == "Royal Squad" then
            Mon = "Royal Squad"
            NameQuest = "SkyExp2Quest"
            LevelQuest = 1
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 550 or MyLevel <= 624 or SelectMonster == "Royal Soldier" then
            Mon = "Royal Soldier"
            NameQuest = "SkyExp2Quest"
            LevelQuest = 2
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 625 or MyLevel <= 649 or SelectMonster == "Galley Pirate" then
            Mon = "Galley Pirate"
            NameQuest = "FountainQuest"
            LevelQuest = 1
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0,
                -0.996196866, 0, 0.087131381)
        elseif MyLevel >= 650 or MyLevel >= 649 or SelectMonster == "Galley Captain" then
            Mon = "Galley Captain"
            NameQuest = "FountainQuest"
            LevelQuest = 2
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0,
                -0.996196866, 0, 0.087131381)
        end
    end
    if L_4442272183_ then
        if MyLevel == 700 or MyLevel <= 724 or SelectMonster == "Raider" then
            Mon = "Raider"
            NameQuest = "Area1Quest"
            LevelQuest = 1
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.334363222, -0, -0.942444324, 0, 1, -0,
                0.942444324, 0, -0.334363222)
        elseif MyLevel == 725 or MyLevel <= 774 or SelectMonster == "Mercenary" then
            Mon = "Mercenary"
            NameQuest = "Area1Quest"
            LevelQuest = 2
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.334363222, -0, -0.942444324, 0, 1, -0,
                0.942444324, 0, -0.334363222)
        elseif MyLevel == 775 or MyLevel <= 799 or SelectMonster == "Swan Pirate" then
            Mon = "Swan Pirate"
            NameQuest = "Area2Quest"
            LevelQuest = 1
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0,
                -0.99026376, 0, 0.139203906)
        elseif MyLevel == 800 or MyLevel <= 874 or SelectMonster == "Factory Staff" then
            Mon = "Factory Staff"
            NameQuest = "Area2Quest"
            LevelQuest = 2
            NameMon = "Factory Staff"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0,
                -0.99026376, 0, 0.139203906)
        elseif MyLevel == 875 or MyLevel <= 899 or SelectMonster == "Marine Lieutenant" then
            Mon = "Marine Lieutenant"
            NameQuest = "MarineQuest3"
            LevelQuest = 1
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0,
                -0.500031412, 0, 0.866007268)
        elseif MyLevel == 900 or MyLevel <= 949 or SelectMonster == "Marine Captain" then
            Mon = "Marine Captain"
            NameQuest = "MarineQuest3"
            LevelQuest = 2
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0,
                -0.500031412, 0, 0.866007268)
        elseif MyLevel == 950 or MyLevel <= 974 or SelectMonster == "Zombie" then
            Mon = "Zombie"
            NameQuest = "ZombieQuest"
            LevelQuest = 1
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0,
                0.95628953, 0, -0.29242146)
        elseif MyLevel == 975 or MyLevel <= 999 or SelectMonster == "Vampire" then
            Mon = "Vampire"
            NameQuest = "ZombieQuest"
            LevelQuest = 2
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0,
                0.95628953, 0, -0.29242146)
        elseif MyLevel == 1000 or MyLevel <= 1049 or SelectMonster == "Snow Trooper" then
            Mon = "Snow Trooper"
            NameQuest = "SnowMountainQuest"
            LevelQuest = 1
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.589568138, 0, 0.807719052, 0, 1, 0,
                -0.807719052, 0, -0.589568138)
        elseif MyLevel == 1050 or MyLevel <= 1099 or SelectMonster == "Winter Warrior" then
            Mon = "Winter Warrior"
            NameQuest = "SnowMountainQuest"
            LevelQuest = 2
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.589568138, 0, 0.807719052, 0, 1, 0,
                -0.807719052, 0, -0.589568138)
        elseif MyLevel == 1100 or MyLevel <= 1124 or SelectMonster == "Lab Subordinate" then
            Mon = "Lab Subordinate"
            NameQuest = "IceSideQuest"
            LevelQuest = 1
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0,
                0.891015649, 0, 0.453972578)
        elseif MyLevel == 1125 or MyLevel <= 1174 or SelectMonster == "Horned Warrior" then
            Mon = "Horned Warrior"
            NameQuest = "IceSideQuest"
            LevelQuest = 2
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0,
                0.891015649, 0, 0.453972578)
        elseif MyLevel == 1175 or MyLevel <= 1199 or SelectMonster == "Magma Ninja" then
            Mon = "Magma Ninja"
            NameQuest = "FireSideQuest"
            LevelQuest = 1
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0,
                -0.469463557, 0, -0.882952213)
        elseif MyLevel == 1200 or MyLevel <= 1249 or SelectMonster == "Lava Pirate" then
            Mon = "Lava Pirate"
            NameQuest = "FireSideQuest"
            LevelQuest = 2
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0,
                -0.469463557, 0, -0.882952213)
        elseif MyLevel == 1250 or MyLevel <= 1274 or SelectMonster == "Ship Deckhand" then
            Mon = "Ship Deckhand"
            NameQuest = "ShipQuest1"
            LevelQuest = 1
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1040.55554, 124.942924, 32909.1055, -0.642763734, 0, 0.766064942, 0, 1, 0,
                -0.766064942, 0, -0.642763734)
        elseif MyLevel == 1275 or MyLevel <= 1299 or SelectMonster == "Ship Engineer" then
            Mon = "Ship Engineer"
            NameQuest = "ShipQuest1"
            LevelQuest = 2
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1040.55554, 124.942924, 32909.1055, -0.642763734, 0, 0.766064942, 0, 1, 0,
                -0.766064942, 0, -0.642763734)
        elseif MyLevel == 1300 or MyLevel <= 1324 or SelectMonster == "Ship Steward" then
            Mon = "Ship Steward"
            NameQuest = "ShipQuest2"
            LevelQuest = 1
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(974.075439, 124.93837, 33253.6211, 0.799319565, 0, 0.600906253, 0, 1, 0,
                -0.600906253, 0, 0.799319565)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(923.212524, 125.086975, 32852.832))
            end
        elseif MyLevel == 1325 or MyLevel <= 1349 or SelectMonster == "Ship Officer" then
            Mon = "Ship Officer"
            NameQuest = "ShipQuest2"
            LevelQuest = 2
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(974.075439, 124.93837, 33253.6211, 0.799319565, 0, 0.600906253, 0, 1, 0,
                -0.600906253, 0, 0.799319565)
        elseif MyLevel == 1350 or MyLevel <= 1374 or SelectMonster == "Arctic Warrior" then
            Mon = "Arctic Warrior"
            NameQuest = "FrostQuest"
            LevelQuest = 1
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0,
                0.358349502, 0, -0.933587909)
        elseif MyLevel == 1375 or MyLevel <= 1424 or SelectMonster == "Snow Lurker" then
            Mon = "Snow Lurker"
            NameQuest = "FrostQuest"
            LevelQuest = 2
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0,
                0.358349502, 0, -0.933587909)
        elseif MyLevel == 1425 or MyLevel <= 1449 or SelectMonster == "Sea Soldier" then
            Mon = "Sea Soldier"
            NameQuest = "ForgottenQuest"
            LevelQuest = 1
            NameMon = "Sea Soldier"
            CFrameQuest = CFrame.new(-3054.44458, 238.344269, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0,
                0.13915664, 0, 0.990270376)
        elseif MyLevel == 1450 or MyLevel >= 1449 or SelectMonster == "Water Fighter" then
            Mon = "Water Fighter"
            NameQuest = "ForgottenQuest"
            LevelQuest = 2
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054.44458, 238.344269, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0,
                0.13915664, 0, 0.990270376)
        end
    end
    if L_7449423635_ then
        if MyLevel == 1500 or MyLevel <= 1524 or SelectMonster == "Pirate Millionaire" then
            Mon = "Pirate Millionaire"
            NameQuest = "PiratePortQuest"
            LevelQuest = 1
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.912899733, -0, -0.408183903, 0, 1, -0,
                0.408183903, 0, 0.912899733)
        elseif MyLevel == 1525 or MyLevel <= 1574 or SelectMonster == "Pistol Billionaire" then
            Mon = "Pistol Billionaire"
            NameQuest = "PiratePortQuest"
            LevelQuest = 2
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-450.104645, 107.681458, 5950.72607, 0.912899733, -0, -0.408183903, 0, 1, -0,
                0.408183903, 0, 0.912899733)
        elseif MyLevel == 1575 or MyLevel <= 1599 or SelectMonster == "Dragon Crew Warrior" then
            Mon = "Dragon Crew Warrior"
            NameQuest = "DragonCrewQuest"
            LevelQuest = 1
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(6735.11084, 126.990463, -711.097961, 0.629286051, 0, -0.777173758, 0, 1, 0,
                0.777173758, 0, 0.629286051)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(5753.5478515625, 610.7880859375, -282.33172607421875))
            end
        elseif MyLevel == 1600 or MyLevel <= 1624 or SelectMonster == "Dragon Crew Archer" then
            Mon = "Dragon Crew Archer"
            NameQuest = "DragonCrewQuest"
            LevelQuest = 2
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(6735.11084, 126.990463, -711.097961, 0.629286051, 0, -0.777173758, 0, 1, 0,
                0.777173758, 0, 0.629286051)
        elseif MyLevel == 1625 or MyLevel <= 1649 or SelectMonster == "Hydra Enforcer" then
            Mon = "Hydra Enforcer"
            NameQuest = "VenomCrewQuest"
            LevelQuest = 1
            NameMon = "Hydra Enforcer"
            CFrameQuest = CFrame.new(5214.33936, 1003.46765, 759.507324, 0.92051065, 0, 0.390717506, 0, 1, 0,
                -0.390717506, 0, 0.92051065)
        elseif MyLevel == 1650 or MyLevel <= 1699 or SelectMonster == "Venomous Assailant" then
            Mon = "Venomous Assailant"
            NameQuest = "VenomCrewQuest"
            LevelQuest = 2
            NameMon = "Venomous Assailant"
            CFrameQuest = CFrame.new(5214.33936, 1003.46765, 759.507324, 0.92051065, 0, 0.390717506, 0, 1, 0,
                -0.390717506, 0, 0.92051065)
        elseif MyLevel == 1700 or MyLevel <= 1724 or SelectMonster == "Marine Commodore" then
            Mon = "Marine Commodore"
            NameQuest = "MarineTreeIsland"
            LevelQuest = 1
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2485.7334, 73.345993, -6788.62549, -0.427591443, 0, 0.903972208, 0, 1, 0,
                -0.903972208, 0, -0.427591443)
        elseif MyLevel == 1725 or MyLevel <= 1774 or SelectMonster == "Marine Rear Admiral" then
            Mon = "Marine Rear Admiral"
            NameQuest = "MarineTreeIsland"
            LevelQuest = 2
            NameMon = "Marine Rear Admiral"
            CFrameQuest = CFrame.new(2485.7334, 73.345993, -6788.62549, -0.427591443, 0, 0.903972208, 0, 1, 0,
                -0.903972208, 0, -0.427591443)
        elseif MyLevel == 1775 or MyLevel <= 1799 or SelectMonster == "Fishman Raider" then
            Mon = "Fishman Raider"
            NameQuest = "DeepForestIsland3"
            LevelQuest = 1
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10582.759765625, 331.78845214844, -8757.666015625)
        elseif MyLevel == 1800 or MyLevel <= 1824 or SelectMonster == "Fishman Captain" then
            Mon = "Fishman Captain"
            NameQuest = "DeepForestIsland3"
            LevelQuest = 2
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10583.099609375, 331.78845214844, -8759.4638671875)
            if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                    Vector3.new(-12468.5380859375, 375.0094299316406, -7554.62548828125))
            end
        elseif MyLevel == 1825 or MyLevel <= 1849 or SelectMonster == "Forest Pirate" then
            Mon = "Forest Pirate"
            NameQuest = "DeepForestIsland"
            LevelQuest = 1
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13232.662109375, 332.40396118164, -7626.4819335938)
        elseif MyLevel == 1850 or MyLevel <= 1899 or SelectMonster == "Mythological Pirate" then
            Mon = "Mythological Pirate"
            NameQuest = "DeepForestIsland"
            LevelQuest = 2
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13232.662109375, 332.40396118164, -7626.4819335938)
        elseif MyLevel == 1900 or MyLevel <= 1924 or SelectMonster == "Jungle Pirate" then
            Mon = "Jungle Pirate"
            NameQuest = "DeepForestIsland2"
            LevelQuest = 1
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
        elseif MyLevel == 1925 or MyLevel <= 1974 or SelectMonster == "Musketeer Pirate" then
            Mon = "Musketeer Pirate"
            NameQuest = "DeepForestIsland2"
            LevelQuest = 2
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
        elseif MyLevel == 1975 or MyLevel <= 1999 or SelectMonster == "Reborn Skeleton" then
            Mon = "Reborn Skeleton"
            NameQuest = "HauntedQuest1"
            LevelQuest = 1
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9480.80762, 142.130661, 5566.37305, -0.00655503059, 4.52954225e-08,
                -0.999978542, 2.04920472e-08, 1, 4.51620679e-08, 0.999978542, -2.01955679e-08, -0.00655503059)
        elseif MyLevel == 2000 or MyLevel <= 2024 or SelectMonster == "Living Zombie" then
            Mon = "Living Zombie"
            NameQuest = "HauntedQuest1"
            LevelQuest = 2
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9480.80762, 142.130661, 5566.37305, -0.00655503059, 4.52954225e-08,
                -0.999978542, 2.04920472e-08, 1, 4.51620679e-08, 0.999978542, -2.01955679e-08, -0.00655503059)
        elseif MyLevel == 2025 or MyLevel <= 2049 or SelectMonster == "Demonic Soul" then
            Mon = "Demonic Soul"
            NameQuest = "HauntedQuest2"
            LevelQuest = 1
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
        elseif MyLevel == 2050 or MyLevel <= 2074 or SelectMonster == "Posessed Mummy" then
            Mon = "Posessed Mummy"
            NameQuest = "HauntedQuest2"
            LevelQuest = 2
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9516.9931640625, 178.00651550293, 6078.4653320313)
        elseif MyLevel == 2075 or MyLevel <= 2099 or SelectMonster == "Peanut Scout" then
            Mon = "Peanut Scout"
            NameQuest = "NutsIslandQuest"
            LevelQuest = 1
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2105.53198, 37.2495995, -10195.5088, -0.766061664, 0, -0.642767608, 0, 1, 0,
                0.642767608, 0, -0.766061664)
        elseif MyLevel == 2100 or MyLevel <= 2124 or SelectMonster == "Peanut President" then
            Mon = "Peanut President"
            NameQuest = "NutsIslandQuest"
            LevelQuest = 2
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2105.53198, 37.2495995, -10195.5088, -0.766061664, 0, -0.642767608, 0, 1, 0,
                0.642767608, 0, -0.766061664)
        elseif MyLevel == 2125 or MyLevel <= 2149 or SelectMonster == "Ice Cream Chef" then
            Mon = "Ice Cream Chef"
            NameQuest = "IceCreamIslandQuest"
            LevelQuest = 1
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0,
                -0.642767608, 0, -0.766061664)
        elseif MyLevel == 2150 or MyLevel <= 2199 or SelectMonster == "Ice Cream Commander" then
            Mon = "Ice Cream Commander"
            NameQuest = "IceCreamIslandQuest"
            LevelQuest = 2
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0,
                -0.642767608, 0, -0.766061664)
        elseif MyLevel == 2200 or MyLevel <= 2224 or SelectMonster == "Cookie Crafter" then
            Mon = "Cookie Crafter"
            NameQuest = "CakeQuest1"
            LevelQuest = 1
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2022.29858, 36.9275894, -12030.9766, -0.961273909, 0, -0.275594592, 0, 1, 0,
                0.275594592, 0, -0.961273909)
        elseif MyLevel == 2225 or MyLevel <= 2249 or SelectMonster == "Cake Guard" then
            Mon = "Cake Guard"
            NameQuest = "CakeQuest1"
            LevelQuest = 2
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2022.29858, 36.9275894, -12030.9766, -0.961273909, 0, -0.275594592, 0, 1, 0,
                0.275594592, 0, -0.961273909)
        elseif MyLevel == 2250 or MyLevel <= 2274 or SelectMonster == "Baking Staff" then
            Mon = "Baking Staff"
            NameQuest = "CakeQuest2"
            LevelQuest = 1
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1928.31763, 37.7296638, -12840.626, 0.951068401, -0, -0.308980465, 0, 1, -0,
                0.308980465, 0, 0.951068401)
        elseif MyLevel == 2275 or MyLevel <= 2299 or SelectMonster == "Head Baker" then
            Mon = "Head Baker"
            NameQuest = "CakeQuest2"
            LevelQuest = 2
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1928.31763, 37.7296638, -12840.626, 0.951068401, -0, -0.308980465, 0, 1, -0,
                0.308980465, 0, 0.951068401)
        elseif MyLevel == 2300 or MyLevel <= 2324 or SelectMonster == "Cocoa Warrior" then
            Mon = "Cocoa Warrior"
            NameQuest = "ChocQuest1"
            LevelQuest = 1
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        elseif MyLevel == 2325 or MyLevel <= 2349 or SelectMonster == "Chocolate Bar Battler" then
            Mon = "Chocolate Bar Battler"
            NameQuest = "ChocQuest1"
            LevelQuest = 2
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        elseif MyLevel == 2350 or MyLevel <= 2374 or SelectMonster == "Sweet Thief" then
            Mon = "Sweet Thief"
            NameQuest = "ChocQuest2"
            LevelQuest = 1
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0,
                -0.906319618, 0, 0.422592998)
        elseif MyLevel == 2375 or MyLevel <= 2400 or SelectMonster == "Candy Rebel" then
            Mon = "Candy Rebel"
            NameQuest = "ChocQuest2"
            LevelQuest = 2
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0,
                -0.906319618, 0, 0.422592998)
        elseif MyLevel == 2400 or MyLevel <= 2424 or SelectMonster == "Candy Pirate" then
            Mon = "Candy Pirate"
            NameQuest = "CandyQuest1"
            LevelQuest = 1
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1166, 60, -14492)
        elseif MyLevel == 2425 or MyLevel <= 2449 or SelectMonster == "Snow Demon" then
            Mon = "Snow Demon"
            NameQuest = "CandyQuest1"
            LevelQuest = 2
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1166, 60, -14492)
        elseif MyLevel == 2450 or MyLevel <= 2474 or SelectMonster == "Isle Outlaw" then
            Mon = "Isle Outlaw"
            NameQuest = "TikiQuest1"
            LevelQuest = 1
            NameMon = "Isle Outlaw"
            CFrameQuest = CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0,
                0.977032006, 0, 0.213092566)
        elseif MyLevel == 2475 or MyLevel <= 2499 or SelectMonster == "Island Boy" then
            Mon = "Island Boy"
            NameQuest = "TikiQuest1"
            LevelQuest = 2
            NameMon = "Island Boy"
            CFrameQuest = CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0,
                0.977032006, 0, 0.213092566)
        elseif MyLevel == 2500 or MyLevel <= 2524 or SelectMonster == "Sun-kissed Warrior" then
            Mon = "Sun-kissed Warrior"
            NameQuest = "TikiQuest2"
            LevelQuest = 1
            NameMon = "Sun-"
            CFrameQuest = CFrame.new(-16541.0215, 54.770813, 1051.46118, 0.0410757065, -0, -0.999156058, 0, 1, -0,
                0.999156058, 0, 0.0410757065)
        elseif MyLevel == 2525 or MyLevel <= 2549 or SelectMonster == "Isle Champion" then
            Mon = "Isle Champion"
            NameQuest = "TikiQuest2"
            LevelQuest = 2
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16541.0215, 54.770813, 1051.46118, 0.0410757065, -0, -0.999156058, 0, 1, -0,
                0.999156058, 0, 0.0410757065)
        elseif MyLevel == 2550 or MyLevel <= 2574 then
            Mon = "Serpent Hunter"
            NameQuest = "TikiQuest3"
            LevelQuest = 1
            NameMon = "Serpent Hunter"
            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0,
                0.308980465, 0, 0.951068401)
        elseif MyLevel == 2575 or MyLevel <= 2599 then
            Mon = "Skull Slayer"
            NameQuest = "TikiQuest3"
            LevelQuest = 2
            NameMon = "Skull Slayer"
            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, 0.951068401, -0, -0.308980465, 0, 1, -0,
                0.308980465, 0, 0.951068401)
        elseif MyLevel == 2600 or MyLevel <= 2624 then
            Mon = "Reef Bandit"
            NameQuest = "SubmergedQuest1"
            LevelQuest = 1
            NameMon = "Reef Bandit"
            CFrameQuest = CFrame.new(10780.6396, -2088.41406, 9260.4541, -0.953751206, 0, 0.300598353, 0, 1, 0, -0.300598353, 0, -0.953751206)
                if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-16271.3271484375, 25.233417510986328, 1370.41943359375))
        elseif MyLevel == 2625 or MyLevel <= 2649 then
            Mon = "Coral Pirate"
            NameQuest = "SubmergedQuest1"
            LevelQuest = 2
            NameMon = "Coral Pirate"
            CFrameQuest = CFrame.new(10780.6396, -2088.41406, 9260.4541, -0.953751206, 0, 0.300598353, 0, 1, 0, -0.300598353, 0, -0.953751206)
                if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-16271.3271484375, 25.233417510986328, 1370.41943359375))
        elseif MyLevel == 2650 or MyLevel <= 2674 then
            Mon = "Sea Chanter"
            NameQuest = "SubmergedQuest2"
            LevelQuest = 1
            NameMon = "Sea Chanter"
            CFrameQuest = CFrame.new(10883.5986, -2086.88892, 10034.0195, 0.99651581, 0, 0.0834043249, 0, 1, 0, -0.0834043249, 0, 0.99651581)
                if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(10533.2861328125, -2029.0860595703125, 9940.482421875))
        elseif MyLevel >= 2675 then
            Mon = "Ocean Prophet"
            NameQuest = "SubmergedQuest2"
            LevelQuest = 2
            NameMon = "Ocean Prophet"
            CFrameQuest = CFrame.new(10883.5986, -2086.88892, 10034.0195, 0.99651581, 0, 0.0834043249, 0, 1, 0, -0.0834043249, 0, 0.99651581)
                if _G['Auto Farm Level'] and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-16271.3271484375, 25.233417510986328, 1370.41943359375))
            end
        end
    end
end
end
function CheckMon()
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if L_2753915549_ then
        if MyLevel == 1 or MyLevel <= 9 or SelectMonster == "Bandit" then
            CFrameMon1 = CFrame.new(922, 50, 1543)
            CFrameMon2 = CFrame.new(1195, 41, 1600)
            CFrameMon3 = CFrame.new(1317, 39, 1521)
            CFrameMon4 = nil
        elseif MyLevel == 10 or MyLevel <= 14 or SelectMonster == "Monkey" then
            CFrameMon1 = CFrame.new(-1409, 58, 175)
            CFrameMon2 = CFrame.new(-1677, 57, -91)
            CFrameMon3 = CFrame.new(-1795, 57, 104)
            CFrameMon4 = CFrame.new(-1644, 65, 359)
        elseif MyLevel == 15 or MyLevel <= 29 or SelectMonster == "Gorilla" then
            CFrameMon1 = CFrame.new(-1264, 95, -494)
            CFrameMon2 = nil
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 30 or MyLevel <= 39 or SelectMonster == "Pirate" then
            CFrameMon1 = CFrame.new(-1205, 53, 3930)
            CFrameMon2 = nil
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 40 or MyLevel <= 59 or SelectMonster == "Brute" then
            CFrameMon1 = CFrame.new(-1385, 68, 4234)
            CFrameMon2 = CFrame.new(-1153, 96, 4356)
            CFrameMon3 = CFrame.new(-896, 60, 4282)
            CFrameMon4 = nil
        elseif MyLevel == 60 or MyLevel <= 74 or SelectMonster == "Desert Bandit" then
            CFrameMon1 = CFrame.new(928, 56, 4485)
            CFrameMon2 = nil
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 75 or MyLevel <= 89 or SelectMonster == "Desert Officer" then
            CFrameMon1 = CFrame.new(1611, 48, 4376)
            CFrameMon2 = nil
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 90 or MyLevel <= 99 or SelectMonster == "Snow Bandit" then
            CFrameMon1 = CFrame.new(1415, 112, -1431)
            CFrameMon2 = CFrame.new(1261, 122, -1358)
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 100 or MyLevel <= 119 or SelectMonster == "Snowman" then
            CFrameMon1 = CFrame.new(1056, 143, -1445)
            CFrameMon2 = CFrame.new(1217, 139, -1603)
            CFrameMon3 = CFrame.new(1056, 143, -1445)
            CFrameMon4 = CFrame.new(1217, 139, -1603)
        elseif MyLevel == 120 or MyLevel <= 149 or SelectMonster == "Chief Petty Officer" then
            CFrameMon1 = CFrame.new(-4936, 60, 4006)
            CFrameMon2 = CFrame.new(-4665, 66, 4505)
            CFrameMon3 = CFrame.new(-4936, 60, 4006)
            CFrameMon4 = CFrame.new(-4665, 66, 4505)
        elseif MyLevel == 150 or MyLevel <= 174 or SelectMonster == "Sky Bandit" then
            CFrameMon1 = CFrame.new(-4884, 321, -2793)
            CFrameMon2 = CFrame.new(-5085, 326, -2864)
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 175 or MyLevel <= 189 or SelectMonster == "Dark Master" then
            CFrameMon1 = CFrame.new(-5161, 435, -2311)
            CFrameMon2 = CFrame.new(-5303, 433, -2163)
            CFrameMon3 = CFrame.new(-5161, 435, -2311)
            CFrameMon4 = CFrame.new(-5303, 433, -2163)
        elseif MyLevel == 190 or MyLevel <= 209 or SelectMonster == "Prisoner" then
            CFrameMon1 = CFrame.new(4978, 53, 593)
            CFrameMon2 = CFrame.new(5232, 59, 435)
            CFrameMon3 = CFrame.new(4978, 53, 593)
            CFrameMon4 = CFrame.new(5232, 59, 435)
        elseif MyLevel == 210 or MyLevel <= 249 or SelectMonster == "Dangerous Prisoner" then
            CFrameMon1 = CFrame.new(5547, 60, 542)
            CFrameMon2 = CFrame.new(5595, 54, 900)
            CFrameMon3 = CFrame.new(5099, 59, 1034)
            CFrameMon4 = nil
        elseif MyLevel == 250 or MyLevel <= 274 or SelectMonster == "Toga Warrior" then
            CFrameMon1 = CFrame.new(-1774, 53, -2771)
            CFrameMon2 = CFrame.new(-2086, 56, -2813)
            CFrameMon3 = CFrame.new(-1774, 53, -2771)
            CFrameMon4 = CFrame.new(-2086, 56, -2813)
        elseif MyLevel == 275 or MyLevel <= 299 or SelectMonster == "Gladiator" then
            CFrameMon1 = CFrame.new(-1229, 56, -3087)
            CFrameMon2 = CFrame.new(-1149, 52, -3331)
            CFrameMon3 = CFrame.new(-1410, 59, -3482)
            CFrameMon4 = CFrame.new(-1488, 62, -3224)
        elseif MyLevel == 300 or MyLevel <= 324 or SelectMonster == "Military Soldier" then
            CFrameMon1 = CFrame.new(-5470, 48, 8368)
            CFrameMon2 = CFrame.new(-5697, 39, 8426)
            CFrameMon3 = CFrame.new(-5292, 39, 8621)
            CFrameMon4 = nil
        elseif MyLevel == 325 or MyLevel <= 374 or SelectMonster == "Military Spy" then
            CFrameMon1 = CFrame.new(-5856, 108, 8841)
            CFrameMon2 = nil
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 375 or MyLevel <= 399 or SelectMonster == "Fishman Warrior" then
            CFrameMon1 = CFrame.new(60956, 61, 1714)
            CFrameMon2 = CFrame.new(60783, 58, 1585)
            CFrameMon3 = CFrame.new(60911, 58, 1292)
            CFrameMon4 = nil
        elseif MyLevel == 400 or MyLevel <= 449 or SelectMonster == "Fishman Commando" then
            CFrameMon1 = CFrame.new(61744, 55, 1562)
            CFrameMon2 = CFrame.new(61784, 72, 1333)
            CFrameMon3 = CFrame.new(62036, 61, 1392)
            CFrameMon4 = CFrame.new(61904, 52, 1667)
        elseif MyLevel == 450 or MyLevel <= 474 or SelectMonster == "God's Guard" then
            CFrameMon1 = CFrame.new(-4839, 892, -1840)
            CFrameMon2 = CFrame.new(-4607, 883, -2002)
            CFrameMon3 = CFrame.new(-4839, 892, -1840)
            CFrameMon4 = CFrame.new(-4607, 883, -2002)
        elseif MyLevel == 475 or MyLevel <= 524 or SelectMonster == "Shanda" then
            CFrameMon1 = CFrame.new(-7753, 5577, -537)
            CFrameMon2 = CFrame.new(-7571, 5592, -627)
            CFrameMon3 = CFrame.new(-7617, 5591, -415)
            CFrameMon4 = nil
        elseif MyLevel == 525 or MyLevel <= 549 or SelectMonster == "Royal Squad" then
            CFrameMon1 = CFrame.new(-7829, 5653, -1367)
            CFrameMon2 = CFrame.new(-7598, 5654, -1490)
            CFrameMon3 = CFrame.new(-7829, 5653, -1367)
            CFrameMon4 = CFrame.new(-7598, 5654, -1490)
        elseif MyLevel == 550 or MyLevel <= 624 or SelectMonster == "Royal Soldier" then
            CFrameMon1 = CFrame.new(-7909, 5660, -1643)
            CFrameMon2 = CFrame.new(-7739, 5656, -1842)
            CFrameMon3 = CFrame.new(-7909, 5660, -1643)
            CFrameMon4 = CFrame.new(-7739, 5656, -1842)
        elseif MyLevel == 625 or MyLevel <= 649 or SelectMonster == "Galley Pirate" then
            CFrameMon1 = CFrame.new(5422, 87, 3977)
            CFrameMon2 = CFrame.new(5714, 81, 3955)
            CFrameMon3 = CFrame.new(5422, 87, 3977)
            CFrameMon4 = CFrame.new(5714, 81, 3955)
        elseif MyLevel >= 650 or MyLevel >= 649 or SelectMonster == "Galley Captain" then
            CFrameMon1 = CFrame.new(5460, 104, 4912)
            CFrameMon2 = CFrame.new(5724, 90, 4938)
            CFrameMon3 = CFrame.new(5919, 86, 4845)
            CFrameMon4 = nil
        end
    end
    if L_4442272183_ then
        if MyLevel == 700 or MyLevel <= 724 or SelectMonster == "Raider" then
            CFrameMon1 = CFrame.new(-723, 113, 2403)
            CFrameMon2 = CFrame.new(-364, 113, 2389)
            CFrameMon3 = CFrame.new(165, 90, 2304)
            CFrameMon4 = CFrame.new(375, 97, 2282)
        elseif MyLevel == 725 or MyLevel <= 774 or SelectMonster == "Mercenary" then
            CFrameMon1 = CFrame.new(-959, 136, 1688)
            CFrameMon2 = CFrame.new(-1004, 119, 1407)
            CFrameMon3 = CFrame.new(-1111, 148, 1089)
            CFrameMon4 = nil
        elseif MyLevel == 775 or MyLevel <= 799 or SelectMonster == "Swan Pirate" then
            CFrameMon1 = CFrame.new(856, 119, 1136)
            CFrameMon2 = CFrame.new(876, 130, 1368)
            CFrameMon3 = CFrame.new(1052, 132, 1172)
            CFrameMon4 = nil
        elseif MyLevel == 800 or MyLevel <= 874 or SelectMonster == "Factory Staff" then
            CFrameMon1 = CFrame.new(848, 132, 120)
            CFrameMon2 = CFrame.new(426, 133, 82)
            CFrameMon3 = CFrame.new(-55, 123, -42)
            CFrameMon4 = CFrame.new(-418, 127, -379)
        elseif MyLevel == 875 or MyLevel <= 899 or SelectMonster == "Marine Lieutenant" then
            CFrameMon1 = CFrame.new(-2694, 128, -3081)
            CFrameMon2 = CFrame.new(-3027, 109, -3043)
            CFrameMon3 = CFrame.new(-3265, 120, -2970)
            CFrameMon4 = nil
        elseif MyLevel == 900 or MyLevel <= 949 or SelectMonster == "Marine Captain" then
            CFrameMon1 = CFrame.new(-2184, 123, -3301)
            CFrameMon2 = CFrame.new(-1911, 121, -3205)
            CFrameMon3 = CFrame.new(-1630, 118, -3332)
            CFrameMon4 = nil
        elseif MyLevel == 950 or MyLevel <= 974 or SelectMonster == "Zombie" then
            CFrameMon1 = CFrame.new(-5598, 104, -924)
            CFrameMon2 = CFrame.new(-5787, 103, -764)
            CFrameMon3 = CFrame.new(-5584, 106, -578)
            CFrameMon4 = nil
        elseif MyLevel == 975 or MyLevel <= 999 or SelectMonster == "Vampire" then
            CFrameMon1 = CFrame.new(-6183, 76, -1178)
            CFrameMon2 = CFrame.new(-5804, 82, -1452)
            CFrameMon3 = CFrame.new(-6183, 76, -1178)
            CFrameMon4 = CFrame.new(-5804, 82, -1452)
        elseif MyLevel == 1000 or MyLevel <= 1049 or SelectMonster == "Snow Trooper" then
            CFrameMon1 = CFrame.new(613, 454, -5503)
            CFrameMon2 = CFrame.new(475, 455, -5315)
            CFrameMon3 = CFrame.new(370, 452, -5091)
            CFrameMon4 = nil
        elseif MyLevel == 1050 or MyLevel <= 1099 or SelectMonster == "Winter Warrior" then
            CFrameMon1 = CFrame.new(1340, 488, -5311)
            CFrameMon2 = CFrame.new(1064, 464, -5043)
            CFrameMon3 = nil
            CFrameMon4 = nil
        elseif MyLevel == 1100 or MyLevel <= 1124 or SelectMonster == "Lab Subordinate" then
            CFrameMon1 = CFrame.new(-5703, 60, -4600)
            CFrameMon2 = CFrame.new(-5946, 54, -4417)
            CFrameMon3 = CFrame.new(-5690, 67, -4328)
            CFrameMon4 = nil
        elseif MyLevel == 1125 or MyLevel <= 1174 or SelectMonster == "Horned Warrior" then
            CFrameMon1 = CFrame.new(-6165, 71, -5923)
            CFrameMon2 = CFrame.new(-6398, 82, -5875)
            CFrameMon3 = CFrame.new(-6506, 74, -5677)
            CFrameMon4 = nil
        elseif MyLevel == 1175 or MyLevel <= 1199 or SelectMonster == "Magma Ninja" then
            CFrameMon1 = CFrame.new(-5686, 95, -5649)
            CFrameMon2 = CFrame.new(-5676, 88, -5897)
            CFrameMon3 = CFrame.new(-5226, 81, -5973)
            CFrameMon4 = CFrame.new(-5232, 91, -6263)
        elseif MyLevel == 1200 or MyLevel <= 1249 or SelectMonster == "Lava Pirate" then
            CFrameMon1 = CFrame.new(-5368, 77, -4868)
            CFrameMon2 = CFrame.new(-5377, 92, -4609)
            CFrameMon3 = CFrame.new(-5102, 68, -4724)
            CFrameMon4 = CFrame.new(-5280, 62, -4384)
        elseif MyLevel == 1250 or MyLevel <= 1274 or SelectMonster == "Ship Deckhand" then
            CFrameMon1 = CFrame.new(1186, 166, 32946)
            CFrameMon2 = CFrame.new(1212, 153, 33182)
            CFrameMon3 = CFrame.new(641, 168, 32966)
            CFrameMon4 = CFrame.new(611, 155, 33134)
        elseif MyLevel == 1275 or MyLevel <= 1299 or SelectMonster == "Ship Engineer" then
            CFrameMon1 = CFrame.new(840, 73, 32714)
            CFrameMon2 = CFrame.new(797, 84, 32968)
            CFrameMon3 = CFrame.new(1036, 82, 33027)
            CFrameMon4 = CFrame.new(1019, 74, 32728)
        elseif MyLevel == 1300 or MyLevel <= 1324 or SelectMonster == "Ship Steward" then
            CFrameMon1 = CFrame.new(817, 153, 33363)
            CFrameMon2 = CFrame.new(810, 156, 33495)
            CFrameMon3 = CFrame.new(1022, 155, 33515)
            CFrameMon4 = CFrame.new(1030, 157, 33370)
        elseif MyLevel == 1325 or MyLevel <= 1349 or SelectMonster == "Ship Officer" then
            CFrameMon1 = CFrame.new(612, 232, 33289)
            CFrameMon2 = CFrame.new(1051, 226, 33349)
            CFrameMon3 = CFrame.new(1292, 228, 33264)
            CFrameMon4 = nil
        elseif MyLevel == 1350 or MyLevel <= 1374 or SelectMonster == "Arctic Warrior" then
            CFrameMon1 = CFrame.new(5831, 74, -6246)
            CFrameMon2 = CFrame.new(6071, 64, -6345)
            CFrameMon3 = CFrame.new(6216, 58, -6144)
            CFrameMon4 = CFrame.new(5990, 81, -6183)
        elseif MyLevel == 1375 or MyLevel <= 1424 or SelectMonster == "Snow Lurker" then
            CFrameMon1 = CFrame.new(5711, 84, -6692)
            CFrameMon2 = CFrame.new(5496, 90, -6678)
            CFrameMon3 = CFrame.new(5500, 80, -6940)
            CFrameMon4 = nil
        elseif MyLevel == 1425 or MyLevel <= 1449 or SelectMonster == "Sea Soldier" then
            CFrameMon1 = CFrame.new(-3016, 112, -9768)
            CFrameMon2 = CFrame.new(-2692, 117, -9823)
            CFrameMon3 = CFrame.new(-3016, 112, -9768)
            CFrameMon4 = CFrame.new(-3317, 102, -9768)
        elseif MyLevel == 1450 or MyLevel >= 1449 or SelectMonster == "Water Fighter" then
            CFrameMon1 = CFrame.new(-3339, 287, -10330)
            CFrameMon2 = CFrame.new(-3359, 295, -10546)
            CFrameMon3 = CFrame.new(-3423, 295, -10734)
            CFrameMon4 = CFrame.new(-3565, 297, -10462)
        end
    end
    if L_7449423635_ then
        if MyLevel == 1500 or MyLevel <= 1524 or SelectMonster == "Pirate Millionaire" then
            CFrameMon1 = CFrame.new(-340, 60, 5544)
            CFrameMon2 = CFrame.new(-123, 108, 5755)
            CFrameMon3 = CFrame.new(-340, 60, 5544)
            CFrameMon4 = CFrame.new(-652, 101, 5619)
        elseif MyLevel == 1525 or MyLevel <= 1574 or SelectMonster == "Pistol Billionaire" then
            CFrameMon1 = CFrame.new(-108, 124, 6058)
            CFrameMon2 = CFrame.new(-251, 125, 6310)
            CFrameMon3 = CFrame.new(-837, 110, 6114)
            CFrameMon4 = CFrame.new(-722, 126, 5845)
        elseif MyLevel == 1575 or MyLevel <= 1599 or SelectMonster == "Dragon Crew Warrior" then
            CFrameMon1 = CFrame.new(7087, 118, -683)
            CFrameMon2 = CFrame.new(6828, 121, -934)
            CFrameMon3 = CFrame.new(6592, 125, -1138)
            CFrameMon4 = CFrame.new(6859, 134, -841)
        elseif MyLevel == 1600 or MyLevel <= 1624 or SelectMonster == "Dragon Crew Archer" then
            CFrameMon1 = CFrame.new(6735, 562, 216)
            CFrameMon2 = CFrame.new(6937, 559, 407)
            CFrameMon3 = CFrame.new(6677, 569, 494)
            CFrameMon4 = CFrame.new(6610, 595, 255)
        elseif MyLevel == 1625 or MyLevel <= 1649 or SelectMonster == "Hydra Enforcer" then
            CFrameMon1 = CFrame.new(4562, 1064, 613)
            CFrameMon2 = CFrame.new(4449, 1044, 460)
            CFrameMon3 = CFrame.new(4543, 1055, 241)
            CFrameMon4 = CFrame.new(4449, 1044, 460)
        elseif MyLevel == 1650 or MyLevel <= 1699 or SelectMonster == "Venomous Assailant" then
            CFrameMon1 = CFrame.new(4709, 1144, 962)
            CFrameMon2 = CFrame.new(4506, 1262, 724)
            CFrameMon3 = CFrame.new(4447, 1272, 389)
            CFrameMon4 = CFrame.new(4506, 1262, 724)
        elseif MyLevel == 1700 or MyLevel <= 1724 or SelectMonster == "Marine Commodore" then
            CFrameMon2 = CFrame.new(2502, 153, -7837)
            CFrameMon3 = CFrame.new(2918, 150, -7965)
            CFrameMon4 = CFrame.new(2502, 153, -7837)
        elseif MyLevel == 1725 or MyLevel <= 1774 or SelectMonster == "Marine Rear Admiral" then
            CFrameMon1 = CFrame.new(3575, 185, -6961)
            CFrameMon2 = CFrame.new(3564, 185, -7258)
            CFrameMon3 = CFrame.new(3828, 203, -7285)
            CFrameMon4 = CFrame.new(3940, 191, -6964)
        elseif MyLevel == 1775 or MyLevel <= 1799 or SelectMonster == "Fishman Raider" then
            CFrameMon1 = CFrame.new(-10492, 399, -8558)
            CFrameMon2 = CFrame.new(-10231, 410, -8460)
            CFrameMon3 = CFrame.new(-10387, 391, -8246)
            CFrameMon4 = CFrame.new(-10811, 391, -8431)
        elseif MyLevel == 1800 or MyLevel <= 1824 or SelectMonster == "Fishman Captain" then
            CFrameMon1 = CFrame.new(-10803, 402, -8941)
            CFrameMon2 = CFrame.new(-11112, 409, -8781)
            CFrameMon3 = CFrame.new(-11111, 382, -9164)
            CFrameMon4 = CFrame.new(-10977, 383, -8848)
        elseif MyLevel == 1825 or MyLevel <= 1849 or SelectMonster == "Forest Pirate" then
            CFrameMon1 = CFrame.new(-13176, 386, -7827)
            CFrameMon2 = CFrame.new(-13456, 375, -8004)
            CFrameMon3 = CFrame.new(-13605, 401, -7766)
            CFrameMon4 = CFrame.new(-13365, 390, -7613)
        elseif MyLevel == 1850 or MyLevel <= 1899 or SelectMonster == "Mythological Pirate" then
            CFrameMon1 = CFrame.new(-13432, 557, -7005)
            CFrameMon2 = CFrame.new(-13256, 570, -6850)
            CFrameMon3 = CFrame.new(-13766, 535, -6899)
            CFrameMon4 = nil
        elseif MyLevel == 1900 or MyLevel <= 1924 or SelectMonster == "Jungle Pirate" then
            CFrameMon1 = CFrame.new(-12213, 395, -10382)
            CFrameMon2 = CFrame.new(-11660, 384, -10504)
            CFrameMon3 = CFrame.new(-11961, 395, -10775)
            CFrameMon4 = CFrame.new(-12334, 386, -10673)
        elseif MyLevel == 1925 or MyLevel <= 1974 or SelectMonster == "Musketeer Pirate" then
            CFrameMon1 = CFrame.new(-13110, 477, -9859)
            CFrameMon2 = CFrame.new(-13388, 473, -9924)
            CFrameMon3 = CFrame.new(-13483, 480, -9731)
            CFrameMon4 = CFrame.new(-13197, 453, -9594)
        elseif MyLevel == 1975 or MyLevel <= 1999 or SelectMonster == "Reborn Skeleton" then
            CFrameMon1 = CFrame.new(-8841, 184, 5930)
            CFrameMon2 = CFrame.new(-8817, 191, 6158)
            CFrameMon3 = CFrame.new(-8649, 190, 6135)
            CFrameMon4 = CFrame.new(-8658, 194, 5860)
        elseif MyLevel == 2000 or MyLevel <= 2024 or SelectMonster == "Living Zombie" then
            CFrameMon1 = CFrame.new(-10020, 207, 5980)
            CFrameMon2 = CFrame.new(-10213, 219, 6090)
            CFrameMon3 = CFrame.new(-10214, 220, 5819)
            CFrameMon4 = nil
        elseif MyLevel == 2025 or MyLevel <= 2049 or SelectMonster == "Demonic Soul" then
            CFrameMon1 = CFrame.new(-9265, 217, 6123)
            CFrameMon2 = CFrame.new(-9743, 220, 6114)
            CFrameMon3 = CFrame.new(-9265, 217, 6123)
            CFrameMon4 = CFrame.new(-9743, 220, 6114)
        elseif MyLevel == 2050 or MyLevel <= 2074 or SelectMonster == "Posessed Mummy" then
            CFrameMon1 = CFrame.new(-9707, 70, 6205)
            CFrameMon2 = CFrame.new(-9597, 64, 6325)
            CFrameMon3 = CFrame.new(-9432, 64, 6205)
            CFrameMon4 = CFrame.new(-9608, 91, 6124)
        elseif MyLevel == 2075 or MyLevel <= 2099 or SelectMonster == "Peanut Scout" then
            CFrameMon1 = CFrame.new(-2059, 88, -10071)
            CFrameMon2 = CFrame.new(-1900, 75, -10132)
            CFrameMon3 = CFrame.new(-2200, 60, -9964)
            CFrameMon4 = CFrame.new(-2318, 88, -10231)
        elseif MyLevel == 2100 or MyLevel <= 2124 or SelectMonster == "Peanut President" then
            CFrameMon1 = CFrame.new(-1977, 97, -10589)
            CFrameMon2 = CFrame.new(-2283, 131, -10503)
            CFrameMon3 = CFrame.new(-1977, 97, -10589)
            CFrameMon4 = CFrame.new(-2283, 131, -10503)
        elseif MyLevel == 2125 or MyLevel <= 2149 or SelectMonster == "Ice Cream Chef" then
            CFrameMon1 = CFrame.new(-1015, 97, -11014)
            CFrameMon2 = CFrame.new(-756, 107, -10829)
            CFrameMon3 = CFrame.new(-541, 115, -10896)
            CFrameMon4 = nil
        elseif MyLevel == 2150 or MyLevel <= 2199 or SelectMonster == "Ice Cream Commander" then
            CFrameMon1 = CFrame.new(-705, 177, -11149)
            CFrameMon2 = CFrame.new(-530, 117, -11332)
            CFrameMon3 = CFrame.new(-385, 129, -11032)
            CFrameMon4 = nil
        elseif MyLevel == 2200 or MyLevel <= 2224 or SelectMonster == "Cookie Crafter" then
            CFrameMon1 = CFrame.new(-2276, 85, -12001)
            CFrameMon2 = CFrame.new(-2461, 86, -12100)
            CFrameMon3 = CFrame.new(-2363, 82, -12222)
            CFrameMon4 = CFrame.new(-2223, 80, -12101)
        elseif MyLevel == 2225 or MyLevel <= 2249 or SelectMonster == "Cake Guard" then
            CFrameMon1 = CFrame.new(-1713, 97, -12252)
            CFrameMon2 = CFrame.new(-1514, 89, -12184)
            CFrameMon3 = CFrame.new(-1479, 80, -12407)
            CFrameMon4 = CFrame.new(-1685, 86, -12431)
        elseif MyLevel == 2250 or MyLevel <= 2274 or SelectMonster == "Baking Staff" then
            CFrameMon1 = CFrame.new(-1945, 92, -13005)
            CFrameMon2 = CFrame.new(-1790, 89, -13108)
            CFrameMon3 = CFrame.new(-1762, 89, -12941)
            CFrameMon4 = CFrame.new(-1815, 91, -12699)
        elseif MyLevel == 2275 or MyLevel <= 2299 or SelectMonster == "Head Baker" then
            CFrameMon1 = CFrame.new(-2149, 108, -12740)
            CFrameMon2 = CFrame.new(-2172, 109, -13015)
            CFrameMon3 = CFrame.new(-2329, 106, -13013)
            CFrameMon4 = CFrame.new(-2319, 118, -12733)
        elseif MyLevel == 2300 or MyLevel <= 2324 or SelectMonster == "Cocoa Warrior" then
            CFrameMon1 = CFrame.new(-40, 93, -12331)
            CFrameMon2 = CFrame.new(-135, 67, -12282)
            CFrameMon3 = CFrame.new(70, 75, -12230)
            CFrameMon4 = CFrame.new(218, 91, -12202)
        elseif MyLevel == 2325 or MyLevel <= 2349 or SelectMonster == "Chocolate Bar Battler" then
            CFrameMon1 = CFrame.new(649, 61, -12405)
            CFrameMon2 = CFrame.new(826, 59, -12647)
            CFrameMon3 = CFrame.new(661, 60, -12688)
            CFrameMon4 = CFrame.new(538, 74, -12464)
        elseif MyLevel == 2350 or MyLevel <= 2374 or SelectMonster == "Sweet Thief" then
            CFrameMon1 = CFrame.new(-89, 63, -12715)
            CFrameMon2 = CFrame.new(-26, 65, -12581)
            CFrameMon3 = CFrame.new(133, 72, -12592)
            CFrameMon4 = nil
        elseif MyLevel == 2375 or MyLevel <= 2400 or SelectMonster == "Candy Rebel" then
            CFrameMon1 = CFrame.new(46, 81, -12857)
            CFrameMon2 = CFrame.new(-33, 70, -12965)
            CFrameMon3 = CFrame.new(116, 67, -13034)
            CFrameMon4 = CFrame.new(198, 65, -12929)
        elseif MyLevel == 2400 or MyLevel <= 2424 or SelectMonster == "Candy Pirate" then
            CFrameMon1 = CFrame.new(-1321, 75, -14438)
            CFrameMon2 = CFrame.new(-1385, 81, -14709)
            CFrameMon3 = CFrame.new(-1321, 75, -14438)
            CFrameMon4 = CFrame.new(-1385, 81, -14709)
        elseif MyLevel == 2425 or MyLevel <= 2449 or SelectMonster == "Snow Demon" then
            CFrameMon1 = CFrame.new(-911, 62, -14626)
            CFrameMon2 = CFrame.new(-849, 72, -14414)
            CFrameMon3 = CFrame.new(-911, 62, -14626)
            CFrameMon4 = CFrame.new(-849, 72, -14414)
        elseif MyLevel == 2450 or MyLevel <= 2474 or SelectMonster == "Isle Outlaw" then
            CFrameMon1 = CFrame.new(-16403, 92, -225)
            CFrameMon2 = CFrame.new(-16241, 69, -108)
            CFrameMon3 = CFrame.new(-16403, 92, -225)
            CFrameMon4 = CFrame.new(-16241, 69, -108)
        elseif MyLevel == 2475 or MyLevel <= 2499 or SelectMonster == "Island Boy" then
            CFrameMon1 = CFrame.new(-16682, 102, -223)
            CFrameMon2 = CFrame.new(-16818, 73, -88)
            CFrameMon3 = CFrame.new(-16937, 62, -161)
            CFrameMon4 = nil
        elseif MyLevel == 2500 or MyLevel <= 2524 or SelectMonster == "Sun-kissed Warrior" then
            CFrameMon1 = CFrame.new(-16400, 98, 1102)
            CFrameMon2 = CFrame.new(-16215, 74, 959)
            CFrameMon3 = CFrame.new(-16215, 74, 959)
            CFrameMon4 = nil
        elseif MyLevel == 2525 or MyLevel <= 2549 or SelectMonster == "Isle Champion" then
            CFrameMon1 = CFrame.new(-16634, 102, 1119)
            CFrameMon2 = CFrame.new(-16825, 60, 968)
            CFrameMon3 = CFrame.new(-16906, 65, 1080)
            CFrameMon4 = nil
        elseif MyLevel == 2550 or MyLevel <= 2574 or SelectMonster == "Serpent Hunter" then
            CFrameMon1 = CFrame.new(-16624, 185, 1307)
            CFrameMon2 = CFrame.new(-16532, 185, 1362)
            CFrameMon3 = CFrame.new(-16541, 150, 1540)
            CFrameMon4 = CFrame.new(-16519, 120, 1716)
        elseif MyLevel == 2575 or MyLevel <= 2599 then
            CFrameMon1 = CFrame.new(-16806, 134, 1534)
            CFrameMon2 = CFrame.new(-16966, 241, 1643)
            CFrameMon3 = CFrame.new(-16818, 219, 1752)
            CFrameMon4 = nil
        elseif MyLevel == 2600 or MyLevel <= 2624 then
            CFrameMon1 = CFrame.new(10920.552734375, -2120.7587890625, 9267.6513671875)
            CFrameMon2 = CFrame.new(11034.779296875, -2128.155517578125, 9118.48046875)
        elseif MyLevel == 2625 or MyLevel <= 2649 then
            CFrameMon1 = CFrame.new(10662.7822265625, -2064.858642578125, 9303.939453125)
            CFrameMon2 = CFrame.new(10835.505859375, -2050.79541015625, 9438.0458984375)
        elseif MyLevel == 2650 or MyLevel <= 2674 then
            CFrameMon1 = CFrame.new(10626.7861328125, -2035.5662841796875, 10000.9775390625)
            CFrameMon2 = CFrame.new(10641.978515625, -2058.716064453125, 10174.470703125)
        elseif MyLevel >= 2675 then
            CFrameMon1 = CFrame.new(11138.119140625, -1975.6793212890625, 10088.7666015625)
            CFrameMon2 = CFrame.new(10892.6611328125, -1973.2645263671875, 10204.5849609375)
        end
    end
end
end
end
function CheckBossQuest()
    if _G['Select Boss'] == "Saber Expert" then
        MsBoss = "Saber Expert"
        NameBoss = "Saber Expert"
        CFrameBoss = CFrame.new(-1458.89502, 29.8870335, -50.633564, 0.858821094, 1.13848939e-08, 0.512275636,
            -4.85649254e-09, 1, -1.40823326e-08, -0.512275636, 9.6063415e-09, 0.858821094)
    elseif _G['Select Boss'] == "The Saw" then
        MsBoss = "The Saw"
        NameBoss = "The Saw"
        CFrameBoss = CFrame.new(-683.519897, 13.8534927, 1610.87854, -0.290192783, 6.88365773e-08, 0.956968188,
            6.98413629e-08, 1, -5.07531119e-08, -0.956968188, 5.21077759e-08, -0.290192783)
    elseif _G['Select Boss'] == "Greybeard" then
        MsBoss = "Greybeard"
        NameBoss = "Greybeard"
        CFrameBoss = CFrame.new(-4955.72949, 80.8163834, 4305.82666, -0.433646321, -1.03394289e-08, 0.901083171,
            -3.0443168e-08, 1, -3.17633075e-09, -0.901083171, -2.88092288e-08, -0.433646321)
    elseif _G['Select Boss'] == "The Gorilla King" then
        MsBoss = "The Gorilla King"
        NameBoss = "The Gorilla King"
        NameQuestBoss = "JungleQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559,
            1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
        CFrameBoss = CFrame.new(-1223.52808, 6.27936459, -502.292664, 0.310949147, -5.66602516e-08, 0.950426519,
            -3.37275488e-08, 1, 7.06501808e-08, -0.950426519, -5.40241736e-08, 0.310949147)
    elseif _G['Select Boss'] == "Bobby" then
        MsBoss = "Bobby"
        NameBoss = "Bobby"
        NameQuestBoss = "BuggyQuest1"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383,
            -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
        CFrameBoss = CFrame.new(-1147.65173, 32.5966301, 4156.02588, 0.956680477, -1.77109952e-10, -0.29113996,
            5.16530874e-10, 1, 1.08897802e-09, 0.29113996, -1.19218679e-09, 0.956680477)
    elseif _G['Select Boss'] == "Yeti" then
        MsBoss = "Yeti"
        NameBoss = "Yeti"
        NameQuestBoss = "SnowQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(1384.90247, 87.3078308, -1296.6825, 0.280209213, 2.72035177e-08, -0.959938943,
            -6.75690828e-08, 1, 8.6151708e-09, 0.959938943, 6.24481444e-08, 0.280209213)
        CFrameBoss = CFrame.new(1221.7356, 138.046906, -1488.84082, 0.349343032, -9.49245944e-08, 0.936994851,
            6.29478194e-08, 1, 7.7838429e-08, -0.936994851, 3.17894653e-08, 0.349343032)
    elseif _G['Select Boss'] == "Mob Leader" then
        MsBoss = "Mob Leader"
        NameBoss = "Mob Leader"
        CFrameBoss = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-08, 0.371961564,
            -7.61816636e-08, 1, 4.44474857e-08, -0.371961564, 1.29216433e-08, -0.92824)
    elseif _G['Select Boss'] == "Vice Admiral" then
        MsBoss = "Vice Admiral"
        NameBoss = "Vice Admiral"
        NameQuestBoss = "MarineQuest2"
        LevelQuestBoss = 2
        CFrameQuestBoss = CFrame.new(-5035.42285, 28.6520386, 4324.50293, -0.0611100644, -8.08395768e-08, 0.998130739,
            -1.57416586e-08, 1, 8.00271849e-08, -0.998130739, -1.08217701e-08, -0.0611100644)
        CFrameBoss = CFrame.new(-5078.45898, 99.6520691, 4402.1665, -0.555574954, -9.88630566e-11, 0.831466436,
            -6.35508286e-08, 1, -4.23449258e-08, -0.831466436, -7.63661632e-08, -0.555574954)
    elseif _G['Select Boss'] == "Warden" then
        MsBoss = "Warden"
        NameBoss = "Warden"
        NameQuestBoss = "ImpelQuest"
        LevelQuestBoss = 1
        CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691,
            1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
        CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697,
            3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
    elseif _G['Select Boss'] == "Chief Warden" then
        MsBoss = "Chief Warden"
        NameBoss = "Chief Warden"
        NameQuestBoss = "ImpelQuest"
        LevelQuestBoss = 2
        CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691,
            1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
        CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697,
            3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
    elseif _G['Select Boss'] == "Swan" then
        MsBoss = "Swan"
        NameBoss = "Swan"
        NameQuestBoss = "ImpelQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691,
            1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
        CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697,
            3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
    elseif _G['Select Boss'] == "Magma Admiral" then
        MsBoss = "Magma Admiral"
        NameBoss = "Magma Admiral"
        NameQuestBoss = "MagmaQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-5317.07666, 12.2721891, 8517.41699, 0.51175487, -2.65508806e-08, -0.859131515,
            -3.91131572e-08, 1, -5.42026761e-08, 0.859131515, 6.13418294e-08, 0.51175487)
        CFrameBoss = CFrame.new(-5530.12646, 22.8769703, 8859.91309, 0.857838571, 2.23414389e-08, 0.513919294,
            1.53689133e-08, 1, -6.91265853e-08, -0.513919294, 6.71978384e-08, 0.857838571)
    elseif _G['Select Boss'] == "Fishman Lord" then
        MsBoss = "Fishman Lord"
        NameBoss = "Fishman Lord"
        NameQuestBoss = "FishmanQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(61123.0859, 18.5066795, 1570.18018, 0.927145958, 1.0624845e-07, 0.374700129,
            -6.98219367e-08, 1, -1.10790765e-07, -0.374700129, 7.65569368e-08, 0.927145958)
        CFrameBoss = CFrame.new(61351.7773, 31.0306778, 1113.31409, 0.999974668, 0, -0.00714713801, 0, 1.00000012, 0,
            0.00714714266, 0, 0.999974549)
    elseif _G['Select Boss'] == "Wysper" then
        MsBoss = "Wysper"
        NameBoss = "Wysper"
        NameQuestBoss = "SkyExp1Quest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-7862.94629, 5545.52832, -379.833954, 0.462944925, 1.45838088e-08, -0.886386991,
            1.0534996e-08, 1, 2.19553424e-08, 0.886386991, -1.95022007e-08, 0.462944925)
        CFrameBoss = CFrame.new(-7925.48389, 5550.76074, -636.178345, 0.716468513, -1.22915289e-09, 0.697619379,
            3.37381434e-09, 1, -1.70304748e-09, -0.697619379, 3.57381835e-09, 0.716468513)
    elseif _G['Select Boss'] == "Thunder God" then
        MsBoss = "Thunder God"
        NameBoss = "Thunder God"
        NameQuestBoss = "SkyExp2Quest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-7902.78613, 5635.99902, -1411.98706, -0.0361216255, -1.16895912e-07,
            0.999347389, 1.44533963e-09, 1, 1.17024491e-07, -0.999347389, 5.6715117e-09, -0.0361216255)
        CFrameBoss = CFrame.new(-7917.53613, 5616.61377, -2277.78564, 0.965189934, 4.80563429e-08, -0.261550069,
            -6.73089886e-08, 1, -6.46515304e-08, 0.261550069, 8.00056768e-08, 0.965189934)
    elseif _G['Select Boss'] == "Cyborg" then
        MsBoss = "Cyborg"
        NameBoss = "Cyborg"
        NameQuestBoss = "FountainQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(5253.54834, 38.5361786, 4050.45166, -0.0112687312, -9.93677887e-08, -0.999936521,
            2.55291371e-10, 1, -9.93769547e-08, 0.999936521, -1.37512213e-09, -0.0112687312)
        CFrameBoss = CFrame.new(6041.82813, 52.7112198, 3907.45142, -0.563162148, 1.73805248e-09, -0.826346457,
            -5.94632716e-08, 1, 4.26280238e-08, 0.826346457, 7.31437524e-08, -0.563162148)
    elseif _G['Select Boss'] == "Diamond" then
        MsBoss = "Diamond"
        NameBoss = "Diamond"
        NameQuestBoss = "Area1Quest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601,
            -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
        CFrameBoss = CFrame.new(-1736.26587, 198.627731, -236.412857, -0.997808516, 0, -0.0661673471, 0, 1, 0,
            0.0661673471, 0, -0.997808516)
    elseif _G['Select Boss'] == "Jeremy" then
        MsBoss = "Jeremy"
        NameBoss = "Jeremy"
        NameQuestBoss = "Area2Quest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771,
            1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
        CFrameBoss = CFrame.new(2203.76953, 448.966034, 752.731079, -0.0217453763, 0, -0.999763548, 0, 1, 0,
            0.999763548, 0, -0.0217453763)
    elseif _G['Select Boss'] == "Fajita" then
        MsBoss = "Fajita"
        NameBoss = "Fajita"
        NameQuestBoss = "MarineQuest3"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301,
            5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
        CFrameBoss = CFrame.new(-2297.40332, 115.449463, -3946.53833, 0.961227536, -1.46645796e-09, -0.275756449,
            -2.3212845e-09, 1, -1.34094433e-08, 0.275756449, 1.35296352e-08, 0.961227536)
    elseif _G['Select Boss'] == "Don Swan" then
        MsBoss = "Don Swan"
        NameBoss = "Don Swan"
        CFrameBoss = CFrame.new(2288.802, 15.1870775, 863.034607, 0.99974072, -8.41247214e-08, -0.0227668174,
            8.4774733e-08, 1, 2.75850098e-08, 0.0227668174, -2.95079072e-08, 0.99974072)
    elseif _G['Select Boss'] == "Smoke Admiral" then
        MsBoss = "Smoke Admiral"
        NameBoss = "Smoke Admiral"
        NameQuestBoss = "IceSideQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-6059.96191, 15.9868021, -4904.7373, -0.444992423, -3.0874483e-09, 0.895534337,
            -3.64098796e-08, 1, -1.4644522e-08, -0.895534337, -3.91229982e-08, -0.444992423)
        CFrameBoss = CFrame.new(-5115.72754, 23.7664986, -5338.2207, 0.251453817, 1.48345061e-08, -0.967869282,
            4.02796978e-08, 1, 2.57916977e-08, 0.967869282, -4.54708946e-08, 0.251453817)
    elseif _G['Select Boss'] == "Cursed Captain" then
        MsBoss = "Cursed Captain"
        NameBoss = "Cursed Captain"
        CFrameBoss = CFrame.new(916.928589, 181.092773, 33422, -0.999505103, 9.26310495e-09, 0.0314563364,
            8.42916226e-09, 1, -2.6643713e-08, -0.0314563364, -2.63653774e-08, -0.999505103)
    elseif _G['Select Boss'] == "Darkbeard" then
        MsBoss = "Darkbeard"
        NameBoss = "Darkbeard"
        CFrameBoss = CFrame.new(3876.00366, 24.6882591, -3820.21777, -0.976951957, 4.97356325e-08, 0.213458836,
            4.57335361e-08, 1, -2.36868622e-08, -0.213458836, -1.33787044e-08, -0.976951957)
    elseif _G['Select Boss'] == "Order" then
        MsBoss = "Order"
        NameBoss = "Order"
        CFrameBoss = CFrame.new(-6221.15039, 16.2351036, -5045.23584, -0.380726993, 7.41463495e-08, 0.924687505,
            5.85604774e-08, 1, -5.60738549e-08, -0.924687505, 3.28013137e-08, -0.380726993)
    elseif _G['Select Boss'] == "Awakened Ice Admiral" then
        MsBoss = "Awakened Ice Admiral"
        NameBoss = "Awakened Ice Admiral"
        NameQuestBoss = "FrostQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(5669.33203, 28.2118053, -6481.55908, 0.921275556, -1.25320829e-08, 0.388910472,
            4.72230788e-08, 1, -7.96414241e-08, -0.388910472, 9.17372489e-08, 0.921275556)
        CFrameBoss = CFrame.new(6407.33936, 340.223785, -6892.521, 0.49051559, -5.25310213e-08, -0.871432424,
            -2.76146022e-08, 1, -7.58250565e-08, 0.871432424, 6.12576301e-08, 0.49051559)
    elseif _G['Select Boss'] == "Tide Keeper" then
        MsBoss = "Tide Keeper"
        NameBoss = "Tide Keeper"
        NameQuestBoss = "ForgottenQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-3053.89648, 236.881363, -10148.2324, -0.985987961, -3.58504737e-09, 0.16681771,
            -3.07832915e-09, 1, 3.29612559e-09, -0.16681771, 2.73641976e-09, -0.985987961)
        CFrameBoss = CFrame.new(-3570.18652, 123.328949, -11555.9072, 0.465199202, -1.3857326e-08, 0.885206044,
            4.0332897e-09, 1, 1.35347511e-08, -0.885206044, -2.72606271e-09, 0.465199202)
    elseif _G['Select Boss'] == "Stone" then
        MsBoss = "Stone"
        NameBoss = "Stone"
        NameQuestBoss = "PiratePortQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-290, 44, 5577)
        CFrameBoss = CFrame.new(-1085, 40, 6779)
    elseif _G['Select Boss'] == "Island Empress" then
        MsBoss = "Island Empress"
        NameBoss = "Island Empress"
        NameQuestBoss = "AmazonQuest2"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(5443, 602, 752)
        CFrameBoss = CFrame.new(5659, 602, 244)
    elseif _G['Select Boss'] == "Kilo Admiral" then
        MsBoss = "Kilo Admiral"
        NameBoss = "Kilo Admiral"
        NameQuestBoss = "MarineTreeIsland"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(2178, 29, -6737)
        CFrameBoss = CFrame.new(2846, 433, -7100)
    elseif _G['Select Boss'] == "Captain Elephant" then
        MsBoss = "Captain Elephant"
        NameBoss = "Captain Elephant"
        NameQuestBoss = "DeepForestIsland"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-13232, 333, -7631)
        CFrameBoss = CFrame.new(-13221, 325, -8405)
    elseif _G['Select Boss'] == "Beautiful Pirate" then
        MsBoss = "Beautiful Pirate"
        NameBoss = "Beautiful Pirate"
        NameQuestBoss = "DeepForestIsland2"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-12686, 391, -9902)
        CFrameBoss = CFrame.new(5182, 23, -20)
    elseif _G['Select Boss'] == "Cake Queen" then
        MsBoss = "Cake Queen"
        NameBoss = "Cake Queen"
        NameQuestBoss = "IceCreamIslandQuest"
        LevelQuestBoss = 3
        CFrameQuestBoss = CFrame.new(-716, 382, -11010)
        CFrameBoss = CFrame.new(-821, 66, -10965)
    elseif _G['Select Boss'] == "rip_indra True Form" then
        MsBoss = "rip_indra True Form"
        NameBoss = "rip_indra True Form"
        CFrameBoss = CFrame.new(-5359, 424, -2735)
    elseif _G['Select Boss'] == "Longma" then
        MsBoss = "Longma"
        NameBoss = "Longma"
        CFrameBoss = CFrame.new(-10248.3936, 353.79129, -9306.34473)
    elseif _G['Select Boss'] == "Soul Reaper" then
        MsBoss = "Soul Reaper"
        NameBoss = "Soul Reaper"
        CFrameBoss = CFrame.new(-9515.62109, 315.925537, 6691.12012)
    end
end
--// Select Monster
Dodge_No_CoolDown = false
function DodgeNoCoolDown()
    if Dodge_No_CoolDown then
        for i, v in next, getgc() do
            if game.Players.LocalPlayer.Character.Dodge then
                if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Dodge then
                    for i2, v2 in next, getupvalues(v) do
                        if tostring(v2) == "0.4" then
                            repeat
                                wait(.1)
                                setupvalue(v, i2, 0)
                            until not Dodge_No_CoolDown
                        end
                    end
                end
            end
        end
    end
end
function fly()
    local mouse = game:GetService("Players").LocalPlayer:GetMouse ''
    localplayer = game:GetService("Players").LocalPlayer
    game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local torso = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local speedSET = 25
    local keys = { a = false, d = false, w = false, s = false }
    local e1
    local e2
    local function start()
        local pos = Instance.new("BodyPosition", torso)
        local gyro = Instance.new("BodyGyro", torso)
        pos.Name = "EPIXPOS"
        pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        pos.position = torso.Position
        gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.CFrame = torso.CFrame
        repeat
            wait()
            localplayer.Character.Humanoid.PlatformStand = true
            local new = gyro.CFrame - gyro.CFrame.p + pos.position
            if not keys.w and not keys.s and not keys.a and not keys.d then
                speed = 1
            end
            if keys.w then
                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed = speed + speedSET
            end
            if keys.s then
                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed = speed + speedSET
            end
            if keys.d then
                new = new * CFrame.new(speed, 0, 0)
                speed = speed + speedSET
            end
            if keys.a then
                new = new * CFrame.new(-speed, 0, 0)
                speed = speed + speedSET
            end
            if speed > speedSET then
                speed = speedSET
            end
            pos.position = new.p
            if keys.w then
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad(speed * 15), 0, 0)
            elseif keys.s then
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(math.rad(speed * 15), 0, 0)
            else
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame
            end
        until not Fly
        if gyro then
            gyro:Destroy()
        end
        if pos then
            pos:Destroy()
        end
        flying = false
        localplayer.Character.Humanoid.PlatformStand = false
        speed = 0
    end
    e1 = mouse.KeyDown:connect(function(key)
        if not torso or not torso.Parent then
            flying = false
            e1:disconnect()
            e2:disconnect()
            return
        end
        if key == "w" then
            keys.w = true
        elseif key == "s" then
            keys.s = true
        elseif key == "a" then
            keys.a = true
        elseif key == "d" then
            keys.d = true
        end
    end)
    e2 = mouse.KeyUp:connect(function(key)
        if key == "w" then
            keys.w = false
        elseif key == "s" then
            keys.s = false
        elseif key == "a" then
            keys.a = false
        elseif key == "d" then
            keys.d = false
        end
    end)
    start()
end
function Click()
    wait(.1)
    game:GetService 'VirtualUser':CaptureController()
    game:GetService 'VirtualUser':Button1Down(Vector2.new(1280, 672))
end
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end
function UnEquipWeapon(Weapon)
    if game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
        _G.NotAutoEquip = true
        wait(.5)
        game.Players.LocalPlayer.Character:FindFirstChild(Weapon).Parent = game.Players.LocalPlayer.Backpack
        wait(.1)
        _G.NotAutoEquip = false
    end
end
function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait(.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end
end
function EquipWeaponSword()
    pcall(function()
        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.ToolTip == "Sword" and v:IsA("Tool") then
                local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid)
            end
        end
    end)
end
function EquipWeaponGun()
    pcall(function()
        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.ToolTip == "Gun" and v:IsA("Tool") then
                local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid)
            end
        end
    end)
end
function EquipWeaponMelee()
    pcall(function()
        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.ToolTip == "Melee" and v:IsA("Tool") then
                local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid)
            end
        end
    end)
end
function EquipWeaponFruit()
    pcall(function()
        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.ToolTip == "Blox Fruit" and v:IsA("Tool") then
                local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid)
            end
        end
    end)
end
function GetDistance(target)
    return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end
function BTP(P)
    repeat
        wait(1)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
    until (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1500
end
function ByPass(Position)
    game.Players.LocalPlayer.Character.Head:Destroy()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position
    wait(.5)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
end
function CheckSword(Sword)
    for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v.Type == "Sword" then
                if v.Name == Sword then
                    return true
                end
            end
        end
    end
    return false
end
function CheckGun(Gun)
    for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v.Type == "Gun" then
                if v.Name == Gun then
                    return true
                end
            end
        end
    end
    return false
end
function GetMaterial(Material)
    for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" and v.Type == "Material" and v.Name == Material then
            return v.Count
        end
    end
    return 0
end
function CheckBelt(BeltName)
    for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v.Type == "Wear" then
                if v.Name == BeltName then
                    return true
                end
            end
        end
    end
    return false
end
function CheckPirateBoat()
    local checkmmpb = {"FishBoat"}
    for r, v in next, workspace.Enemies:GetChildren() do
        if table.find(checkmmpb, v.Name) and v:FindFirstChild("Health") and v.Health.Value > 0 then
            return v
        end
    end
end
function useSkill(key)
    game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
    wait(0.1)
    game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
end
function useitem(key)
    game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
    game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
end
function EEPP()
    for i,v in ipairs({"One"}) do
        useitem(v)
    end
    wait(0.8)
        for i,v2 in ipairs({"Two"}) do
        useitem(v2)
    end
    wait(0.8)
    for i,v3 in ipairs({"Three"})do
        useitem(v3)
    end
    wait(0.8)
    for i,v4 in ipairs({"Four"}) do
        useitem(v4)
    end
end
function EPDDKEJ()
    for i,v in ipairs({"Z","X","C","V","F"}) do
    if _G["Skill " .. v] then
        useSkill(v)
        end
    end
end
function TelePPlayer(P)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
end
function _G.TP(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 85 then
        Speed = 250
    elseif Distance < 80 then
        Speed = 250
    elseif Distance < 200 then
        Speed = 275
    elseif Distance < 550 then
        Speed = 750
    elseif Distance < 600 then
        Speed = 600
    elseif Distance < 650 then
        Speed = 500
    elseif Distance < 750 then
        Speed = 400
    elseif Distance < 800 then
        Speed = 300
    elseif Distance < 1000 then
        Speed = 275
    elseif Distance < 1000 then
        Speed = 275
    elseif Distance >= 1000 then
        Speed = 275
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        { CFrame = Pos }
    ):Play()
end
function TP1(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 375 then
        Speed = 600
    elseif Distance < 375 then
        Speed = 420
    elseif Distance < 420 then
        Speed = 420
    elseif Distance < 420 then
        Speed = 420
    elseif Distance < 420 then
        Speed = 420
    elseif Distance < 750 then
        Speed = 375
    elseif Distance >= 1000 then
        Speed = 375
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        { CFrame = Pos }
    ):Play()
end
function topos(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 250 then
        Speed = 5000
    elseif Distance < 250 then
        Speed = 2000
    elseif Distance < 250 then
        Speed = 800
    elseif Distance < 250 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 400
    elseif Distance < 750 then
        Speed = 300
    elseif Distance >= 1000 then
        Speed = 300
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        { CFrame = Pos }
    ):Play()
end
function TPB(CFgo)
    local tween_s = game:service "TweenService"
    local info = TweenInfo.new(
        (game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame.Position - CFgo.Position)
        .Magnitude /
        300, Enum.EasingStyle.Linear)
    tween = tween_s:Create(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat, info, { CFrame = CFgo })
    tween:Play()
    local tweenfunc = {}
    function tweenfunc:Stop()
        tween:Cancel()
    end
    return tweenfunc
end
function TPB2(BoatsPos)
    local Distance = (BoatsPos.Position - game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.Position)
        .Magnitude
    if Distance > 1 then
        Speed = spppp
    end
    game:GetService("TweenService"):Create(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), { CFrame = BoatsPos }):Play()
    if _G.StopTweenBoat then
        game:GetService("TweenService"):Create(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat,
            TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), { CFrame = BoatsPos }):Cancel()
    end
end
function PlayBoatsTween(Target)
    local Distance = (Target.Position - game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade").VehicleSeat.Position)
        .Magnitude
    if Distance > 1 then
        Speed = spppp
    end
    game:GetService("TweenService"):Create(
        game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade").VehicleSeat,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), { CFrame = Target }):Play()
    if _G.StopTweenBoat then
        game:GetService("TweenService"):Create(
            game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade").VehicleSeat,
            TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear), { CFrame = Target }):Cancel()
    end
end
function StopBoats(target)
    if not target then
        _G.StopTweenBoat = true
        wait(.1)
        TPB(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame)
        wait(.1)
        _G.StopTweenBoat = false
    end
end
function StopBoatsTween(target)
    pcall(function()
    if not target then
        _G.StopTweenBoat = true
        wait(.1)
        PlayBoatsTween(game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade").VehicleSeat.CFrame)
        wait(.1)
        _G.StopTweenBoat = false
    end
end)
end
function TPP(CFgo)
    if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health <= 0 or not game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") then
        tween:Cancel()
        repeat wait() until game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid") and game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Health > 0
        wait(7)
        return
    end
    local tween_s = game:service "TweenService"
    local info = TweenInfo.new(
        (game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - CFgo.Position).Magnitude /
        325,
        Enum.EasingStyle.Linear)
    tween = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, { CFrame = CFgo })
    tween:Play()

    local tweenfunc = {}

    function tweenfunc:Stop()
        tween:Cancel()
    end

    return tweenfunc
end
getgenv().ToTargets = function(p)
    task.spawn(function()
        pcall(function()
            if game:GetService("Players").LocalPlayer:DistanceFromCharacter(p.Position) <= 250 then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = p
            elseif not game.Players.LocalPlayer.Character:FindFirstChild("Root") then
                local K = Instance.new("Part", game.Players.LocalPlayer.Character)
                K.Size = Vector3.new(1, 0.5, 1)
                K.Name = "Root"
                K.Anchored = true
                K.Transparency = 1
                K.CanCollide = false
                K.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
            end
            local U = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Position).Magnitude
            local z = game:service("TweenService")
            local B = TweenInfo.new((p.Position - game.Players.LocalPlayer.Character.Root.Position).Magnitude / 300,
                Enum.EasingStyle.Linear)
            local S, g = pcall(function()
                local q = z:Create(game.Players.LocalPlayer.Character.Root, B, { CFrame = p })
                q:Play()
            end)
            if not S then
                return g
            end
            game.Players.LocalPlayer.Character.Root.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart
                .CFrame
            if S and game.Players.LocalPlayer.Character:FindFirstChild("Root") then
                pcall(function()
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Position).Magnitude >= 20 then
                        spawn(function()
                            pcall(function()
                                if (game.Players.LocalPlayer.Character.Root.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 150 then
                                    game.Players.LocalPlayer.Character.Root.CFrame = game.Players.LocalPlayer
                                        .Character.HumanoidRootPart.CFrame
                                else
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players
                                        .LocalPlayer.Character.Root.CFrame
                                end
                            end)
                        end)
                    elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Position).Magnitude >= 10 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Position).Magnitude < 20 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
                    elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Position).Magnitude < 10 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
                    end
                end)
            end
        end)
    end)
end
function toposition(Pos)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenService = game:GetService("TweenService")
    local root
    if not character:FindFirstChild("Root") then
        root = Instance.new("Part", character)
        root.Size = Vector3.new(20, 0.5, 20)
        root.Name = "Root"
        root.Anchored = true
        root.Transparency = 1
        root.CanCollide = false
        root.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0.6, 0)
    else
        root = character:FindFirstChild("Root")
    end
    if character:FindFirstChild("Humanoid") and character.Humanoid.Sit then
        character.Humanoid.Sit = false
    end
    local distance = (Pos.Position - humanoidRootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / L_3c2, Enum.EasingStyle.Linear)
    local function syncRootToPlayer()
        root.CFrame = humanoidRootPart.CFrame
    end
    local function syncPlayerToRoot()
        humanoidRootPart.CFrame = root.CFrame
    end
    local xTweenPosition = {}
    function xTweenPosition:Stop()
        if self.tween then
            self.tween:Cancel()
            self.tween = nil
        end
    end
    if distance <= 10 then
        root.CFrame = Pos
        return xTweenPosition
    end
    local tween = tweenService:Create(root, tweenInfo, { CFrame = Pos })
    xTweenPosition.tween = tween
    tween:Play()
    local connection
    connection = game:GetService("RunService").Stepped:Connect(function()
        if not root or not character or not character.Parent then
            connection:Disconnect()
            return
        end
        syncPlayerToRoot()
        if (root.Position - humanoidRootPart.Position).Magnitude >= 1 then
            syncRootToPlayer()
        end
    end)
    tween.Completed:Connect(function()
        connection:Disconnect()
        syncPlayerToRoot()
    end)
    return xTweenPosition
end
function topos1(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
    pcall(function()
        tween = game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / 300, Enum.EasingStyle.Linear),
            { CFrame = Pos })
    end)
    tween:Play()
    if Distance <= 300 then
        tween:Cancel()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    if _G.StopTween == true then
        tween:Cancel()
        _G.Clip = false
    end
end
function GetDistance(target)
    return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end
function _G.TP11(Pos)
    Distance = (Pos.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 300 then
        Speed = 600
    elseif Distance >= 1000 then
        Speed = 300
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        { CFrame = Pos }
    ):Play()
    _G.Clip = true
    wait(Distance / Speed)
    _G.Clip = false
end
function topos2(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
    pcall(function()
        tween = game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / 400, Enum.EasingStyle.Linear),
            { CFrame = Pos })
    end)
    tween:Play()
    if Distance <= 250 then
        tween:Cancel()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    if _G.StopTween == true then
        tween:Cancel()
        _G.Clip = false
    end
end
function TP22(Pos)
    repeat
        wait()
        Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
        pcall(function()
            tween = game:GetService("TweenService"):Create(
                game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance / 270,
                    Enum.EasingStyle.Linear), { CFrame = Pos })
        end)
        tween:Play()
        if Distance <= 250 then
            tween:Cancel()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        end
        if _G.StopTween == true then
            tween:Cancel()
            _G.Clip = false
        end
    until Distance <= 10
end
function TP33(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
    pcall(function()
        tween = game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / 210, Enum.EasingStyle.Linear),
            { CFrame = Pos })
    end)
    tween:Play()
    if Distance <= 110 then
        tween:Cancel()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    if _G.StopTween == true then
        tween:Cancel()
        _G.Clip = false
    end
end
function GetDistance(target)
    return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end
function TP44(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 300 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 300
    elseif Distance < 360 then
        Speed = 600
    elseif Distance >= 500 then
        Speed = 300
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        { CFrame = Pos }
    ):Play()
end
function TP55(Pos)
    Distance = (Pos.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 350 then
        Speed = 300
    elseif Distance >= 300 then
        Speed = 350
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        { CFrame = Pos }
    ):Play()
    _G.Clip = true
    wait(Distance / Speed)
    _G.Clip = false
end
function ATween(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
    pcall(function()
        tween = game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / 275, Enum.EasingStyle.Linear),
            { CFrame = Pos })
    end)
    tween:Play()
    if Distance <= 0 then
        tween:Cancel()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    if _G.StopTween == true then
        tween:Cancel()
        _G.Clip = false
    end
end
function Tween(CFrame)
    Distance = (CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 250 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 500
    elseif Distance < 750 then
        Speed = 400
    elseif Distance >= 1000 then
        Speed = 250
    end
    tween =
        game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
            { CFrame = CFrame }
        ):Play()

    return Distance / Speed
end
function Tween1(K1)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    if humanoid.Sit then
        humanoid.Sit = false
    end
    local root = char:WaitForChild("HumanoidRootPart")
    root.CanCollide = false
    local dist = (K1.Position - root.Position).Magnitude
    local spd = 300
    local TweenSvc = game:GetService("TweenService")
    local TweenInf = TweenInfo.new(dist / spd, Enum.EasingStyle.Linear)
    local tween = TweenSvc:Create(root, TweenInf, { CFrame = K1 })
    tween:Play()
    tween.Completed:Connect(function()
        root.CanCollide = true
    end)
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        wait(0.03)
        if _G.StopTween then
            tween:Cancel()
            root.CanCollide = true
            break
        end
    end
end
function TP(Pos)
    local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance <= 100 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    local tweenInfo = TweenInfo.new(Distance / Config["Tween Speed"], Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,
        tweenInfo, {
            CFrame = Pos
        })
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, Pos.Y,
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
    if BypassTP and Distance >= 1000 then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    end
    tween:Play()
end
--[[function TP(Pos)
    local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance <= 100 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    if Distance < 80 then
        Speed11 = 275
    elseif Distance < 120 then
        Speed11 = 300
    elseif Distance < 150 then
        Speed11 = 800
    elseif Distance < 230 then
        Speed11 = 740
    elseif Distance < 330 then
        Speed11 = 640
    elseif Distance < 440 then
        Speed11 = 520
    elseif Distance < 580 then
        Speed11 = 410
    elseif Distance < 700 then
        Speed11 = 350
    elseif Distance < 800 then
        Speed11 = 300
    elseif Distance < 900 then
        Speed11 = 275
    elseif Distance >= 1000 then
        Speed11 = 275
    end
    local tweenInfo = TweenInfo.new(Distance / L_3c2, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,
        tweenInfo, {
            CFrame = Pos
        })
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, Pos.Y,
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
    if BypassTP and Distance >= 1500 then
        game.Players.LocalPlayer.Character.Head:Destroy()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    end
    tween:Play()
end--]]
function TPTPP(Pos)
    local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance <= 100 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
    end
    if Distance < 80 then
        Speed11 = 275
    elseif Distance < 120 then
        Speed11 = 300
    elseif Distance < 150 then
        Speed11 = 800
    elseif Distance < 230 then
        Speed11 = 740
    elseif Distance < 330 then
        Speed11 = 640
    elseif Distance < 440 then
        Speed11 = 520
    elseif Distance < 580 then
        Speed11 = 410
    elseif Distance < 700 then
        Speed11 = 350
    elseif Distance < 800 then
        Speed11 = 300
    elseif Distance < 900 then
        Speed11 = 275
    elseif Distance >= 1000 then
        Speed11 = 275
    end
    local tweenInfo = TweenInfo.new(Distance / 325, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,
        tweenInfo, {
            CFrame = Pos
        })
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, Pos.Y,
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
    if BypassTP and Distance >= 1500 then
        game.Players.LocalPlayer.Character.Head:Destroy()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    end
    tween:Play()
end
local function Tween32(Pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local HN = char:WaitForChild("Humanoid")
    if HN.Sit then
        HN.Sit = false
    end
    local root = char:WaitForChild("HumanoidRootPart")
    root.CanCollide = false
    if _G.Tweening then
        return
    end
    local dist = (p.Position - root.Position).Magnitude
    local spd
    if dist >= 1000 then
        spd = 320
    elseif dist >= 500 then
        spd = 500
    elseif dist >= 200 then
        spd = 700
    else
        spd = 300
    end
    local TweenSvc = game:GetService("TweenService")
    local TweenInf = TweenInfo.new(dist / 275, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenSvc:Create(root, TweenInf, { CFrame = Pos })
    _G.Tweening = true
    tween:Play()
    tween.Completed:Connect(function()
        root.CanCollide = true
        _G.Tweening = false
    end)
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        wait(0.1)
        if _G.StopTween then
            tween:Cancel()
            root.CanCollide = true
            _G.Tweening = false
            break
        end
    end
end
function teleportToFarm(targetCFrame)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        local distance = (targetCFrame.Position - humanoidRootPart.Position).Magnitude
        local baseSpeed = 275
        local speedMultiplier = 1.2
        if distance < 500 then
            speedMultiplier = 1.5
        elseif distance < 250 then
            speedMultiplier = 1.7
        end
        local tween = game:GetService("TweenService"):Create(
            humanoidRootPart,
            TweenInfo.new((distance / baseSpeed) / speedMultiplier, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            { CFrame = targetCFrame }
        )
        tween:Play()
    end
end
local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end
local function useAvailableSkills()
    for _, key in ipairs({"Z", "X", "C", "V", "F"}) do
        if _G["Skill " .. key] then
            useSkill(key)
        end
    end
end
local function performAction(cframe)
    TP(cframe)
    for _, key in ipairs({"One", "Two", "Three", "Four"}) do
        pressKey(key)
        useAvailableSkills()
        wait(0.5)
    end
end
Type = 1
spawn(function()
    while wait(0.1) do
        if Type == 1 then
            Pos = CFrame.new(0, Config["Farm Distance"], 0)
        elseif Type == 2 then
            Pos = CFrame.new(0, Config["Farm Distance"], -25)
        elseif Type == 3 then
            Pos = CFrame.new(25, Config["Farm Distance"], 0)
        elseif Type == 4 then
            Pos = CFrame.new(0, Config["Farm Distance"], 25)
        elseif Type == 5 then
            Pos = CFrame.new(-25, Config["Farm Distance"], 0)
        elseif Type == 6 then
            Pos = CFrame.new(0, Config["Farm Distance"], 0)
        end
    end
end)
spawn(function()
    while wait(0) do
        Type = 1
        wait(0.5)
        Type = 2
        wait(0.5)
        Type = 3
        wait(0.5)
        Type = 4
        wait(0.5)
        Type = 5
        wait(0.5)
    end
end)
TypeKillPlayers = 1
spawn(function()
    while wait() do
        if TypeKillPlayers == 1 then
            PosKillPlayers = CFrame.new(0, 58, 0)
        elseif TypeKillPlayers == 2 then
            PosKillPlayers = CFrame.new(0, 18, -58)
        elseif TypeKillPlayers == 3 then
            PosKillPlayers = CFrame.new(58, 18, 0)
        elseif TypeKillPlayers == 4 then
            PosKillPlayers = CFrame.new(0, 18, 58)
        elseif TypeKillPlayers == 5 then
            PosKillPlayers = CFrame.new(-58, 18, 0)
        elseif TypeKillPlayers == 6 then
            PosKillPlayers = CFrame.new(0, 18, -58)
        elseif TypeKillPlayers == 7 then
            PosKillPlayers = CFrame.new(-58, 18, 0)
        end
    end
end)
spawn(function()
    while wait(-200) do
        TypeKillPlayers = 1
        wait(-200)
        TypeKillPlayers = 2
        wait(-200)
        TypeKillPlayers = 3
        wait(-200)
        TypeKillPlayers = 4
        wait(-200)
        TypeKillPlayers = 5
        wait(-200)
    end
end)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function isAutoEnabled()
    local keys_G = {
        "Auto Farm Level", "Auto Second Sea", "Auto Third Sea", "Auto Factory",
        "Auto Castle Pirate Raid", "Auto Farm Cake Prince", "Auto Hallow Sycthe",
        "Auto Farm Bone", "Auto Farm Elite Hunter", "Auto Bartilo Quest",
        "Auto Farm Leather or Scrap Metal", "Auto Farm Fiah Tail", "Auto Farm Magma Ore",
        "Auto Farm [Nearest Mob]", "Auto Saber", "Auto Pole v1", "Auto Bisento V2",
        "Auto Rengoku", "Teleport to Players", "Tween Island", "Auto Next lsland",
        "Auto Farm Angel Wings", "Auto Farm Radioactive Materials", "Auto Farm Demonic Wips",
        "Auto Farm Vampire Fang", "Auto Farm Mini Tusk", "Auto Farm Gunpowder",
        "Auto Farm Sea Events", "Auto Dragon Hunter", "Auto Swan Glasses",
        "Auto Dojo Quest", "Auto Farm Observation Exp", "Auto Dungeon", "Auto Canvander",
        "Auto Yama", "Auto Find Mirage Island", "Teleport to Mirage Island",
        "Auto Farm Boss", "Auto Farm Sea Beasts", "Auto Farm Mastery Fruit [Level]",
        "Auto Farm Mastery Gun [Level]", "Auto Holy Torch", "Auto Budy Sword",
        "Auto Tushita", "Teleport to Fruit", "Auto Evo Race V2",
        "Auto Find Advanced Fruit Dealer", "Auto Find Gear",
        "Auto Musketeer Hat", "Auto Rainbow Haki", "Teleport to Race Door",
        "Auto Farm Ectoplasm", "Auto Get Cursed Dual Katana", "Auto Farm All Boss",
        "Auto Find Prehistoric Island", "Teleport to Prehistoric Island", "Auto Godhuman Full",
        "Auto Relic Events", "Auto Collect Dinosaur Bones", "Auto Collect Dragon Egg",
        "Auto Find Kitsune Island", "Teleport to Kitsune Island", "Auto Craft Volcanic Magnet", "Auto Quest Yama", "Auto Quest Tushita",
        "Auto Collect Berry", "Auto Godhuman Full", "Auto Electric Claw", "Auto Sharkman Karate", "Auto Twin Hooks",
        "Auto Soul Guitar", "Auto Kill Players", "Auto Complete Trail", "Auto Farm Chest [ Tweem ]", "Auto Farm Chest [ TP ] ( Risk )",
        "Auto Observation V2", "Auto Dough King V2", "Auto Farm Order Boss","Auto Farm Mastery Fruit [Bone]",
        "Auto Farm Mastery Gun [Bone]","Auto Farm Mastery Fruit [Cake Prince]","Auto Farm Mastery Gun [Cake Prince]",
        "Auto Tyrant of the Skies","Enabled Farm Fast","Auto Farm Oni Soldier","Auto Farm Red Commander","Auto Fishing"
    }
    for _, key in ipairs(keys_G) do
        if Config[key] then return true end
    end
    return false
end
RunService.Heartbeat:Connect(function()
    if isAutoEnabled() then
        if not Workspace:FindFirstChild("LOL") then
            local LOL = Instance.new("Part")
            LOL.Name = "LOL"
            LOL.Parent = Workspace
            LOL.Anchored = true
            LOL.Transparency = 1
            LOL.Size = Vector3.new(0, 0, 0)
        end
    else
        if Workspace:FindFirstChild("LOL") then
            Workspace.LOL:Destroy()
        end
    end
end)
spawn(function()
    while wait() do
        if isAutoEnabled() then
            local hrp = Players.LocalPlayer.Character.HumanoidRootPart
            if not hrp:FindFirstChild("BodyClip") then
                local Noclip = Instance.new("BodyVelocity")
                Noclip.Name = "BodyClip"
                Noclip.Parent = hrp
                Noclip.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                Noclip.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
RunService.Stepped:Connect(function()
    if isAutoEnabled() then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)
spawn(function()
    while wait() do
        if isAutoEnabled() then
            if not Players.LocalPlayer.Character:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.FillColor = Color3.fromRGB(81, 255, 60)
                Highlight.OutlineColor = Color3.fromRGB(81, 255, 60)
                Highlight.Parent = Players.LocalPlayer.Character
            end
        end
    end
end)
--[[]
spawn(function()
    while wait(1) do
        if isAutoEnabled() and game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Yeti-Yeti") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Blade-Blade") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Mammoth-Mammoth") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gas-Gas") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard-Leopard") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Kitsune-Kitsune") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon-Dragon") and _G['Select Weapon'] == "Fruit" then
            Click()
        end
    end
end)
--]]
spawn(function()
    while wait() do
        if isAutoEnabled() then
            pcall(function()
                ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if Config["Auto Farm Sea Events"] or Config["Auto Find Mirage Island"] or Config["Auto Find Kitsune Island"] or Config["Auto Find Prehistoric Island"] or Config["Auto Dojo Quest"] then
                if game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade") then
                    local BoatsTarget = game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade")
                    for _, v in pairs(BoatsTarget:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    end)
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if not Config["Auto Farm Sea Events"] or Config["Auto Find Mirage Island"] or Config["Auto Find Kitsune Island"] or Config["Auto Find Prehistoric Island"] or Config["Auto Dojo Quest"] then
                if game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade") then
                    local BoatsTarget = game:GetService("Workspace").Boats:FindFirstChild("PirateGrandBrigade")
                    for _, v in pairs(BoatsTarget:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = true
                        end
                    end
                end
            end
        end)
    end)
end)
-- No _G.
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        if TeleporttPrehistoricIsland then
            if not game:GetService("Workspace"):FindFirstChild("LOL") then
                local LOL = Instance.new("Part")
                LOL.Name = "LOL"
                LOL.Parent = Workspace
                LOL.Anchored = true
                LOL.Transparency = 1
                LOL.Size = Vector3.new(0,0,0)
            elseif game:GetService("Workspace"):FindFirstChild("LOL") then
                --game.Workspace["LOL"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.6, 0)
            end
        else
            if game:GetService("Workspace"):FindFirstChild("LOL") then
                game:GetService("Workspace"):FindFirstChild("LOL"):Destroy()
            end
        end
    end)
    end)
    spawn(function()
        pcall(function()
            while wait() do
                if TeleporttPrehistoricIsland == true then
                    if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                        local Noclip = Instance.new("BodyVelocity")
                        Noclip.Name = "BodyClip"
                        Noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                        Noclip.MaxForce = Vector3.new(100000000000000000000000000000000000000000000000000000000000000000000000000000000000,100000000000000000000000000000000000000000000000000000000000000000000000000000000000,100000000000000000000000000000000000000000000000000000000000000000000000000000000000)
                        Noclip.Velocity = Vector3.new(0,0,0)
                    end
                end
            end
        end)
    end)
    spawn(function()
        pcall(function()
            game:GetService("RunService").Stepped:Connect(function()
                if TeleporttPrehistoricIsland == true then
                    for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false    
                        end
                    end
                end
            end)
        end)
    end)
    spawn(function()
        pcall(function()
            while wait() do
                if TeleporttPrehistoricIsland == true then
                    if not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then
                        local Highlight = Instance.new("Highlight")
                        Highlight.FillColor = Color3.fromRGB(81, 255, 60)
                        Highlight.OutlineColor = Color3.fromRGB(81, 255, 60)
                        Highlight.Parent = game.Players.LocalPlayer.Character
                        end
                    end
                end
            end)
        end)
    spawn(function()
        while wait() do
            if TeleporttPrehistoricIsland == true then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken",true)
                end)
            end    
        end
    end)
function InstancePos(pos)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end
function TP3(pos)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end
function _St(target)
    if not target then
        _G.StopTween = true
        wait()
        topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        local humanoidRootPart = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        if humanoidRootPart:FindFirstChild("BodyClip") then
            humanoidRootPart:FindFirstChild("BodyClip"):Destroy()
        end
        _G.StopTween = false
        _G.Clip = false
        local character = game.Players.LocalPlayer.Character
        if character:FindFirstChild("Highlight") then
            character:FindFirstChild("Highlight"):Destroy()
        end
    end
end
spawn(function()
    pcall(function()
        while wait() do
            for i, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if v:IsA("Tool") then
                    if v:FindFirstChild("RemoteFunctionShoot") then
                        SelectWeaponGun = v.Name
                    end
                end
            end
        end
    end)
end)
local RS = game:GetService("ReplicatedStorage")
local regAtk = RS.Modules.Net:FindFirstChild("RE/RegisterAttack")
local regHit = RS.Modules.Net:FindFirstChild("RE/RegisterHit")
local yZn34 = false
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
Speed22 = 300
--[[]
ScreenGui.Parent = Players.LocalPlayer.PlayerGui
ScreenGui.Name = "NotificationGui"
TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
TextLabel.Position = UDim2.new(0.25, 0, -0.1, 0)
TextLabel.BackgroundTransparency = 1 
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 30
TextLabel.Text = "Successfully Executed"
TextLabel.TextWrapped = true
TextLabel.TextStrokeTransparency = 0.5
TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TextLabel:TweenPosition(UDim2.new(0.25, 0, 0., 0), "Out", "Quad", 1, true)
TextLabel:TweenSize(UDim2.new(0.5, 0, 0.15, 0), "Out", "Quad", 1, true)
game:GetService("TweenService"):Create(TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 0.5}):Play()
wait(5)
TextLabel:TweenPosition(UDim2.new(0.25, 0, -0.1, 0), "Out", "Quad", 1, true)
TextLabel:TweenSize(UDim2.new(0.5, 0, 0.1, 0), "Out", "Quad", 1, true, function()
TextLabel:Destroy()
end)
--]]
task.spawn(function()
    while task.wait() do
        pcall(function()
            local player = game.Players.LocalPlayer
            local backpack = player.Backpack
            local char = player.Character
            local weaponType = _G['Select Weapon']
            local targetToolTip = nil
            if weaponType == "Melee" then
                targetToolTip = "Melee"
            elseif weaponType == "Sword" then
                targetToolTip = "Sword"
            elseif weaponType == "Gun" then
                targetToolTip = "Gun"
            elseif weaponType == "Fruit" then
                targetToolTip = "Blox Fruit"
            end
            if targetToolTip then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.ToolTip == targetToolTip then
                        _G['Select Weapon'] = tool.Name
                    end
                end
            end
        end)
    end
end)
function BringMob(pos)
    local BlacklistMob = {
        "rip_indra", "Ice Admiral", "Saber Expert", "The Saw", "Greybeard", "Mob Leader",
        "The Gorilla King", "Bobby", "Yeti", "Vice Admiral", "Warden", "Chief Warden",
        "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg",
        "Don Swan", "Diamond", "Jeremy", "Fajita", "Smoke Admiral", "Awakened Ice Admiral",
        "Tide Keeper", "Order", "Darkbeard", "Stone", "Island Empress", "Kilo Admiral",
        "Captain Elephant", "Beautiful Pirate", "Cake Queen", "rip_indra True Form",
        "Longma", "Soul Reaper", "Cake Prince", "Dough King"
    }
    pcall(function()
        for i, v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                if not table.find(BlacklistMob, v.Name) then
                    local p = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
                    local m = v.HumanoidRootPart.Position
                    if (m - p).Magnitude <= 210 then
                        v.HumanoidRootPart.CFrame = pos
                        v.HumanoidRootPart.CanCollide = false
                        if v:FindFirstChild("Head") then
                            v.Head.CanCollide = false
                        end
                        v.Humanoid.WalkSpeed = 0
                        v.Humanoid.JumpHeight = 0
                        v.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        v.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                        local bp = Instance.new("BodyPosition", v.HumanoidRootPart)
                        bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bp.Position = pos.Position
                        bp.P = 1e6
                        local bg = Instance.new("BodyGyro", v.HumanoidRootPart)
                        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                        bg.CFrame = pos
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        setscriptable(game.Players.LocalPlayer, "SimulationRadius", true)
                    end
                end
            end
        end
    end)
end
spawn(function()
    while task.wait() do
        if Config["Fast Attack"] then
            pcall(function()
                for i, v in next, workspace.Enemies:GetChildren() do
                    if v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= tonumber(60) then
                        game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterAttack")
                            :FireServer(-9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999)
                        local args = {
                            [1] = v:FindFirstChild("HumanoidRootPart"),
                            [2] = {}
                        }
                        for _, e in next, workspace:WaitForChild("Enemies"):GetChildren() do
                            if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                                table.insert(args[2], {
                                    [1] = e,
                                    [2] = e:FindFirstChild("HumanoidRootPart") or e:FindFirstChildOfClass("BasePart")
                                })
                            end
                        end
                        game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterHit"):FireServer(
                            unpack(args))
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex")
                            .LeftClickRemote:FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Yeti-Yeti").LeftClickRemote
                            :FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Yeti-Yeti")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Blade-Blade")
                            .LeftClickRemote:FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Blade-Blade")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Mammoth-Mammoth")
                            .LeftClickRemote:FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }

                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Mammoth-Mammoth")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gas-Gas").LeftClickRemote
                            :FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gas-Gas")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard-Leopard")
                            .LeftClickRemote:FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard-Leopard")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1,
                            [3] = true
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Kitsune-Kitsune")
                            .LeftClickRemote:FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1,
                                [3] = true
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Kitsune-Kitsune")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, enemy in pairs(game.workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local args = {
                            [1] = enemy.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon-Dragon")
                            .LeftClickRemote:FireServer(unpack(args))
                        --[[]
                    for i, player in pairs(game.workspace.Characters:GetChildren()) do
                        if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                            local args = {
                            [1] = player.HumanoidRootPart.Position,
                            [2] = 1
                        }
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex").LeftClickRemote:FireServer(unpack(args))
                    end
                    end
                    --]]
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if Config["Fast Attack"] then
            pcall(function()
                for i, player in pairs(game.workspace.Characters:GetChildren()) do
                    if player:FindFirstChild("HumanoidRootPart") and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
                        if (player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1250 then
                            local args = {
                                [1] = player.HumanoidRootPart.Position,
                                [2] = 1
                            }
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon-Dragon")
                                .LeftClickRemote:FireServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Fast Attack"] then
            pcall(function()
                for i,v in pairs(game.workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 50 then
                            local args = {
                                [1] = "TAP",
                                [2] = v.HumanoidRootPart.Position,
                                [3] = v.HumanoidRootPart.Position
                            }
                            
                            game:GetService("Players").LocalPlayer.Character.Humanoid:FindFirstChild(""):InvokeServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end
end)
_G['Bring Mob'] = true
spawn(function()
    while wait(0) do
        pcall(function()
            if _G['Bring Mob'] then
                CheckQuest()
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if _G['Auto Farm Level'] and _G['StartMagnet'] and v.Name == Mon and (Mon == "Factory Staff" or Mon == "Monkey" or Mon == "Dragon Crew Warrior" or Mon == "Dragon Crew Archer") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        v.HumanoidRootPart.CFrame = _G['PosMon']
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                    elseif _G['Auto Farm Level'] and _G['StartMagnet'] and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G['BringMode'] then
                        v.HumanoidRootPart.CFrame = _G['PosMon']
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                    end
                    if _G['Auto Farm [Nearest Mob]'] and _G['StartN'] and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G['BringMode'] then
                        v.HumanoidRootPart.CFrame = _G['PosMonN']
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                    end
                    if _G.AutoEctoplasm and StartEctoplasmMagnet then
                        if string.find(v.Name, "Ship") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - EctoplasmMon.Position).Magnitude <= _G['BringMode'] then
                            v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            v.HumanoidRootPart.CFrame = EctoplasmMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoRengoku and StartRengokuMagnet then
                        if (v.Name == "Snow Lurker" or v.Name == "Arctic Warrior") and (v.HumanoidRootPart.Position - RengokuMon.Position).Magnitude <= _G['BringMode'] and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(1500, 1500, 1500)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = RengokuMon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G['Auto Bartilo Quest'] and _G['AutoBartiloBring'] then
                        if v.Name == "Swan Pirate" and (v.HumanoidRootPart.Position - PosMonBarto.Position).Magnitude <= _G['BringMode'] and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = _G['PosMonBarto']
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G['Auto Farm Fast Mode'] and _G['Fast Mode'] then
                        if v.Name == "Swan Pirate" and (v.HumanoidRootPart.Position - PosMonBarto.Position).Magnitude <= _G['BringMode'] and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = _G['PosMonFastMode']
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G['Auto Farm Bone'] and _G['StartMagnetBoneMon'] then
                        if (v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy") and (v.HumanoidRootPart.Position - PosMonBone.Position).Magnitude <= _G['BringMode'] and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = _G['PosMonBone']
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G['Auto Fram Cake Prince'] and _G['MagnetDought'] then
                        if (v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker") and (v.HumanoidRootPart.Position - PosMonDoughtOpenDoor.Position).Magnitude <= _G['BringMode'] and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = _G['PosMonDoughtOpenDoor']
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
    end
end)
if World1 then
    _G['BringMode'] = 325
end
if L_4442272183_ then
    _G['BringMode'] = 325
end
if L_7449423635_ then
    _G['BringMode'] = 325
end
spawn(function()
    while wait(.1) do
        if Config['Auto Haki'] then
            pcall(function()
                if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                    local args = {
                        [1] = "Buso"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config['Auto Set Spawn Point'] then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            end)
        end
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if Config['Hide Notifications'] then
                game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Enabled = false
            else
                game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Enabled = true
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if Config['White Screen'] then
                game:GetService('RunService'):Set3dRenderingEnabled(false)
            else
                game:GetService('RunService'):Set3dRenderingEnabled(true)
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        if Config["Enabled Full Bright"] then
            pcall(function()
                game:GetService("Lighting").ClockTime = 14
            end)
        end
    end
end)
v2 = false
spawn(function()
    while wait() do
        if Config["Auto Farm Level"] then
            pcall(function()
                local v3 = (game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text)
                if not string.find(v3, NameMon) then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if (game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible) == false then
                    CheckQuest()
                    if (BypassTP) then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude >= (1500) then
                            BTP(CFrameQuest)
                        else
                            TP(CFrameQuest)
                        end
                    else
                        TP(CFrameQuest)
                    end
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= (20) then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest,
                            LevelQuest)
                    end
                elseif (game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible) == true then
                    CheckQuest()
                    v2 = false
                    if (workspace.Enemies:FindFirstChild(Mon)) then
                        for v4, v5 in pairs(workspace.Enemies:GetChildren()) do
                            if (v5:FindFirstChild("HumanoidRootPart") and v5:FindFirstChild("Humanoid") and v5.Humanoid.Health > (0)) then
                                if (v5.Name == Mon) then
                                    if (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon)) then
                                        repeat
                                            wait()
                                            EquipWeapon(_G['Select Weapon'])
                                            AutoHaki()
                                            v5.Humanoid.WalkSpeed = 0
                                            TP(v5.HumanoidRootPart.CFrame * Pos)
                                            BringMob(v5.HumanoidRootPart.CFrame)
                                        until not Config["Auto Farm Level"] or v5.Humanoid.Health <= 0 or not v5.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                            "AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        CheckMon()
                        if not v2 then
                            v2 = true
                            for _, v6 in ipairs({ CFrameMon1, CFrameMon2, CFrameMon3, CFrameMon4 }) do
                                if (workspace.Enemies:FindFirstChild(Mon)) then
                                    v2 = false
                                    break
                                end
                                TP(v6)
                                wait(0.65)
                            end
                            v2 = false
                        end
                        if (game:GetService("ReplicatedStorage"):FindFirstChild(Mon)) then
                            TP(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame *
                                CFrame.new(15, 10, 2))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Level"] and Config["Enabled Farm Fast"] then
            pcall(function()
                if game:GetService("Players").LocalPlayer.Data.Level.Value < 10 then
                local v3 = (game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text)
                if not string.find(v3, NameMon) then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if (game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible) == false then
                    CheckQuest()
                    if (BypassTP) then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude >= (1500) then
                            BTP(CFrameQuest)
                        else
                            TP(CFrameQuest)
                        end
                    else
                        TP(CFrameQuest)
                    end
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= (20) then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest,
                            LevelQuest)
                    end
                elseif (game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible) == true then
                    CheckQuest()
                    v2 = false
                    if (workspace.Enemies:FindFirstChild(Mon)) then
                        for v4, v5 in pairs(workspace.Enemies:GetChildren()) do
                            if (v5:FindFirstChild("HumanoidRootPart") and v5:FindFirstChild("Humanoid") and v5.Humanoid.Health > (0)) then
                                if (v5.Name == Mon) then
                                    if (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon)) then
                                        repeat
                                            wait()
                                            EquipWeapon(_G['Select Weapon'])
                                            AutoHaki()
                                            v5.Humanoid.WalkSpeed = 0
                                            TP(v5.HumanoidRootPart.CFrame * Pos)
                                            BringMob(v5.HumanoidRootPart.CFrame) 
                                        until not Config["Auto Farm Level"] or v5.Humanoid.Health <= 0 or not v5.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                            "AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        CheckMon()
                        if not v2 then
                            v2 = true
                            for _, v6 in ipairs({ CFrameMon1, CFrameMon2, CFrameMon3, CFrameMon4 }) do
                                if (workspace.Enemies:FindFirstChild(Mon)) then
                                    v2 = false
                                    break
                                end
                                TP(v6)
                                wait(0.65)
                            end
                            v2 = false
                        end
                        if (game:GetService("ReplicatedStorage"):FindFirstChild(Mon)) then
                            TP(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame *
                                CFrame.new(15, 10, 2))

                            end
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 10 and game:GetService("Players").LocalPlayer.Data.Level.Value < 75 then
                    local posffarmfffast = CFrame.new()
                    if (posffarmfffast.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1500  then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",
                        Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
                    else
                    end
                else
                end
            end)
        end
    end
end)
spawn(function()
    while task.wait() do
        if Config["Auto Farm [Nearest Mob]"] then
            pcall(function()
                for v12, v13 in pairs(workspace.Enemies:GetChildren()) do
                    if (v13.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= (2000) and v13.Humanoid.Health > (0) then
                        repeat
                            wait()
                            EquipWeapon(_G['Select Weapon'])
                            TP(v13.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                            BringMob(v13.HumanoidRootPart.CFrame)
                        until not Config["Auto Farm [Nearest Mob]"] or not v13.Parent or v13.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm All Boss"] then
            pcall(function()
                for i,v in pairs(game.ReplicatedStorage:GetChildren()) do
                    if string.find(v.Name, bossCheck) then
                        if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 17000 then
                            repeat task.wait()
                                AutoHaki()
                                EquipWeapon(_G['Select Weapon'])
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                TP(v.HumanoidRootPart.CFrame * Pos)
                                sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                            until v.Humanoid.Health <= 0 or not  Config["Auto Farm All Boss"] or not v.Parent
                        end
                    else
                        for i, v in pairs(workspace.Enemies:GetChildren()) do
                            if string.find(v.Name, bossCheck) then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G['Select Weapon'])
                                        TP(v.HumanoidRootPart.CFrame * Pos)
                                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius",
                                            math.huge)
                                    until not Config["Auto Farm All Boss"] or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Boss"] and not Config["Enabled Accept Quest"] then
            pcall(function()
                if workspace.Enemies:FindFirstChild(_G['Select Boss']) then
                    for i, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == _G['Select Boss'] then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G['Select Weapon'])
                                    TP(v.HumanoidRootPart.CFrame * Pos)
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius",
                                        math.huge)
                                until not Config["Auto Farm Boss"] or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    end
                else
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameBoss.Position).Magnitude > 1500 then
                            TP(CFrameBoss)
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameBoss.Position).Magnitude < 1500 then
                            TP(CFrameBoss)
                        end
                    else
                        TP(CFrameBoss)
                    end
                    if game:GetService("ReplicatedStorage"):FindFirstChild(_G['Select Boss']) then
                        TP(game:GetService("ReplicatedStorage"):FindFirstChild(_G['Select Boss']).HumanoidRootPart
                            .CFrame * CFrame.new(5, 10, 2))
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Boss"] and Config["Enabled Accept Quest"] then
            pcall(function()
                CheckBossQuest()
                local QuestBoss = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle
                    .Title.Text
                if not string.find(QuestBoss, NameBoss) then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuestBoss.Position).Magnitude > 1500 then
                            TP(CFrameQuestBoss)
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuestBoss.Position).Magnitude < 1500 then
                            TP(CFrameQuestBoss)
                        end
                    else
                        TP(CFrameQuestBoss)
                    end
                    if (CFrameQuestBoss.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuestBoss,
                            LevelQuestBoss)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    if workspace.Enemies:FindFirstChild(_G['Select Boss']) then
                        for i, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == _G['Select Boss'] then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameBoss) then
                                        repeat
                                            task.wait()
                                            EquipWeapon(_G['Select Weapon'])
                                            AutoHaki()
                                            TP(v.HumanoidRootPart.CFrame * Pos)
                                        until not Config["Auto Farm Boss"] or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                            "AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        TP(CFrameBoss)
                        if game:GetService("ReplicatedStorage"):FindFirstChild(_G['Select Boss']) then
                            TP(game:GetService("ReplicatedStorage"):FindFirstChild(_G['Select Boss'])
                                .HumanoidRootPart.CFrame * CFrame.new(15, 10, 2))
                        end
                    end
                end
            end)
        end
    end
end)
CheckMonM = false
spawn(function()
    while wait() do
        if Config["Auto Farm Mastery Fruit [Level]"] then
            pcall(function()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle
                    .Title.Text
                if not string.find(QuestTitle, NameMon) then
                    _G['Enabled Aimbot Mastery'] = false
                    _G['UseSkill'] = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    _G['Enabled Aimbot Mastery'] = false
                    _G['UseSkill'] = false
                    CheckQuest()
                    repeat
                        wait()
                        TP(CFrameQuest)
                    until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not Config["Auto Farm Mastery Fruit [Level]"]
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest,
                            LevelQuest)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CheckQuest()
                    if workspace.Enemies:FindFirstChild(Mon) then
                        for i, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        HealthMs = v.Humanoid.MaxHealth * _G['Kill At'] / 100
                                        repeat
                                            task.wait()
                                            if v.Humanoid.Health <= HealthMs then
                                                AutoHaki()
                                                EquipWeapon(game:GetService("Players").LocalPlayer.Data.DevilFruit
                                                    .Value)
                                                PosMonMasteryFruit = v.HumanoidRootPart.Position
                                                BringMob(v.HumanoidRootPart.CFrame)
                                                TP(v.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0)) 
                                                _G['Enabled Aimbot Mastery'] = true
                                                _G['UseSkill'] = true
                                            else
                                                _G['Enabled Aimbot Mastery'] = false
                                                _G['UseSkill'] = false
                                                AutoHaki()
                                                EquipWeapon(_G['Select Weapon'])
                                                BringMob(v.HumanoidRootPart.CFrame)
                                                TP(v.HumanoidRootPart.CFrame * Pos)
                                                PosMonMasteryFruit = v.HumanoidRootPart.Position
                                            end
                                        until not Config["Auto Farm Mastery Fruit [Level]"] or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        _G['Enabled Aimbot Mastery'] = false
                                        _G['UseSkill'] = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                            "AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        _G['Enabled Aimbot Mastery'] = false
                        _G['UseSkill'] = false
                        CheckMon()
                        if not CheckMonM then
                            CheckMonM = true
                            for _, cframemon in ipairs({ CFrameMon1, CFrameMon2, CFrameMon3, CFrameMon4 }) do
                                if (workspace.Enemies:FindFirstChild(Mon)) then
                                    CheckMonM = false
                                    break
                                end
                                TP(cframemon)
                                wait(0.65)
                            end
                            CheckMonM = false
                        end
                        if (game:GetService("ReplicatedStorage"):FindFirstChild(Mon)) then
                            TP(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame *
                                CFrame.new(15, 10, 2))
                        end
                    end
                end
            end)
        end
    end
end)
CheckMonMG = false
spawn(function()
    while wait() do
        if Config["Auto Farm Mastery Gun [Level]"] then
            pcall(function()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle
                    .Title.Text
                if not string.find(QuestTitle, NameMon) then
                    _G['Enabled Aimbot Mastery Gun'] = false
                    _G['UseSkill'] = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    _G['Enabled Aimbot Mastery Gun'] = false
                    _G['UseSkill'] = false
                    CheckQuest()
                    repeat
                        wait()
                        TP(CFrameQuest)
                    until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not Config["Auto Farm Mastery Gun [Level]"]
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest,
                            LevelQuest)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CheckQuest()
                    if workspace.Enemies:FindFirstChild(Mon) then
                        for i, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        HealthMin = v.Humanoid.MaxHealth * _G['Kill At'] / 100
                                        repeat
                                            task.wait()
                                            if v.Humanoid.Health <= HealthMin then
                                                AutoHaki()
                                                EquipWeaponGun()
                                                PosMonMasteryGun = v.HumanoidRootPart.Position
                                                TP(v.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                                BringMob(v.HumanoidRootPart.CFrame)
                                                _G['Enabled Aimbot Mastery Gun'] = true
                                                _G['UseSkill'] = true
                                                local args = {
                                                    [1] = v.HumanoidRootPart.Position,
                                                    [2] = {}
                                                }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Modules")
                                                    :WaitForChild("Net"):WaitForChild("RE/ShootGunEvent"):FireServer(
                                                    unpack(args))
                                            else
                                                _G['Enabled Aimbot Mastery Gun'] = false
                                                _G['UseSkill'] = false
                                                AutoHaki()
                                                EquipWeapon(_G['Select Weapon'])
                                                TP(v.HumanoidRootPart.CFrame * Pos)
                                                PosMonMasteryGun = v.HumanoidRootPart.Position
                                                BringMob(v.HumanoidRootPart.CFrame)  
                                            end
                                        until not Config["Auto Farm Mastery Gun [Level]"] or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        _G['Enabled Aimbot Mastery Gun'] = false
                                        _G['UseSkill'] = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                            "AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        _G['Enabled Aimbot Mastery Gun'] = false
                        _G['UseSkill'] = false
                        CheckMon()
                        if not CheckMonMG then
                            CheckMonMG = true
                            for _, cframemonG in ipairs({ CFrameMon1, CFrameMon2, CFrameMon3, CFrameMon4 }) do
                                if (workspace.Enemies:FindFirstChild(Mon)) then
                                    CheckMonMG = false
                                    break
                                end
                                TP(cframemonG)
                                wait(0.65)
                            end
                            CheckMonMG = false
                        end
                        if (game:GetService("ReplicatedStorage"):FindFirstChild(Mon)) then
                            TP(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame *
                                CFrame.new(15, 10, 2))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Mastery Fruit [Bone]"] and L_7449423635_ then
            pcall(function()
                if (ByPassTP) then
                    BTP(CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625))
                elseif not (ByPassTP) then
                    TP(CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625))
                end
                for v33, v34 in pairs(Workspace.Enemies:GetChildren()) do
                    if v34:FindFirstChild("Humanoid") and v34:FindFirstChild("HumanoidRootPart") and v34.Humanoid.Health > (0) then
                        if v34.Name == "Reborn Skeleton" or v34.Name == "Living Zombie" or v34.Name == "Demonic Soul" or v34.Name == "Posessed Mummy" then
                            HealthMin = v34.Humanoid.MaxHealth * _G['Kill At'] / 100
                            repeat
                                task.wait()
                                if v34.Humanoid.Health <= HealthMin then
                                    AutoHaki()
                                    EquipWeaponFruit()
                                    PosMonMasteryGun = v34.HumanoidRootPart.Position
                                    TP(v34.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                    BringMob(v34.HumanoidRootPart.CFrame) 
                                    _G['Enabled Aimbot Mastery Gun'] = true
                                    _G['UseSkill'] = true
                                else
                                    _G['Enabled Aimbot Mastery Gun'] = false
                                    _G['UseSkill'] = false
                                    AutoHaki()
                                    EquipWeapon(_G['Select Weapon'])
                                    TP(v34.HumanoidRootPart.CFrame * Pos)
                                    PosMonMasteryGun = v34.HumanoidRootPart.Position
                                    BringMob(v34.HumanoidRootPart.CFrame)
                                end
                            until not Config["Auto Farm Mastery Fruit [Bone]"] or not v34.Parent or v34.Humanoid.Health <= 0 or not Workspace.Enemies:FindFirstChild(v34.Name)
                        end
                    end
                end
                for v33, v34 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                    if v34.Name == "Reborn Skeleton" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    elseif v34.Name == "Living Zombie" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    elseif v34.Name == "Demonic Soul" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    elseif v34.Name == "Posessed Mummy" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Mastery Gun [Bone]"] and L_7449423635_ then
            pcall(function()
                if (ByPassTP) then
                    BTP(CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625))
                elseif not (ByPassTP) then
                    TP(CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625))
                end
                for v33, v34 in pairs(Workspace.Enemies:GetChildren()) do
                    if v34:FindFirstChild("Humanoid") and v34:FindFirstChild("HumanoidRootPart") and v34.Humanoid.Health > (0) then
                        if v34.Name == "Reborn Skeleton" or v34.Name == "Living Zombie" or v34.Name == "Demonic Soul" or v34.Name == "Posessed Mummy" then
                            HealthMin = v34.Humanoid.MaxHealth * _G['Kill At'] / 100
                            repeat
                                task.wait()
                                if v34.Humanoid.Health <= HealthMin then
                                    AutoHaki()
                                    EquipWeaponGun()
                                    PosMonMasteryGun = v34.HumanoidRootPart.Position
                                    TP(v34.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                    BringMob(v34.HumanoidRootPart.CFrame) 
                                    _G['Enabled Aimbot Mastery Gun'] = true
                                    _G['UseSkill'] = true
                                else
                                    _G['Enabled Aimbot Mastery Gun'] = false
                                    _G['UseSkill'] = false
                                    AutoHaki()
                                    EquipWeapon(_G['Select Weapon'])
                                    TP(v34.HumanoidRootPart.CFrame * Pos)
                                    PosMonMasteryGun = v34.HumanoidRootPart.Position
                                    BringMob(v34.HumanoidRootPart.CFrame)
                                end
                            until not Config["Auto Farm Mastery Gun [Bone]"] or not v34.Parent or v34.Humanoid.Health <= 0 or not Workspace.Enemies:FindFirstChild(v34.Name)
                        end
                    end
                end
                for v33, v34 in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                    if v34.Name == "Reborn Skeleton" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    elseif v34.Name == "Living Zombie" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    elseif v34.Name == "Demonic Soul" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    elseif v34.Name == "Posessed Mummy" then
                        TP(v34.HumanoidRootPart.CFrame * Pos)
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Mastery Fruit [Cake Prince]"] and L_7449423635_ then
            pcall(function()
                if (game.ReplicatedStorage:FindFirstChild("Cake Prince") or workspace.Enemies:FindFirstChild("Cake Prince")) then
                    if (workspace.Enemies:FindFirstChild("Cake Prince")) then
                        for v28, v29 in pairs(Workspace.Enemies:GetChildren()) do
                            if (Config["Auto Fram Cake Prince"] and v29.Name == "Cake Prince" and v29:FindFirstChild("HumanoidRootPart") and v29:FindFirstChild("Humanoid") and v29.Humanoid.Health) > (0) then
                                HealthMin = v29.Humanoid.MaxHealth * _G['Kill At'] / 100
                                repeat
                                    game:GetService("RunService").Heartbeat:wait()
                                    if v29.Humanoid.Health <= HealthMin then
                                        AutoHaki()
                                        EquipWeaponFruit()
                                        PosMonMasteryGun = v29.HumanoidRootPart.Position
                                        TP(v29.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                        BringMob(v34.HumanoidRootPart.CFrame)
                                        _G['Enabled Aimbot Mastery Gun'] = true
                                        _G['UseSkill'] = true
                                    else
                                        _G['Enabled Aimbot Mastery Gun'] = false
                                        _G['UseSkill'] = false
                                        AutoHaki()
                                        EquipWeapon(_G['Select Weapon'])
                                        TP(v29.HumanoidRootPart.CFrame * Pos)
                                        PosMonMasteryGun = v29.HumanoidRootPart.Position
                                        BringMob(v29.HumanoidRootPart.CFrame)  
                                    end
                                until not Config["Auto Farm Mastery Fruit [Cake Prince]"] or not v29.Parent or v29.Humanoid.Health <= 0
                            end
                        end
                    else
                        if (game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == (0) and (CFrame.new(-1990.672607421875, 4532.99951171875, -14973.6748046875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position)).Magnitude >= (1000) then
                            TP(CFrame.new(-2151.82153, 149.315704, -12404.9053))
                        end
                    end
                else
                    if (workspace.Enemies:FindFirstChild("Cookie Crafter") or workspace.Enemies:FindFirstChild("Cake Guard") or workspace.Enemies:FindFirstChild("Baking Staff") or workspace.Enemies:FindFirstChild("Head Baker")) then
                        for v30, v31 in pairs(Workspace.Enemies:GetChildren()) do
                            if (v31:FindFirstChild("Humanoid") and v31:FindFirstChild("HumanoidRootPart") and v31.Humanoid.Health) > (0) then
                                if (v31.Name == "Cookie Crafter" or v31.Name == "Cake Guard" or v31.Name == "Baking Staff" or v31.Name == "Head Baker") and v31:FindFirstChild("HumanoidRootPart") and v31:FindFirstChild("Humanoid") and v31.Humanoid.Health > (0) then
                                HealthMin = v31.Humanoid.MaxHealth * _G['Kill At'] / 100
                                    repeat
                                        wait()
                                        if v31.Humanoid.Health <= HealthMin then
                                            AutoHaki()
                                            EquipWeaponFruit()
                                            PosMonMasteryGun = v31.HumanoidRootPart.Position
                                            TP(v31.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                            BringMob(v34.HumanoidRootPart.CFrame)
                                            _G['Enabled Aimbot Mastery Gun'] = true
                                            _G['UseSkill'] = true
                                        else
                                            _G['Enabled Aimbot Mastery Gun'] = false
                                            _G['UseSkill'] = false
                                            AutoHaki()
                                            EquipWeapon(_G['Select Weapon'])
                                            TP(v31.HumanoidRootPart.CFrame * Pos)
                                            PosMonMasteryGun = v31.HumanoidRootPart.Position
                                            BringMob(v34.HumanoidRootPart.CFrame)
                                        end
                                    until not Config["Auto Farm Mastery Fruit [Cake Prince]"] or not v31.Parent or v31.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if (ByPassTP) then
                            BTP(CFrame.new(-2077, 252, -12373))
                        else
                            TP(CFrame.new(-2077, 252, -12373))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Mastery Gun [Cake Prince]"] and L_7449423635_ then
            pcall(function()
                if (game.ReplicatedStorage:FindFirstChild("Cake Prince") or workspace.Enemies:FindFirstChild("Cake Prince")) then
                    if (workspace.Enemies:FindFirstChild("Cake Prince")) then
                        for v28, v29 in pairs(Workspace.Enemies:GetChildren()) do
                            if (Config["Auto Fram Cake Prince"] and v29.Name == "Cake Prince" and v29:FindFirstChild("HumanoidRootPart") and v29:FindFirstChild("Humanoid") and v29.Humanoid.Health) > (0) then
                                HealthMin = v29.Humanoid.MaxHealth * _G['Kill At'] / 100
                                repeat
                                    game:GetService("RunService").Heartbeat:wait()
                                    if v29.Humanoid.Health <= HealthMin then
                                        AutoHaki()
                                        EquipWeaponGun()
                                        PosMonMasteryGun = v29.HumanoidRootPart.Position
                                        TP(v29.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                        BringMob(v29.HumanoidRootPart.CFrame) 
                                        _G['Enabled Aimbot Mastery Gun'] = true
                                        _G['UseSkill'] = true
                                    else
                                        _G['Enabled Aimbot Mastery Gun'] = false
                                        _G['UseSkill'] = false
                                        AutoHaki()
                                        EquipWeapon(_G['Select Weapon'])
                                        TP(v29.HumanoidRootPart.CFrame * Pos)
                                        PosMonMasteryGun = v29.HumanoidRootPart.Position
                                        BringMob(v29.HumanoidRootPart.CFrame) 
                                    end
                                until not Config["Auto Farm Mastery Fruit [Cake Prince]"] or not v29.Parent or v29.Humanoid.Health <= 0
                            end
                        end
                    else
                        if (game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == (0) and (CFrame.new(-1990.672607421875, 4532.99951171875, -14973.6748046875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position)).Magnitude >= (1000) then
                            TP(CFrame.new(-2151.82153, 149.315704, -12404.9053))
                        end
                    end
                else
                    if (workspace.Enemies:FindFirstChild("Cookie Crafter") or workspace.Enemies:FindFirstChild("Cake Guard") or workspace.Enemies:FindFirstChild("Baking Staff") or workspace.Enemies:FindFirstChild("Head Baker")) then
                        for v30, v31 in pairs(Workspace.Enemies:GetChildren()) do
                            if (v31:FindFirstChild("Humanoid") and v31:FindFirstChild("HumanoidRootPart") and v31.Humanoid.Health) > (0) then
                                if (v31.Name == "Cookie Crafter" or v31.Name == "Cake Guard" or v31.Name == "Baking Staff" or v31.Name == "Head Baker") and v31:FindFirstChild("HumanoidRootPart") and v31:FindFirstChild("Humanoid") and v31.Humanoid.Health > (0) then
                                HealthMin = v31.Humanoid.MaxHealth * _G['Kill At'] / 100
                                    repeat
                                        wait()
                                        if v31.Humanoid.Health <= HealthMin then
                                            AutoHaki()
                                            EquipWeaponGun()
                                            PosMonMasteryGun = v31.HumanoidRootPart.Position
                                            TP(v31.HumanoidRootPart.CFrame * CFrame.new(0,Config["Farm Distance"],0))
                                            --BringMob(v34.HumanoidRootPart.CFrame)
                                            BringMob(v31.HumanoidRootPart.CFrame) 
                                            _G['Enabled Aimbot Mastery Gun'] = true
                                            _G['UseSkill'] = true
                                        else
                                            _G['Enabled Aimbot Mastery Gun'] = false
                                            _G['UseSkill'] = false
                                            AutoHaki()
                                            EquipWeapon(_G['Select Weapon'])
                                            TP(v31.HumanoidRootPart.CFrame * Pos)
                                            PosMonMasteryGun = v31.HumanoidRootPart.Position
                                            --BringMob(v34.HumanoidRootPart.CFrame)
                                            BringMob(v31.HumanoidRootPart.CFrame) 
                                        end
                                    until not Config["Auto Farm Mastery Gun [Cake Prince]"] or not v31.Parent or v31.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if (ByPassTP) then
                            BTP(CFrame.new(-2077, 252, -12373))
                        else
                            TP(CFrame.new(-2077, 252, -12373))
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if not Config["Auto Farm Mastery Gun [Level]"] or Config["Auto Farm Mastery Fruit [Level]"] then
            pcall(function()
                _G['UseSkill'] = false
                wait(0.1)
                _G['Enabled Aimbot Mastery Gun'] = false
                wait(0.1)
                _G['Enabled Aimbot Mastery'] = false
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G['UseSkill'] then
            pcall(function()
                if _G['Skill Z'] then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                    wait(0.1)
                    game:service("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                end
                if _G['Skill X'] then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                    wait(0.1)
                    game:service("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                end
                if _G['Skill C'] then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                    wait(0.1)
                    game:service("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
                end
                if _G['Skill V'] then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                    wait(0.1)
                    game:service("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
                end
                if _G['Skill F'] then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                    wait(0.1)
                    game:service("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                end
            end)
        end
    end
end)
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local center = Camera.ViewportSize / 2
local Player = game.Players.LocalPlayer
function EquipWeaponFish()
    pcall(function()
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "JobTool" then
                Player.Character.Humanoid:EquipTool(v)
            end
        end
    end)
end
--[[]
spawn(function()
    while wait() do
        if Config["Auto Fishing"] then
            pcall(function()
                for _, v in pairs(Player.Character:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Fishing_Cast Meter" and (v:GetAttribute("State") ~= "Waiting" and v:GetAttribute("State") ~= "Launching") then
                        VIM:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 1)
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 1)
                    elseif v:IsA("Tool") and v.Name == "Fishing_Cast Meter" and (v:GetAttribute("State") ~= "Waiting" and v:GetAttribute("State") ~= "Launching") then
                        if v.CastMeter.Bar.Frame.BackgroundColor3 == Color3.fromRGB(55,255,0) then
                            VIM:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 1)
                            task.wait(0.1)
                            VIM:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 1)
                        end
                    elseif v:IsA("Tool") and (v:GetAttribute("State") == "Waiting" or v:GetAttribute("State") == "Launching") then
                    elseif not v:IsA("Tool") then
                        EquipWeaponFish()
                    elseif v:IsA("Tool") and (v:GetAttribute("State") == "Playing") then
                        game:GetService("ReplicatedStorage").FishReplicated.FishingRequest:InvokeServer("Catch",1,1,0.9851064984812247)
                    end
                end
            end)
        end
    end
end)
--]]
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local distance = math.random(30, 70)
local angle = math.rad(math.random(-20, 20))
local lookVector = HRP.CFrame.LookVector
local rotatedVector = (CFrame.fromAxisAngle(Vector3.new(0,1,0), angle) * lookVector)
local castPosition = HRP.Position + (rotatedVector * distance)
spawn(function()
    while wait() do
        if Config["Auto Fishing"] then
            pcall(function()
                local args = {
                    "StartCasting"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("FishReplicated"):WaitForChild("FishingRequest"):InvokeServer(unpack(args))
                local args = {
                    "CastLineAtLocation",
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
                    100,
                    true
                }
                game:GetService("ReplicatedStorage"):WaitForChild("FishReplicated"):WaitForChild("FishingRequest"):InvokeServer(unpack(args))
                local args = {
                    "Catching",
                    true,
                    {
                        fastBite = true
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("FishReplicated"):WaitForChild("FishingRequest"):InvokeServer(unpack(args))
                local args = {
                    "Catch",
                    1,
                    0,
                    0.9078708211247271
                }
                game:GetService("ReplicatedStorage"):WaitForChild("FishReplicated"):WaitForChild("FishingRequest"):InvokeServer(unpack(args))
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Sell Fish"] then
            pcall(function()
                local args = {
                    "FishingNPC",
                    "SellFish"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/JobsRemoteFunction"):InvokeServer(unpack(args))
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Oni Soldier"] then
            pcall(function()
                local pos = CFrame.new(-4874.89551, -4169.51709, 4323.7627, -0.126709223, 1.07911422e-08, -0.991939902, -1.04938373e-07, 1, 2.42835299e-08, 0.991939902, 1.07169512e-07, -0.126709223)
                if (pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
                    local args = {
                        "InitiateTeleportToTemple"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/OniTempleTransportation"):InvokeServer(unpack(args))
                else
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == "Oni Soldier" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                            repeat wait()
                            EquipWeapon(_G['Select Weapon'])
                            TP(v.HumanoidRootPart.CFrame * Pos)
                            BringMob(v.HumanoidRootPart.CFrame)
                            until not Config["Auto Farm Oni Soldier"] or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Oni Soldier"] then
            pcall(function()
                local pos = CFrame.new(-4874.89551, -4169.51709, 4323.7627, -0.126709223, 1.07911422e-08, -0.991939902, -1.04938373e-07, 1, 2.42835299e-08, 0.991939902, 1.07169512e-07, -0.126709223)
                local posx = CFrame.new(-243.375778, 21.051712, 5549.46191, -0.288501978, -4.17173212e-08, -0.957479298, -1.66592962e-08, 1, -3.85502652e-08, 0.957479298, 4.82910334e-09, -0.288501978)
                if (posx.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 2100 and (pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1300 then
                    TP(posx)
                else
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Farm Red Commander"] then
            pcall(function()
                for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == "Red Commander" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                        repeat wait()
                        EquipWeapon(_G['Select Weapon'])
                        TP(v.HumanoidRootPart.CFrame * Pos)
                        BringMob(v.HumanoidRootPart.CFrame)
                        until not Config["Auto Farm Red Commander"] or v.Humanoid.Health <= 0 or not v.Parent
                    else
                        local args = {
                            "InitiateTeleportToInterior"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/OniTempleTransportation"):InvokeServer(unpack(args))
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Config["Auto Summon Red Gacha"] then
            pcall(function()
                local args = {
                    "Cousin",
                    "BuyRedHead"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
            end)
        end
    end
end)
local bait = {}
local baitrequire = require(game:GetService("ReplicatedStorage").Modules.Asset.ItemData.Types.Bait)
for i,v in pairs(baitrequire) do
    table.insert(bait,i)
end
local Boss = {}
for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
    if string.find(v.Name, "Boss") then
        if v.Name ~= "Ice Admiral" then
            table.insert(Boss, v.Name)
        end
    end
end
local bossNames = {
    "The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Warden", "Chief Warden",
    "Swan", "Saber Expert", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Greybeard",
    "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Order",
    "Darkbeard", "Cursed Captain", "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant",
    "Beautiful Pirate", "Longma", "Cake Queen", "Soul Reaper", "Rip_Indra", "Cake Prince", "Dough King"
}
local function updateBossList()
    local bossCheck = {}
    for _, bossName in pairs(bossNames) do
        if game:GetService("ReplicatedStorage"):FindFirstChild(bossName) then
            table.insert(bossCheck, bossName)
        end
    end
    for _, bossName in pairs(bossNames) do
        if workspace.Enemies:FindFirstChild(bossName) then
            table.insert(bossCheck, bossName)
        end
    end
    for _, name in pairs(Boss) do
        table.insert(bossCheck, name)
    end
    return bossCheck
end
local bossCheck = updateBossList()
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local center = Camera.ViewportSize / 2
Settings = {
    ['Team'] = nil, -- Pirates/Marines
}
local v1 = game:GetService("Players").LocalPlayer.Team
if v1 ~= "Pirates" or v1 ~= "Marines" then
    if Settings['Team'] ~= "Pirates" or Settings['Team'] ~= "Marines" then
        local args = {
            [1] = "SetTeam",
            [2] = "Marines",
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    elseif Settings['Team'] == "Pirates" then
        local args = {
            [1] = "SetTeam",
            [2] = "Pirates",
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    elseif Settings['Team'] == "Marines" then
        local args = {
            [1] = "SetTeam",
            [2] = "Marines",
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end
local DynamicNotify = function(Text_i,Duration_i)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Dynamic Hub",
        Text = Text_i,
        Duration = Duration_i,
        Icon = "rbxassetid://105608302686093"
    })
end
DynamicNotify("discord.gg/BFuEmqUgPq",5)
if game:GetService("Players").LocalPlayer.Team then end
wait(1.5)
local Window = Fluent:CreateWindow({
	Size = UDim2.fromOffset(620, 420),
	Title = "Blox Fruit - Dynamic Hub",
	SubTitle = "By thanakrit0067",
	TabWidth = 160,
})
local Tabs = {
    General = Window:AddTab({ Title = "General", Icon = "component" }),
    Quest = Window:AddTab({ Title = "Quest", Icon = "scroll" }),
    item = Window:AddTab({ Title = "item", Icon = "package-plus" }),
    Combat = Window:AddTab({ Title = "Combat ", Icon = "user" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "signal" }),
    Materials = Window:AddTab({ Title = "Materials", Icon = "box" }),
    MirageandRace = Window:AddTab({ Title = "Race & Mirage", Icon = "rbxassetid://88290704589579" }),
    Events = Window:AddTab({ Title = "Events", Icon = "party-popper" }),
    VolcanoEvents = Window:AddTab({ Title = "Volcano Events", Icon = "Dragondojo" }), 
    Location = Window:AddTab({ Title = "Location", Icon = "compass" }),
    Esp = Window:AddTab({ Title = "Esp", Icon = "eye" }),
    DevilFruit = Window:AddTab({ Title = "Devil Fruit", Icon = "apple" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Dungeons = Window:AddTab({ Title = "Dungeons", Icon = "shield" }),
    FarmSettings = Window:AddTab({ Title = "Farm Settings", Icon = "sliders-horizontal" }),
    Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "fingerprint" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local gg = getrawmetatable(game)
local old = gg.__namecall
setreadonly(gg, false)
gg.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = { ... }
    if tostring(method) == "FireServer" then
        if tostring(args[1]) == "RemoteEvent" then
            if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                if _G['Enabled Aimbot Mastery'] then
                    args[2] = PosMonMasteryFruit
                    return old(unpack(args))
                end
            end
        end
    end
    return old(...)
end)
local gg = getrawmetatable(game)
local old = gg.__namecall
setreadonly(gg, false)
gg.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = { ... }
    if tostring(method) == "FireServer" then
        if tostring(args[1]) == "RemoteEvent" then
            if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                if _G['Enabled Aimbot Mastery Gun'] then
                    args[2] = PosMonMasteryGun
                    return old(unpack(args))
                end
            end
        end
    end
    return old(...)
end)
local Options = Fluent.Options
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local humanoidRootPart = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Config = getgenv().Config
function AllFunS(s , d)
local section = s:AddSection(d)
return section
end
function AllFun(s,t , d , n , dd)
    local toggle = s:AddToggle("MyToggle", {
        Title = t,
        Description = d,
        Default = Config[dd] ~= nil and Config[dd] or n,
        Callback = function(Value)
            Config[dd] = Value
            getgenv()['Update_Setting'](getgenv()['MyName'])
            _St(Config[dd])
        end
    })
end
function AllFunD(s, t , d , v , n , m , dd , sh)
    local dropdown = s:AddDropdown("Dropdown", {
        Title = t,
        Description = d,
        Values = v,
        Multi = m,
        Default = Config[dd] or n,
        Searchable = sh
    })
    dropdown:OnChanged(function(Value)
        Config[dd] = Value
        getgenv()['Update_Setting'](getgenv()['MyName'])
    end)
    return dropdown
end
function AllFunB(s, t , dd , callback)
    local button = s:AddButton({
        Title = t,
        Description = dd,
        Callback = callback
    })
    return button
end
function AllFunSs(s, t , d , dd , default , min , max , rounding)
local slider = s:AddSlider("Slider",
    {
        Title = t,
        Description = d,
        Default = Config[dd] or default,
        Min = min,
        Max = max,
        Rounding = rounding,
        Callback = function(Value)
            Config[dd] = Value
            getgenv()['Update_Setting'](getgenv()['MyName'])
        end
    })
    return slider
end
function AllFunP(tab, title, content)
    local paragraph = tab:AddParagraph({
        Title = title,
        Content = content
    })
    return paragraph
end
task.defer(function()
Main = AllFunS(Tabs.General,"Main")
Boss = AllFunS(Tabs.General,"Boss")
Red_Event = AllFunS(Tabs.General,"Red Event")
Fishing = AllFunS(Tabs.General,"Fishing")
Mastery = AllFunS(Tabs.General,"Mastery")
Berry = AllFunS(Tabs.General,"Berry")
Next_World = AllFunS(Tabs.General,"Next World")
Factory = AllFunS(Tabs.General,"Factory")
Castle_Raid = AllFunS(Tabs.General,"Castle Raid")
Chest = AllFunS(Tabs.General,"Chest")
Cake_Prince = AllFunS(Tabs.General,"Cake Prince")
Bone = AllFunS(Tabs.General,"Bone")
Elite_Hunter = AllFunS(Tabs.General,"Elite Hunter")
Tyrant_of_the_Skies = AllFunS(Tabs.General,"Tyrant of the Skies")
Observations = AllFunS(Tabs.General,"Observations")
Ectoplasm = AllFunS(Tabs.General,"Ectoplasm")
Sea_Beasts = AllFunS(Tabs.General,"Sea Beasts")
Evo = AllFunS(Tabs.General,"Evo")
Order_Law = AllFunS(Tabs.General,"Order - Law")
Bartilo = AllFunS(Tabs.Quest,"Bartilo")
Musketeer_Hat = AllFunS(Tabs.Quest,"Musketeer Hat")
Rainbow_Haki = AllFunS(Tabs.Quest,"Rainbow Haki")
Fighting_Styles = AllFunS(Tabs.item,"Fighting Styles")
Hallow_Sycthe = AllFunS(Tabs.item,"Hallow Sycthe")
Bisento = AllFunS(Tabs.item,"Bisento")
Saber = AllFunS(Tabs.item,"Saber")
Pole = AllFunS(Tabs.item,"Pole")
Swan_Glasses = AllFunS(Tabs.item,"Swan Glasses")
Lengedary_Sword = AllFunS(Tabs.item,"Lengedary Sword")
Rengoku = AllFunS(Tabs.item,"Rengoku")
Budy_Sword = AllFunS(Tabs.item,"Budy Sword")
Canvander = AllFunS(Tabs.item,"Canvander")
Yama = AllFunS(Tabs.item,"Yama")
Twin_Hooks = AllFunS(Tabs.item,"Twin Hooks")
Soul_Guitar = AllFunS(Tabs.item,"Soul Guitar")
Tushita = AllFunS(Tabs.item,"Tushita")
Cursed_Dual_Katana = AllFunS(Tabs.item,"Cursed Dual Katana")
Combat = AllFunS(Tabs.Combat,"Combat")
Farm_Settings = AllFunS(Tabs.FarmSettings,"Farm Settings")
AllFun(Main,"Auto Farm Level",nil,false,"Auto Farm Level")
AllFun(Main,"Enabled Farm Fast",nil,false,"Enabled Farm Fast")
AllFun(Main,"Auto Farm [ Nearest Mob ]",nil,false,"Auto Farm [Nearest Mob]")
AllFunD(Boss,"Select Boss",nil,bossCheck,false,false,"Select Boss",true)
AllFunB(Boss, "Refresh Boss", nil, function() local bossCheck = updateBossList() BossDrop:SetValues(bossCheck) end)
AllFun(Boss,"Auto Farm Boss",nil,false,"Auto Farm Boss")
AllFun(Boss,"Auto Farm All Boss",nil,false,"Auto Farm All Boss")
AllFun(Boss,"Enabled Accept Quest",nil,false,"Enabled Accept Quest")
AllFun(Red_Event,"Auto Farm Oni Soldier",nil,false,"Auto Farm Oni Soldier")
AllFun(Red_Event,"Auto Farm Red Commander",nil,false,"Auto Farm Red Commander")
AllFun(Red_Event,"Auto Summon Red Gacha",nil,false,"Auto Summon Red Gacha")
AllFunB(Red_Event, "Teleport to Temple", nil, function() local args = {"InitiateTeleportToTemple"}game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/OniTempleTransportation"):InvokeServer(unpack(args))end)
AllFunB(Red_Event, "Teleport to Interior", nil, function() local args = {"InitiateTeleportToInterior"}game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/OniTempleTransportation"):InvokeServer(unpack(args))end)
AllFunD(Fishing,"Select Bait",nil,bait,false,false,"Select Bait",true)
AllFun(Fishing,"Auto Fishing",nil,false,"Auto Fishing")
AllFun(Fishing,"Auto Sell Fish",nil,false,"Auto Sell Fish")
AllFunB(Fishing, "Get Rod", nil, function() local args = {"FishingNPC","FirstTimeFreeRod"} game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/JobsRemoteFunction"):InvokeServer(unpack(args)) end)
AllFunB(Fishing, "Buy Bait", nil, function()local args = {"Craft",Config["Select Bait"],{}}game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft"):InvokeServer(unpack(args)) end)
AllFun(Mastery,"Auto Farm Mastery Fruit [ Level ]",nil,false,"Auto Farm Mastery Fruit [Level]")
AllFun(Mastery,"Auto Farm Mastery Gun [ Level ]",nil,false,"Auto Farm Mastery Gun [Level]")
AllFun(Mastery,"Auto Farm Mastery Fruit [ Bone ]",nil,false,"Auto Farm Mastery Fruit [Bone]")
AllFun(Mastery,"Auto Farm Mastery Gun [ Bone ]",nil,false,"Auto Farm Mastery Gun [Bone]")
AllFun(Mastery,"Auto Farm Mastery Fruit [ Cake Prince ]",nil,false,"Auto Farm Mastery Fruit [Level]")
AllFun(Mastery,"Auto Farm Mastery Gun [ Cake Prince ]",nil,false,"Auto Farm Mastery Gun [Cake Prince]")
AllFunSs(Mastery,"Kill At Health %",nil,"Kill At",25,10,100,0)
AllFun(Berry,"Auto Collect Berry",nil,false,"Auto Collect Berry")
AllFun(Berry,"Auto Collect Berry Hop",nil,false,"Auto Collect Berry Hop")
AllFun(Next_World,"Auto Second Sea",nil,false,"Auto Second Sea")
AllFun(Next_World,"Auto Third Sea",nil,false,"Auto Third Sea")
AllFun(Factory,"Auto Factory",nil,false,"Auto Factory")
AllFun(Castle_Raid,"Auto Castle Pirate Raid",nil,false,"Auto Castle Pirate Raid")
AllFun(Chest,"Auto Farm Chest [ Tweem ]",nil,false,"Auto Farm Chest [ Tweem ]")
AllFun(Chest,"Auto Farm Chest [ TP ] ( Risk )",nil,false,"Auto Farm Chest [ TP ] ( Risk )")
local v27 = AllFunP(Cake_Prince, "lnfomation", "Loading...")
AllFun(Cake_Prince,"Auto Farm Cake Prince",nil,false,"Auto Farm Cake Prince")
AllFun(Cake_Prince,"Enabled Spwm Cake Prince",nil,false,"Enabled Spwm Cake Prince")
local v32 = AllFunP(Bone, "lnfomation", "Loading...")
AllFun(Bone,"Auto Farm Bone",nil,false,"Auto Farm Bone")
AllFun(Bone,"Enabled Random Bone Surprise",nil,false,"Enabled Random Bone Surprise")
local v35 = AllFunP(Elite_Hunter, "Elite Hunter : Waiting for spawn", "Loading...")
local v36 = AllFunP(Elite_Hunter, "Already Kill", "Loading...")
AllFun(Elite_Hunter,"Auto Farm Elite Hunter",nil,false,"Auto Farm Elite Hunter")
AllFun(Tyrant_of_the_Skies,"Auto Tyrant of the Skies",nil,false,"Auto Tyrant of the Skies")
local v37 = AllFunP(Observations, "Observations", "Loading...")
AllFun(Observations,"Auto Farm Observation Exp",nil,false,"Auto Farm Observation Exp")
AllFun(Observations,"Auto Farm Observation Exp Hop",nil,false,"Auto Farm Observation Exp Hop")
AllFun(Observations,"Auto Observation V2",nil,false,"Auto Observation V2")
AllFun(Ectoplasm,"Auto Farm Ectoplasm",nil,false,"Auto Farm Ectoplasm")
AllFun(Sea_Beasts,"Auto Farm Sea Beasts",nil,false,"Auto Farm Sea Beasts")
AllFun(Evo,"Auto Evo Race V2",nil,false,"Auto Evo Race V2")
AllFun(Order_Law,"Auto Farm Order Boss",nil,false,"Auto Farm Order Boss")
AllFun(Order_Law,"Enabled Buy Raid Chip",nil,false,"Enabled Buy Raid Chip")
AllFun(Order_Law,"Enabled Start Raid",nil,false,"Enabled Start Raid")
AllFunB(Order_Law, "Buy Raid Chip", nil, function() local args = {[1] = "BlackbeardReward",[2] = "Microchip",[3] = "2"}game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) end)
AllFunB(Order_Law, "Start Raid", nil, function() fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector) end)
AllFun(Fighting_Styles,"Auto Superhuman",nil,false,"Auto Superhuman")
AllFun(Fighting_Styles,"Auto Death Step",nil,false,"Auto Death Step")
AllFun(Fighting_Styles,"Auto Sharkman Karate",nil,false,"Auto Sharkman Karate")
AllFun(Fighting_Styles,"Auto Electric Claw",nil,false,"Auto Electric Claw")
AllFun(Fighting_Styles,"Auto Dragon Talon",nil,false,"Auto Dragon Talon")
AllFun(Fighting_Styles,"Auto Godhuman",nil,false,"Auto Godhuman")
AllFun(Fighting_Styles,"Auto Godhuman Full",nil,false,"Auto Godhuman Full")
AllFun(Hallow_Sycthe,"Auto Hallow Sycthe",nil,false,"Auto Hallow Sycthe")
AllFun(Bartilo,"Auto Bartilo Quest",nil,false,"Auto Bartilo Quest")
AllFun(Musketeer_Hat,"Auto Musketeer Hat",nil,false,"Auto Musketeer Hat")
AllFun(Rainbow_Haki,"Auto Rainbow Haki",nil,false,"Auto Rainbow Haki")
AllFun(Saber,"Auto Saber",nil,false,"Auto Saber")
AllFun(Pole,"Auto Pole v1",nil,false,"Auto Pole v1")
AllFun(Pole,"Auto Pole v1 Hop",nil,false,"Auto Pole v1 Hop")
AllFun(Swan_Glasses,"Auto Swan Glasses",nil,false,"Auto Swan Glasses")
AllFun(Bisento,"Auto Bisento v2",nil,false,"Auto Bisento v2")
AllFun(Bisento,"Auto Bisento v2 Hop",nil,false,"Auto Bisento v2 Hop")
local BYTE_Io = AllFunP(Lengedary_Sword, "lnfomation", "Loading...")
AllFun(Lengedary_Sword,"Auto Buy Lengedary Sword",nil,false,"Auto Buy Lengedary Sword")
AllFun(Lengedary_Sword,"Auto Buy Lengedary Sword Hop",nil,false,"Auto Buy Lengedary Sword Hop")
AllFun(Rengoku,"Auto Rengoku",nil,false,"Auto Rengoku")
AllFun(Budy_Sword,"Auto Budy Sword",nil,false,"Auto Budy Sword")
AllFun(Budy_Sword,"Auto Budy Sword Hop",nil,false,"Auto Budy Sword Hop")
AllFun(Canvander,"Auto Canvander",nil,false,"Auto Canvander")
AllFun(Canvander,"Auto Canvander Hop",nil,false,"Auto Canvander Hop")
AllFun(Yama,"Auto Yama",nil,false,"Auto Yama")
AllFun(Twin_Hooks,"Auto Twin Hooks",nil,false,"Auto Twin Hooks")
AllFun(Twin_Hooks,"Auto Twin Hooks Hop",nil,false,"Auto Twin Hooks Hop")
AllFun(Soul_Guitar,"Auto Soul Guitar",nil,false,"Auto Soul Guitar")
AllFun(Tushita,"Auto Tushita",nil,false,"Auto Tushita")
AllFun(Tushita,"Auto Holy Torch",nil,false,"Auto Holy Torch")
AllFun(Cursed_Dual_Katana,"Auto Quest Yama",nil,false,"Auto Quest Yama")
AllFun(Cursed_Dual_Katana,"Auto Quest Tushita",nil,false,"Auto Quest Tushita")
AllFun(Cursed_Dual_Katana,"Auto Get Cursed Dual Katana",nil,false,"Auto Get Cursed Dual Katana")
local Pplyserv = AllFunP(Combat, "Players", "")
local SelectWeapon = Tabs.FarmSettings:AddDropdown("Select Weapon", {
    Title = "Select Weapon",
    Description = "",
    Values = { "Melee", "Sword", "Gun", "Fruit" },
    Multi = false,
    Default = getgenv().Config["Select Weapon"] or "Melee",
})
SelectWeapon:OnChanged(function(Value)
    _G['Select Weapon'] = Value
    getgenv().Config["Select Weapon"] = Value
    getgenv()['Update_Setting'](getgenv()['MyName'])
end)
AllFun(Farm_Settings,"Fast Attack",nil,true,"Fast Attack")
AllFun(Farm_Settings,"Auto Haki",nil,true,"Auto Haki")
AllFun(Farm_Settings,"Auto Set Spawn Point",nil,false,"Auto Set Spawn Point")
AllFun(Farm_Settings,"Bypass TP",nil,false,BypassTP)
AllFun(Farm_Settings,"Hide Notifications",nil,false,"Hide Notifications")
AllFun(Farm_Settings,"White Screen",nil,false,"White Screen")
AllFunSs(Farm_Settings,"Farm Distance",nil,"Farm Distance",16,5,40,0)
AllFunSs(Farm_Settings,"Tween Speed",nil,"Tween Speed",275,50,300,0)
spawn(function()
    while task.wait() do
        pcall(function()
            local result = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
            local len = string.len(result)
            if len == 88 then
                v27:SetDesc("Defeat : " .. string.sub(result, 39, 41))
            elseif len == 87 then
                v27:SetDesc("Defeat : " .. string.sub(result, 39, 40))
            elseif len == 86 then
                v27:SetDesc("Defeat : " .. string.sub(result, 39, 39))
            else
                v27:SetDesc("Boss Is Spawning")
            end
            if L_2753915549_ or L_4442272183_ then
                v27:SetDesc("Defeat : N/A")
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        while wait() do
            v32:SetDesc("You Have : " .. tostring(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check") .. " Bones"))
        end
    end)
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or workspace.Enemies:FindFirstChild("Diablo") or workspace.Enemies:FindFirstChild("Deandre") or workspace.Enemies:FindFirstChild("Urban") then
                v35:SetDesc("Status : spawn 🟢")
            else
                v35:SetDesc("Status : Not spawn 🔴")
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        v36:SetDesc("Already Kill Elite Hunter : " .. game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
    end
end)
spawn(function()
    while task.wait() do
        v37:SetDesc("Observation Exp : " .. game:GetService("Players").LocalPlayer.VisionRadius.Value)
    end
end)
spawn(function()
    pcall(function()
        while wait() do
            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then
                BYTE_Io:SetTitle("Sword Spawn : Shisui 🟢")
            elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer","2") then
                BYTE_Io:SetTitle("Sword Spawn : Wando 🟢")
            elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer","3") then
                BYTE_Io:SetTitle("Sword Spawn : Saddi 🟢")
            else
                BYTE_Io:SetTitle("Not Found Lengedary Sword 🔴")
            end
        end
    end)
end)
spawn(function()
    while wait() do
        pcall(function()
            for i, v in pairs((game:GetService("Players")):GetPlayers()) do
                if i == 12 then
                    Pplyserv:SetTitle("Players :" .. " " .. i .. " " .. "/" .. " " .. "12" .. " " .. "(Max)")
                elseif i >= 12 then
                    Pplyserv:SetTitle("Player :" .. " " .. i .. " " .. "/" .. " " .. "12" .. "" .. "(???)")
                elseif i == 1 then
                    Pplyserv:SetTitle("Player :" .. " " .. i .. " " .. "/" .. " " .. "12")
                else
                    Pplyserv:SetTitle("Players :" .. " " .. i .. " " .. "/" .. " " .. "12")
                end
            end
        end)
    end
end)
end)
-- Anti-Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if method == "Kick" then
		return -- บล็อกเลย
	end
	return old(self, ...)
end)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
