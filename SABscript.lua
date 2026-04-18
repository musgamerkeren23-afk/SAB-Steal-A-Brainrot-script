local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local VALID_KEY = "SAB_script_2026"

local C_BG = Color3.fromRGB(10, 0, 0)
local C_DARK = Color3.fromRGB(20, 0, 0)
local C_RED = Color3.fromRGB(180, 0, 0)
local C_BRIGHTRED = Color3.fromRGB(220, 0, 0)
local C_GREEN = Color3.fromRGB(0, 180, 0)
local C_YELLOW = Color3.fromRGB(255, 200, 0)
local C_WHITE = Color3.fromRGB(255, 255, 255)

local speedValue = 16
local jumpValue = 50
local infiniteJumpEnabled = false
local autoStealEnabled = false
local autoFarmEnabled = false
local tpActive = false
local selectedTarget = nil

-- ══════════════════════════════
--         NOTIF
-- ══════════════════════════════

local function showNotif(msg, color, duration)
    local existing = player.PlayerGui:FindFirstChild("NotifGui")
    if existing then existing:Destroy() end
    local ng = Instance.new("ScreenGui")
    ng.Name = "NotifGui"
    ng.ResetOnSpawn = false
    ng.Parent = player.PlayerGui
    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0, 380, 0, 54)
    nf.Position = UDim2.new(0.5, -190, 0, -70)
    nf.BackgroundColor3 = C_DARK
    nf.BorderSizePixel = 0
    nf.Parent = ng
    Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 8)
    local ns = Instance.new("UIStroke")
    ns.Color = color or C_RED
    ns.Thickness = 1
    ns.Parent = nf
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(1, -16, 1, 0)
    nl.Position = UDim2.new(0, 8, 0, 0)
    nl.BackgroundTransparency = 1
    nl.Text = msg
    nl.TextColor3 = color or C_BRIGHTRED
    nl.TextSize = 12
    nl.Font = Enum.Font.GothamBold
    nl.TextXAlignment = Enum.TextXAlignment.Left
    nl.TextWrapped = true
    nl.Parent = nf
    TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Position = UDim2.new(0.5, -190, 0, 16)
    }):Play()
    task.wait(duration or 3)
    TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Position = UDim2.new(0.5, -190, 0, -70)
    }):Play()
    task.wait(0.5)
    ng:Destroy()
end

-- ══════════════════════════════
--         KEY SYSTEM
-- ══════════════════════════════

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = player:WaitForChild("PlayerGui")

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 360, 0, 220)
keyFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
keyFrame.BackgroundColor3 = C_BG
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.Parent = keyGui
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 10)

local fs = Instance.new("UIStroke")
fs.Color = C_RED
fs.Thickness = 2
fs.Parent = keyFrame

local keyTitleBar = Instance.new("Frame")
keyTitleBar.Size = UDim2.new(1, 0, 0, 46)
keyTitleBar.BackgroundColor3 = C_DARK
keyTitleBar.BorderSizePixel = 0
keyTitleBar.Parent = keyFrame
Instance.new("UICorner", keyTitleBar).CornerRadius = UDim.new(0, 10)

local keyTitleIcon = Instance.new("TextLabel")
keyTitleIcon.Size = UDim2.new(0, 40, 1, 0)
keyTitleIcon.Position = UDim2.new(0, 8, 0, 0)
keyTitleIcon.BackgroundTransparency = 1
keyTitleIcon.Text = "💀"
keyTitleIcon.TextSize = 22
keyTitleIcon.Font = Enum.Font.GothamBold
keyTitleIcon.Parent = keyTitleBar

local keyTitleLabel = Instance.new("TextLabel")
keyTitleLabel.Size = UDim2.new(1, -60, 1, 0)
keyTitleLabel.Position = UDim2.new(0, 48, 0, 0)
keyTitleLabel.BackgroundTransparency = 1
keyTitleLabel.Text = "h4ll0 w0rld | SAB Key"
keyTitleLabel.TextColor3 = C_BRIGHTRED
keyTitleLabel.TextSize = 15
keyTitleLabel.Font = Enum.Font.GothamBold
keyTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
keyTitleLabel.Parent = keyTitleBar

coroutine.wrap(function()
    while keyTitleLabel and keyTitleLabel.Parent do
        keyTitleLabel.TextTransparency = 0.6
        task.wait(0.05)
        keyTitleLabel.TextTransparency = 0
        task.wait(math.random(3, 7))
    end
end)()

