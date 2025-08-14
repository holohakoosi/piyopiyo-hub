local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

local flying = true
local speed = 50

game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local moveDir = char.Humanoid.MoveDirection
		local camDir = (cam.CFrame.LookVector * moveDir.Z) + (cam.CFrame.RightVector * moveDir.X)
		if camDir.Magnitude > 0 then
			hrp.Velocity = camDir.Unit * speed
			hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + camDir)
		else
			hrp.Velocity = Vector3.zero
		end
	end
end)
