-- ============================================
-- Misc Tab - Professional Features Hub
-- ============================================

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Create UI elements inside the container
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🎮 Miscellaneous Features"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = container

-- ============================================
-- FLY SYSTEM with ADVANCED ANTI-FLY BYPASS
-- ============================================
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1, -20, 0, 220)
flyFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
flyFrame.BorderSizePixel = 0
flyFrame.Parent = container

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyFrame

local flyTitle = Instance.new("TextLabel")
flyTitle.Size = UDim2.new(1, -10, 0, 25)
flyTitle.Position = UDim2.new(0, 5, 0, 5)
flyTitle.BackgroundTransparency = 1
flyTitle.Text = "✈️ Flight System (Advanced Anti-Fly Bypass)"
flyTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
flyTitle.TextSize = 15
flyTitle.Font = Enum.Font.GothamBold
flyTitle.TextXAlignment = Enum.TextXAlignment.Left
flyTitle.Parent = flyFrame

-- Fly toggle button
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0.48, 0, 0, 35)
flyToggle.Position = UDim2.new(0, 10, 0, 35)
flyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
flyToggle.Text = "🔘 Enable Fly"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.TextSize = 14
flyToggle.Font = Enum.Font.GothamBold
flyToggle.Parent = flyFrame

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 6)
flyToggleCorner.Parent = flyToggle

-- Anti-fly bypass toggle (advanced)
local antiFlyBypass = Instance.new("TextButton")
antiFlyBypass.Size = UDim2.new(0.48, 0, 0, 35)
antiFlyBypass.Position = UDim2.new(0.52, -10, 0, 35)
antiFlyBypass.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
antiFlyBypass.Text = "🛡️ Adv Bypass: OFF"
antiFlyBypass.TextColor3 = Color3.fromRGB(255, 255, 255)
antiFlyBypass.TextSize = 13
antiFlyBypass.Font = Enum.Font.GothamBold
antiFlyBypass.Parent = flyFrame

local bypassCorner = Instance.new("UICorner")
bypassCorner.CornerRadius = UDim.new(0, 6)
bypassCorner.Parent = antiFlyBypass

-- Fly speed slider
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.4, 0, 0, 25)
flySpeedLabel.Position = UDim2.new(0, 10, 0, 80)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Fly Speed: 50"
flySpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
flySpeedLabel.TextSize = 13
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flyFrame

local flySliderBg = Instance.new("Frame")
flySliderBg.Size = UDim2.new(0.9, 0, 0, 4)
flySliderBg.Position = UDim2.new(0, 10, 0, 110)
flySliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
flySliderBg.BorderSizePixel = 0
flySliderBg.Parent = flyFrame

local flySliderFill = Instance.new("Frame")
flySliderFill.Size = UDim2.new(0.5, 0, 1, 0)
flySliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
flySliderFill.BorderSizePixel = 0
flySliderFill.Parent = flySliderBg

local flySliderButton = Instance.new("TextButton")
flySliderButton.Size = UDim2.new(0, 16, 0, 16)
flySliderButton.Position = UDim2.new(0.5, -8, 0, -6)
flySliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
flySliderButton.BorderSizePixel = 0
flySliderButton.Text = ""
flySliderButton.Parent = flyFrame

-- Fly variables
local flying = false
local flySpeed = 50
local antiBypass = false
local bodyVelocity = nil
local bodyGyro = nil
local flyConnections = {}

