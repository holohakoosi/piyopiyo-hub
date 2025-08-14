-- スマホ用シンプルFlyスクリプト（LocalScript）
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
local isMovingUp = false
local isMovingDown = false

-- GUI作成
local function createMobileFlyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileFlyGui"
    screenGui.Parent = playerGui
    
    -- メインフレーム
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 120)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- コーナーを丸くする
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- タイトル
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    title.BorderSizePixel = 0
    title.Text = "📱 モバイル Fly"
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    -- Flyボタン
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(0, 100, 0, 40)
    flyButton.Position = UDim2.new(0, 15, 0, 40)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    flyButton.BorderSizePixel = 0
    flyButton.Text = "✈️ Fly開始"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 14
    flyButton.Font = Enum.Font.SourceSansBold
    flyButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = flyButton
    
    -- 速度ラベル
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 80, 0, 20)
    speedLabel.Position = UDim2.new(0, 130, 0, 40)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "⚡ 速度: " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 12
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.Parent = mainFrame
    
    -- 速度スライダーのフレーム
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 140, 0, 10)
    sliderFrame.Position = UDim2.new(0, 130, 0, 65)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = mainFrame
    
    local sliderFrameCorner = Instance.new("UICorner")
    sliderFrameCorner.CornerRadius = UDim.new(0, 5)
    sliderFrameCorner.Parent = sliderFrame
    
    -- 速度スライダーのハンドル
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 20, 0, 20)
    sliderHandle.Position = UDim2.new(0, 45, 0, -5) -- 初期位置（速度50に対応）
    sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderFrame
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 10)
    handleCorner.Parent = sliderHandle
    
    -- 状態表示
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 18)
    statusLabel.Position = UDim2.new(0, 0, 0, 95)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "📍 状態: 待機中 | ジョイスティックで移動"
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = mainFrame
    
    -- 上昇・下降ボタンフレーム（右側）
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(0, 70, 0, 100)
    controlFrame.Position = UDim2.new(1, -80, 1, -110)
    controlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = screenGui
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 12)
    controlCorner.Parent = controlFrame
    
    -- 上昇ボタン
    local upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 60, 0, 40)
    upButton.Position = UDim2.new(0, 5, 0, 5)
    upButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    upButton.BorderSizePixel = 0
    upButton.Text = "⬆️"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 18
    upButton.Font = Enum.Font.SourceSansBold
    upButton.Parent = controlFrame
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upButton
    
    -- 下降ボタン
    local downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 60, 0, 40)
    downButton.Position = UDim2.new(0, 5, 0, 55)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    downButton.BorderSizePixel = 0
    downButton.Text = "⬇️"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 18
    downButton.Font = Enum.Font.SourceSansBold
    downButton.Parent = controlFrame
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downButton
    
    return flyButton, speedLabel, sliderFrame, sliderHandle, statusLabel, upButton, downButton
end

-- スライダー操作の設定
local function setupSpeedSlider(sliderFrame, sliderHandle, speedLabel)
    local isDragging = false
    local connection
    
    -- ハンドルのタッチ操作
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            
            connection = UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.Touch then
                    local framePosition = sliderFrame.AbsolutePosition.X
                    local frameSize = sliderFrame.AbsoluteSize.X
                    local inputX = input.Position.X
                    
                    -- ハンドルの位置を計算（0から1の範囲）
                    local relativeX = math.max(0, math.min(1, (inputX - framePosition) / frameSize))
                    
                    -- ハンドルの位置を更新
                    sliderHandle.Position = UDim2.new(relativeX, -10, 0, -5)
                    
                    -- 速度を計算（5から200の範囲）
                    flySpeed = math.floor(5 + relativeX * 195)
                    speedLabel.Text = "⚡ 速度: " .. flySpeed
                end
            end)
        end
    end)
    
    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            if connection then
                connection:Disconnect()
            end
        end
    end)
    
    -- スライダーフレームをタップした時の処理
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and not isDragging then
            local framePosition = sliderFrame.AbsolutePosition.X
            local frameSize = sliderFrame.AbsoluteSize.X
            local inputX = input.Position.X
            
            local relativeX = math.max(0, math.min(1, (inputX - framePosition) / frameSize))
            
            sliderHandle.Position = UDim2.new(relativeX, -10, 0, -5)
            flySpeed = math.floor(5 + relativeX * 195)
            speedLabel.Text = "⚡ 速度: " .. flySpeed
        end
    end)
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
    print("📱 モバイルFly開始！")
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
    isMovingUp = false
    isMovingDown = false
    print("📱 モバイルFly停止！")
end

-- GUI作成とイベント接続
local flyButton, speedLabel, sliderFrame, sliderHandle, statusLabel, upButton, downButton = createMobileFlyGui()

-- スライダー設定
setupSpeedSlider(sliderFrame, sliderHandle, speedLabel)

-- Flyボタンのタッチイベント
flyButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            if flying then
                stopFly()
                flyButton.Text = "✈️ Fly開始"
                flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                statusLabel.Text = "📍 状態: 待機中 | ジョイスティックで移動"
                statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            else
                startFly(character)
                flyButton.Text = "🛑 Fly停止"
                flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                statusLabel.Text = "📍 状態: Fly中 | ジョイスティックで移動"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            end
        end
    end
end)

-- 上昇ボタン
upButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isMovingUp = true
        upButton.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    end
end)

upButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isMovingUp = false
        upButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end
end)

-- 下降ボタン
downButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isMovingDown = true
        downButton.BackgroundColor3 = Color3.fromRGB(240, 0, 0)
    end
end)

downButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isMovingDown = false
        downButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- Fly中の移動処理
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
    
    -- 移動方向を計算（既存のジョイスティック使用）
    local flyDirection = (forwardVector * moveVector.Z + rightVector * moveVector.X)
    
    -- 上下移動の処理（タッチボタン）
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
        flyButton.Text = "✈️ Fly開始"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        statusLabel.Text = "📍 状態: 待機中 | ジョイスティックで移動"
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        isMovingUp = false
        isMovingDown = false
    end
end)

print("📱 スマホ用Flyスクリプトが読み込まれました！")
print("操作方法:")
print("1. Flyボタンをタッチで飛行開始/停止")
print("2. ジョイスティックで移動方向を制御")
print("3. ⬆️⬇️ボタンをタッチで上昇・下降")
print("4. スライダーをタッチで速度調整")
print("3. スペースキーで上昇、左シフトで下降")
print("4. スライダーで速度調整（5-200）")
