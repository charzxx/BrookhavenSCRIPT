local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "pastagame UI 1.0",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "pastagame UI",
   LoadingSubtitle = "This is the only official source of pastagame UI 1.0",
   ShowText = "pastagame 1.0", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

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
        local fly = true -- enabled immediately

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
        local connection
        connection = runService.RenderStepped:Connect(function(delta)
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
