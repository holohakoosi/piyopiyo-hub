local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
   Name = "テスト HUB",
   LoadingTitle = "Rayfield Test",
   LoadingSubtitle = "By najayou777",
   KeySystem = false
})

local Tab = Window:CreateTab("Player 🧍", 4483362458)

Tab:CreateButton({
   Name = "テストボタン",
   Callback = function()
      print("Button Pressed!")
   end
})

-- ← これを忘れない
Rayfield:Init()
