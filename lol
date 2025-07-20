local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === BASE COLORS ===
local bgColor = Color3.fromRGB(20, 20, 20)
local accentColor = Color3.fromRGB(45, 45, 45)
local primaryColor = Color3.fromRGB(100, 200, 255)
local successColor = Color3.fromRGB(0, 170, 130)
local warningColor = Color3.fromRGB(255, 60, 60)

local guiVisible = true

-- === FUNCTION: Fade GUI Text ===
local function fadeText(label, stopSignal)
    while not stopSignal.Value do
        for i = 0, 1, 0.05 do
            if stopSignal.Value then return end
            label.TextTransparency = i
            task.wait(0.05)
        end
        for i = 1, 0, -0.05 do
            if stopSignal.Value then return end
            label.TextTransparency = i
            task.wait(0.05)
        end
    end
end

-- === FUNCTION: Tracking Bar GUI ===
local function showTrackingBarUI()
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "TrackingBarGui"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 320, 0, 170)
    frame.Position = UDim2.new(0.5, -160, 0.5, -85)
    frame.BackgroundColor3 = bgColor
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Text = "Pet Spawner"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1

    local barBackground = Instance.new("Frame", frame)
    barBackground.Size = UDim2.new(0.85, 0, 0.2, 0)
    barBackground.Position = UDim2.new(0.075, 0, 0.4, 0)
    barBackground.BackgroundColor3 = accentColor
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 8)

    local barFill = Instance.new("Frame", barBackground)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = primaryColor
    barFill.BorderSizePixel = 0
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 8)

    local percentText = Instance.new("TextLabel", barBackground)
    percentText.Size = UDim2.new(1, 0, 1, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.Font = Enum.Font.GothamMedium
    percentText.TextScaled = true
    percentText.TextColor3 = Color3.new(1, 1, 1)

    local fadeLabel = Instance.new("TextLabel", frame)
    fadeLabel.Size = UDim2.new(1, -20, 0.2, 0)
    fadeLabel.Position = UDim2.new(0, 10, 0.75, 0)
    fadeLabel.BackgroundTransparency = 1
    fadeLabel.Text = "Make sure you have the pet you're trying to spawn."
    fadeLabel.Font = Enum.Font.Gotham
    fadeLabel.TextSize = 16
    fadeLabel.TextColor3 = Color3.new(1, 1, 1)

    local stopFade = Instance.new("BoolValue")
    stopFade.Value = false
    coroutine.wrap(function()
        fadeText(fadeLabel, stopFade)
    end)()

    local percent = 0

    local function updateBar()
        barFill:TweenSize(UDim2.new(percent / 100, 0, 1, 0), "Out", "Quad", 0.5, true)
        percentText.Text = percent .. "%"
    end

    task.spawn(function()
        while percent < 100 do
            task.wait(percent >= 80 and 15 or 10)
            percent = math.min(100, percent + 5)
            updateBar()
        end

        stopFade.Value = true
        fadeLabel:Destroy()

        local errorMsg = Instance.new("TextLabel", frame)
        errorMsg.Size = UDim2.new(1, -20, 0.35, 0)
        errorMsg.Position = UDim2.new(0, 10, 0.6, 0)
        errorMsg.BackgroundTransparency = 1
        errorMsg.TextWrapped = true
        errorMsg.Font = Enum.Font.GothamBold
        errorMsg.TextSize = 16
        errorMsg.TextColor3 = warningColor
        errorMsg.Text = "Error: It looks like you don't have a Divine pet or you didn't turn off your Anti-Scam setting. Please disable it and try again."
    end)
end

-- === FUNCTION: Pet Input UI ===
local function showPetInputUI()
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "PetInputGui"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 260, 0, 180)
    frame.Position = UDim2.new(0.5, -130, 0.5, -90)
    frame.BackgroundColor3 = bgColor
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Text = "Pet Spawner"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8, 0, 0.22, 0)
    input.Position = UDim2.new(0.1, 0, 0.35, 0)
    input.PlaceholderText = "Enter pet name..."
    input.Font = Enum.Font.Gotham
    input.TextScaled = true
    input.TextColor3 = Color3.new(1, 1, 1)
    input.BackgroundColor3 = accentColor
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

    local spawnBtn = Instance.new("TextButton", frame)
    spawnBtn.Size = UDim2.new(0.6, 0, 0.22, 0)
    spawnBtn.Position = UDim2.new(0.2, 0, 0.7, 0)
    spawnBtn.Text = "Spawn"
    spawnBtn.Font = Enum.Font.GothamSemibold
    spawnBtn.TextScaled = true
    spawnBtn.TextColor3 = Color3.new(1, 1, 1)
    spawnBtn.BackgroundColor3 = successColor
    Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 8)

    spawnBtn.MouseButton1Click:Connect(function()
        if input.Text ~= "" then
            gui:Destroy()
            showTrackingBarUI()
        end
    end)
