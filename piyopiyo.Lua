-- Orion UI 読み込み
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- 初期値
local WalkSpeed = 16
local JumpPower = 50
local FlyEnabled = false
local ESPEnabled = false
local Language = "日本語"

-- ウィンドウ
local Window = OrionLib:MakeWindow({
    Name = "ぴよぴよ Hub | by najayou777",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "PiyoHub"
})

-------------------
-- プレイヤータブ
-------------------
local PlayerTab = Window:MakeTab({
    Name = (Language == "日本語" and "プレイヤー" or "Player"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 歩行速度スライダー
PlayerTab:AddSlider({
    Name = (Language == "日本語" and "歩行速度" or "Walk Speed"),
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255,128,64),
    Increment = 1,
    ValueName = "速度",
    Callback = function(Value)
        WalkSpeed = Value
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed
    end
})

-- ジャンプ力スライダー
PlayerTab:AddSlider({
    Name = (Language == "日本語" and "ジャンプ力" or "Jump Power"),
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(64,128,255),
    Increment = 1,
    ValueName = "高さ",
    Callback = function(Value)
        JumpPower = Value
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = JumpPower
    end
})

-- 無限ジャンプ
PlayerTab:AddToggle({
    Name = (Language == "日本語" and "無限ジャンプ" or "Infinite Jump"),
    Default = false,
    Callback = function(State)
        if State then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        end
    end
})

-- Fly
PlayerTab:AddToggle({
    Name = (Language == "日本語" and "フライ" or "Fly"),
    Default = false,
    Callback = function(State)
        FlyEnabled = State
        local Char = game.Players.LocalPlayer.Character
        local Humanoid = Char:FindFirstChildOfClass("Humanoid")
        if State then
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0,0,0)
            BodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
            BodyVelocity.Parent = Char.HumanoidRootPart
        else
            if Char.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                Char.HumanoidRootPart.BodyVelocity:Destroy()
            end
        end
    end
})

-- リセット
PlayerTab:AddButton({
    Name = (Language == "日本語" and "リセット" or "Reset"),
    Callback = function()
        local Hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        WalkSpeed = 16
        JumpPower = 50
        Hum.WalkSpeed = WalkSpeed
        Hum.JumpPower = JumpPower
        FlyEnabled = false
        OrionLib:MakeNotification({
            Name = "リセット完了",
            Content = "設定を初期化しました！",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-------------------
-- ESPタブ
-------------------
local EspTab = Window:MakeTab({
    Name = (Language == "日本語" and "ESP" or "ESP"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

EspTab:AddToggle({
    Name = (Language == "日本語" and "ESP有効" or "Enable ESP"),
    Default = false,
    Callback = function(State)
        ESPEnabled = State
        -- 簡易ESP例（本格的にはループ処理で各プレイヤーにBillboardGuiやHighlight追加が必要）
        for _,plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if State then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255,0,0)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = plr.Character
                else
                    if plr.Character:FindFirstChild("Highlight") then
                        plr.Character.Highlight:Destroy()
                    end
                end
            end
        end
    end
})

-------------------
-- 設定タブ
-------------------
local SettingsTab = Window:MakeTab({
    Name = (Language == "日本語" and "設定" or "Settings"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 言語切替（ドロップダウン）
SettingsTab:AddDropdown({
    Name = "言語 / Language",
    Default = "日本語",
    Options = {"日本語", "English"},
    Callback = function(Value)
        Language = Value
        OrionLib:MakeNotification({
            Name = "Language",
            Content = "言語を "..Value.." に変更しました",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- 色変更
SettingsTab:AddColorpicker({
    Name = (Language == "日本語" and "テーマカラー" or "Theme Color"),
    Default = Color3.fromRGB(255, 170, 0),
    Callback = function(Value)
        OrionLib.Theme.Default = Value
    end
})

-- 設定初期化
SettingsTab:AddButton({
    Name = (Language == "日本語" and "設定を初期化" or "Reset Settings"),
    Callback = function()
        WalkSpeed = 16
        JumpPower = 50
        FlyEnabled = false
        ESPEnabled = false
        Language = "日本語"
        OrionLib:MakeNotification({
            Name = "リセット完了",
            Content = "すべての設定を初期化しました",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

OrionLib:Init()
