-- Misc Tab Content
-- 'container' is provided by the main script

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Miscellaneous Features"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = container

-- WalkSpeed control
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, 0, 0, 30)
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.Text = "Set Walkspeed to 50"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 14
speedButton.Parent = container

speedButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    end
end)

-- Reset walkspeed
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(1, 0, 0, 30)
resetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resetButton.Text = "Reset Walkspeed"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = 14
resetButton.Parent = container

resetButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Jump Power control 1
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(1, 0, 0, 30)
jumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpButton.Text = "Set Jump Power to 100"
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.TextSize = 14
jumpButton.Parent = container

jumpButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 100
    end
end)
