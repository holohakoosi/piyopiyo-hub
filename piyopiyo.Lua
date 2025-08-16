--// Rayfield Library 読み込み
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Window 作成
local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよ HUB",
   LoadingTitle = "ぴよぴよ HUB",
   LoadingSubtitle = "by najayou777",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PiyopiyoHub", -- 設定保存用
      FileName = "Config"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

----------------------------------------------------------------
-- Player タブ
----------------------------------------------------------------
local PlayerTab = Window:CreateTab("Player 🧍", 4483362458)

-- WalkSpeed スライダー
local WalkSpeedValue = 16
local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      WalkSpeedValue = Value
      -- 実行処理（ダミー）
      print("WalkSpeed = " .. Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- WalkSpeed リセット
PlayerTab:CreateButton({
   Name = "WalkSpeed リセット",
   Callback = function()
      WalkSpeedValue = 16
      WalkSpeedSlider:Set(16)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end
      print("WalkSpeed Reset")
   end,
})

-- JumpPower スライダー
local JumpPowerValue = 50
local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      JumpPowerValue = Value
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

-- JumpPower リセット
PlayerTab:CreateButton({
   Name = "JumpPower リセット",
   Callback = function()
      JumpPowerValue = 50
      JumpPowerSlider:Set(50)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
      end
      print("JumpPower Reset")
   end,
})

-- Infinite Jump トグル（ダミー）
local InfiniteJump = false
PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
      InfiniteJump = Value
      print("Infinite Jump: " .. tostring(Value))
   end,
})

-- Fly トグル（簡易版）
local Flying = false
PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
      Flying = Value
      print("Fly: " .. tostring(Value))
   end,
})

----------------------------------------------------------------
-- Settings タブ
----------------------------------------------------------------
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

-- 言語切替（ドロップダウン）
local Language = "日本語"
SettingsTab:CreateDropdown({
   Name = "Language",
   Options = {"日本語", "English"},
   CurrentOption = "日本語",
   Flag = "Language",
   Callback = function(Option)
      Language = Option
      print("Language set to: " .. Option)
   end,
})

-- テーマカラー変更（サンプル）
SettingsTab:CreateColorPicker({
   Name = "UIテーマカラー",
   Color = Color3.fromRGB(255, 200, 200),
   Flag = "ThemeColor",
   Callback = function(Color)
      print("Theme color changed: ", Color)
   end,
})

-- 設定リセット
SettingsTab:CreateButton({
   Name = "設定リセット",
   Callback = function()
      Rayfield:Destroy() -- UIを閉じて再起動が必要
      print("Settings Reset")
   end,
})
