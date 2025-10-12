---@diagnostic disable: undefined-global
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Safe Rayfield loader
local ok, Rayfield = pcall(function()
	return loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
end)
if not ok or not Rayfield then
	warn("Failed to load Rayfield:", Rayfield)
	return
end

-- Window + Main tab
local Window = Rayfield:CreateWindow({
	Name = "Brookhaven M2 Script by Charz",
	LoadingTitle = "Loading Brookhaven M2 Script...",
	LoadingSubtitle = "By Charz 😎",
	ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main", 4483362458)

-- Global variable for target player name
_G.TargetPlayerName = ""

-- Textbox: Target Player Name
Tab:CreateTextbox({
	Name = "Target Player",
	PlaceholderText = "Type player name here...",
	RemoveTextAfterFocusLost = false,
	Callback = function(playerName)
		_G.TargetPlayerName = playerName
	end
})

-- Bring Player mechanism
local function BringPlayer(targetName)
	local LocalPlayer = Players.LocalPlayer
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

	-- Grab tool loop
	spawn(function()
		while targetPlayer and targetPlayer.Parent do
			local tool = (targetPlayer.Backpack and targetPlayer.Backpack:FindFirstChildOfClass("Tool")) 
						or (targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Tool"))
			if tool and LocalPlayer.Character then
				tool.Parent = LocalPlayer.Backpack
			end
			task.wait(0.5)
		end
	end)

	-- Teleport the player to you when tool is activated
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
end

-- Button: Bring Player
Tab:CreateButton({
	Name = "Bring Player",
	Callback = function()
		BringPlayer(_G.TargetPlayerName)
	end
})

print("Brookhaven M2 Script loaded! Main tab and Bring Player button ready.")
