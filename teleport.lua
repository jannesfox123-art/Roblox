-- Teleport Tab Content
if container then
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "Teleport Features"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = container
    
    -- TP to specific coordinates
    local coordLabel = Instance.new("TextLabel")
    coordLabel.Size = UDim2.new(1, 0, 0, 20)
    coordLabel.BackgroundTransparency = 1
    coordLabel.Text = "Enter coordinates (X, Y, Z):"
    coordLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    coordLabel.TextSize = 12
    coordLabel.Parent = container
    
    local xInput = Instance.new("TextBox")
    xInput.Size = UDim2.new(0.3, 0, 0, 25)
    xInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    xInput.Text = "0"
    xInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    xInput.PlaceholderText = "X"
    xInput.Parent = container
    
    local yInput = Instance.new("TextBox")
    yInput.Size = UDim2.new(0.3, 0, 0, 25)
    yInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    yInput.Text = "0"
    yInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    yInput.PlaceholderText = "Y"
    yInput.Parent = container
    
    local zInput = Instance.new("TextBox")
    zInput.Size = UDim2.new(0.3, 0, 0, 25)
    zInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    zInput.Text = "0"
    zInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    zInput.PlaceholderText = "Z"
    zInput.Parent = container
    
    local tpButton = Instance.new("TextButton")
    tpButton.Size = UDim2.new(1, 0, 0, 30)
    tpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tpButton.Text = "Teleport"
    tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpButton.TextSize = 14
    tpButton.Parent = container
    
    tpButton.MouseButton1Click:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local x = tonumber(xInput.Text) or 0
            local y = tonumber(yInput.Text) or 0
            local z = tonumber(zInput.Text) or 0
            player.Character:MoveTo(Vector3.new(x, y, z))
        end
    end)
    
    -- Save Position
    local savedPos = nil
    local saveButton = Instance.new("TextButton")
    saveButton.Size = UDim2.new(1, 0, 0, 30)
    saveButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    saveButton.Text = "Save Position"
    saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveButton.TextSize = 14
    saveButton.Parent = container
    
    saveButton.MouseButton1Click:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedPos = player.Character.HumanoidRootPart.Position
        end
    end)
    
    local loadButton = Instance.new("TextButton")
    loadButton.Size = UDim2.new(1, 0, 0, 30)
    loadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    loadButton.Text = "Load Position"
    loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadButton.TextSize = 14
    loadButton.Parent = container
    
    loadButton.MouseButton1Click:Connect(function()
        if savedPos and player and player.Character then
            player.Character:MoveTo(savedPos)
        end
    end)
end
