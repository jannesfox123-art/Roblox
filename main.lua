-- ============================================
-- ADVANCED HUB SYSTEM - DARK THEME
-- Toggle key: Right Shift
-- Tabs load from external URLs
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- ========== CONFIGURATION ==========
local TAB_URLS = {
    main = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/main.lua",
    misc = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/miscb.lua",
    teleport = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/teleport.lua",
    settings = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/settings.lua",
    esp = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/esp.lua",
    garden = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/garden.lua",
    exploit = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/main/exploit.lua"
}

local currentTab = nil
local contentFrame = nil
local loadingOverlay = nil
local isFetching = false

-- ========== CREATE UI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = playerGui

-- Blur effect (modern dark theme)
local blur = Instance.new("BlurEffect")
blur.Name = "HubBlur"
blur.Size = 0
blur.Parent = Lighting

-- Main container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 880, 0, 600)
mainFrame.Position = UDim2.new(0.5, -440, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Main corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Drop shadow (subtle)
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316044814"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Title & icon
local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 40, 1, 0)
titleIcon.Position = UDim2.new(0, 15, 0, 0)
titleIcon.BackgroundTransparency = 1
titleIcon.Text = "🖤"
titleIcon.TextColor3 = Color3.fromRGB(100, 150, 255)
titleIcon.TextSize = 24
titleIcon.Font = Enum.Font.GothamBold
titleIcon.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DARK HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -48, 0, 11)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Sidebar (scrollable)
local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 200, 1, -60)
sidebar.Position = UDim2.new(0, 0, 0, 60)
sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 3
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 0)
sidebarCorner.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 15)
sidebarPadding.PaddingLeft = UDim.new(0, 10)
sidebarPadding.PaddingRight = UDim.new(0, 10)
sidebarPadding.Parent = sidebar

-- Content area
contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -220, 1, -80)
contentFrame.Position = UDim2.new(0, 210, 0, 70)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
contentFrame.BackgroundTransparency = 0.4
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 15)
contentPadding.PaddingLeft = UDim.new(0, 15)
contentPadding.PaddingRight = UDim.new(0, 15)
contentPadding.PaddingBottom = UDim.new(0, 15)
contentPadding.Parent = contentFrame

-- Loading overlay (modern spinner)
loadingOverlay = Instance.new("Frame")
loadingOverlay.Size = UDim2.new(1, 0, 1, 0)
loadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingOverlay.BackgroundTransparency = 0.7
loadingOverlay.Visible = false
loadingOverlay.Parent = contentFrame

local spinner = Instance.new("Frame")
spinner.Size = UDim2.new(0, 40, 0, 40)
spinner.Position = UDim2.new(0.5, -20, 0.4, -20)
spinner.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
spinner.BorderSizePixel = 0
spinner.Parent = loadingOverlay

local spinnerCorner = Instance.new("UICorner")
spinnerCorner.CornerRadius = UDim.new(1, 0)
spinnerCorner.Parent = spinner

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Position = UDim2.new(0, 0, 0.5, 10)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextSize = 16
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = loadingOverlay

-- Rotate spinner animation
local spinConnection = nil
local function StartSpinner()
    if spinConnection then spinConnection:Disconnect() end
    local angle = 0
    spinConnection = RunService.RenderStepped:Connect(function(dt)
        if not loadingOverlay.Visible then
            if spinConnection then spinConnection:Disconnect() end
            return
        end
        angle = angle + dt * 8
        spinner.Rotation = angle % 360
    end)
end

-- ========== TAB BUTTONS ==========
local tabs = {
    {id = "main", name = "Main", icon = "🏠", color = Color3.fromRGB(66, 133, 244)},
    {id = "misc", name = "Misc", icon = "🎲", color = Color3.fromRGB(234, 67, 53)},
    {id = "teleport", name = "Teleport", icon = "🚀", color = Color3.fromRGB(52, 168, 83)},
    {id = "settings", name = "Settings", icon = "⚙️", color = Color3.fromRGB(251, 188, 5)},
    {id = "esp", name = "ESP", icon = "👁️", color = Color3.fromRGB(156, 39, 176)},
    {id = "garden", name = "Garden", icon = "🌿", color = Color3.fromRGB(76, 175, 80)},
    {id = "exploit", name = "Exploit", icon = "⚡", color = Color3.fromRGB(255, 87, 34)}
}

local tabButtons = {}

for _, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tab.id .. "Btn"
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = tab.color
    btn.BackgroundTransparency = 0.3
    btn.Text = tab.icon .. "  " .. tab.name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = btn
    
    tabButtons[tab.id] = btn
    
    btn.MouseButton1Click:Connect(function()
        LoadTab(tab.id)
    end)
end

-- Adjust sidebar canvas size
sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 25)
end)

