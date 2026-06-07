-- esp.lua – This script creates an "ESP" tab inside the main GUI.
-- It is designed to be loaded via the external tab loader.

-- All the UI creation functions (CreateTab, CreateSection, etc.) are already in the environment.

local espTab = CreateTab("ESP", "👁️")

-- ESP Settings Section
local settingsSection = CreateSection(espTab, "ESP Settings")
CreateToggle(settingsSection, "ESP Enabled", false, function(state)
    print("ESP Enabled:", state)
end)
CreateToggle(settingsSection, "Show Boxes", false, function(state)
    print("Show Boxes:", state)
end)
CreateToggle(settingsSection, "Show Names", true, function(state)
    print("Show Names:", state)
end)
CreateToggle(settingsSection, "Show Health", true, function(state)
    print("Show Health:", state)
end)

-- Visual Options Section
local visualSection = CreateSection(espTab, "Visual Options")
CreateToggle(visualSection, "Chams", false, function(state)
    print("Chams:", state)
end)
CreateSlider(visualSection, "Box Thickness", 1, 5, 2, function(value)
    print("Box Thickness:", value)
end)
CreateSlider(visualSection, "ESP Distance", 100, 1000, 500, function(value)
    print("ESP Distance:", value)
end)

-- Colors Section
local colorsSection = CreateSection(espTab, "Colors")
CreateToggle(colorsSection, "Team Color ESP", true, function(state)
    print("Team Color:", state)
end)
CreateToggle(colorsSection, "Rainbow ESP", false, function(state)
    print("Rainbow:", state)
end)

CreateButton(espTab, "Refresh ESP", function()
    print("ESP refreshed.")
end)