local keySep = Instance.new("Frame")
keySep.Size = UDim2.new(1, -20, 0, 1)
keySep.Position = UDim2.new(0, 10, 0, 50)
keySep.BackgroundColor3 = C_RED
keySep.BorderSizePixel = 0
keySep.Parent = keyFrame

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, -20, 0, 24)
subLabel.Position = UDim2.new(0, 10, 0, 58)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Enter your key to unlock SAB Hub"
subLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
subLabel.TextSize = 12
subLabel.Font = Enum.Font.Gotham
subLabel.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -20, 0, 40)
keyInput.Position = UDim2.new(0, 10, 0, 88)
keyInput.BackgroundColor3 = C_DARK
keyInput.Text = ""
keyInput.PlaceholderText = "Enter key here..."
keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyInput.TextColor3 = C_WHITE
keyInput.TextSize = 13
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyFrame
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = C_RED
inputStroke.Thickness = 1
inputStroke.Parent = keyInput

local keyStatusLabel = Instance.new("TextLabel")
keyStatusLabel.Size = UDim2.new(1, -20, 0, 20)
keyStatusLabel.Position = UDim2.new(0, 10, 0, 132)
keyStatusLabel.BackgroundTransparency = 1
keyStatusLabel.Text = ""
keyStatusLabel.TextColor3 = C_BRIGHTRED
keyStatusLabel.TextSize = 11
keyStatusLabel.Font = Enum.Font.Gotham
keyStatusLabel.Parent = keyFrame

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(1, -20, 0, 38)
verifyBtn.Position = UDim2.new(0, 10, 0, 158)
verifyBtn.BackgroundColor3 = C_RED
verifyBtn.Text = "🔑 Verify Key"
verifyBtn.TextColor3 = C_WHITE
verifyBtn.TextSize = 14
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.BorderSizePixel = 0
verifyBtn.Parent = keyFrame
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 6)

local function shakeFrame()
    local orig = keyFrame.Position
    for i = 1, 3 do
        TweenService:Create(keyFrame, TweenInfo.new(0.04), {
            Position = UDim2.new(orig.X.Scale, orig.X.Offset + 10, orig.Y.Scale, orig.Y.Offset)
        }):Play()
        task.wait(0.04)
        TweenService:Create(keyFrame, TweenInfo.new(0.04), {
            Position = UDim2.new(orig.X.Scale, orig.X.Offset - 10, orig.Y.Scale, orig.Y.Offset)
        }):Play()
        task.wait(0.04)
    end
    TweenService:Create(keyFrame, TweenInfo.new(0.05), {Position = orig}):Play()
end

-- ══════════════════════════════
--         MAIN HUB
-- ══════════════════════════════

local function loadMainHub()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SABHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
mainFrame.BackgroundColor3 = C_BG
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C_RED
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = C_DARK
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 40, 1, 0)
titleIcon.Position = UDim2.new(0, 10, 0, 0)
titleIcon.BackgroundTransparency = 1
titleIcon.Text = "💀"
titleIcon.TextSize = 24
titleIcon.Font = Enum.Font.GothamBold
titleIcon.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -110, 1, 0)
titleLabel.Position = UDim2.new(0, 52, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "h4ll0 w0rld | SAB Hub"
titleLabel.TextColor3 = C_BRIGHTRED
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

coroutine.wrap(function()
    while titleLabel and titleLabel.Parent do
        titleLabel.TextTransparency = 0.6
        task.wait(0.05)
        titleLabel.TextTransparency = 0
        task.wait(math.random(3, 7))
    end
end)()

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
minBtn.Text = "—"
minBtn.TextColor3 = C_WHITE
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -20, 0, 1)
sep.Position = UDim2.new(0, 10, 0, 54)
sep.BackgroundColor3 = C_RED
sep.BorderSizePixel = 0
sep.Parent = mainFrame

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 36)
tabBar.Position = UDim2.new(0, 10, 0, 62)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -115)
contentFrame.Position = UDim2.new(0, 10, 0, 108)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local function makeToggle(parent, text, order, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 46)
    row.BackgroundColor3 = C_DARK
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke")
    rs.Color = C_RED
    rs.Thickness = 1
    rs.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(0, 55, 0, 26)
    togBtn.Position = UDim2.new(1, -65, 0.5, -13)
    togBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    togBtn.Text = "OFF"
    togBtn.TextColor3 = C_BRIGHTRED
    togBtn.TextSize = 11
    togBtn.Font = Enum.Font.GothamBold
    togBtn.BorderSizePixel = 0
    togBtn.Parent = row
    Instance.new("UICorner", togBtn).CornerRadius = UDim.new(0, 6)
    local state = false
    togBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            togBtn.Text = "ON"
            togBtn.TextColor3 = C_GREEN
            TweenService:Create(togBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 60, 0)}):Play()
        else
            togBtn.Text = "OFF"
            togBtn.TextColor3 = C_BRIGHTRED
            TweenService:Create(togBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
        end
        callback(state)
    end)
