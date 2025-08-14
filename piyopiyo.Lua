local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "ぴよぴよ ハブ", HidePremium = false, IntroText = "by najayou777", SaveConfig = true})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 状態管理
local flying, flySpeed, flyEnabled = false, 50, false
local walkSpeed, walkEnabled = humanoid.WalkSpeed, false
local jumpPower, jumpEnabled = humanoid.JumpPower, false
local infiniteJump, wallNoClip = false, false

-- 言語管理
local language = "JP" -- "JP" or "EN"

-- 翻訳テーブル
local L = {
    JP = {
        Fly="飛行",
        FlySpeed="飛行速度",
        ApplyFly="飛行速度適用",
        WalkSpeed="歩く速度",
        ApplyWalk="歩く速度適用",
        JumpPower="ジャンプ力",
        ApplyJump="ジャンプ力適用",
        InfiniteJump="無限ジャンプ",
        WallNoClip="壁すり抜け",
        Settings="設定",
        Language="言語",
        UIColor="UI色",
        Reset="設定初期化"
    },
    EN = {
        Fly="Fly",
        FlySpeed="Fly Speed",
        ApplyFly="Apply Fly Speed",
        WalkSpeed="WalkSpeed",
        ApplyWalk="Apply WalkSpeed",
        JumpPower="JumpPower",
        ApplyJump="Apply JumpPower",
        InfiniteJump="Infinite Jump",
        WallNoClip="Wall NoClip",
        Settings="Settings",
        Language="Language",
        UIColor="UI Color",
        Reset="Reset Settings"
    }
}

-- Fly制御
local bv
local function startFly()
    flying = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    task.spawn(function()
        while flying do
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            bv.Velocity = flyEnabled and (moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.zero) or Vector3.zero
            task.wait()
        end
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() bv = nil end
end

-- 無限ジャンプ
UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- WallNoClip
RunService.RenderStepped:Connect(function()
    if wallNoClip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    if walkEnabled then humanoid.WalkSpeed = walkSpeed end
    if jumpEnabled then humanoid.JumpPower = jumpPower end
end)

-- プレイヤータブ
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "", PremiumOnly = false})
-- Fly
PlayerTab:AddToggle({Name = L[language].Fly, Default=false, Callback=function(v) flyEnabled=v if v and not flying then startFly() elseif not v then stopFly() end end})
PlayerTab:AddSlider({Name=L[language].FlySpeed, Min=10, Max=200, Default=flySpeed, Increment=5, Callback=function(v) flySpeed=v end})
PlayerTab:AddToggle({Name=L[language].ApplyFly, Default=true, Callback=function(v) flyEnabled=v end})
-- WalkSpeed
PlayerTab:AddSlider({Name=L[language].WalkSpeed, Min=16, Max=500, Default=walkSpeed, Increment=5, Callback=function(v) walkSpeed=v end})
PlayerTab:AddToggle({Name=L[language].ApplyWalk, Default=false, Callback=function(v) walkEnabled=v end})
-- JumpPower
PlayerTab:AddSlider({Name=L[language].JumpPower, Min=50, Max=500, Default=jumpPower, Increment=5, Callback=function(v) jumpPower=v end})
PlayerTab:AddToggle({Name=L[language].ApplyJump, Default=false, Callback=function(v) jumpEnabled=v end})
-- 無限ジャンプ
PlayerTab:AddToggle({Name=L[language].InfiniteJump, Default=false, Callback=function(v) infiniteJump=v end})
-- WallNoClip
PlayerTab:AddToggle({Name=L[language].WallNoClip, Default=false, Callback=function(v) wallNoClip=v end})

-- 設定タブ（画面下に表示）
local SettingsTab = Window:MakeTab({Name=L[language].Settings, Icon="", PremiumOnly=false})

-- 言語切替
SettingsTab:AddDropdown({Name=L[language].Language, Default="日本語", Options={"日本語","English"}, Callback=function(v)
    language = v=="日本語" and "JP" or "EN"
    OrionLib:Init() -- UIを更新
end})

-- UI色変更
SettingsTab:AddColorPicker({Name=L[language].UIColor, Default=Color3.fromRGB(255,255,255), Callback=function(c)
    Window:ChangeConfig({ThemeColor=c})
end})

-- 設定初期化
SettingsTab:AddButton({Name=L[language].Reset, Callback=function()
    -- 変数初期化
    flyEnabled=false; flying=false; walkEnabled=false; jumpEnabled=false; infiniteJump=false; wallNoClip=false
    flySpeed=50; walkSpeed=16; jumpPower=50
    humanoid.WalkSpeed=16; humanoid.JumpPower=50
    if bv then bv:Destroy() bv=nil end
    -- UIを初期化
    OrionLib:Init()
end})

OrionLib:Init()
if bv then
        bv:Destroy()
        bv = nil
    end
end

-- メインタブ
local MainTab = Window:MakeTab({Name = "Main", Icon = "", PremiumOnly = false})

-- Flyトグル
MainTab:AddToggle({
    Name = "Fly ON/OFF",
    Default = false,
    Callback = function(Value)
        if Value then
            startFly()
        else
            stopFly()
        end
    end
})

-- Fly速度スライダー
MainTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = speed,
    Color = Color3.fromRGB(0,255,0),
    Increment = 5,
    ValueName = "Speed",
    Callback = function(Value)
        speed = Value
    end
})

-- 閉じるボタン
MainTab:AddButton({
    Name = "Close UI",
    Callback = function()

        Window:Destroy()
        ScreenGui:Destroy()
    end
})

-- UI表示
OrionLib:Init()
