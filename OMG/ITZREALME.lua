local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Dragon Hub | Status: Free | Version [v.beta]`,
    SubTitle = "by ttvkaiser & FLX_Liam",
    TabWidth = 160,
    Size = UDim2.fromOffset(1087, 690.5),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "VSC Dark High Contrast",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
}

-- Fluent Renewed provides ALL 1544 Lucide 0.469.0 https://lucide.dev/icons/ Icons and ALL 9072 Phosphor 2.1.0 https://phosphoricons.com/ Icons for the tabs, icons are optional
local Tabs = {
    Home = Window:CreateTab{
        Title = "Home",
        Icon = "house"
    },
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "align-justify"
    },
    Kill = Window:CreateTab{
        Title = "Auto Kill",
        Icon = "skull"
    },
    Rebirth = Window:CreateTab{
        Title = "Auto Rebirth",
        Icon = "biceps-flexed"
    },
    Status = Window:CreateTab{
        Title = "Status",
        Icon = "circle-plus"
    },
    Misc = Window:CreateTab{
        Title = "Miscellaneous",
        Icon = "command"
    },
    Credits = Window:CreateTab{
        Title = "Credits",
        Icon = "credit-card"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

Library:Notify{
    Title = "Notification",
    Content = "This is a notification",
    SubContent = "SubContent", -- Optional
    Duration = 5 -- Set to nil to make the notification not disappear
}

Tabs.Home:CreateParagraph("Aligned Paragraph", {
    Title = "---Local Player Configuration---",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local speed = 500 -- Default speed

-- Input field
local Input = Tabs.Home:AddInput("Input", {
    Title = "Speed Input",
    Default = tostring(speed),
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            speed = num
            print("Speed set to:", speed)
            if Options.MyToggle.Value then
                applySpeed()
            end
        end
    end
})

-- Toggle
local Toggle = Tabs.Home:AddToggle("MyToggle", {
    Title = "Enable Speed",
    Default = false
})

-- Utility to apply speed
local function applySpeed()
    local player = game.Players.LocalPlayer
    if not player then return end

    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Options.MyToggle.Value and speed or 16
        end
    end
end

-- Toggle handler
Toggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
    applySpeed()
end)

-- Reapply speed on respawn
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid") -- Ensure humanoid exists
    if Options.MyToggle.Value then
        task.wait(0.1) -- slight delay to ensure stability
        applySpeed()
    end
end)

-- Infinite Jump Toggle
local ToggleInfiniteJump = Tabs.Home:AddToggle("Toggle_InfiniteJump", {Title = "Infinite Jump", Default = false})
ToggleInfiniteJump:OnChanged(function()
    if Options.Toggle_InfiniteJump.Value then
        local UserInputService = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        -- Connection to jump input
        _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if Options.Toggle_InfiniteJump.Value then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("Infinite Jump enabled")
    else
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
        print("Infinite Jump disabled")
    end
end)

-- No Clip Toggle
local ToggleNoClip = Tabs.Home:AddToggle("Toggle_NoClip", {Title = "No Clip", Default = false})
ToggleNoClip:OnChanged(function()
    local RunService = game:GetService("RunService")
    local Player = game.Players.LocalPlayer

    if Options.Toggle_NoClip.Value then
        _G.NoclipConnection = RunService.Stepped:Connect(function()
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("No Clip enabled")
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        print("No Clip disabled")
    end
end)

local player = game:GetService("Players").LocalPlayer

local ToggleAutoLift = Tabs.Main:AddToggle("MyToggle_AutoLift", {Title = "Auto Lift", Default = false})

ToggleAutoLift:OnChanged(function()
    if Options.MyToggle_AutoLift.Value then
        print("Toggle changed:", true)
        player.autoLiftEnabled.Value = true
    else
        print("Toggle changed:", false)
        player.autoLiftEnabled.Value = false
    end
end)

Options.MyToggle_AutoLift:SetValue(false)

local Paragraph_PlayTime = Tabs.Status:CreateParagraph("Paragraph_PlayTime", {
    Title = "Time in Server",
    Content = "Calculating..."
})

local joinTime = tick()

task.spawn(function()
    while true do
        local timeInServer = math.floor(tick() - joinTime)
        local minutes = math.floor(timeInServer / 60)
        local seconds = timeInServer % 60

        Paragraph_PlayTime:SetContent(string.format("You have been in this server for:\n%02d minutes and %02d seconds", minutes, seconds))
        task.wait(1)
    end
end)

local Paragraph_Stats = Tabs.Status:CreateParagraph("Paragraph_Stats", {
    Title = "Your Stats",
    Content = "Fetching..."
})

local function getStatValue(player, statName)
    local stat = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild(statName)
    return stat and stat.Value or "N/A"
end

task.spawn(function()
    local player = game:GetService("Players").LocalPlayer
    while true do
        local strength = getStatValue(player, "Strength")
        local durability = getStatValue(player, "Durability")
        local agility = getStatValue(player, "Agility")
        local totalKills = getStatValue(player, "Total Kills")
        local positiveKills = getStatValue(player, "Positive Kills")
        local negativeKills = getStatValue(player, "Negative Kills")
        local rebirths = getStatValue(player, "Rebirths")

        local statsText = string.format([[
Strength: %s
Durability: %s
Agility: %s
Total Kills: %s
Positive Kills: %s
Negative Kills: %s
Rebirths: %s
]], strength, durability, agility, totalKills, positiveKills, negativeKills, rebirths)

        Paragraph_Stats:SetContent(statsText)
        task.wait(1)
    end
end)

local Paragraph_Earnings = Tabs.Status:CreateParagraph("Paragraph_Earnings", {
    Title = "Session Earnings",
    Content = "Calculating..."
})

local player = game:GetService("Players").LocalPlayer
local startValues = {}

-- Wait for leaderstats to load
repeat task.wait() until player:FindFirstChild("leaderstats")

-- Record starting values
for _, statName in ipairs({"Strength", "Durability", "Agility", "Total Kills", "Rebirths"}) do
    local stat = player.leaderstats:FindFirstChild(statName)
    startValues[statName] = stat and stat.Value or 0
end

task.spawn(function()
    while true do
        local stats = player.leaderstats
        local earningsText = ""

        for _, statName in ipairs({"Strength", "Durability", "Agility", "Total Kills", "Rebirths"}) do
            local current = stats:FindFirstChild(statName)
            local earned = current and (current.Value - (startValues[statName] or 0)) or "N/A"
            earningsText = earningsText .. string.format("%s Earned: %s\n", statName, earned)
        end

        Paragraph_Earnings:SetContent(earningsText)
        task.wait(1)
    end
end)

local player = game:GetService("Players").LocalPlayer

-- Create a blackout overlay GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BlackoutOverlay"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0
frame.Visible = false
frame.Parent = gui

gui.Parent = player:WaitForChild("PlayerGui")

-- Add toggle
local Toggle_BlackScreen = Tabs.Misc:AddToggle("Toggle_BlackScreen", {
    Title = "Black Screen",
    Default = false
})

Toggle_BlackScreen:OnChanged(function()
    frame.Visible = Options.Toggle_BlackScreen.Value
end)

Options.Toggle_BlackScreen:SetValue(false)

local player = game:GetService("Players").LocalPlayer

-- Create a white overlay GUI
local guiWhite = Instance.new("ScreenGui")
guiWhite.Name = "WhiteoutOverlay"
guiWhite.ResetOnSpawn = false
guiWhite.IgnoreGuiInset = true

local frameWhite = Instance.new("Frame")
frameWhite.Size = UDim2.new(1, 0, 1, 0)
frameWhite.Position = UDim2.new(0, 0, 0, 0)
frameWhite.BackgroundColor3 = Color3.new(1, 1, 1) -- White
frameWhite.BackgroundTransparency = 0
frameWhite.Visible = false
frameWhite.Parent = guiWhite

guiWhite.Parent = player:WaitForChild("PlayerGui")

-- Add toggle
local Toggle_WhiteScreen = Tabs.Misc:AddToggle("Toggle_WhiteScreen", {
    Title = "White Screen",
    Default = false
})

Toggle_WhiteScreen:OnChanged(function()
    frameWhite.Visible = Options.Toggle_WhiteScreen.Value
end)

Options.Toggle_WhiteScreen:SetValue(false)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Toggle_ESP = Tabs.Misc:AddToggle("Toggle_ESP", {
    Title = "Player ESP",
    Default = false
})

local ESP_Boxes = {}
local ESP_Labels = {}

local function createESP(player)
    if player == LocalPlayer then return end
    local function onCharacterAdded(char)
        -- Create box
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = char
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = Vector3.new(3, 6, 1.5)
        box.Transparency = 0.7
        box.Color3 = Color3.new(1, 1, 1)
        box.Parent = workspace
        ESP_Boxes[player] = box

        -- Create label
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPLabel"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = char:WaitForChild("HumanoidRootPart")

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(1, 1, 1)
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Parent = billboard

        billboard.Parent = workspace
        ESP_Labels[player] = {gui = billboard, label = text}
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function removeESP(player)
    if ESP_Boxes[player] then
        ESP_Boxes[player]:Destroy()
        ESP_Boxes[player] = nil
    end
    if ESP_Labels[player] then
        ESP_Labels[player].gui:Destroy()
        ESP_Labels[player] = nil
    end
end

local function updateESP()
    for player, labelData in pairs(ESP_Labels) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = math.floor((player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            local health = math.floor((player.Character:FindFirstChildOfClass("Humanoid") or {}).Health or 0)
            labelData.label.Text = string.format("(%s)\nhealth: %d\nstuds away: %d", player.Name, health, distance)
        end
    end
end

Toggle_ESP:OnChanged(function()
    local enabled = Options.Toggle_ESP.Value

    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end
        Players.PlayerAdded:Connect(createESP)
        Players.PlayerRemoving:Connect(removeESP)

        _G.ESPConnection = RunService.RenderStepped:Connect(updateESP)
    else
        for player, box in pairs(ESP_Boxes) do
            box:Destroy()
        end
        for player, labelData in pairs(ESP_Labels) do
            labelData.gui:Destroy()
        end
        ESP_Boxes = {}
        ESP_Labels = {}

        if _G.ESPConnection then
            _G.ESPConnection:Disconnect()
            _G.ESPConnection = nil
        end
    end
end)

Options.Toggle_ESP:SetValue(false)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes{}

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
}

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
