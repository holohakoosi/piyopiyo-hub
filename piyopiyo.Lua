-- Roblox Fly Script (カメラ方向に飛べる版)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = game.Workspace.CurrentCamera

local flying = false
local speed = 50
local moveForward = false

-- UI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Fly ON/OFF ボタン
local flyButton = Instance.new("TextButton", screenGui)
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0.05, 0, 0.8, 0)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
flyButton.TextScaled = true

-- スピードスライダー
local sliderFrame = Instance.new("Frame", screenGui)
sliderFrame.Size = UDim2.new(0, 200, 0, 40)
sliderFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- ボタンでFly切り替え
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyButton.Text = "Fly: ON"
		humanoid.PlatformStand = true
	else
		flyButton.Text = "Fly: OFF"
		humanoid.PlatformStand = false
		hrp.Velocity = Vector3.zero
	end
end)

-- スライダーで速度変更
local dragging = false
sliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)
sliderFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
		sliderBar.Size = UDim2.new(relativeX, 0, 1, 0)
		speed = 20 + (relativeX * 180)
	end
end)

-- 移動処理（カメラの向いている方向に進む）
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			local camDir = camera.CFrame.LookVector -- カメラの向き
			hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + camDir) -- 向き変更
			hrp.Velocity = camDir * speed
		else
			hrp.Velocity = Vector3.zero
		end
	end
end)
