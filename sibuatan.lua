-- Teleport Gunung Sibuatan + GUI Minimalis
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Lokasi default
local locations = {
    ["Basecamp"]        = Vector3.new(987, 112, -698),
    ["Pos Pendakian"]   = Vector3.new(5200, 4000, 2100),
    ["Puncak Sibuatan"] = Vector3.new(5322, 8119, 2150)
}

-- GUI utama
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 230)
Frame.Position = UDim2.new(0.4, 0, 0.55, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -30, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Teleport Sibuatan"
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close/Show (minimalis)
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseBtn.BorderSizePixel = 0
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Text = "–"

-- Frame tombol teleport
local ButtonFrame = Instance.new("Frame", Frame)
ButtonFrame.Size = UDim2.new(1, -20, 1, -80)
ButtonFrame.Position = UDim2.new(0, 10, 0, 40)
ButtonFrame.BackgroundTransparency = 1

-- Tombol Save Lokasi
local SaveBtn = Instance.new("TextButton", Frame)
SaveBtn.Size = UDim2.new(1, -20, 0, 32)
SaveBtn.Position = UDim2.new(0, 10, 1, -40)
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SaveBtn.BorderSizePixel = 0
SaveBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
SaveBtn.Font = Enum.Font.Gotham
SaveBtn.TextSize = 16
SaveBtn.Text = "Save Lokasi Saya"

-- Function buat tombol teleport
local function createTeleportButton(name, pos)
    local btn = Instance.new("TextButton", ButtonFrame)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.Text = name

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
        local name = "Custom-" .. math.random(1000,9999)
        createTeleportButton(name, pos)
        print("Lokasi disimpan:", pos)
    end
end)

-- Fitur draggable frame
local UIS = game:GetService("UserInputService")
local dragging, dragInput, mousePos, framePos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    and input.Position.Y < (Frame.AbsolutePosition.Y + 35) then
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
