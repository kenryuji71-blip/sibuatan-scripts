-- Teleport Gunung Sibuatan
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Ganti koordinat sesuai posisi Gunung Sibuatan di game
local targetPosition = Vector3.new(1200, 350, -450)

if char and char:FindFirstChild("HumanoidRootPart") then
    char.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
end
