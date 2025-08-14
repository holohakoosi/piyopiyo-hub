-- スマホ用 vfly（カメラ方向自由飛行版）
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local runService = game:GetService("RunService")

local flying = false
local speed = 50

-- === UI作成 ===
local gui = Instance.new("ScreenGui", player.PlayerGui)

-- Fly切り替えボタン
local flyBtn = Instance.new("TextButton", gui)
flyBtn.Size = UDim2.new(0, 100, 0, 50)
flyBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
flyBtn.TextScaled = true
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
	if not flying then
		hrp.Velocity = Vector3.zero
	end
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
game:GetService("UserInputService").InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		local ratio = math.clamp((i.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
		sliderBar.Size = UDim2.new(ratio, 0, 1, 0)
		speed = 20 + (ratio * 180)
	end
end)

-- === Fly挙動 ===
runService.RenderStepped:Connect(function()
	if flying then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = true end

		-- 左ジョイスティックの入力を取得
		local moveDir = hum.MoveDirection -- XZ平面ベース

		-- カメラ方向に変換（LookVectorで上下も含む）
		local camCF = cam.CFrame
		local worldDir = (camCF.LookVector * moveDir.Z) + (camCF.RightVector * moveDir.X)

		if worldDir.Magnitude > 0 then
			worldDir = worldDir.Unit * speed
		end

		hrp.Velocity = worldDir
		-- 体の向きを進行方向に
		if worldDir.Magnitude > 0 then
			hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + worldDir)
		end
	else
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = false end
		hrp.Velocity = Vector3.zero
	end
end)
