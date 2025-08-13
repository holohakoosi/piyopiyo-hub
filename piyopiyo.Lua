-- ボタン式飛行スクリプト（LocalScript）
-- StarterPlayerScripts または StarterGui に配置してください

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local flying = false
local flySpeed = 50

local bodyVelocity
local bodyAngularVelocity

-- GUI作成
local function createFlyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyGui"
    screenGui.Parent = playerGui
    
    -- メインフレーム
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 200, 0, 120)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = screenGui
    
    -- タイトル
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.BorderSizePixel = 0
    title.Text = "飛行コントロール"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    -- 飛行ボタン
    local flyButton = Instance.new("TextButton")
    flyButton.Name = "FlyButton"
    flyButton.Size = UDim2.new(0.8, 0, 0, 35)
    flyButton.Position = UDim2.new(0.1, 0, 0, 40)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    flyButton.BorderSizePixel = 1
    flyButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.Text = "飛行開始"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 14
    flyButton.Font = Enum.Font.SourceSansBold
    flyButton.Parent = frame
    
    -- 速度調整ラベル
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0.4, 0, 0, 25)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 85)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "速度: " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 12
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.Parent = frame
    
    -- 速度アップボタン
    local speedUpButton = Instance.new("TextButton")
    speedUpButton.Name = "SpeedUpButton"
    speedUpButton.Size = UDim2.new(0.2, 0, 0, 25)
    speedUpButton.Position = UDim2.new(0.5, 0, 0, 85)
    speedUpButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    speedUpButton.BorderSizePixel = 1
    speedUpButton.Text = "+"
    speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUpButton.TextSize = 14
    speedUpButton.Font = Enum.Font.SourceSansBold
    speedUpButton.Parent = frame
    
    -- 速度ダウンボタン
    local speedDownButton = Instance.new("TextButton")
    speedDownButton.Name = "SpeedDownButton"
    speedDownButton.Size = UDim2.new(0.2, 0, 0, 25)
    speedDownButton.Position = UDim2.new(0.75, 0, 0, 85)
    speedDownButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    speedDownButton.BorderSizePixel = 1
    speedDownButton.Text = "-"
    speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDownButton.TextSize = 14
    speedDownButton.Font = Enum.Font.SourceSansBold
    speedDownButton.Parent = frame
    
    return flyButton, speedLabel, speedUpButton, speedDownButton
end

-- 飛行開始関数
local function startFlying(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- BodyVelocityとBodyAngularVelocityを作成
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = humanoidRootPart
    
    flying = true
    print("飛行開始！")
end

-- 飛行停止関数
local function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    
    flying = false
    print("飛行停止！")
end

-- GUI作成とイベント接続
local flyButton, speedLabel, speedUpButton, speedDownButton = createFlyGui()

-- 飛行ボタンのクリックイベント
flyButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if flying then
            stopFlying()
            flyButton.Text = "飛行開始"
            flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            startFlying(character)
            flyButton.Text = "飛行停止"
            flyButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end
end)

-- 速度調整ボタンのイベント
speedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 10, 200)
    speedLabel.Text = "速度: " .. flySpeed
end)

speedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 10, 10)
    speedLabel.Text = "速度: " .. flySpeed
end)

-- 飛行中の移動処理
RunService.Heartbeat:Connect(function()
    if not flying or not bodyVelocity or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then
        return
    end
    
    local camera = workspace.CurrentCamera
    local moveVector = humanoid.MoveDirection
    
    -- カメラの向きを基準とした移動ベクトル
    local cameraCFrame = camera.CFrame
    local forwardVector = cameraCFrame.LookVector
    local rightVector = cameraCFrame.RightVector
    
    -- 移動方向を計算
    local flyDirection = (forwardVector * moveVector.Z + rightVector * moveVector.X)
    
    -- 上下移動の処理
    local upDown = 0
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        upDown = 1
    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        upDown = -1
    end
    
    -- 最終的な移動ベクトル
    local finalVelocity = flyDirection * flySpeed + Vector3.new(0, upDown * flySpeed, 0)
    bodyVelocity.Velocity = finalVelocity
    
    -- 回転を固定
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
end)

-- プレイヤーがリスポーンしたときの処理
player.CharacterAdded:Connect(function(character)
    if flying then
        flying = false
        bodyVelocity = nil
        bodyAngularVelocity = nil
        flyButton.Text = "飛行開始"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

print("ボタン式飛行スクリプトが読み込まれました！")
print("画面左上のボタンで飛行を開始/停止できます")
print("飛行中の操作:")
print("WASD: 前後左右移動")
print("スペース: 上昇")
print("左シフト: 下降")
