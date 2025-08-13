local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよスクリプト",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield piyopiyo hub",
   LoadingSubtitle = "作者 najayou777",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hina0804"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("プレイヤー", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Section Example")

-- プレイヤータブにスライダーを追加
local SpeedSlider = Tab:CreateSlider({
    Name = "プレイヤースピード",
    Range = {16, 500},
    Increment = 1,
    Suffix = " スピード",
    CurrentValue = 16,
    Flag = "PlayerSpeed",
})

-- ON/OFFトグル
local SpeedToggle = Tab:CreateToggle({
    Name = "スピード適用",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(State)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            if State then
                -- トグルONならスライダー値を適用
                player.Character.Humanoid.WalkSpeed = SpeedSlider.CurrentValue
            else
                -- トグルOFFならデフォルト速度に戻す
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

-- スライダー値変更時の処理
SpeedSlider:OnChanged(function(Value)
    local player = game.Players.LocalPlayer
    -- トグルがONのときだけ適用
    if SpeedToggle.CurrentValue and player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = Value
    end
end)

-- 設定をロード
Rayfield:LoadConfiguration()