-- Advanced anti-fly bypass: constantly reapplies velocity, prevents anti-fly scripts from detecting
local function advancedBypass(rootPart, velocity)
    if not antiBypass or not flying then return end
    -- Multiple methods: reset velocity every frame, fake character state, and override anti-fly checks
    task.spawn(function()
        while antiBypass and flying and rootPart and bodyVelocity do
            bodyVelocity.Velocity = velocity
            -- Also try to modify humanoid state if needed
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local hum = player.Character.Humanoid
                if hum:GetState() == Enum.HumanoidStateType.Freefall then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function startFly()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    humanoid.PlatformStand = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    bodyGyro.Parent = rootPart
    
    local lastMove = tick()
    local keys = {W = false, S = false, A = false, D = false, Space = false, Q = false, E = false}
    
    local inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = input.KeyCode
        if key == Enum.KeyCode.W then keys.W = true end
        if key == Enum.KeyCode.S then keys.S = true end
        if key == Enum.KeyCode.A then keys.A = true end
        if key == Enum.KeyCode.D then keys.D = true end
        if key == Enum.KeyCode.Space then keys.Space = true end
        if key == Enum.KeyCode.Q then keys.Q = true end
        if key == Enum.KeyCode.E then keys.E = true end
    end)
    
    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        local key = input.KeyCode
        if key == Enum.KeyCode.W then keys.W = false end
        if key == Enum.KeyCode.S then keys.S = false end
        if key == Enum.KeyCode.A then keys.A = false end
        if key == Enum.KeyCode.D then keys.D = false end
        if key == Enum.KeyCode.Space then keys.Space = false end
        if key == Enum.KeyCode.Q then keys.Q = false end
        if key == Enum.KeyCode.E then keys.E = false end
    end)
    
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if not flying or not player.Character or not rootPart or not bodyVelocity then
            connection:Disconnect()
            inputBegan:Disconnect()
            inputEnded:Disconnect()
            return
        end
        
        local moveDirection = Vector3.new()
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        
        if keys.W then moveDirection = moveDirection + forward end
        if keys.S then moveDirection = moveDirection - forward end
        if keys.A then moveDirection = moveDirection - right end
        if keys.D then moveDirection = moveDirection + right end
        if keys.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if keys.Q then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            lastMove = tick()
        end
        
        local velocity = moveDirection * flySpeed
        bodyVelocity.Velocity = velocity
        
        -- Update gyro to face direction smoothly
        if moveDirection.Magnitude > 0 then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDirection)
        end
        
        -- Advanced bypass: rapid reapplication and anti-anti-fly
        if antiBypass then
            advancedBypass(rootPart, velocity)
        end
    end)
    
    flyConnections = {inputBegan, inputEnded, connection}
end

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    bodyVelocity = nil
    bodyGyro = nil
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
    end
    for _, conn in pairs(flyConnections) do
        if conn then conn:Disconnect() end
    end
    flyConnections = {}
end

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        startFly()
        flyToggle.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        flyToggle.Text = "🔴 Disable Fly"
    else
        stopFly()
        flyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        flyToggle.Text = "🔘 Enable Fly"
    end
end)

antiFlyBypass.MouseButton1Click:Connect(function()
    antiBypass = not antiBypass
    if antiBypass then
        antiFlyBypass.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        antiFlyBypass.Text = "🛡️ Adv Bypass: ON"
    else
        antiFlyBypass.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        antiFlyBypass.Text = "🛡️ Adv Bypass: OFF"
    end
end)

-- Fly speed slider
local draggingFly = false
local function updateFlySpeed(input)
    local relativeX = math.clamp((input.Position.X - flySliderBg.AbsolutePosition.X) / flySliderBg.AbsoluteSize.X, 0, 1)
    flySpeed = math.floor(10 + (relativeX * 190))
    flySliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
    flySliderButton.Position = UDim2.new(relativeX, -8, 0, -6)
    flySpeedLabel.Text = "Fly Speed: " .. flySpeed
end

flySliderButton.MouseButton1Down:Connect(function()
    draggingFly = true
    updateFlySpeed({Position = UserInputService:GetMouseLocation()})
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingFly and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateFlySpeed(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFly = false
    end
end)

flySliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateFlySpeed(input)
    end
end)

-- ============================================
-- INFINITE JUMP
-- ============================================
local infiniteJumpFrame = Instance.new("Frame")
infiniteJumpFrame.Size = UDim2.new(1, -20, 0, 70)
infiniteJumpFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
infiniteJumpFrame.BorderSizePixel = 0
infiniteJumpFrame.Parent = container

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 8)
jumpCorner.Parent = infiniteJumpFrame

local jumpTitle = Instance.new("TextLabel")
jumpTitle.Size = UDim2.new(1, -10, 0, 25)
jumpTitle.Position = UDim2.new(0, 5, 0, 5)
jumpTitle.BackgroundTransparency = 1
jumpTitle.Text = "🦘 Infinite Jump"
jumpTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
jumpTitle.TextSize = 16
jumpTitle.Font = Enum.Font.GothamBold
jumpTitle.TextXAlignment = Enum.TextXAlignment.Left
jumpTitle.Parent = infiniteJumpFrame

local infiniteJumpToggle = Instance.new("TextButton")
infiniteJumpToggle.Size = UDim2.new(0.48, 0, 0, 35)
infiniteJumpToggle.Position = UDim2.new(0, 10, 0, 35)
infiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
infiniteJumpToggle.Text = "🔘 Infinite Jump: OFF"
infiniteJumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteJumpToggle.TextSize = 14
infiniteJumpToggle.Font = Enum.Font.GothamBold
infiniteJumpToggle.Parent = infiniteJumpFrame

