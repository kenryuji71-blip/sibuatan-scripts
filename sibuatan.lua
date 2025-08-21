local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Lokasi default
local locations = {
    ["Basecamp"]        = Vector3.new(987, 112, -698),
    ["Pos Pendakian"]   = Vector3.new(5200, 4000, 2100),
    ["Puncak Sibuatan"] = Vector3.new(5344, 8113, 2117),
    ["Checkpoint 19"]   = Vector3.new(1667, 4284, 5191), -- lokasi baru
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 230)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "–"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local ButtonFrame = Instance.new("Frame", Frame)
ButtonFrame.Size = UDim2.new(1, -10, 1, -50)
ButtonFrame.Position = UDim2.new(0, 5, 0, 40)
ButtonFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ButtonFrame)
UIListLayout.Padding = UDim.new(0, 5)

local SaveBtn = Instance.new("TextButton", Frame)
SaveBtn.Size = UDim2.new(0, 200, 0, 30)
SaveBtn.Position = UDim2.new(0, 10, 1, -40)
SaveBtn.Text = "Save Lokasi"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi teleport
local function teleportTo(pos)
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(pos)
    end
end

-- Generate tombol teleport
for name, pos in pairs(locations) do
    local btn = Instance.new("TextButton", ButtonFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        teleportTo(pos)
    end)
end

-- Fungsi Close/Show
local hidden = false
CloseBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    ButtonFrame.Visible = not hidden
    SaveBtn.Visible = not hidden

    if hidden then
        CloseBtn.Text = "+"
        Frame.Size = UDim2.new(0, 220, 0, 35)
    else
        CloseBtn.Text = "–"
        Frame.Size = UDim2.new(0, 220, 0, 230)
    end
end)
