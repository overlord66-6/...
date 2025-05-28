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

Tabs.Main:CreateParagraph("Aligned Paragraph", {
    Title = "---Auto Lift/Punch---",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

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

-- Auto Punch Toggle

local Toggle_Apunch = Tabs.Main:CreateToggle("AutoPunch", {
    Title = "Auto Punch",
    Default = false
})

Options.AutoPunch:SetValue(false)

local autoPunchRunning = false

Toggle_Apunch:OnChanged(function()
    autoPunchRunning = Options.AutoPunch.Value

    task.spawn(function()
        while autoPunchRunning do
            -- Replace this with your actual punching logic
            print("Punch!")

            -- Example:
            -- game:GetService("ReplicatedStorage").Remotes.Punch:FireServer()

            task.wait(0.1) -- adjust timing as needed
        end
    end)
end)

Options.MyToggle_AutoLift:SetValue(false)

Tabs.Main:CreateParagraph("Aligned Paragraph", {
    Title = "---Auto Equip---",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local TogglePunch = Tabs.Main:CreateToggle("AutoPunch", {Title = "Auto Equip: Punch", Default = false})

TogglePunch:OnChanged(function()
    print("Auto Punch toggle changed:", Options.AutoPunch.Value)
    -- Add your punch equip logic here
end)

Options.AutoPunch:SetValue(false)

local TogglePushup = Tabs.Main:CreateToggle("AutoPushup", {Title = "Auto Equip: Pushup", Default = false})

TogglePushup:OnChanged(function()
    print("Auto Pushup toggle changed:", Options.AutoPushup.Value)
    -- Add your pushup equip logic here
end)

Options.AutoPushup:SetValue(false)

local ToggleSitup = Tabs.Main:CreateToggle("AutoSitup", {Title = "Auto Equip: Situp", Default = false})

ToggleSitup:OnChanged(function()
    print("Auto Situp toggle changed:", Options.AutoSitup.Value)
    -- Add your situp equip logic here
end)

Options.AutoSitup:SetValue(false)

local ToggleWeight = Tabs.Main:CreateToggle("AutoWeight", {Title = "Auto Equip: Weight", Default = false})

ToggleWeight:OnChanged(function()
    print("Auto Weight toggle changed:", Options.AutoWeight.Value)
    -- Add your weight equip logic here
end)

Options.AutoWeight:SetValue(false)

Tabs.Main:CreateParagraph("Aligned Paragraph", {
    Title = "---Faster Tools---",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

-- Fast Punch Toggle
local Toggle_FastPunch = Tabs.Main:CreateToggle("Fast_Punch", {
    Title = "Fast Punch",
    Default = false
})

local runningFastPunch = false
Toggle_FastPunch:OnChanged(function()
    runningFastPunch = Options.Fast_Punch.Value
    task.spawn(function()
        while runningFastPunch do
            print("Fast Punch!")
            -- game:GetService("ReplicatedStorage").Remotes.Punch:FireServer()
            task.wait(0.1) -- Adjust speed
        end
    end)
end)

Options.Fast_Punch:SetValue(false)

-- Fast Pushup Toggle
local Toggle_FastPushup = Tabs.Main:CreateToggle("Fast_Pushup", {
    Title = "Fast Pushup",
    Default = false
})

local runningFastPushup = false
Toggle_FastPushup:OnChanged(function()
    runningFastPushup = Options.Fast_Pushup.Value
    task.spawn(function()
        while runningFastPushup do
            print("Fast Pushup!")
            -- Insert pushup logic here
            task.wait(0.1)
        end
    end)
end)

Options.Fast_Pushup:SetValue(false)

-- Fast Situps Toggle
local Toggle_FastSitups = Tabs.Main:CreateToggle("Fast_Situps", {
    Title = "Fast Situps",
    Default = false
})

local runningFastSitups = false
Toggle_FastSitups:OnChanged(function()
    runningFastSitups = Options.Fast_Situps.Value
    task.spawn(function()
        while runningFastSitups do
            print("Fast Situps!")
            -- Insert situps logic here
            task.wait(0.1)
        end
    end)
end)

Options.Fast_Situps:SetValue(false)

-- Fast Weights Toggle
local Toggle_FastWeights = Tabs.Main:CreateToggle("Fast_Weights", {
    Title = "Fast Weights",
    Default = false
})

local runningFastWeights = false
Toggle_FastWeights:OnChanged(function()
    runningFastWeights = Options.Fast_Weights.Value
    task.spawn(function()
        while runningFastWeights do
            print("Fast Weights!")
            -- Insert weights logic here
            task.wait(0.1)
        end
    end)
end)

Options.Fast_Weights:SetValue(false)

Tabs.Main:CreateParagraph("Aligned Paragraph", {
    Title = "---Auto Kill---",
    Content = "Make SURE YOU USE LOCK POSTION OR IT WON'T WORK!!!",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

-- AutoKill Toggle

local Toggle_AutoKill = Tabs.Kill:CreateToggle("Auto_Kill", {
    Title = "Auto Kill",
    Default = false
})

Options.Auto_Kill:SetValue(false)

local runningAutoKill = false
local originalSizes = {}

Toggle_AutoKill:OnChanged(function()
    runningAutoKill = Options.Auto_Kill.Value

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if runningAutoKill then
        task.spawn(function()
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    originalSizes[part.Name] = part.Size
                    
                    -- CLIENT-SIDE VISUAL FIX
                    if player == game.Players.LocalPlayer then
                        -- Make you appear normal on your own screen
                        part.Size = Vector3.new(2, 2, 1)
                        part.Transparency = 0
                        part.Material = Enum.Material.Plastic
                    end

                    -- SERVER HITBOX EXPANSION
                    part:GetPropertyChangedSignal("Size"):Connect(function()
                        -- Force server to see giant size
                        if runningAutoKill then
                            part.Size = Vector3.new(1e6, 1e6, 1e6)
                            part.Transparency = 0.8
                            part.Material = Enum.Material.Neon
                            part.CanCollide = false
                        end
                    end)

                    -- Trigger immediately
                    part.Size = Vector3.new(1e6, 1e6, 1e6)
                    part.Transparency = 0.8
                    part.Material = Enum.Material.Neon
                    part.CanCollide = false
                end
            end

            -- Auto punch loop
            while runningAutoKill do
                print("KILLING EVERYTHING!!!")

                -- Replace with your actual RemoteEvent logic
                -- game:GetService("ReplicatedStorage").Remotes.Punch:FireServer()

                task.wait(0.1)
            end
        end)
    else
        -- Restore parts to original size
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and originalSizes[part.Name] then
                part.Size = originalSizes[part.Name]
                part.Transparency = 0
                part.Material = Enum.Material.Plastic
                part.CanCollide = true
            end
        end
        originalSizes = {}
    end
end)

-- Lock Position Toggle

local Toggle_LockPos = Tabs.Kill:CreateToggle("Lock_Position", {
    Title = "Lock Position",
    Default = false
})

Options.Lock_Position:SetValue(false)

local runningLockPos = false
local storedCFrame = nil
local lockConnection = nil

Toggle_LockPos:OnChanged(function()
    runningLockPos = Options.Lock_Position.Value
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if runningLockPos and rootPart then
        storedCFrame = rootPart.CFrame

        -- Freeze character in place
        lockConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if rootPart and runningLockPos then
                rootPart.Velocity = Vector3.zero
                rootPart.RotVelocity = Vector3.zero
                rootPart.CFrame = storedCFrame
            end
        end)

        print("Position locked!")
    elseif not runningLockPos and lockConnection then
        -- Unlock and disconnect
        lockConnection:Disconnect()
        lockConnection = nil
        print("Position unlocked!")
    end
end)

local LanguageInfo = Tabs.Status:CreateParagraph("LanguageInfo", {
    Title = "Language",
    Content = [[
Current Script Language: English

The script is written entirely in English for ease of use and clarity. All labels, buttons, and descriptions are in English so it’s easy for everyone to understand and use right away.

Our Discord server also supports German and Spanish! If English isn’t your main language, feel free to hop in and get help, updates, and support in your native tongue.
]]
})

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

local Credits = Tabs.Credits:CreateParagraph("Credits", {
    Title = "Credits",
    Content = [[
This script was created by ttvkaiser and FLX_liam.

We started working on this because we felt like most of the scripts out there were either broken, filled with junk, or just didn’t feel complete. We wanted to make something smooth, useful, and clean—something people could actually enjoy using without having to dig through a mess.

From the UI to the features, every part of this was made with real care. It wasn’t rushed, and we’ve tested things to make sure they actually work in-game. Whether you're grinding stats or just messing around, we hope this script makes your experience better.

Thanks to everyone who supports what we do. More updates will come—this is just the start.
]]
})
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
