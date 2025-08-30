-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Mount Sibuatan",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By Satanico",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "MyScripts",
        FileName = "Satanicohub"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Variables
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Lokasi default
local locations = {
    ["Basecamp"]        = Vector3.new(987, 112, -698),
    ["Pos Pendakian"]   = Vector3.new(5200, 4000, 2100),
    ["Puncak Sibuatan"] = Vector3.new(5344, 8113, 2117),
    ["Checkpoint 19"]   = Vector3.new(1667, 4284, 5191),
}

-- Fungsi teleport
local function teleportTo(pos)
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
for name, pos in pairs(locations) do
    TeleportTab:CreateButton({
        Name = name,
        Callback = function()
            teleportTo(pos)
        end
    })
end

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- Fly V2 Anti-Deteksi
local flying = false
local flySpeed = 50
local flyVelocity, flyGyro

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {16, 300},
    Increment = 5,
    Suffix = "Studs/s",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(value)
        flySpeed = value
    end
})

PlayerTab:CreateToggle({
    Name = "Fly V2 (Anti-Deteksi)",
    CurrentValue = true,
    Flag = "FlyToggle",
    Callback = function(value)
        flying = value
        if flying then
            flyGyro = Instance.new("BodyGyro", hrp)
            flyGyro.P = 9e4
            flyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)

            flyVelocity = Instance.new("BodyVelocity", hrp)
            flyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
            flyVelocity.Velocity = Vector3.new(0,0,0)

            local function flyLoop()
                RunService.RenderStepped:Connect(function()
                    if not flying then
                        if flyGyro then flyGyro:Destroy() end
                        if flyVelocity then flyVelocity:Destroy() end
                        return
                    end
                    local camCF = workspace.CurrentCamera.CFrame
                    local moveDir = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit * flySpeed
                    end
                    flyVelocity.Velocity = moveDir
                    flyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
                end)
            end
            flyLoop()
        else
            if flyGyro then flyGyro:Destroy() end
            if flyVelocity then flyVelocity:Destroy() end
        end
    end
})

-- Fall Anti-Damage Toggle
local fallDamageDisabled = true
PlayerTab:CreateToggle({
    Name = "Fall Anti-Damage",
    CurrentValue = true,
    Flag = "FallToggle",
    Callback = function(value)
        fallDamageDisabled = value
        if fallDamageDisabled then
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        end
    end
})
