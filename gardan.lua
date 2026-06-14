
-- Gardan Tab Content (assuming it's for guard/security related features)
if container then
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "Gardan Features"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = container
    
    -- Anti-AFK
    local afkButton = Instance.new("TextButton")
    afkButton.Size = UDim2.new(1, 0, 0, 30)
    afkButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    afkButton.Text = "Toggle Anti-AFK"
    afkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    afkButton.TextSize = 14
    afkButton.Parent = container
    
    local antiAFK = false
    afkButton.MouseButton1Click:Connect(function()
        antiAFK = not antiAFK
        afkButton.Text = antiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"
    end)
    
    -- Anti-AFK loop
    spawn(function()
        while wait(1) do
            if antiAFK and player and player.Character and player.Character:FindFirstChild("Humanoid") then
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end
    end)
    
    -- NoClip
    local noclipButton = Instance.new("TextButton")
    noclipButton.Size = UDim2.new(1, 0, 0, 30)
    noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    noclipButton.Text = "Toggle NoClip"
    noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipButton.TextSize = 14
    noclipButton.Parent = container
    
    local noclip = false
    noclipButton.MouseButton1Click:Connect(function()
        noclip = not noclip
        noclipButton.Text = noclip and "NoClip: ON" or "NoClip: OFF"
    end)
    
    -- NoClip loop
    game:GetService("RunService").Stepped:Connect(function()
        if noclip and player and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end)
end
