-- Settings Tab - Configure GUI keybind and unload
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local screenGui = screenGui  -- passed from main environment
local mainFrame = mainFrame

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -20, 0, 35)
header.BackgroundTransparency = 1
header.Text = "⚙️ Settings"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextSize = 20
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = container

-- GUI Toggle Key Setting
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(1, -20, 0, 100)
keyFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = container

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyFrame

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -10, 0, 25)
keyLabel.Position = UDim2.new(0, 5, 0, 5)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 GUI Toggle Key"
keyLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
keyLabel.TextSize = 16
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = keyFrame

local currentKeyLabel = Instance.new("TextLabel")
currentKeyLabel.Size = UDim2.new(1, -10, 0, 25)
currentKeyLabel.Position = UDim2.new(0, 5, 0, 35)
currentKeyLabel.BackgroundTransparency = 1
currentKeyLabel.Text = "Current: RightShift"
currentKeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentKeyLabel.TextSize = 14
currentKeyLabel.Font = Enum.Font.Gotham
currentKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
currentKeyLabel.Parent = keyFrame

local changeKeyButton = Instance.new("TextButton")
changeKeyButton.Size = UDim2.new(0.48, 0, 0, 35)
changeKeyButton.Position = UDim2.new(0, 10, 0, 65)
changeKeyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
changeKeyButton.Text = "🎮 Change Key"
changeKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
changeKeyButton.TextSize = 14
changeKeyButton.Font = Enum.Font.GothamBold
changeKeyButton.Parent = keyFrame

local keyCornerBtn = Instance.new("UICorner")
keyCornerBtn.CornerRadius = UDim.new(0, 6)
keyCornerBtn.Parent = changeKeyButton

local waitingForKey = false
local currentToggleKey = Enum.KeyCode.RightShift

changeKeyButton.MouseButton1Click:Connect(function()
    waitingForKey = true
    changeKeyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    changeKeyButton.Text = "⌨️ Press any key..."
    currentKeyLabel.Text = "Waiting for key press..."
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if waitingForKey then
            local key = input.KeyCode
            if key ~= Enum.KeyCode.Unknown then
                currentToggleKey = key
                waitingForKey = false
                changeKeyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                changeKeyButton.Text = "🎮 Change Key"
                currentKeyLabel.Text = "Current: " .. tostring(key):gsub("KeyCode.", "")
                connection:Disconnect()
                
                -- Rebind the toggle
                local oldConnection = _G.toggleConnection
                if oldConnection then oldConnection:Disconnect() end
                
                local guiVisible = true
                _G.toggleConnection = UserInputService.InputBegan:Connect(function(inp, gp)
                    if gp then return end
                    if inp.KeyCode == currentToggleKey then
                        guiVisible = not guiVisible
                        screenGui.Enabled = guiVisible
                    end
                end)
            end
        end
    end)
end)

-- Unload GUI Section
local unloadFrame = Instance.new("Frame")
unloadFrame.Size = UDim2.new(1, -20, 0, 130)
unloadFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
unloadFrame.BorderSizePixel = 0
unloadFrame.Parent = container

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 8)
unloadCorner.Parent = unloadFrame

local unloadLabel = Instance.new("TextLabel")
unloadLabel.Size = UDim2.new(1, -10, 0, 25)
unloadLabel.Position = UDim2.new(0, 5, 0, 5)
unloadLabel.BackgroundTransparency = 1
unloadLabel.Text = "⚠️ Unload Hub"
unloadLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
unloadLabel.TextSize = 16
unloadLabel.Font = Enum.Font.GothamBold
unloadLabel.TextXAlignment = Enum.TextXAlignment.Left
unloadLabel.Parent = unloadFrame

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(1, -10, 0, 40)
warningText.Position = UDim2.new(0, 5, 0, 35)
warningText.BackgroundTransparency = 1
warningText.Text = "This will completely remove the GUI and stop all features. You will need to re-execute the script to get it back."
warningText.TextColor3 = Color3.fromRGB(200, 200, 200)
warningText.TextSize = 12
warningText.Font = Enum.Font.Gotham
warningText.TextWrapped = true
warningText.Parent = unloadFrame

local unloadButton = Instance.new("TextButton")
unloadButton.Size = UDim2.new(0.48, 0, 0, 35)
unloadButton.Position = UDim2.new(0, 10, 0, 80)
unloadButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
unloadButton.Text = "💣 Unload GUI Completely"
unloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadButton.TextSize = 14
unloadButton.Font = Enum.Font.GothamBold
unloadButton.Parent = unloadFrame

local unloadCornerBtn = Instance.new("UICorner")
unloadCornerBtn.CornerRadius = UDim.new(0, 6)
unloadCornerBtn.Parent = unloadButton

unloadButton.MouseButton1Click:Connect(function()
    -- Destroy the entire GUI
    screenGui:Destroy()
    -- Also disconnect any global connections
    if _G.toggleConnection then _G.toggleConnection:Disconnect() end
    print("Custom Hub fully unloaded.")
end)

-- Info frame
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -20, 0, 80)
infoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
infoFrame.BorderSizePixel = 0
infoFrame.Parent = container

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -10, 0, 60)
infoText.Position = UDim2.new(0, 5, 0, 10)
infoText.BackgroundTransparency = 1
infoText.Text = "📌 Info:\n• RightShift (or custom key) toggles GUI visibility\n• Settings changes apply immediately\n• Unload will remove everything - rerun script to restore"
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 12
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.Parent = infoFrame

print("Settings tab loaded!")