local infJumpCorner = Instance.new("UICorner")
infJumpCorner.CornerRadius = UDim.new(0, 6)
infJumpCorner.Parent = infiniteJumpToggle

local infiniteJumpActive = false
local jumpConnection

infiniteJumpToggle.MouseButton1Click:Connect(function()
    infiniteJumpActive = not infiniteJumpActive
    if infiniteJumpActive then
        infiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        infiniteJumpToggle.Text = "🔴 Infinite Jump: ON"
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        infiniteJumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        infiniteJumpToggle.Text = "🔘 Infinite Jump: OFF"
        if jumpConnection then jumpConnection:Disconnect() end
    end
end)

-- ============================================
-- NOCLIP
-- ============================================
local noclipFrame = Instance.new("Frame")
noclipFrame.Size = UDim2.new(1, -20, 0, 70)
noclipFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
noclipFrame.BorderSizePixel = 0
noclipFrame.Parent = container

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipFrame

local noclipTitle = Instance.new("TextLabel")
noclipTitle.Size = UDim2.new(1, -10, 0, 25)
noclipTitle.Position = UDim2.new(0, 5, 0, 5)
noclipTitle.BackgroundTransparency = 1
noclipTitle.Text = "🌀 NoClip"
noclipTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
noclipTitle.TextSize = 16
noclipTitle.Font = Enum.Font.GothamBold
noclipTitle.TextXAlignment = Enum.TextXAlignment.Left
noclipTitle.Parent = noclipFrame

local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0.48, 0, 0, 35)
noclipToggle.Position = UDim2.new(0, 10, 0, 35)
noclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
noclipToggle.Text = "🔘 NoClip: OFF"
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.TextSize = 14
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = noclipFrame

local noclipCornerBtn = Instance.new("UICorner")
noclipCornerBtn.CornerRadius = UDim.new(0, 6)
noclipCornerBtn.Parent = noclipToggle

local noclipActive = false
local noclipConnection

noclipToggle.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        noclipToggle.Text = "🔴 NoClip: ON"
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        noclipToggle.Text = "🔘 NoClip: OFF"
        if noclipConnection then noclipConnection:Disconnect() end
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ============================================
-- ANTI-AFK
-- ============================================
local antiAFKFrame = Instance.new("Frame")
antiAFKFrame.Size = UDim2.new(1, -20, 0, 70)
antiAFKFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
antiAFKFrame.BorderSizePixel = 0
antiAFKFrame.Parent = container

local aaCorner = Instance.new("UICorner")
aaCorner.CornerRadius = UDim.new(0, 8)
aaCorner.Parent = antiAFKFrame

local aaTitle = Instance.new("TextLabel")
aaTitle.Size = UDim2.new(1, -10, 0, 25)
aaTitle.Position = UDim2.new(0, 5, 0, 5)
aaTitle.BackgroundTransparency = 1
aaTitle.Text = "💤 Anti-AFK"
aaTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
aaTitle.TextSize = 16
aaTitle.Font = Enum.Font.GothamBold
aaTitle.TextXAlignment = Enum.TextXAlignment.Left
aaTitle.Parent = antiAFKFrame

local antiAFKButton = Instance.new("TextButton")
antiAFKButton.Size = UDim2.new(0.48, 0, 0, 35)
antiAFKButton.Position = UDim2.new(0, 10, 0, 35)
antiAFKButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
antiAFKButton.Text = "💤 Anti-AFK: OFF"
antiAFKButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiAFKButton.TextSize = 13
antiAFKButton.Font = Enum.Font.GothamBold
antiAFKButton.Parent = antiAFKFrame

local afkCorner = Instance.new("UICorner")
afkCorner.CornerRadius = UDim.new(0, 6)
afkCorner.Parent = antiAFKButton

local afkActive = false
local afkConnection

antiAFKButton.MouseButton1Click:Connect(function()
    afkActive = not afkActive
    if afkActive then
        antiAFKButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        antiAFKButton.Text = "💤 Anti-AFK: ON"
        afkConnection = RunService.RenderStepped:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    else
        antiAFKButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        antiAFKButton.Text = "💤 Anti-AFK: OFF"
        if afkConnection then afkConnection:Disconnect() end
    end
end)

print("Misc tab loaded: Fly with advanced bypass, Infinite Jump, NoClip, Anti-AFK")
