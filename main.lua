-- Main GUI Loader Script
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomHub"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 550, 0, 500)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Add shadow
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Dragging logic
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})
titleGradient.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.8, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "✨ Custom Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextYAlignment = Enum.TextYAlignment.Center
titleText.Parent = titleBar

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 1, -8)
minimizeButton.Position = UDim2.new(1, -65, 0, 4)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeButton.BackgroundTransparency = 0.5
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 1, -8)
closeButton.Position = UDim2.new(1, -35, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local targetSize = UDim2.new(0, 550, 0, 45)
        TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
        minimizeButton.Text = "+"
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local targetSize = UDim2.new(0, 550, 0, 500)
        TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
        minimizeButton.Text = "−"
    end
end)

-- Tab buttons container
local tabButtons = Instance.new("Frame")
tabButtons.Name = "TabButtons"
tabButtons.Size = UDim2.new(0, 180, 1, -45)
tabButtons.Position = UDim2.new(0, 0, 0, 45)
tabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabButtons.BorderSizePixel = 0
tabButtons.Parent = mainFrame

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -180, 1, -45)
contentFrame.Position = UDim2.new(0, 180, 0, 45)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Tab data (including Settings)
local tabs = {
    {name = "🏠 Main", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/main_tab.lua"},
    {name = "🎮 Misc", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/misc.lua"},
    {name = "🛡️ Gardan", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/gardan.lua"},
    {name = "💀 Exploit", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/exploit.lua"},
    {name = "⚙️ Settings", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/settings.lua"}  -- New settings tab
}

local tabObjects = {}
local currentTab = nil

-- Function to load script from URL
local function loadScriptFromUrl(url, container)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result then
        local scriptEnv = {
            container = container,
            player = player,
            players = game:GetService("Players"),
            workspace = workspace,
            game = game,
            Instance = Instance,
            Vector3 = Vector3,
            Color3 = Color3,
            UDim2 = UDim2,
            Enum = Enum,
            spawn = spawn,
            wait = wait,
            print = print,
            warn = warn,
            pcall = pcall,
            TweenService = TweenService,
            UserInputService = UserInputService,
            screenGui = screenGui,  -- Pass for unloading
            mainFrame = mainFrame,
            tabContainer = container
        }
        
        local scriptFunction, loadError = loadstring(result)
        if scriptFunction then
            setfenv(scriptFunction, scriptEnv)
            local execSuccess, execError = pcall(scriptFunction)
            if not execSuccess then
                warn("Error executing tab script: " .. tostring(execError))
                local errorLabel = Instance.new("TextLabel")
                errorLabel.Size = UDim2.new(1, 0, 0, 30)
                errorLabel.BackgroundTransparency = 1
                errorLabel.Text = "Error: " .. tostring(execError):sub(1, 100)
                errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                errorLabel.TextSize = 12
                errorLabel.Font = Enum.Font.Gotham
                errorLabel.Parent = container
                return false
            end
            return true
        else
            warn("Error loading tab script: " .. tostring(loadError))
            return false
        end
    else
        warn("Failed to fetch script from URL: " .. url)
        return false
    end
end

-- Function to create tabs
local function createTab(tabData, index)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabData.name .. "Button"
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, (index - 1) * 45 + 10)
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabButton.BackgroundTransparency = 0.5
    tabButton.Text = tabData.name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.TextYAlignment = Enum.TextYAlignment.Center
    tabButton.Parent = tabButtons
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = tabButton
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = tabData.name .. "Container"
    tabContainer.Size = UDim2.new(1, -10, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 6
    tabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
    tabContainer.Visible = false
    tabContainer.Parent = contentFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 10)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = tabContainer
    
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, 10)
    uiPadding.PaddingBottom = UDim.new(0, 10)
    uiPadding.Parent = tabContainer
    
    local loaded = loadScriptFromUrl(tabData.url, tabContainer)
    
    if not loaded then
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, 0, 0, 40)
        errorLabel.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        errorLabel.BackgroundTransparency = 0.2
        errorLabel.Text = "⚠️ Failed to load " .. tabData.name .. " tab"
        errorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorLabel.TextSize = 14
        errorLabel.Font = Enum.Font.Gotham
        errorLabel.Parent = tabContainer
        
        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 8)
        errorCorner.Parent = errorLabel
    end
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabObjects) do
            if tab and tab.container then
                tab.container.Visible = false
            end
            if tab and tab.button then
                tab.button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                tab.button.BackgroundTransparency = 0.5
                tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        
        tabContainer.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        tabButton.BackgroundTransparency = 0
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = tabData.name
    end)
    
    return {
        button = tabButton,
        container = tabContainer
    }
end

-- Create all tabs
for i, tabData in ipairs(tabs) do
    tabObjects[i] = createTab(tabData, i)
end

-- Show first tab by default
if tabObjects[1] then
    tabObjects[1].container.Visible = true
    tabObjects[1].button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    tabObjects[1].button.BackgroundTransparency = 0
    tabObjects[1].button.TextColor3 = Color3.fromRGB(255, 255, 255)
    currentTab = tabs[1].name
end

-- GUI Toggle using RightShift
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

print("✨ Custom Hub GUI loaded successfully! Press RightShift to hide/show.")
