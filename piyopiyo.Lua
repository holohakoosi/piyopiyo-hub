-- Rayfieldライブラリを読み込み
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================================
-- ウィンドウ作成
-- ================================
local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよ ハブ",
   LoadingTitle = "by najayou777",
   LoadingSubtitle = "Rayfield UI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PiyoPiyoHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false
   }
})

-- ================================
-- 状態変数
-- ================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local flying, flySpeed = false, 50
local walkEnabled, walkSpeed = false, humanoid.WalkSpeed
local jumpEnabled, jumpPower = false, humanoid.JumpPower
local infiniteJump, noclip = false, false

-- ================================
-- Fly機能
-- ================================
local bv
local function startFly()
    if flying then return end
    flying = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    game:GetService("RunService").RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        local uis = game:GetService("UserInputService")

        if uis:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() bv = nil end
end

-- ================================
-- プレイヤータブ
-- ================================
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(v)
      if v then startFly() else stopFly() end
   end
})

PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 5,
   CurrentValue = flySpeed,
   Callback = function(v) flySpeed = v end
})

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = walkSpeed,
   Callback = function(v) humanoid.WalkSpeed = v end
})

PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 5,
   CurrentValue = jumpPower,
   Callback = function(v) humanoid.JumpPower = v end
})

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) infiniteJump = v end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

PlayerTab:CreateToggle({
   Name = "Wall NoClip",
   CurrentValue = false,
   Callback = function(v) noclip = v end
})

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ================================
-- 設定タブ
-- ================================
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateButton({
   Name = "Reset Settings",
   Callback = function()
      stopFly()
      humanoid.WalkSpeed = 16
      humanoid.JumpPower = 50
      infiniteJump, noclip = false, false
   end
})
