local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "pastagame UI 1.0",
   Icon = 0, -- 0 = no icon
   LoadingTitle = "pastagame UI",
   LoadingSubtitle = "This is the only official source of pastagame UI 1.0",
   ShowText = "pastagame 1.0",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
})

-- Give Rayfield a moment to initialize
task.defer(function()
    local Tab = Window:CreateTab("Main", 0) -- 0 = no image

    local Button = Tab:CreateButton({
        Name = "Fly",
        Callback = function()
            -- Fly function
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local uis = game:GetService("UserInputService")
            local runService = game:GetService("RunService")

            local flySpeed = 50
            local fly = true

            -- BodyVelocity & BodyGyro
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = Vector3.new(0,0,0)
            bv.P = 1e4
            bv.Parent = hrp

            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bg.CFrame = hrp.CFrame
            bg.P = 1e4
            bg.Parent = hrp

            -- Fly update loop
            runService.RenderStepped:Connect(function()
                if fly then
                    local direction = Vector3.new(0,0,0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + hrp.CFrame.LookVector
                    end
                    if uis:IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - hrp.CFrame.LookVector
                    end
                    if uis:IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - hrp.CFrame.RightVector
                    end
                    if uis:IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + hrp.CFrame.RightVector
                    end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then
                        direction = direction + Vector3.new(0,1,0)
                    end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                        direction = direction - Vector3.new(0,1,0)
                    end

                    if direction.Magnitude > 0 then
                        direction = direction.Unit * flySpeed
                        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
                    end
                    bv.Velocity = direction
                else
                    bv.Velocity = Vector3.new(0,0,0)
                end
            end)

            -- Optional: toggle fly off with F key
            uis.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.KeyCode == Enum.KeyCode.F then
                    fly = not fly
                    if not fly then
                        bv.Velocity = Vector3.new(0,0,0)
                        bg.CFrame = hrp.CFrame
                    end
                end
            end)
        end,
    })
end)
