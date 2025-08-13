local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよ ハブ",
   LoadingTitle = "ぴよぴよ ハブ",
   LoadingSubtitle = "作者 najayou777",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "MyHub"
   },
})

local MainTab = Window:CreateTab("プレイヤー", nil) -- Title, Image
local MainSection = MainTab:CreateSection("スピード")

local Slider = MainTab:CreateSlider({
   Name = "プレイヤースピード",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        Game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (value)
   end,
})

Rayfield:LoadConfiguration()
