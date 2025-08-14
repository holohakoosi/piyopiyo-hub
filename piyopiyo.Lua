-- モバイル用Flyスクリプト（向いた方向に飛ぶ）（LocalScript）
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

-- タッチ操作用の変数
local isMovingForward = false
local isMovingBackward = false
local isMovingUp = false
local isMovingDown = false

-- GUI作成
local function createMobileFlyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileFlyGui"
    screenGui.Parent = playerGui
    
    -- メインコントロールフレーム
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(0, 200, 0, 140)
    controlFrame.Position = UDim2.new(0, 10, 0, 10)
    controlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    controlFrame.BorderSizePixel = 2
    controlFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    controlFrame.Parent = screenGui
    
    -- タイトル
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.BorderSizePixel = 0
    title.Text = "モバイル Fly"
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.TextSize = 14
    title.Font = Enum.Font.SourceSansBold
    title.Parent = controlFrame
    
    -- Flyボタン
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(0.8, 0, 0, 30)
    flyButton.Position = UDim2.new(0.1, 0, 0, 30)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    flyButton.BorderSizePixel = 1
    flyButton.BorderColor3 = Color3.fromRGB(0, 150, 255)
    flyButton.Text = "Fly 開始"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 12
    flyButton.Font = Enum.Font.SourceSansBold
    flyButton.Parent = controlFrame
    
    -- 速度調整
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.4, 0, 0, 20)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 70)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "速度: " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 10
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.Parent = controlFrame
    
    local speedUpButton = Instance.new("TextButton")
    speedUpButton.Size = UDim2.new(0.2, 0, 0, 20)
    speedUpButton.Position = UDim2.new(0.5, 0, 0, 70)
    speedUpButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    speedUpButton.BorderSizePixel = 1
    speedUpButton.Text = "+"
    speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUpButton.TextSize = 12
    speedUpButton.Font = Enum.Font.SourceSansBold
    speedUpButton.Parent = controlFrame
    
    local speedDownButton = Instance.new("TextButton")
    speedDownButton.Size = UDim2.new(0.2, 0, 0, 20)
    speedDownButton.Position = UDim2.new(0.75, 0, 0, 70)
    speedDownButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    speedDownButton.BorderSizePixel = 1
    speedDownButton.Text = "-"
    speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDownButton.TextSize = 12
    speedDownButton.Font = Enum.Font.SourceSansBold
    speedDownButton.Parent = controlFrame
    
    -- 上昇ボタン
    local upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0.35, 0, 0, 25)
    upButton.Position = UDim2.new(0.05, 0, 0, 100)
    upButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    upButton.BorderSizePixel = 1
    upButton.Text = "上昇"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 11
    upButton.Font = Enum.Font.SourceSansBold
    upButton.Parent = controlFrame
    
    -- 下降ボタン
    local downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0.35, 0, 0, 25)
    downButton.Position = UDim2.new(0.6, 0, 0, 100)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    downButton.BorderSizePixel = 1
    downButton.Text = "下降"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 11
    downButton.Font = Enum.Font.SourceSansBold
    downButton.Parent = controlFrame
    
    -- 移動コントロールフレーム（右下）
    local moveFrame = Instance.new("Frame")
    moveFrame.Name = "MoveFrame"
    moveFrame.Size = UDim2.new(0, 120, 0, 120)
    moveFrame.Position = UDim2.new(1, -130, 1, -130)
    moveFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    moveFrame.BorderSizePixel = 2
    moveFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    moveFrame.Parent = screenGui
    
    -- 前進ボタン
    local forwardButton = Instance.new("TextButton")
    forwardButton.Size = UDim2.new(0, 80, 0, 35)
    forwardButton.Position = UDim2.new(0, 20, 0, 10)
    forwardButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    forwardButton.BorderSizePixel = 1
    forwardButton.Text = "前進"
    forwardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    forwardButton.TextSize = 12
    forwardButton.Font = Enum.Font.SourceSansBold
    forwardButton.Parent = moveFrame
    
    -- 後退ボタン
    local backwardButton = Instance.new("TextButton")
    backwardButton.Size = UDim2.new(0, 80, 0, 35)
    backwardButton.Position = UDim2.new(0, 20, 0, 75)
    backwardButton.BackgroundColor3 = Color3.fromRGB(0, 100, 160)
    backwardButton.BorderSizePixel = 1
    backwardButton.Text = "後退"
    backwardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    backwardButton.TextSize = 12
    backwardButton.Font = Enum.Font.SourceSansBold
    backwardButton.Parent = moveFrame
    
    -- ラベル
    local moveLabel = Instance.new("TextLabel")
    moveLabel.Size = UDim2.new(1, 0, 0, 20)
    moveLabel.Position = UDim2.new(0, 0, 0, 50)
    moveLabel.BackgroundTransparency = 1
    moveLabel.Text = "カメラ方向"
    moveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    moveLabel.TextSize = 10
    moveLabel.Font = Enum.Font.SourceSans
    moveLabel.Parent = moveFrame
    
    return flyButton, speedLabel, speedUpButton, speedDownButton, upButton, downButton, forwardButton, backwardButton
end

-- Fly開始関数
local function startFly(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = humanoidRootPart
    
    flying = true
    print("Fly開始！カメラが向いている方向に飛びます")
end

-- Fly停止関数
local function stopFly()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    
    flying = false
    isMovingForward = false
    isMovingBackward = false
    isMovingUp = false
    isMovingDown = false
    print("Fly停止！")
end

-- GUI作成とイベント接続
local flyButton, speedLabel, speedUpButton, speedDownButton, upButton, downButton, forwardButton, backwardButton = createMobileFlyGui()

-- Flyボタンのクリックイベント
flyButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if flying then
            stopFly()
            flyButton.Text = "Fly 開始"
            flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        else
            startFly(character)
            flyButton.Text = "Fly 停止"
            flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    end
end)

-- 速度調整ボタン
speedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 10, 200)
    speedLabel.Text = "速度: " .. flySpeed
end)

speedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 5, 5)
    speedLabel.Text = "速度: " .. flySpeed
end)

-- 前進ボタン
forwardButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingForward = true
    end
end)

forwardButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingForward = false
    end
end)

-- 後退ボタン
backwardButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingBackward = true
    end
end)

backwardButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingBackward = false
    end
end)

-- 上昇ボタン
upButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingUp = true
    end
end)

upButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingUp = false
    end
end)

-- 下降ボタン
downButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingDown = true
    end
end)

downButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMovingDown = false
    end
end)

-- Fly中の移動処理
RunService.Heartbeat:Connect(function()
    if not flying or not bodyVelocity or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then
        return
    end
    
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local forwardVector = cameraCFrame.LookVector
    
    -- 移動方向を計算（カメラの向きに基づく）
    local flyDirection = Vector3.new(0, 0, 0)
    
    if isMovingForward then
        flyDirection = flyDirection + forwardVector
    end
    if isMovingBackward then
        flyDirection = flyDirection - forwardVector
    end
    
    -- 上下移動
    local upDown = 0
    if isMovingUp then
        upDown = 1
    elseif isMovingDown then
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
        flyButton.Text = "Fly 開始"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        isMovingForward = false
        isMovingBackward = false
        isMovingUp = false
        isMovingDown = false
    end
end)

print("モバイルFly（カメラ方向）スクリプトが読み込まれました！")
print("操作方法:")
print("1. 左上のボタンでFlyを開始/停止")
print("2. カメラを向けたい方向に回転")
print("3. 前進/後退ボタンでカメラ方向に移動")
print("4. 上昇/下降ボタンで高度調整")
print("5. +/-ボタンで速度調整")
