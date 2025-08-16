-- Orion Library の読み込み
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- ウィンドウ作成
local Window = OrionLib:MakeWindow({
    Name = "ぴよぴよ HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "PiyoPiyoHub",
    IntroEnabled = true,
    IntroText = "Made by najayou777"
})

------------------------------------------------
-- Player Tab
------------------------------------------------
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 5,
    ValueName = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

PlayerTab:AddButton({
    Name = "Fly (簡易版)",
    Callback = function()
        print("Fly 起動（実装は簡易サンプル）")
    end    
})

PlayerTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end    
})

------------------------------------------------
-- ESP Tab
------------------------------------------------
local EspTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://6034287517",
    PremiumOnly = false
})

EspTab:AddToggle({
    Name = "名前表示",
    Default = false,
    Callback = function(Value)
        print("ESP Name: " .. tostring(Value))
    end    
})

EspTab:AddToggle({
    Name = "体の枠 (Box ESP)",
    Default = false,
    Callback = function(Value)
        print("ESP Box: " .. tostring(Value))
    end    
})

EspTab:AddColorpicker({
    Name = "ESPカラー",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        print("ESP Color: ", Value)
    end  
})

EspTab:AddSlider({
    Name = "透明度",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 5,
    ValueName = "%",
    Callback = function(Value)
        print("ESP Transparency: " .. Value)
    end    
})

------------------------------------------------
-- Settings Tab
------------------------------------------------
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://6034509993",
    PremiumOnly = false
})

SettingsTab:AddDropdown({
    Name = "Language",
    Default = "日本語",
    Options = {"日本語", "English"},
    Callback = function(Value)
        print("Language set to: " .. Value)
    end    
})

SettingsTab:AddColorpicker({
    Name = "テーマカラー",
    Default = Color3.fromRGB(44, 120, 224),
    Callback = function(Value)
        print("Theme Color: ", Value)
    end  
})

SettingsTab:AddButton({
    Name = "設定初期化",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Reset",
            Content = "設定が初期化されました",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

------------------------------------------------
-- 起動
------------------------------------------------
OrionLib:Init()
