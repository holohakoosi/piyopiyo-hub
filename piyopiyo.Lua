local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "ぴよぴよスクリプト",
    Icon = 0,
    LoadingTitle = "Rayfield piyopiyo hub",
    LoadingSubtitle = "作者 najayou777",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "Big Hub" },
    Discord = { Enabled=false },
    KeySystem = false
})

local Tab = Window:CreateTab("プレイヤー", 4483362458)
local Section = Tab:CreateSection("プレイヤー操作")

-- トグルを作成
local speedToggle = Tab:CreateToggle({
    Name = "速度変更オン",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(value)
        -- トグルがオンのときだけスライダーで反映されるようにする
        if value then
            humanoid.WalkSpeed = Tab.Flags.SpeedSlider
        else
            humanoid.WalkSpeed = 16 -- デフォルト速度に戻す
        end
    end
})

-- スライダーを作成
local speedSlider = Tab:CreateSlider({
    Name = "移動速度",
    Range = {16, 200}, -- デフォルト16
    Increment = 1,
    Suffix = "スピード",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(value)
        -- トグルがオンのときだけ適用
        if speedToggle.CurrentValue then
            humanoid.WalkSpeed = value
        end
    end
})

-- プレイヤーのHumanoidを取得
local player = game.Players.LocalPlayer
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

-- キャラクターがリスポーンしたときもHumanoidを更新
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
end)

Rayfield:LoadConfiguration()
