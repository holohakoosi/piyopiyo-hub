-- シンプルFlyスクリプト（既存ジョイスティック対応）（LocalScript）
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
local function createSimpleFlyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimpleFlyGui"
    screenGui.Parent = playerGui
    
    -- メインフレーム
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 100)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 162, 255)
    mainFrame.Parent = screenGui
    
    -- コーナーを丸くする
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- タイトル
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.BorderSizePixel = 0
    title.Text = "Fly コントロール"
    title.TextColor3 = Color3.fromRGB(0, 162, 255)
    title.TextSize = 14
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = title
    
    -- Flyボタン
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(0, 80, 0, 30)
    flyButton.Position = UDim2.new(0, 15, 0, 35)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
    flyButton.BorderSizePixel = 0
    flyButton.Text = "Fly 開始"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 12
    flyButton.Font = Enum.Font.SourceSansBold
    flyButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = flyButton
    
    -- 速度ラベル
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 60, 0, 15)
    speedLabel.Position = UDim2.new(0, 110, 0, 35)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "速度: " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 11
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.Parent = mainFrame
    
    -- 速度スライダーのフレーム
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 120, 0, 8)
    sliderFrame.Position = UDim2.new(0, 110, 0, 55)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = mainFrame
    
    local sliderFrameCorner = Instance.new("UICorner")
    sliderFrameCorner.CornerRadius = UDim.new(0, 4)
    sliderFrameCorner.Parent = sliderFrame
    
    -- 速度スライダーのハンドル
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new(0, 40, 0, -4) -- 初期位置（速度50に対応）
    sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderFrame
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 8)
    handleCorner.Parent = sliderHandle
    
    -- 状態表示
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 15)
    statusLabel.Position = UDim2.new(0, 0, 0, 78)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "状態: 待機中 | ジョイスティックで移動"
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = mainFrame
    
    return flyButton, speedLabel, sliderFrame, sliderHandle, statusLabel
end

-- スライダー操作の設定
local function setupSpeedSlider(sliderFrame, sliderHandle, speedLabel)
    local isDragging = false
    local connection
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            
            connection = UserInputService.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    local framePosition = sliderFrame.AbsolutePosition.X
                    local frameSize = sliderFrame.AbsoluteSize.X
                    local inputX = input.Position.X
                    
                    -- ハンドルの位置を計算（0から1の範囲）
                    local relativeX = math.max(0, math.min(1, (inputX - framePosition) / frameSize))
                    
                    -- ハンドルの位置を更新
                    sliderHandle.Position = UDim2.new(relativeX, -8, 0, -4)
                    
                    -- 速度を計算（5から200の範囲）
                    flySpeed = math.floor(5 + relativeX * 195)
                    speedLabel.Text = "速度: " .. flySpeed
                end
            end)
        end
    end)
    
    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            if connection then
                connection:Disconnect()
            end
        end
    end)
    
    -- スライダーフレームをタップした時の処理
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local framePosition = sliderFrame.AbsolutePosition.X
            local frameSize = sliderFrame.AbsoluteSize.X
            local inputX = input.Position.X
            
            local relativeX = math.max(0, math.min(1, (inputX - framePosition) / frameSize))
            
            sliderHandle.Position = UDim2.new(relativeX, -8, 0, -4)
            flySpeed = math.floor(5 + relativeX * 195)
            speedLabel.Text = "速度: " .. flySpeed
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
    print("Fly開始！ジョイスティックで移動してください")
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
    print("Fly停止！")
end

-- GUI作成とイベント接続
local flyButton, speedLabel, sliderFrame, sliderHandle, statusLabel = createSimpleFlyGui()

-- スライダー設定
setupSpeedSlider(sliderFrame, sliderHandle, speedLabel)

-- Flyボタンのクリックイベント
flyButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if flying then
            stopFly()
            flyButton.Text = "Fly 開始"
            flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
            statusLabel.Text = "状態: 待機中 | ジョイスティックで移動"
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        else
            startFly(character)
            flyButton.Text = "Fly 停止"
            flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            statusLabel.Text = "状態: Fly中 | ジョイスティックで移動"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        end
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
    
    -- 移動方向を計算
    local flyDirection = (forwardVector * moveVector.Z + rightVector * moveVector.X)
    
    -- 上下移動の処理（スペースキーと左シフトキー）
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
        flyButton.Text = "Fly 開始"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
        statusLabel.Text = "状態: 待機中 | ジョイスティックで移動"
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

print("シンプルFlyスクリプトが読み込まれました！")
print("操作方法:")
print("1. Flyボタンで飛行開始/停止")
print("2. ジョイスティックで移動方向を制御")
print("3. スペースキーで上昇、左シフトで下降")
print("4. スライダーで速度調整（5-200）")
