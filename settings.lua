-- ============================================
-- SETTINGS TAB
-- Controls hub appearance and behavior
-- ============================================

local container = contentFrame
local blurEffect = Lighting:FindFirstChild("HubBlur")

-- ========== LOAD SETTINGS ==========
if _G.HubSettings == nil then
    _G.HubSettings = {
        blurEnabled = true,
        blurStrength = 16,
        notifications = true,
        soundEffects = true,
        autoSave = true,
    }
end

local function SaveSettings()
    pcall(function()
        player:SetAttribute("HubSettings", _G.HubSettings)
    end)
end

-- ========== CREATE UI ==========
local yOffset = 0

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "⚙️ SETTINGS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = container
yOffset = 50

-- Blur Toggle
local blurToggle = CreateToggle("Blur Effect", _G.HubSettings.blurEnabled, function(state)
    _G.HubSettings.blurEnabled = state
    if blurEffect then
        blurEffect.Size = state and _G.HubSettings.blurStrength or 0
    end
    if _G.HubSettings.autoSave then SaveSettings() end
end, yOffset)
blurToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Blur Strength Slider (visible only if blur enabled)
local blurSlider = CreateSlider("Blur Strength", 4, 24, _G.HubSettings.blurStrength, function(value)
    _G.HubSettings.blurStrength = value
    if _G.HubSettings.blurEnabled and blurEffect then
        blurEffect.Size = value
    end
    if _G.HubSettings.autoSave then SaveSettings() end
end, yOffset)
blurSlider.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
blurSlider.frame.Visible = _G.HubSettings.blurEnabled
yOffset = yOffset + 75

-- Notifications Toggle (demo)
local notifToggle = CreateToggle("Show Notifications", _G.HubSettings.notifications, function(state)
    _G.HubSettings.notifications = state
    if _G.HubSettings.autoSave then SaveSettings() end
end, yOffset)
notifToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Sound Effects Toggle (demo)
local soundToggle = CreateToggle("Sound Effects", _G.HubSettings.soundEffects, function(state)
    _G.HubSettings.soundEffects = state
    if _G.HubSettings.autoSave then SaveSettings() end
end, yOffset)
soundToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Auto Save Toggle
local autoSaveToggle = CreateToggle("Auto Save Settings", _G.HubSettings.autoSave, function(state)
    _G.HubSettings.autoSave = state
    if state then SaveSettings() end
end, yOffset)
autoSaveToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Reset Button
local resetBtn = CreateButton("Reset All Settings", function()
    _G.HubSettings = {
        blurEnabled = true,
        blurStrength = 16,
        notifications = true,
        soundEffects = true,
        autoSave = true,
    }
    if blurEffect then
        blurEffect.Size = _G.HubSettings.blurEnabled and _G.HubSettings.blurStrength or 0
    end
    if _G.HubSettings.autoSave then SaveSettings() end
    -- Reload the settings tab to refresh UI
    LoadTab("settings")
end, yOffset)
resetBtn.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.92, 0, 0, 40)
infoLabel.Position = UDim2.new(0.04, 0, 0, yOffset + 10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Settings are saved automatically.\nToggle key: Right Shift"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = container

yOffset = yOffset + 70
container.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- Update blur slider visibility when blur toggle changes
task.spawn(function()
    while container and container.Parent do
        if blurSlider and blurSlider.frame then
            local visible = _G.HubSettings.blurEnabled
            if blurSlider.frame.Visible ~= visible then
                blurSlider.frame.Visible = visible
            end
        end
        task.wait(0.5)
    end
end)

print("Settings tab loaded")