end

-- === FUNCTION: Note Popup ===
local function showNotePopup()
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "PetNoteGui"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 320, 0, 200)
    frame.Position = UDim2.new(0.5, -160, 0.5, -100)
    frame.BackgroundColor3 = bgColor
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local note = Instance.new("TextLabel", frame)
    note.Size = UDim2.new(1, -20, 0.8, 0)
    note.Position = UDim2.new(0, 10, 0, 10)
    note.TextWrapped = true
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.Font = Enum.Font.Gotham
    note.TextSize = 16
    note.TextColor3 = Color3.new(1, 1, 1)
    note.BackgroundTransparency = 1
    note.Text = [[
Note: This only works with Divine pets for now.

You must have (at least 1) of these pets:
• Queen Bee       • T-Rex
• Dragonfly       • Fennec Fox
• Disco Bee       • Butterfly
• Mimic Octopus   • Spinosaurus
• Raccoon
    ]]

    local continue = Instance.new("TextButton", frame)
    continue.Size = UDim2.new(0.4, 0, 0.15, 0)
    continue.Position = UDim2.new(0.3, 0, 0.88, 0)
    continue.Text = "Continue"
    continue.Font = Enum.Font.GothamSemibold
    continue.TextSize = 16
    continue.TextColor3 = Color3.new(1, 1, 1)
    continue.BackgroundColor3 = primaryColor
    Instance.new("UICorner", continue).CornerRadius = UDim.new(0, 8)

    continue.MouseButton1Click:Connect(function()
        gui:Destroy()
        showPetInputUI()
    end)
end

-- === FUNCTION: Executor Notice GUI ===
local function showExecutorNotice()
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "ExecutorNoticeGui"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 340, 0, 180)
    frame.Position = UDim2.new(0.5, -170, 0.5, -90)
    frame.BackgroundColor3 = bgColor
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0.65, 0)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.TextWrapped = true
    label.Text = "This only works in KRNL for now. If you're using Delta Executor, make sure to turn off the Anti-Scam setting (Delta blocks this script as a scam because they don't want us to get rich). After disabling it, rejoin the game and execute the script again."
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1

    local proceed = Instance.new("TextButton", frame)
    proceed.Size = UDim2.new(0.4, 0, 0.2, 0)
    proceed.Position = UDim2.new(0.3, 0, 0.75, 0)
    proceed.Text = "Proceed"
    proceed.Font = Enum.Font.GothamSemibold
    proceed.TextSize = 16
    proceed.TextColor3 = Color3.new(1, 1, 1)
    proceed.BackgroundColor3 = primaryColor
    Instance.new("UICorner", proceed).CornerRadius = UDim.new(0, 8)

    proceed.MouseButton1Click:Connect(function()
        gui:Destroy()
        showNotePopup()
    end)
end

-- === START GUI ===
showExecutorNotice()

-- === TOGGLE KEYBIND ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name:match("Pet") then
                gui.Enabled = guiVisible
            end
        end
    end
end)
