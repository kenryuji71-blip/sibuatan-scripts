-- Teleport Gunung Sibuatan + GUI Minimalis + Smooth Drag
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Lokasi default
local locations = {
    ["Basecamp"] = Vector3.new(987, 112, -698),
    ["Pos Pendakian"] = Vector3.new(5200, 4000, 2100),
    ["Puncak Sibuatan"] = Vector3.new(5394, 8108, 2205)
}

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 240)
Frame.Position = UDim2.new(0.35, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = false -- pakai script custom biar halus
Frame.ClipsDescendants = true
Frame.UICorner = Instance.new("UICorner", Frame)
Frame.UICorner.CornerRadius = UDim.new(0, 12)

-- Title bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, -30, 0, 35)
TitleBar.Position = UDim2.new(0, 10, 0, 0)
TitleBar.BackgroundTransparency = 1
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "Teleport Sibuatan"
TitleBar.TextSize = 18
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Text = "×"
CloseBtn.AutoButtonColor = true
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Frame untuk tombol teleport
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = Frame
ButtonFrame.Size = UDim2.new(1, -20, 1, -80)
ButtonFrame.Position = UDim2.new(0, 10, 0, 40)
ButtonFrame.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", ButtonFrame)
UIList.Padding = UDim.new(0, 6)

-- Tombol Save Lokasi
local SaveBtn = Instance.new("TextButton")
SaveBtn.Parent = Frame
SaveBtn.Size = UDim2.new(1, -20, 0, 35)
SaveBtn.Position = UDim2.new(0, 10, 1, -40)
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 16
SaveBtn.Text = "Save Lokasi Saya"
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)

-- Function buat tombol teleport
local function createTeleportButton(name, pos)
    local btn = Instance.new("TextButton")
    btn.Parent = ButtonFrame
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(40, 120, 220)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end

-- Isi tombol default
for name, pos in pairs(locations) do
    createTeleportButton(name, pos)
end

-- Save lokasi custom
SaveBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        local name = "Custom-"..math.random(1000,9999)
        createTeleportButton(name, pos)
    end
end)

-- Smooth Dragging
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Close / Open toggle
local hidden = false
CloseBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    ButtonFrame.Visible = not hidden
    SaveBtn.Visible = not hidden
    if hidden then
        Frame.Size = UDim2.new(0, 220, 0, 40)
        CloseBtn.Text = "+"
    else
        Frame.Size = UDim2.new(0, 220, 0, 240)
        CloseBtn.Text = "×"
    end
end)
