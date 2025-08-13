local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "ぴよぴよスクリプト",
    Icon = 0,
    LoadingTitle = "Rayfield piyopiyo hub",
    LoadingSubtitle = "作者 najayou777",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },
    Discord = {Enabled=false},
    KeySystem = false
})

local Tab = Window:CreateTab("プレイヤー", 4483362458)
local Section = Tab:CreateSection("プレイヤー操作")

local player = game.Players.LocalPlayer
local defaultSpeed = 16

-- Humanoidを安全に取得（Characterがロードされるまで待機）
local function getHumanoid()
    if not player then return nil end
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

-- スライダー作成
local SpeedSlider = Tab:CreateSlider({
    Name = "プレイヤースピード",
    Range = {16, 500},
    Increment = 1,
    Suffix = " スピード",
    CurrentValue = 16,
    Flag = "PlayerSpeed",
})

-- トグル作成
local SpeedToggle = Tab:CreateToggle({
    Name = "スピード適用",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(State)
        local success, humanoid = pcall(getHumanoid)
        if success and humanoid then
            humanoid.WalkSpeed = State and SpeedSlider.CurrentValue or defaultSpeed
        end
    end,
})

-- スライダー変更時
SpeedSlider:OnChanged(function(Value)
    local success, humanoid = pcall(getHumanoid)
    if success and humanoid and SpeedToggle.CurrentValue then
        humanoid.WalkSpeed = Value
    end
end)

-- Character生成時の対応
player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = SpeedToggle.CurrentValue and SpeedSlider.CurrentValue or defaultSpeed
end)

Rayfield:LoadConfiguration()
