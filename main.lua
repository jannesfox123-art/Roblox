-- Main GUI Loader Script
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomHub"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Make frame draggable
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.8, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Custom Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab buttons container
local tabButtons = Instance.new("Frame")
tabButtons.Name = "TabButtons"
tabButtons.Size = UDim2.new(0, 150, 1, -30)
tabButtons.Position = UDim2.new(0, 0, 0, 30)
tabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabButtons.BorderSizePixel = 0
tabButtons.Parent = mainFrame

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -150, 1, -30)
contentFrame.Position = UDim2.new(0, 150, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Tab data
local tabs = {
    {name = "Misc", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/misc.lua"},
    {name = "Gardan", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/gardan.lua"},
    {name = "Exploit", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/exploit.lua"},
    {name = "Teleport", url = "https://raw.githubusercontent.com/jannesfox123-art/Roblox/refs/heads/main/teleport.lua"}
}

local tabObjects = {}
local currentTab = nil

-- Function to load script from URL
local function loadScriptFromUrl(url, container)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result then
        -- Create environment with container and other useful variables
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
            -- Also include the container as 'tabContainer' for clarity
            tabContainer = container
        }
        
        local scriptFunction, loadError = loadstring(result)
        if scriptFunction then
            -- Set the environment for the script
            setfenv(scriptFunction, scriptEnv)
            local execSuccess, execError = pcall(scriptFunction)
            if not execSuccess then
                warn("Error executing tab script: " .. tostring(execError))
                -- Show error in the container
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

-- Function to create and switch tabs
local function createTab(tabData, index)
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabData.name .. "Button"
    tabButton.Size = UDim2.new(1, -4, 0, 30)
    tabButton.Position = UDim2.new(0, 2, 0, (index - 1) * 32 + 2)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButton.Text = tabData.name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = tabButtons
    
    -- Create container for this tab's content
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = tabData.name .. "Container"
    tabContainer.Size = UDim2.new(1, -10, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 8
    tabContainer.Visible = false
    tabContainer.Parent = contentFrame
    
    -- Add UIListLayout for automatic positioning
    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 5)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = tabContainer
    
    -- Add UI Padding
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, 5)
    uiPadding.Parent = tabContainer
    
    -- Load the tab's script
    local loaded = loadScriptFromUrl(tabData.url, tabContainer)
    
    -- If script failed to load, show error message
    if not loaded then
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, 0, 0, 30)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = "Failed to load " .. tabData.name .. " tab. Check console for errors."
        errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorLabel.TextSize = 14
        errorLabel.Font = Enum.Font.Gotham
        errorLabel.Parent = tabContainer
    end
    
    tabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, tab in pairs(tabObjects) do
            if tab and tab.container then
                tab.container.Visible = false
            end
            if tab and tab.button then
                tab.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
        
        -- Show selected tab
        tabContainer.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
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
    tabObjects[1].button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    currentTab = tabs[1].name
end

print("Custom Hub GUI loaded successfully!")