-- ========== HELPER FUNCTIONS FOR TABS ==========
local function CreateButton(text, callback, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 42)
    btn.Position = yPos and UDim2.new(0.04, 0, 0, yPos) or UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(text, defaultValue, callback, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 48)
    frame.Position = yPos and UDim2.new(0.04, 0, 0, yPos) or UDim2.new(0.04, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    frame.BackgroundTransparency = 0.5
    frame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 70, 0, 32)
    toggle.Position = UDim2.new(1, -82, 0.5, -16)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(80, 80, 90)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 13
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 16)
    toggleCorner.Parent = toggle
    
    local state = defaultValue
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(80, 80, 90)
        toggle.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    return {frame = frame, getValue = function() return state end}
end

local function CreateSlider(text, minVal, maxVal, defaultVal, callback, yPos)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 70)
    frame.Position = yPos and UDim2.new(0.04, 0, 0, yPos) or UDim2.new(0.04, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    frame.BackgroundTransparency = 0.5
    frame.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 30)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 30)
    valueLabel.Position = UDim2.new(1, -72, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -24, 0, 6)
    sliderBar.Position = UDim2.new(0, 12, 0, 48)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBar.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderBar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local dragging = false
    local currentValue = defaultVal
    
    local function updateFromPercent(percent)
        currentValue = math.floor(minVal + (maxVal - minVal) * math.clamp(percent, 0, 1))
        valueLabel.Text = tostring(currentValue)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        if callback then callback(currentValue) end
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = sliderBar.AbsolutePosition.X
            local width = sliderBar.AbsoluteSize.X
            local percent = (mousePos - barPos) / width
            updateFromPercent(percent)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local barPos = sliderBar.AbsolutePosition.X
            local width = sliderBar.AbsoluteSize.X
            local percent = (mousePos - barPos) / width
            updateFromPercent(percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {frame = frame, getValue = function() return currentValue end}
end

-- ========== TAB LOADING SYSTEM ==========
function LoadTab(tabId)
    if isFetching then return end
    if currentTab == tabId then return end
    
    -- Clear content area
    for _, child in pairs(contentFrame:GetChildren()) do
        if child ~= loadingOverlay and child ~= contentPadding then
            child:Destroy()
        end
    end
    
    -- Show loading overlay
    loadingOverlay.Visible = true
    loadingText.Text = "Loading " .. string.upper(tabId) .. " tab..."
    StartSpinner()
    isFetching = true
    
    local url = TAB_URLS[tabId]
    if not url then
        loadingText.Text = "Error: No URL for " .. tabId
        task.wait(2)
        loadingOverlay.Visible = false
        isFetching = false
        return
    end
    
    -- Fetch with retry (up to 2 retries)
    local scriptContent = nil
    for attempt = 1, 3 do
        local success, result = pcall(function()
            return HttpService:GetAsync(url, true) -- true = async
        end)
        if success then
            scriptContent = result
            break
        elseif attempt < 3 then
            loadingText.Text = "Retrying... (" .. attempt .. "/3)"
            task.wait(0.5)
        else
            loadingText.Text = "Failed to load tab"
            task.wait(2)
            loadingOverlay.Visible = false
            isFetching = false
            return
        end
    end
    
    -- Execute the script
    local func, err = loadstring(scriptContent)
    if not func then
        loadingText.Text = "Script error: Invalid format"
        task.wait(2)
        loadingOverlay.Visible = false
        isFetching = false
        return
    end
    
    -- Sandbox environment for the tab
    local tabEnv = {
        contentFrame = contentFrame,
        player = player,
        game = game,
        workspace = workspace,
        Players = Players,
        UserInputService = UserInputService,
        TweenService = TweenService,
        Lighting = Lighting,
        CreateButton = CreateButton,
        CreateToggle = CreateToggle,
        CreateSlider = CreateSlider,
    }
    setfenv(func, tabEnv)
    
    local success, execErr = pcall(func)
    
    loadingOverlay.Visible = false
    isFetching = false
    
    if not success then
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, 0, 0, 40)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = "Tab error: " .. tostring(execErr)
        errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorLabel.TextSize = 14
        errorLabel.Font = Enum.Font.Gotham
        errorLabel.Parent = contentFrame
        return
    end
    
    currentTab = tabId
    
    -- Highlight active button
    for id, btn in pairs(tabButtons) do
        btn.BackgroundTransparency = (id == tabId) and 0.1 or 0.3
    end
end

-- ========== WINDOW CONTROLS ==========
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    blur.Size = 0
end)

-- Toggle hub with RIGHT SHIFT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
        blur.Size = mainFrame.Visible and 16 or 0
        if mainFrame.Visible and not currentTab then
            LoadTab("main")
        end
    end
end)

-- Dragging (only from header)
local dragStart = nil
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        if mousePos.Y >= mainFrame.AbsolutePosition.Y and mousePos.Y <= mainFrame.AbsolutePosition.Y + 60 then
            dragStart = Vector2.new(mousePos.X - mainFrame.AbsolutePosition.X, mousePos.Y - mainFrame.AbsolutePosition.Y)
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragStart and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        mainFrame.Position = UDim2.new(0, mousePos.X - dragStart.X, 0, mousePos.Y - dragStart.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = nil
    end
end)

print("Dark Hub Loaded. Press Right Shift to open.")
