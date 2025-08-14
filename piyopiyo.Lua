-- スマホ用 vfly + ESP + UI閉じるボタン
local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local runService = game:GetService("RunService")

local flying = false
local speed = 50
local velocity = Vector3.zero

-- === UI作成 ===
local gui = Instance.new("ScreenGui", player.PlayerGui)

-- Fly ON/OFF ボタン
local flyBtn = Instance.new("TextButton", gui)
flyBtn.Size = UDim2.new(0, 100, 0, 50)
flyBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.TextScaled = true
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
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
		local ratio = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
		sliderBar.Size = UDim2.new(ratio, 0, 1, 0)
		speed = 20 + (ratio * 180)
	end
end)

-- 閉じるボタン
local closeBtn = Instance.new("TextButton", gui)
closeBtn.Size = UDim2.new(0, 60, 0, 40)
closeBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
closeBtn.Text = "×"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- === ESP 作成 ===
local function createESP(targetChar)
	if not targetChar then return end
	local hrpTarget = targetChar:FindFirstChild("HumanoidRootPart")
	if not hrpTarget then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Adornee = hrpTarget
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = gui

	local text = Instance.new("TextLabel", billboard)
	text.Size = UDim2.new(1,0,1,0)
	text.TextScaled = true
	text.BackgroundTransparency = 1
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.Text = targetChar.Name

	return billboard
end

local espList = {}
players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		espList[p.Name] = createESP(c)
	end)
end)

for _, p in pairs(players:GetPlayers()) do
	if p ~= player and p.Character then
		espList[p.Name] = createESP(p.Character)
	end
end

-- === Fly挙動 ===
runService.RenderStepped:Connect(function(delta)
	if flying then
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = true end

		local moveInput = hum.MoveDirection
		local camCF = cam.CFrame
		local moveVector = (camCF.LookVector * moveInput.Z) + (camCF.RightVector * moveInput.X)

		if moveVector.Magnitude > 0 then
			velocity = velocity:Lerp(moveVector.Unit * speed, 0.2)
			hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + moveVector)
		else
			velocity = velocity:Lerp(Vector3.zero, 0.2)
		end

		hrp.Velocity = velocity
	else
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = false end
		hrp.Velocity = Vector3.zero
	end
end)
