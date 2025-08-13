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

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
})

local Tab = Window:CreateTab("プレイヤー", 4483362458)
local Section = Tab:CreateSection("プレイヤー操作")

local player = game.Players.LocalPlayer
local defaultSpeed = 16 -- デフォルト速度

-- Humanoidを安全に取得する関数
local function getHumanoid()
    if player and player.Character then
        return player.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
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
        local humanoid = getHumanoid()
        if humanoid then
            if State then
                humanoid.WalkSpeed = SpeedSlider.CurrentValue
            else
                humanoid.WalkSpeed = defaultSpeed
            end
        end
    end,
})

-- スライダー変更時
SpeedSlider:OnChanged(function(Value)
    local humanoid = getHumanoid()
    if SpeedToggle.CurrentValue and humanoid then
        humanoid.WalkSpeed = Value
    end
end)

-- Character生成時の対応
player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    if SpeedToggle.CurrentValue then
        humanoid.WalkSpeed = SpeedSlider.CurrentValue
    else
        humanoid.WalkSpeed = defaultSpeed
    end
end)

-- 設定の読み込み
Rayfield:LoadConfiguration()
