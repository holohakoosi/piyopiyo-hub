-- Rayfieldライブラリ読込
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================================
-- 初期化
-- ================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 状態変数
local flying, flySpeed = false, 50
local infiniteJump, noclip, espEnabled = false, false, false
local bv = nil

-- 言語設定
local currentLang = "JP"
local texts = {
    JP = {
        Player = "プレイヤー",
        Fly = "フライ",
        FlySpeed = "フライ速度",
        WalkSpeed = "歩く速度",
        JumpPower = "ジャンプ力",
        InfJump = "無限ジャンプ",
        NoClip = "すり抜け",
        ESP = "ESP",
        Settings = "設定",
        Reset = "リセット",
        Lang = "言語"
    },
    EN = {
        Player = "Player",
        Fly = "Fly",
        FlySpeed = "Fly Speed",
        WalkSpeed = "Walk Speed",
        JumpPower = "Jump Power",
        InfJump = "Infinite Jump",
        NoClip = "NoClip",
        ESP = "ESP",
        Settings = "Settings",
        Reset = "Reset",
        Lang = "Language"
    }
}
local function T(key) return texts[currentLang][key] end

-- ================================
-- Fly関数
-- ================================
local flyConn
local function startFly()
    if flying then return end
    flying = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not flying or not bv or not hrp then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= cam.CFrame.UpVector end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() bv = nil end
    if flyConn then flyConn:Disconnect() flyConn = nil end
end

-- ================================
-- ESP関数
-- ================================
local function toggleESP(on)
    espEnabled = on
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if on then
                if not plr.Character:FindFirstChild("PiyoESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "PiyoESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = plr.Character
                end
            else
                if plr.Character:FindFirstChild("PiyoESP") then
                    plr.Character.PiyoESP:Destroy()
                end
            end
        end
    end
end

-- ================================
-- ウィンドウ
-- ================================
local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよ ハブ",
   LoadingTitle = "by najayou777",
   LoadingSubtitle = "Rayfield UI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PiyoPiyoHub",
      FileName = "Config"
   }
})

-- ================================
-- プレイヤータブ
-- ================================
local PlayerTab = Window:CreateTab(T("Player"), 4483362458)

PlayerTab:CreateToggle({
   Name = T("Fly"),
   CurrentValue = false,
   Callback = function(v) if v then startFly() else stopFly() end end
})

PlayerTab:CreateSlider({
   Name = T("FlySpeed"),
   Range = {10,200},
   Increment = 5,
   CurrentValue = flySpeed,
   Callback = function(v) flySpeed = v end
})

PlayerTab:CreateSlider({
   Name = T("WalkSpeed"),
   Range = {16,500},
   Increment = 5,
   CurrentValue = humanoid.WalkSpeed,
   Callback = function(v) humanoid.WalkSpeed = v end
})

PlayerTab:CreateSlider({
   Name = T("JumpPower"),
   Range = {50,500},
   Increment = 5,
   CurrentValue = humanoid.JumpPower,
   Callback = function(v) humanoid.JumpPower = v end
})

PlayerTab:CreateToggle({
   Name = T("InfJump"),
   CurrentValue = false,
   Callback = function(v) infiniteJump = v end
})

UIS.JumpRequest:Connect(function()
    if infiniteJump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

PlayerTab:CreateToggle({
   Name = T("NoClip"),
   CurrentValue = false,
   Callback = function(v) noclip = v end
})

RunService.Stepped:Connect(function()
    if noclip then
        for _,part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ================================
-- ESPタブ
-- ================================
local ESPTab = Window:CreateTab(T("ESP"), 4483362458)

ESPTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = toggleESP
})

-- ================================
-- 設定タブ
-- ================================
local SettingsTab = Window:CreateTab(T("Settings"), 4483362458)

SettingsTab:CreateButton({
   Name = T("Reset"),
   Callback = function()
      stopFly()
      humanoid.WalkSpeed = 16
      humanoid.JumpPower = 50
      infiniteJump, noclip = false, false
      toggleESP(false)
   end
})

SettingsTab:CreateDropdown({
   Name = T("Lang"),
   Options = {"日本語", "English"},
   CurrentOption = "日本語",
   Callback = function(option)
      currentLang = (option == "日本語") and "JP" or "EN"
      warn("⚠️ 言語切替は再読み込みが必要です")
   end
})