end

local function makeSlider(parent, text, order, minVal, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 60)
    row.BackgroundColor3 = C_DARK
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke")
    rs.Color = C_RED
    rs.Thickness = 1
    rs.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.35, 0, 0, 20)
    valLbl.Position = UDim2.new(0.62, 0, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = C_BRIGHTRED
    valLbl.TextSize = 12
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = row
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = C_RED
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + (maxVal - minVal) * rel)
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
            valLbl.Text = tostring(val)
            callback(val)
        end
    end)
end

local function makePage(pageName)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C_RED
    page.Visible = false
    page.Parent = contentFrame
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    return page
end

local mainPage = makePage("Main")
local playerPage = makePage("Player")

makeToggle(mainPage, "🎒 Auto Steal + Auto Base", 1, function(state)
    autoStealEnabled = state
    coroutine.wrap(function()
        showNotif(state and "✅ Auto Steal ON!" or "❌ Auto Steal OFF!", state and C_GREEN or C_BRIGHTRED, 2)
    end)()
    while autoStealEnabled do
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not autoStealEnabled then break end
                    if obj.Name == "Brainrot" or obj.Name == "Pet" or obj:HasTag("Stealable") then
                        hrp.CFrame = CFrame.new(obj.Position)
                        task.wait(0.5)
                        local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("SpawnLocation")
                        if base then
                            hrp.CFrame = CFrame.new(base.Position + Vector3.new(0, 5, 0))
                        end
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

makeToggle(mainPage, "💰 Auto Farm Money", 2, function(state)
    autoFarmEnabled = state
    coroutine.wrap(function()
        showNotif(state and "✅ Auto Farm ON!" or "❌ Auto Farm OFF!", state and C_GREEN or C_BRIGHTRED, 2)
    end)()
    while autoFarmEnabled do
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not autoFarmEnabled then break end
                    if obj.Name == "Money" or obj.Name == "Coin" or obj.Name == "Cash" then
                        hrp.CFrame = CFrame.new(obj.Position)
                        task.wait(0.2)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

makeSlider(mainPage, "⚡ WalkSpeed", 3, 16, 150, speedValue, function(val)
    speedValue = val
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
end)

makeSlider(mainPage, "🔺 JumpPower", 4, 50, 300, jumpValue, function(val)
    jumpValue = val
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = val end
    end
end)

makeToggle(mainPage, "♾️ Infinite Jump", 5, function(state)
    infiniteJumpEnabled = state
    coroutine.wrap(function()
        showNotif(state and "✅ Infinite Jump ON!" or "❌ Infinite Jump OFF!", state and C_GREEN or C_BRIGHTRED, 2)
    end)()
end)

UserInputService.JumpRequest:Connect(function()
    if not infiniteJumpEnabled then return end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, 0, 0, 46)
tpBtn.BackgroundColor3 = C_DARK
tpBtn.Text = "🌀 TP Tool (Click part to TP)"
tpBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tpBtn.TextSize = 12
tpBtn.Font = Enum.Font.GothamBold
tpBtn.BorderSizePixel = 0
tpBtn.LayoutOrder = 6
tpBtn.Parent = mainPage
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)
local tpStroke = Instance.new("UIStroke")
tpStroke.Color = C_RED
tpStroke.Thickness = 1
tpStroke.Parent = tpBtn

tpBtn.MouseButton1Click:Connect(function()
    tpActive = not tpActive
    if tpActive then
        tpBtn.TextColor3 = C_GREEN
        tpBtn.Text = "🌀 TP Tool: ON (Click part)"
        TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 30, 0)}):Play()
        coroutine.wrap(function()
            showNotif("🌀 TP Tool ON! Klik part buat TP!", C_GREEN, 3)
        end)()
    else
        tpBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tpBtn.Text = "🌀 TP Tool (Click part to TP)"
        TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3 = C_DARK}):Play()
    end
