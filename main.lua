-- Create the textbox
Tab:CreateTextbox({
    Name = "Target Player",
    PlaceholderText = "Type player name here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(playerName)
        -- Store the target player name
        _G.TargetPlayerName = playerName
    end
})

-- Button: Bring Player
Tab:CreateButton({
    Name = "Bring Player",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        local targetName = _G.TargetPlayerName
        if not targetName or targetName == "" then
            Rayfield:Notify({
                Title = "Error",
                Content = "No player name entered!",
                Duration = 3
            })
            return
        end

        local targetPlayer = Players:FindFirstChild(targetName)
        if not targetPlayer then
            Rayfield:Notify({
                Title = "Error",
                Content = targetName .. " not found!",
                Duration = 3
            })
            return
        end

        -- Loop to bring Tool if they have one
        spawn(function()
            while targetPlayer and targetPlayer.Parent do
                local tool = (targetPlayer.Backpack and targetPlayer.Backpack:FindFirstChildOfClass("Tool")) 
                            or (targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Tool"))
                if tool and LocalPlayer.Character then
                    tool.Parent = LocalPlayer.Backpack -- bring tool to you
                end
                task.wait(0.5)
            end
        end)

        -- Connect to Tool activation
        local function onToolActivated(tool)
            if targetPlayer.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                targetPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = myHRP.CFrame + Vector3.new(0,0,5)
                Rayfield:Notify({
                    Title = "Tool Activated!",
                    Content = targetPlayer.Name .. " has been teleported to you!",
                    Duration = 3
                })
            end
        end

        if targetPlayer.Backpack then
            for _, tool in ipairs(targetPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Activated:Connect(function() onToolActivated(tool) end)
                end
            end
        end
        if targetPlayer.Character then
            for _, tool in ipairs(targetPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Activated:Connect(function() onToolActivated(tool) end)
                end
            end
        end

        Rayfield:Notify({
            Title = "Active!",
            Content = "Monitoring " .. targetName .. " for tools...",
            Duration = 3
        })
    end
})
