local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ぴよぴよ ハブ",
   LoadingTitle = "ぴよぴよ ハブ",
   LoadingSubtitle = "作者 najayou777",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MyHub"
   },
})

local MainTab = Window:CreateTab("プレイヤー", nil)
local MainSection = MainTab:CreateSection("スピード")

-- プレイヤー取得
local player = game.Players.LocalPlayer

-- Humanoid取得関数
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local Slider = MainTab:CreateSlider({
   Name = "プレイヤースピード",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = Value
        end
   end,
})

Rayfield:LoadConfiguration()
