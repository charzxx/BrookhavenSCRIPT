--// Mini Editor All-in-One LocalScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Ensure RemoteEvents exist
local RunCodeEvent = ReplicatedStorage:FindFirstChild("RunCodeEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
RunCodeEvent.Name = "RunCodeEvent"

local RemoteOutput = ReplicatedStorage:FindFirstChild("RemoteOutput") or Instance.new("RemoteEvent", ReplicatedStorage)
RemoteOutput.Name = "RemoteOutput"

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniEditorGUI"
screenGui.Parent = StarterGui
screenGui.ResetOnSpawn = false

-- ======= Input TextBox =======
local input = Instance.new("TextBox")
input.Name = "Input"
input.Parent = screenGui
input.Size = UDim2.new(1, -20, 0, 200)
input.Position = UDim2.new(0, 10, 0, 10)
input.BackgroundColor3 = Color3.fromRGB(30,30,30)
input.TextColor3 = Color3.new(1,1,1)
input.Font = Enum.Font.SourceSans
input.TextSize = 18
input.MultiLine = true
input.ClearTextOnFocus = false
input.TextWrapped = false
input.PlaceholderText = "Type Lua code here..."
input.TextXAlignment = Enum.TextXAlignment.Left
input.TextYAlignment = Enum.TextYAlignment.Top
input.LineHeight = 1.2

-- ======= Run Button =======
local runButton = Instance.new("TextButton")
runButton.Name = "RunButton"
runButton.Parent = screenGui
runButton.Size = UDim2.new(0, 100, 0, 40)
runButton.Position = UDim2.new(0, 10, 0, 220)
runButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
runButton.TextColor3 = Color3.new(1,1,1)
runButton.Font = Enum.Font.SourceSansBold
runButton.TextSize = 18
runButton.Text = "Run"

-- ======= Output Button =======
local outputButton = Instance.new("TextButton")
outputButton.Name = "OutputButton"
outputButton.Parent = screenGui
outputButton.Size = UDim2.new(0, 100, 0, 40)
outputButton.Position = UDim2.new(0, 120, 0, 220)
outputButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
outputButton.TextColor3 = Color3.new(1,1,1)
outputButton.Font = Enum.Font.SourceSansBold
outputButton.TextSize = 18
outputButton.Text = "Output"

-- ======= Console Frame =======
local consoleFrame = Instance.new("ScrollingFrame")
consoleFrame.Name = "ConsoleFrame"
consoleFrame.Parent = screenGui
consoleFrame.Size = UDim2.new(1, -20, 0, 200)
consoleFrame.Position = UDim2.new(0, 10, 0, 270)
consoleFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
consoleFrame.Visible = false
consoleFrame.ScrollBarThickness = 6
consoleFrame.CanvasSize = UDim2.new(0,0,0,0)
consoleFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local consoleText = Instance.new("TextLabel")
consoleText.Name = "ConsoleText"
consoleText.Parent = consoleFrame
consoleText.Size = UDim2.new(1,0,0,0)
consoleText.Position = UDim2.new(0,0,0,0)
consoleText.BackgroundTransparency = 1
consoleText.TextXAlignment = Enum.TextXAlignment.Left
consoleText.TextYAlignment = Enum.TextYAlignment.Top
consoleText.TextWrapped = true
consoleText.TextColor3 = Color3.new(1,1,1)
consoleText.Font = Enum.Font.SourceSans
consoleText.TextSize = 16
consoleText.Text = ""

-- ======= Functions =======

-- Toggle console visibility
outputButton.MouseButton1Click:Connect(function()
	consoleFrame.Visible = not consoleFrame.Visible
end)

-- Run code
runButton.MouseButton1Click:Connect(function()
	RunCodeEvent:FireServer(input.Text)
end)

-- Receive server output
RemoteOutput.OnClientEvent:Connect(function(msg)
	consoleText.Text = consoleText.Text .. "\n" .. msg
	-- Auto scroll to bottom
	consoleFrame.CanvasPosition = Vector2.new(0, consoleText.TextBounds.Y)
end)
