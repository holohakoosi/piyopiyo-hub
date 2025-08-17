--!strict
--[[ 
    Piyopiyo Hub
    Author: najayou777
    UI Library: Rayfield (https://github.com/shlexware/Rayfield)
]]

-- ライブラリの読み込み
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ウィンドウ作成
local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよはぶ",
   LoadingTitle = "Piyopiyo Hub Loading...",
   LoadingSubtitle = "by najayou777",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PiyopiyoHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- 📌 プレイヤータブ
local PlayerTab = Window:CreateTab("プレイヤー", 4483362458)

-- WalkSpeed スライダー
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
       if game.Players.LocalPlayer.Character then
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- JumpPower スライダー
PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 10,
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
       if game.Players.LocalPlayer.Character then
           game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
       end
   end,
})

-- 無限ジャンプ トグル
PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
       _G.InfJump = Value
   end,
})

-- 無限ジャンプ処理
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)

-- Fly トグル（ダミー）
PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
       if Value then
           Rayfield:Notify({Title = "ぴよぴよはぶ", Content = "Fly ON (デモ)", Duration = 3})
       else
           Rayfield:Notify({Title = "ぴよぴよはぶ", Content = "Fly OFF", Duration = 3})
       end
   end,
})

-- 📌 設定タブ
local SettingsTab = Window:CreateTab("⚙️ 設定", 7072717697)

SettingsTab:CreateButton({
    Name = "設定を初期化",
    Callback = function()
        Rayfield:LoadConfiguration() -- 保存された設定を再ロード
        Rayfield:Notify({Title="ぴよぴよはぶ", Content="設定を初期化しました", Duration=3})
    end
})
