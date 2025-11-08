-- Simple Rayfield UI (no exploit-checker fallbacks)
-- NOTE: This uses game:HttpGet directly. If your environment doesn't expose Game:HttpGet, this will error.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create window
local Window = Rayfield:CreateWindow({
    Name = "pastagame UI (Rayfield)",
    LoadingTitle = "pastagame",
    LoadingSubtitle = "rayfield example",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PastagameConfigs",
        FileName = "default"
    },
    KeySystem = false
})

-- Main tab + section
local MainTab = Window:CreateTab("Main")
local MainSection = MainTab:CreateSection("Main Controls")

-- Toggle example
MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(state)
        print("Auto Farm:", state)
        if state then
            _G._pastagame_auto_farm = true
            spawn(function()
                while _G._pastagame_auto_farm do
                    pcall(function()
                        -- game-specific action here
                    end)
                    wait(1)
                end
            end)
        else
            _G._pastagame_auto_farm = false
        end
    end
})

-- Slider example (walkspeed)
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(val)
        local plr = game:GetService("Players").LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            pcall(function() plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val end)
        end
    end
})

-- Textbox example (teleport to player)
MainTab:CreateTextBox({
    Name = "Teleport To (player name)",
    Placeholder = "playerName",
    TextDisappear = true,
    Callback = function(txt)
        local plr = game:GetService("Players").LocalPlayer
        local target = game:GetService("Players"):FindFirstChild(txt)
        if plr and plr.Character and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                plr.Character:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame + Vector3.new(2,0,0))
            end)
        else
            Rayfield:Notify({ Title = "Teleport", Content = "player not found or no character", Duration = 3 })
        end
    end
})

-- Button example
MainTab:CreateButton({
    Name = "Do a thing",
    Callback = function()
        print("button pressed, do your thing here")
        Rayfield:Notify({ Title = "Button", Content = "button pressed!", Duration = 2 })
    end
})

-- Keybind example (toggle UI)
MainTab:CreateKeyBind({
    Name = "Toggle UI",
    CurrentKey = "RightShift",
    Mode = "Toggle",
    Flag = "ToggleUIKeybind",
    Callback = function()
        Rayfield:Toggle()
    end
})

-- Color picker example
MainTab:CreateColorPicker({
    Name = "Example Color",
    Default = Color3.fromRGB(255,255,255),
    Flag = "ExampleColor",
    Callback = function(color)
        print("picked color:", color)
    end
})

-- Save config button
MainTab:CreateButton({
    Name = "Save Config (manual notify)",
    Callback = function()
        Rayfield:Notify({ Title = "Config", Content = "Saved config to folder.", Duration = 2 })
    end
})

Rayfield:Notify({ Title = "Rayfield loaded", Content = "UI ready — tweak flags & callbacks as needed", Duration = 4 })