end)

local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    if not tpActive then return end
    local target = mouse.Target
    if target and target:IsA("BasePart") then
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 5, 0))
                coroutine.wrap(function()
                    showNotif("🌀 TP ke " .. target.Name .. "!", C_GREEN, 2)
                end)()
            end
        end
    end
end)

player.CharacterAdded:Connect(function(newChar)
    local hum = newChar:WaitForChild("Humanoid")
    hum.WalkSpeed = speedValue
    hum.JumpPower = jumpValue
end)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, 0, 0, 36)
playerListFrame.BackgroundColor3 = C_DARK
playerListFrame.BorderSizePixel = 0
playerListFrame.LayoutOrder = 1
playerListFrame.Parent = playerPage
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 8)

local playerDropLabel = Instance.new("TextLabel")
playerDropLabel.Size = UDim2.new(1, -20, 1, 0)
playerDropLabel.Position = UDim2.new(0, 10, 0, 0)
playerDropLabel.BackgroundTransparency = 1
playerDropLabel.Text = "👤 Selected: None"
playerDropLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
playerDropLabel.TextSize = 12
playerDropLabel.Font = Enum.Font.Gotham
playerDropLabel.TextXAlignment = Enum.TextXAlignment.Left
playerDropLabel.Parent = playerListFrame

local function refreshPlayerList()
    for _, child in pairs(playerPage:GetChildren()) do
        if child:IsA("TextButton") and child.Name == "PlayerBtn" then
            child:Destroy()
        end
    end
    local order = 2
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton")
            pBtn.Name = "PlayerBtn"
            pBtn.Size = UDim2.new(1, 0, 0, 40)
            pBtn.BackgroundColor3 = C_DARK
            pBtn.Text = "👤 " .. p.Name
            pBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            pBtn.TextSize = 12
            pBtn.Font = Enum.Font.Gotham
            pBtn.BorderSizePixel = 0
            pBtn.LayoutOrder = order
            pBtn.Parent = playerPage
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 8)
            local pbs = Instance.new("UIStroke")
            pbs.Color = C_RED
            pbs.Thickness = 1
            pbs.Parent = pBtn
            pBtn.MouseButton1Click:Connect(function()
                selectedTarget = p
                playerDropLabel.Text = "👤 Selected: " .. p.Name
                for _, b in pairs(playerPage:GetChildren()) do
                    if b.Name == "PlayerBtn" then
                        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = C_DARK}):Play()
                        b.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
                TweenService:Create(pBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
                pBtn.TextColor3 = C_BRIGHTRED
                coroutine.wrap(function()
                    showNotif("👤 Selected: " .. p.Name, C_BRIGHTRED, 2)
                end)()
            end)
            order += 1
        end
    end
end

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, 0, 0, 36)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
refreshBtn.Text = "🔄 Refresh Players"
refreshBtn.TextColor3 = C_WHITE
refreshBtn.TextSize = 12
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0
refreshBtn.LayoutOrder = 50
refreshBtn.Parent = playerPage
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)
refreshBtn.MouseButton1Click:Connect(function()
    refreshPlayerList()
    coroutine.wrap(function()
        showNotif("🔄 Player list refreshed!", C_YELLOW, 2)
    end)()
end)

local slapBtn = Instance.new("TextButton")
slapBtn.Size = UDim2.new(1, 0, 0, 46)
slapBtn.BackgroundColor3 = C_DARK
slapBtn.Text = "👋 Slap Player"
slapBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
slapBtn.TextSize = 12
slapBtn.Font = Enum.Font.GothamBold
slapBtn.BorderSizePixel = 0
slapBtn.LayoutOrder = 51
slapBtn.Parent = playerPage
Instance.new("UICorner", slapBtn).CornerRadius = UDim.new(0, 8)
local slapStroke = Instance.new("UIStroke")
slapStroke.Color = C_RED
slapStroke.Thickness = 1
slapStroke.Parent = slapBtn

slapBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then
        coroutine.wrap(function()
            showNotif("⚠️ Pilih player dulu!", C_YELLOW, 2)
        end)()
        return
    end
    local targetChar = selectedTarget.Character
    if targetChar then
        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
        local myChar = player.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if targetHrp and myHrp then
            myHrp.CFrame = CFrame.new(targetHrp.Position + Vector3.new(2, 0, 0))
            task.wait(0.1)
            targetHrp.AssemblyLinearVelocity = Vector3.new(math.random(-80, 80), 60, math.random(-80, 80))
            coroutine.wrap(function()
                showNotif("👋 Slapped " .. selectedTarget.Name .. "!", C_BRIGHTRED, 2)
            end)()
        end
    end
end)

local tpPlayerBtn = Instance.new("TextButton")
tpPlayerBtn.Size = UDim2.new(1, 0, 0, 46)
tpPlayerBtn.BackgroundColor3 = C_DARK
tpPlayerBtn.Text = "🌀 TP to Player"
tpPlayerBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tpPlayerBtn.TextSize = 12
tpPlayerBtn.Font = Enum.Font.GothamBold
tpPlayerBtn.BorderSizePixel = 0
tpPlayerBtn.LayoutOrder = 52
tpPlayerBtn.Parent = playerPage
Instance.new("UICorner", tpPlayerBtn).CornerRadius = UDim.new(0, 8)
local tpPStroke = Instance.new("UIStroke")
tpPStroke.Color = C_RED
tpPStroke.Thickness = 1
tpPStroke.Parent = tpPlayerBtn

tpPlayerBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then
        coroutine.wrap(function()
            showNotif("⚠️ Pilih player dulu!", C_YELLOW, 2)
        end)()
        return
    end
    local targetChar = selectedTarget.Character
    local myChar = player.Character
    if targetChar and myChar then
        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if targetHrp and myHrp then
            myHrp.CFrame = CFrame.new(targetHrp.Position + Vector3.new(0, 3, 0))
            coroutine.wrap(function()
                showNotif("🌀 TP ke " .. selectedTarget.Name .. "!", C_GREEN, 2)
            end)()
        end
    end
end)

refreshPlayerList()

local pages = {["Main"] = mainPage, ["Player"] = playerPage}
local tabData = {
    {name = "⚙️ Main", page = "Main"},
    {name = "👤 Player", page = "Player"},
}
local activeTabBtn = nil

local function switchTab(pageName, btn)
    for _, p in pairs(pages) do p.Visible = false end
    pages[pageName].Visible = true
    if activeTabBtn then
        TweenService:Create(activeTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = C_DARK}):Play()
        activeTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C_RED}):Play()
    btn.TextColor3 = C_WHITE
    activeTabBtn = btn
end

for i, data in ipairs(tabData) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 195, 1, 0)
    tabBtn.BackgroundColor3 = C_DARK
    tabBtn.Text = data.name
    tabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.LayoutOrder = i
    tabBtn.Parent = tabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    local ts = Instance.new("UIStroke")
    ts.Color = C_RED
    ts.Thickness = 1
    ts.Parent = tabBtn
    tabBtn.MouseButton1Click:Connect(function() switchTab(data.page, tabBtn) end)
    if i == 1 then switchTab(data.page, tabBtn) end
end

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    minBtn.Text = minimized and "+" or "—"
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = minimized and UDim2.new(0, 420, 0, 50) or UDim2.new(0, 420, 0, 520)
    }):Play()
end)

print("💀 h4ll0 w0rld | SAB Hub loaded!")
end

-- ══════════════════════════════
--       KEY VERIFY
-- ══════════════════════════════

local function verifyKey(input)
    if input == VALID_KEY then
        keyStatusLabel.TextColor3 = C_GREEN
        keyStatusLabel.Text = "✅ Key verified! Loading hub..."
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(1)
        TweenService:Create(keyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.5)
        keyGui:Destroy()
        loadMainHub()
    else
        keyStatusLabel.TextColor3 = C_BRIGHTRED
        keyStatusLabel.Text = "❌ Wrong key! Try again."
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
        task.wait(0.2)
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = C_RED}):Play()
        shakeFrame()
    end
end

verifyBtn.MouseButton1Click:Connect(function() verifyKey(keyInput.Text) end)
keyInput.FocusLost:Connect(function(enter) if enter then verifyKey(keyInput.Text) end end)

print("💀 h4ll0 w0rld | SAB Key System loaded!")
