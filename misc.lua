-- ============================================
-- MISC TAB
-- Fun and utility features
-- ============================================

local container = contentFrame

-- ========== CREATE UI ==========
local yOffset = 0

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🎲 MISC FEATURES"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = container
yOffset = 50

-- Walkspeed Slider
local speedSlider = CreateSlider("Walkspeed", 16, 100, 16, function(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end, yOffset)
speedSlider.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 75

-- Jump Power Slider
local jumpSlider = CreateSlider("Jump Power", 50, 200, 50, function(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end, yOffset)
jumpSlider.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 75

-- Fly Mode Toggle
local flyToggle = CreateToggle("Fly Mode", false, function(state)
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if state then
        humanoid.PlatformStand = true
        -- Fly movement loop
        task.spawn(function()
            while state and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                local rootPart = player.Character.HumanoidRootPart
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -1, 0) end
                
                if moveDir.Magnitude > 0 then
                    rootPart.Velocity = moveDir.Unit * 60
                else
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                end
                task.wait()
            end
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.PlatformStand = false
            end
        end)
    else
        humanoid.PlatformStand = false
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then rootPart.Velocity = Vector3.new(0, 0, 0) end
    end
end, yOffset)
flyToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Infinite Jump Toggle
local infJumpToggle = CreateToggle("Infinite Jump", false, function(state)
    if state then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            local connection
            connection = char.HumanoidRootPart.Touched:Connect(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) and humanoid:GetState() == Enum.HumanoidStateType.Landed then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            -- Store connection for cleanup? Not necessary, but we could
        end
    end
end, yOffset)
infJumpToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Anti-AFK Toggle
local antiAfkToggle = CreateToggle("Anti-AFK", false, function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if state then
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end
end, yOffset)
antiAfkToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 55

-- Noclip Toggle (simple)
local noclipToggle = CreateToggle("Noclip", false, function(state)
    local char = player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end, yOffset)
noclipToggle.frame.Position = UDim2.new(0.04, 0, 0, yOffset)
yOffset = yOffset + 70

-- Info text
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.92, 0, 0, 40)
infoLabel.Position = UDim2.new(0.04, 0, 0, yOffset + 10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Walkspeed and Jump Power reset when you respawn.\nFly mode: WASD + Space (up) + Shift (down)"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = container

yOffset = yOffset + 70
container.CanvasSize = UDim2.new(0, 0, 0, yOffset)

print("Misc tab loaded")
