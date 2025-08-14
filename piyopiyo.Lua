local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local speed = 50

-- Fly ON/OFF トグル
local function toggleFly()
	flying = not flying
	if not flying then
		player.Character:WaitForChild("Humanoid").PlatformStand = false
	end
end

-- スマホUIボタン作成
local gui = Instance.new("ScreenGui", player.PlayerGui)
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 100, 0, 50)
btn.Position = UDim2.new(0.05, 0, 0.8, 0)
btn.Text = "Fly OFF"
btn.MouseButton1Click:Connect(function()
	toggleFly()
	btn.Text = flying and "Fly ON" or "Fly OFF"
end)

-- スピードスライダー
local sliderFrame = Instance.new("Frame", gui)
sliderFrame.Size = UDim2.new(0, 200, 0, 40)
sliderFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local dragging = false
sliderFrame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)
sliderFrame.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
uis.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		local ratio = math.clamp((i.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
		sliderBar.Size = UDim2.new(ratio, 0, 1, 0)
		speed = 20 + (ratio * 180)
	end
end)

-- Fly挙動
runService.RenderStepped:Connect(function()
	if flying then
		local moveVec = Vector3.new()
		local hum = player.Character:FindFirstChild("Humanoid")

		if hum then
			hum.PlatformStand = true -- 重力無効化
		end

		-- デフォルト移動入力（WASDやジョイスティック）
		moveVec = player.Character:WaitForChild("Humanoid").MoveDirection

		-- カメラ方向に変換
		local camDir = camera.CFrame:VectorToWorldSpace(moveVec)
		player.Character:WaitForChild("HumanoidRootPart").Velocity = camDir * speed
	end
end)
