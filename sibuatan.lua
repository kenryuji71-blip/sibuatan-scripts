-- Teleport Gunung Sibuatan + GUI Multi-Tombol + Custom Save Lokasi
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Lokasi default
local locations = {
    ["Basecamp"] = Vector3.new(5000, 100, 2000),
    ["Pos Pendakian"] = Vector3.new(5200, 4000, 2100),
    ["Puncak Sibuatan"] = Vector3.new(5394, 8108, 2205)
}

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 240, 0, 260)
Frame.Position = UDim2.new(0.4, 0, 0.6, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Teleport Sibuatan"
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close/Show
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Text = "X"

-- Frame untuk tombol teleport
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = Frame
ButtonFrame.Size = UDim2.new(1, -10, 1, -90)
ButtonFrame.Position = UDim2.new(0, 5, 0, 45)
ButtonFrame.BackgroundTransparency = 1

-- Tombol Save Lokasi
local SaveBtn = Instance.new("TextButton")
SaveBtn.Parent = Frame
SaveBtn.Size = UDim2.new(1, -10, 0, 40)
SaveBtn.Position = UDim2.new(0, 5, 1, -45)
SaveBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.SourceSansBold
SaveBtn.TextSize = 18
SaveBtn.Text = "Save Lokasi Saya"

-- Function untuk membuat tombol teleport
local function createTeleportButton(name, pos)
    local btn = Instance.new("TextButton")
    btn.Parent = ButtonFrame
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = name

    -- klik untuk teleport
    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end

-- Isi tombol awal
for name, pos in pairs(locations) do
    createTeleportButton(name, pos)
end

-- Save lokasi custom
SaveBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        local name = "Custom-"..math.random(1000,9999)
        createTeleportButton(name, pos)
        print("Lokasi disimpan:", pos)
    end
end)

-- Fitur draggable frame
local UIS = game:GetService("UserInputService")
local dragging, dragInput, mousePos, framePos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < (Frame.AbsolutePosition.Y + 40) then
        dragging = true
        mousePos = input.Position
        framePos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        Frame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Close/Show fungsi
local hidden = false
CloseBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    ButtonFrame.Visible = not hidden
    SaveBtn.Visible = not hidden
    if hidden then
        CloseBtn.Text = "+"
        Frame.Size = UDim2.new(0, 240, 0, 40)
    else
        CloseBtn.Text = "X"
        Frame.Size = UDim2.new(0, 240, 0, 260)
    end
end)
