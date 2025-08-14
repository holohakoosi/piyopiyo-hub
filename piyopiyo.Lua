-- Orion UI読み込み
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- ウィンドウ作成
local Window = OrionLib:MakeWindow({Name = "ぴよぴよ ハブ", HidePremium = false, IntroText = "by najayou777", SaveConfig = false})

-- プレイヤー設定
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local flying = false
local speed = 50
local bv

-- 仮想ジョイスティックを作る（ScreenGui + Frame + Input）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local joystickBase = Instance.new("Frame")
joystickBase.Size = UDim2.new(0,150,0,150)
joystickBase.Position = UDim2.new(0,50,1,-200)
joystickBase.BackgroundTransparency = 0.5
joystickBase.Parent = ScreenGui

local joystickKnob = Instance.new("Frame")
joystickKnob.Size = UDim2.new(0,50,0,50)
joystickKnob.Position = UDim2.new(0.5,-25,0.5,-25)
joystickKnob.BackgroundColor3 = Color3.fromRGB(0,255,0)
joystickKnob.AnchorPoint = Vector2.new(0.5,0.5)
joystickKnob.Parent = joystickBase

-- 入力管理
local moveVector = Vector3.zero
local dragging = false

joystickKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

joystickKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        joystickKnob.Position = UDim2.new(0.5,-25,0.5,-25)
        moveVector = Vector3.zero
    end
end)

joystickKnob.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                joystickKnob.Position = UDim2.new(0.5,-25,0.5,-25)
                moveVector = Vector3.zero
            end
        end)
    end
end)

local UserInputService = game:GetService("UserInputService")

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - joystickBase.AbsolutePosition - Vector2.new(75,75)
        local radius = math.clamp(delta.Magnitude,0,50)
        local direction = delta.Unit * radius
        joystickKnob.Position = UDim2.new(0,75+direction.X-25,0,75+direction.Y-25)
        moveVector = Vector3.new(direction.X,0,direction.Y).Unit
    end
end)

-- Fly開始
local function startFly()
    flying = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    task.spawn(function()
        while flying do
            local cam = workspace.CurrentCamera
            -- カメラ方向に合わせた移動
            local camForward = Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit
            local camRight = Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z).Unit
            local dir = (camForward * moveVector.Z + camRight * moveVector.X)
            if dir.Magnitude > 0 then
                bv.Velocity = dir.Unit * speed
            else
                bv.Velocity = Vector3.zero
            end
            task.wait()
        end
    end)
end

-- Fly停止
local function stopFly()
    flying = false
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
