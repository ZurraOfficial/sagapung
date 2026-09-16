--[[
    Hallwayz Fly + ESP + Combat + Zone Teleport
    Load: loadstring(game:HttpGet("https://raw.githubusercontent.com/ZurraOfficial/Fly/main/main.lua"))()
    Fly engine: Infinite Yield (EdgeIY)
]]

print("[Hallwayz] Script started...")

local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera or workspace:WaitForChild("Camera", 5)

local CONFIG = {
    Name = "Hallwayz",
    Subtitle = "BY MAVERICK",
    Version = "v2.0.0",
    KeysURL = "https://raw.githubusercontent.com/ZurraOfficial/Fly/main/keys.txt",
}

local Theme = {
    BG          = Color3.fromRGB(11, 11, 16),
    Sidebar     = Color3.fromRGB(15, 15, 22),
    Card        = Color3.fromRGB(20, 20, 30),
    CardHover   = Color3.fromRGB(26, 26, 38),
    Border      = Color3.fromRGB(30, 30, 44),
    BorderHover = Color3.fromRGB(48, 48, 66),
    Text        = Color3.fromRGB(232, 232, 240),
    TextMuted   = Color3.fromRGB(105, 105, 128),
    Accent      = Color3.fromRGB(107, 127, 255),
    AccentDark  = Color3.fromRGB(75, 95, 220),
    AccentGlow  = Color3.fromRGB(140, 155, 255),
    Success     = Color3.fromRGB(74, 222, 128),
    Error       = Color3.fromRGB(248, 113, 113),
    Warning     = Color3.fromRGB(250, 204, 21),
    Divider     = Color3.fromRGB(26, 26, 38),
}

pcall(function()
    for _, obj in pairs(CoreGui:GetChildren()) do
        if obj.Name == "HallwayzUI" then obj:Destroy() end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HallwayzUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

local okCore = pcall(function() ScreenGui.Parent = CoreGui end)
if not okCore or not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function corner(r, p) return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p }) end
local function stroke(c, t, p) return new("UIStroke", { Color = c, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p }) end
local function tween(o, t, p)
    local tw = TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p)
    tw:Play(); return tw
end

local IconLib = {}

function IconLib.Close(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    new("Frame", { Size = UDim2.new(0,12,0,2), Position = UDim2.new(0,1,0,6), BackgroundColor3 = color, BorderSizePixel = 0, Rotation = 45, Parent = h })
    new("Frame", { Size = UDim2.new(0,12,0,2), Position = UDim2.new(0,1,0,6), BackgroundColor3 = color, BorderSizePixel = 0, Rotation = -45, Parent = h })
    return h
end

function IconLib.Minimize(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    new("Frame", { Size = UDim2.new(0,12,0,2), Position = UDim2.new(0,1,0,7), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    return h
end

function IconLib.Key(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    local head = new("Frame", { Size = UDim2.new(0,8,0,8), Position = UDim2.new(0,1,0,4), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    corner(100, head)
    local hole = new("Frame", { Size = UDim2.new(0,3,0,3), Position = UDim2.new(0.5,-1.5,0.5,-1.5), BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = head })
    corner(100, hole)
    new("Frame", { Size = UDim2.new(0,9,0,2), Position = UDim2.new(0,8,0,8), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,2,0,3), Position = UDim2.new(0,12,0,8), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,2,0,3), Position = UDim2.new(0,15,0,8), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    return h
end

function IconLib.Wing(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    new("Frame", { Size = UDim2.new(0,14,0,3), Position = UDim2.new(0,1,0,4), BackgroundColor3 = color, BorderSizePixel = 0, Rotation = -20, Parent = h })
    new("Frame", { Size = UDim2.new(0,12,0,3), Position = UDim2.new(0,1,0,8), BackgroundColor3 = color, BorderSizePixel = 0, Rotation = -10, Parent = h })
    new("Frame", { Size = UDim2.new(0,9,0,3), Position = UDim2.new(0,1,0,12), BackgroundColor3 = color, BorderSizePixel = 0, Rotation = 5, Parent = h })
    return h
end

function IconLib.Speed(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    new("Frame", { Size = UDim2.new(0,14,0,2), Position = UDim2.new(0,1,0,4), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,10,0,2), Position = UDim2.new(0,1,0,8), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,14,0,2), Position = UDim2.new(0,1,0,12), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    return h
end

function IconLib.Info(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    local outer = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    corner(100, outer)
    local inner = new("Frame", { Size = UDim2.new(1,-4,1,-4), Position = UDim2.new(0,2,0,2), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = h })
    corner(100, inner)
    new("Frame", { Size = UDim2.new(0,2,0,2), Position = UDim2.new(0.5,-1,0,3), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,2,0,6), Position = UDim2.new(0.5,-1,0,7), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    return h
end

function IconLib.Eye(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    local outer = new("Frame", { Size = UDim2.new(1,0,0.7,0), Position = UDim2.new(0,0,0.15,0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    corner(100, outer)
    local inner = new("Frame", { Size = UDim2.new(1,-4,0.7,-4), Position = UDim2.new(0,2,0.15,2), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = h })
    corner(100, inner)
    local pupil = new("Frame", { Size = UDim2.new(0,6,0,6), Position = UDim2.new(0.5,-3,0.5,-3), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    corner(100, pupil)
    return h
end

function IconLib.Crosshair(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    new("Frame", { Size = UDim2.new(0,2,0,6), Position = UDim2.new(0.5,-1,0,0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,2,0,6), Position = UDim2.new(0.5,-1,1,-6), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,6,0,2), Position = UDim2.new(0,0,0.5,-1), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    new("Frame", { Size = UDim2.new(0,6,0,2), Position = UDim2.new(1,-6,0.5,-1), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    return h
end

function IconLib.Pin(parent, color)
    local h = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = parent })
    local top = new("Frame", { Size = UDim2.new(0,10,0,10), Position = UDim2.new(0.5,-5,0,1), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    corner(100, top)
    local inner = new("Frame", { Size = UDim2.new(0,4,0,4), Position = UDim2.new(0.5,-2,0,4), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = top })
    corner(100, inner)
    new("Frame", { Size = UDim2.new(0,2,0,8), Position = UDim2.new(0.5,-1,0,10), BackgroundColor3 = color, BorderSizePixel = 0, Parent = h })
    return h
end

local function buildLogo(parent, size)
    size = size or 30
    local h = new("Frame", { Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1, Parent = parent })
    local sk = size / 32
    new("Frame", { Size = UDim2.new(0, 8*sk, 0, 13*sk), Position = UDim2.new(0, 6*sk, 0, 3*sk), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Rotation = 20, Parent = h })
    new("Frame", { Size = UDim2.new(0, 8*sk, 0, 13*sk), Position = UDim2.new(0, 6*sk, 0, 16*sk), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Rotation = 20, Parent = h })
    new("Frame", { Size = UDim2.new(0, 9*sk, 0, 26*sk), Position = UDim2.new(0, 17*sk, 0, 3*sk), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Rotation = 20, Parent = h })
    new("Frame", { Size = UDim2.new(0, 11*sk, 0, 2*sk), Position = UDim2.new(0, 7*sk, 0, 15*sk), BackgroundColor3 = Theme.AccentGlow, BorderSizePixel = 0, Rotation = -25, Parent = h })
    return h
end

-- ============================================================
-- FLY ENGINE (Infinite Yield — unchanged)
-- ============================================================
FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1

function sFLY(vfly)
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    local T = humanoid.RootPart
    local CONTROL = {F=0, B=0, L=0, R=0, Q=0, E=0}
    local lCONTROL = {F=0, B=0, L=0, R=0, Q=0, E=0}
    local SPEED = 0
    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera
                if not vfly and humanoid then humanoid.PlatformStand = true end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = camera.CFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if humanoid then humanoid.PlatformStand = false end
        end)
    end
    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -(vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -(vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() Camera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0
        end
    end)
    FLY()
end

function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function doFly()
    if not isMobile then
        NOFLY()
        task.wait(0.05)
        sFLY()
    end
end

local function doUnfly()
    if not isMobile then NOFLY() end
end

-- ============================================================
-- KEY VALIDATION
-- ============================================================
local function fetchValidKeys()
    if not CONFIG.KeysURL or CONFIG.KeysURL == "" then return {} end
    local ok, result = pcall(game.HttpGet, game, CONFIG.KeysURL, true)
    if not ok or not result then return {} end
    local keys = {}
    for line in result:gmatch("[^\r\n]+") do
        line = line:gsub("%s+", "")
        if line ~= "" and not line:match("^#") then keys[line:lower()] = true end
    end
    return keys
end

local function validateKey(inputKey)
    if not inputKey or inputKey == "" then return false, "Key tidak boleh kosong" end
    local vk = fetchValidKeys()
    if vk[inputKey:lower()] then return true, "Key valid" end
    return false, "Key tidak valid"
end

-- ============================================================
-- UNIVERSAL ESP + RAINBOW LINES + AIMBOT + ZONE DETECT
-- ============================================================
local HasDrawing = pcall(function() local l = Drawing.new("Line") l:Remove() end)

local ESPSys = {
    enabled = false,
    lines = false,
    boxes = true,
    names = true,
    distance = true,
    tracking = {},
    lineObjects = {},
    hue = 0,
}

local function cleanupESP()
    for _, data in pairs(ESPSys.tracking) do
        if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
        if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
    end
    ESPSys.tracking = {}
    for _, line in pairs(ESPSys.lineObjects) do
        pcall(function() line.Visible = false line:Remove() end)
    end
    ESPSys.lineObjects = {}
end

local function addPlayerESP(plr)
    if plr == LocalPlayer then return end
    if ESPSys.tracking[plr] then return end
    if not plr.Character then return end

    local function setup(char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not head then return end

        local bb = new("BillboardGui", {
            Adornee = head,
            Size = UDim2.new(0, 200, 0, 70),
            StudsOffset = Vector3.new(0, 3, 0),
            AlwaysOnTop = true,
            Parent = ScreenGui,
        })

        local nameLbl = new("TextLabel", {
            Size = UDim2.new(1, 0, 0.4, 0),
            BackgroundTransparency = 1,
            Text = plr.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextStrokeTransparency = 0,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            Parent = bb,
        })

        local distLbl = new("TextLabel", {
            Size = UDim2.new(1, 0, 0.3, 0),
            Position = UDim2.new(0, 0, 0.4, 0),
            BackgroundTransparency = 1,
            Text = "0 studs",
            TextColor3 = Color3.fromRGB(90, 180, 255),
            TextStrokeTransparency = 0,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Parent = bb,
        })

        local healthLbl = new("TextLabel", {
            Size = UDim2.new(1, 0, 0.3, 0),
            Position = UDim2.new(0, 0, 0.7, 0),
            BackgroundTransparency = 1,
            Text = "HP: 100",
            TextColor3 = Color3.fromRGB(120, 230, 120),
            TextStrokeTransparency = 0,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            Parent = bb,
        })

        local hl = new("Highlight", {
            Adornee = char,
            FillColor = Color3.fromRGB(107, 127, 255),
            FillTransparency = 0.7,
            OutlineColor = Color3.fromRGB(255, 255, 255),
            OutlineTransparency = 0.2,
            Parent = ScreenGui,
        })

        local lineObj = nil
        if HasDrawing and Drawing then
            local ok, l = pcall(function()
                local line = Drawing.new("Line")
                line.Thickness = 2
                line.Transparency = 1
                line.Visible = false
                return line
            end)
            if ok then lineObj = l end
        end

        ESPSys.tracking[plr] = {
            billboard = bb,
            nameLbl = nameLbl,
            distLbl = distLbl,
            healthLbl = healthLbl,
            highlight = hl,
            lineObject = lineObj,
            char = char,
        }
    end

    if plr.Character then setup(plr.Character) end

    if not ESPSys[plr .. "_conn"] then
        plr.CharacterAdded:Connect(function(c)
            if ESPSys.enabled then
                if ESPSys.tracking[plr] then
                    local t = ESPSys.tracking[plr]
                    if t.billboard and t.billboard.Parent then t.billboard:Destroy() end
                    if t.highlight and t.highlight.Parent then t.highlight:Destroy() end
                    if t.lineObject then pcall(function() t.lineObject:Remove() end) end
                    ESPSys.tracking[plr] = nil
                end
                task.wait(0.5)
                if ESPSys.enabled then setup(c) end
            end
        end)
    end
end

local function refreshESP()
    if not ESPSys.enabled then
        cleanupESP()
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then addPlayerESP(plr) end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if ESPSys.enabled then
        task.wait(1)
        addPlayerESP(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    local data = ESPSys.tracking[plr]
    if data then
        if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
        if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
        if data.lineObject then pcall(function() data.lineObject:Remove() end) end
        ESPSys.tracking[plr] = nil
    end
end)

-- ESP update loop
task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()
        if ESPSys.enabled then
            ESPSys.hue = (ESPSys.hue + 0.005) % 1
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            for plr, data in pairs(ESPSys.tracking) do
                if not plr.Parent or not data.char or not data.char.Parent then
                    if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
                    if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
                    if data.lineObject then pcall(function() data.lineObject:Remove() end) end
                    ESPSys.tracking[plr] = nil
                else
                    local head = data.char:FindFirstChild("Head")
                    local hum = data.char:FindFirstChildOfClass("Humanoid")
                    if data.billboard then
                        data.billboard.Enabled = ESPSys.names or ESPSys.distance
                        if data.nameLbl then data.nameLbl.Visible = ESPSys.names end
                        if data.healthLbl then
                            data.healthLbl.Visible = ESPSys.distance
                            if hum then
                                data.healthLbl.Text = "HP: " .. math.floor(hum.Health)
                                local pct = hum.Health / hum.MaxHealth
                                data.healthLbl.TextColor3 = Color3.fromRGB(255 * (1 - pct), 255 * pct, 80)
                            end
                        end
                    end
                    if data.distLbl and myRoot and head then
                        data.distLbl.Visible = ESPSys.distance
                        local d = math.floor((myRoot.Position - head.Position).Magnitude)
                        data.distLbl.Text = d .. " studs"
                    end
                    if data.highlight then
                        local hue = (ESPSys.hue + tick() * 0.1) % 1
                        data.highlight.FillColor = Color3.fromHSV(hue, 0.9, 1)
                        data.highlight.OutlineColor = Color3.fromHSV((hue + 0.5) % 1, 0.9, 1)
                    end

                    -- Rainbow lines
                    if ESPSys.lines and data.lineObject and myRoot and head then
                        local cam = workspace.CurrentCamera
                        local myPos, onScreen1 = cam:WorldToViewportPoint(myRoot.Position - Vector3.new(0, 2, 0))
                        local targetPos, onScreen2 = cam:WorldToViewportPoint(head.Position)
                        if onScreen1 and onScreen2 then
                            local hue = (ESPSys.hue + tick() * 0.3) % 1
                            pcall(function()
                                data.lineObject.From = Vector2.new(myPos.X, myPos.Y)
                                data.lineObject.To = Vector2.new(targetPos.X, targetPos.Y)
                                data.lineObject.Color = Color3.fromHSV(hue, 1, 1)
                                data.lineObject.Visible = true
                            end)
                        else
                            pcall(function() data.lineObject.Visible = false end)
                        end
                    elseif data.lineObject then
                        pcall(function() data.lineObject.Visible = false end)
                    end
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- AIMBOT
local Aimbot = {
    enabled = false,
    fov = 150,
    smooth = 0.15,
    targetPart = "Head",
    teamCheck = false,
}

local function getClosestToCursor()
    local closest = nil
    local minDist = Aimbot.fov
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if not (Aimbot.teamCheck and plr.Team == LocalPlayer.Team) then
                local part = plr.Character:FindFirstChild(Aimbot.targetPart)
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = plr
                        end
                    end
                end
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()
        if Aimbot.enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestToCursor()
            if target and target.Character then
                local part = target.Character:FindFirstChild(Aimbot.targetPart)
                if part then
                    Camera.CFrame = Camera.CFrame:Lerp(
                        CFrame.new(Camera.CFrame.Position, part.Position),
                        Aimbot.smooth
                    )
                end
            end
        end
    end
end)

-- ZONE DETECTION (universal)
local ZoneSys = {
    zones = {},
    keywordList = {
        "zone", "area", "region", "biome", "realm", "island", "map",
        "level", "stage", "world", "land", "dimension", "portal",
        "celestial", "void", "paradise", "heaven", "hell", "boss",
        "arena", "dungeon", "sector", "territory", "base", "hub",
    },
}

local function detectZones()
    local found = {}
    local seen = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Folder") then
            local nameLow = obj.Name:lower()
            for _, kw in ipairs(ZoneSys.keywordList) do
                if string.find(nameLow, kw) and not seen[obj] then
                    seen[obj] = true
                    local pos = nil
                    if obj:IsA("BasePart") then
                        pos = obj.Position
                    elseif obj:IsA("Model") then
                        local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if pp then pos = pp.Position end
                    else
                        local part = obj:FindFirstChildWhichIsA("BasePart", true)
                        if part then pos = part.Position end
                    end
                    if pos then
                        table.insert(found, { name = obj.Name, pos = pos, obj = obj })
                    end
                    break
                end
            end
        end
    end
    -- Dedupe by name
    local result = {}
    local seenNames = {}
    for _, z in ipairs(found) do
        local key = z.name:lower()
        if not seenNames[key] then
            seenNames[key] = true
            table.insert(result, z)
        end
    end
    table.sort(result, function(a, b) return a.name < b.name end)
    return result
end

local function teleportToZone(zone)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local target = zone.pos + Vector3.new(0, 5, 0)
    root.CFrame = CFrame.new(target)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(0, 0, 0)
                v.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

-- ============================================================
-- KEY UI
-- ============================================================
local function buildKeyUI(onSuccess)
    local Dim = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })

    local KeyCard = new("Frame", {
        Size = UDim2.new(0, 380, 0, 290),
        Position = UDim2.new(0.5, -190, 0.5, -145),
        BackgroundColor3 = Theme.BG,
        BorderSizePixel = 0,
        Parent = Dim,
    })
    corner(14, KeyCard)
    stroke(Theme.Border, 1, KeyCard)

    local glow = new("UIStroke", { Color = Theme.Accent, Thickness = 1.5, Transparency = 0.7, Parent = KeyCard })
    task.spawn(function()
        while KeyCard.Parent do
            tween(glow, 2, { Transparency = 0.2 }); task.wait(2)
            tween(glow, 2, { Transparency = 0.85 }); task.wait(2)
        end
    end)

    local uk = new("UIScale", { Scale = 1, Parent = KeyCard })
    local function updScale()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        uk.Scale = math.min((vp.X * 0.9) / 380, (vp.Y * 0.9) / 290, 1)
    end
    updScale()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updScale)
    end

    local Header = new("Frame", {
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = KeyCard,
    })
    corner(14, Header)
    new("Frame", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = Header })

    local logoHolder = new("Frame", { Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 16, 0.5, -16), BackgroundTransparency = 1, Parent = Header })
    buildLogo(logoHolder, 32)

    new("TextLabel", {
        Size = UDim2.new(1, -70, 0, 18), Position = UDim2.new(0, 58, 0, 12),
        BackgroundTransparency = 1, Text = CONFIG.Name,
        TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Header,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -70, 0, 13), Position = UDim2.new(0, 58, 0, 32),
        BackgroundTransparency = 1, Text = CONFIG.Subtitle,
        TextColor3 = Theme.TextMuted, TextSize = 9, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Header,
    })

    local keyClose = new("TextButton", {
        Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -38, 0, 19),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Text = "", Parent = Header,
    })
    corner(6, keyClose)
    local kcHolder = new("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7), BackgroundTransparency = 1, Parent = keyClose })
    IconLib.Close(kcHolder, Theme.TextMuted)
    keyClose.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Body = new("Frame", {
        Size = UDim2.new(1, -28, 1, -84),
        Position = UDim2.new(0, 14, 0, 80),
        BackgroundTransparency = 1, Parent = KeyCard,
    })

    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
        Text = "Masukkan key untuk melanjutkan",
        TextColor3 = Theme.Text, TextSize = 11, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Body,
    })

    local InputBox = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 24),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = Body,
    })
    corner(8, InputBox)
    local inputStroke = stroke(Theme.Border, 1, InputBox)

    local keyIconHolder = new("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 12, 0.5, -7), BackgroundTransparency = 1, Parent = InputBox })
    IconLib.Key(keyIconHolder, Theme.TextMuted)

    local KeyInput = new("TextBox", {
        Size = UDim2.new(1, -102, 1, 0), Position = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency = 1, Text = "",
        PlaceholderText = "FREE_XXXXXXXXXXXXXXXX",
        PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.Text,
        TextSize = 12, Font = Enum.Font.Code, ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = InputBox,
    })

    local pasteBtn = new("TextButton", {
        Size = UDim2.new(0, 52, 0, 26), Position = UDim2.new(1, -58, 0.5, -13),
        BackgroundColor3 = Theme.CardHover, BorderSizePixel = 0,
        Text = "Paste", TextColor3 = Theme.Text, TextSize = 10,
        Font = Enum.Font.GothamMedium, Parent = InputBox,
    })
    corner(6, pasteBtn)
    pasteBtn.MouseButton1Click:Connect(function()
        local ok, clip = pcall(function() return game:GetService("GuiService"):GetClipboard() end)
        if ok and clip and clip ~= "" then KeyInput.Text = clip end
    end)

    local StatusLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 74),
        BackgroundTransparency = 1, Text = "", TextColor3 = Theme.TextMuted,
        TextSize = 10, Font = Enum.Font.Gotham, Parent = Body,
    })

    local verifyBtn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 0, 96),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        Text = "Verifikasi Key", TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12, Font = Enum.Font.GothamBold, Parent = Body,
    })
    corner(8, verifyBtn)

    local function submit()
        local key = KeyInput.Text
        if key == "" then
            StatusLabel.Text = "Key tidak boleh kosong"
            StatusLabel.TextColor3 = Theme.Error
            return
        end
        StatusLabel.Text = "Memverifikasi..."
        StatusLabel.TextColor3 = Theme.Warning
        verifyBtn.Text = "..."
        task.wait(0.4)
        local valid, msg = validateKey(key)
        if valid then
            StatusLabel.Text = msg
            StatusLabel.TextColor3 = Theme.Success
            task.wait(0.35)
            tween(Dim, 0.3, { BackgroundTransparency = 1 })
            tween(KeyCard, 0.3, { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
            task.wait(0.3)
            Dim:Destroy()
            onSuccess()
        else
            StatusLabel.Text = msg
            StatusLabel.TextColor3 = Theme.Error
            verifyBtn.Text = "Verifikasi Key"
        end
    end
    verifyBtn.MouseButton1Click:Connect(submit)
    KeyInput.FocusLost:Connect(function(enter) if enter then submit() end end)
end

-- ============================================================
-- MAIN UI (tabbed)
-- ============================================================
local function buildMainUI()
    local Main = new("Frame", {
        Size = UDim2.new(0, 500, 0, 380),
        Position = UDim2.new(0.5, -250, 0.5, -190),
        BackgroundColor3 = Theme.BG,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    corner(12, Main)
    stroke(Theme.Border, 1, Main)

    local mScale = new("UIScale", { Scale = 1, Parent = Main })
    local function upd()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        mScale.Scale = math.min((vp.X * 0.9) / 500, (vp.Y * 0.9) / 380, 1)
    end
    upd()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(upd)
    end

    Main.Size = UDim2.new(0, 0, 0, 0)
    tween(Main, 0.3, { Size = UDim2.new(0, 500, 0, 380) })

    local dragging, dragStart, startPos = false, nil, nil
    local dragArea = new("Frame", { Size = UDim2.new(1, 0, 0, 100), BackgroundTransparency = 1, Parent = Main })
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local Header = new("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0, Parent = Main,
    })
    corner(12, Header)
    new("Frame", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = Header })

    local logoHolder = new("Frame", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 16, 0.5, -14), BackgroundTransparency = 1, Parent = Header })
    buildLogo(logoHolder, 28)

    new("TextLabel", {
        Size = UDim2.new(1, -130, 0, 18), Position = UDim2.new(0, 54, 0, 12),
        BackgroundTransparency = 1, Text = CONFIG.Name,
        TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Header,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -130, 0, 12), Position = UDim2.new(0, 54, 0, 30),
        BackgroundTransparency = 1, Text = CONFIG.Subtitle .. " • " .. CONFIG.Version,
        TextColor3 = Theme.TextMuted, TextSize = 9, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Header,
    })

    local function winBtn(iconFn, xOffset)
        local b = new("TextButton", {
            Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, xOffset, 0, 16),
            BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Text = "", Parent = Header,
        })
        corner(6, b)
        local holder = new("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7), BackgroundTransparency = 1, Parent = b })
        IconLib[iconFn](holder, Theme.TextMuted)
        b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundColor3 = Theme.CardHover }) end)
        b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundColor3 = Theme.Card }) end)
        return b
    end

    local MinBtn = winBtn("Minimize", -64)
    local CloseBtn = winBtn("Close", -34)
    CloseBtn.MouseButton1Click:Connect(function()
        doUnfly()
        cleanupESP()
        ScreenGui:Destroy()
    end)

    -- Tab Bar
    local TabBar = new("Frame", {
        Size = UDim2.new(1, -24, 0, 40),
        Position = UDim2.new(0, 12, 0, 62),
        BackgroundTransparency = 1,
        Parent = Main,
    })
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabBar,
    })

    local Content = new("Frame", {
        Size = UDim2.new(1, -24, 1, -114),
        Position = UDim2.new(0, 12, 0, 110),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local Pages = {}

    local function makeTab(label, iconFn, order)
        local btn = new("TextButton", {
            Size = UDim2.new(0, 110, 0, 34),
            BackgroundColor3 = Theme.Card,
            BorderSizePixel = 0,
            Text = "",
            LayoutOrder = order,
            Parent = TabBar,
        })
        corner(8, btn)

        local iconHolder = new("Frame", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, 12, 0.5, -7),
            BackgroundTransparency = 1,
            Parent = btn,
        })
        IconLib[iconFn](iconHolder, Theme.TextMuted)

        local lbl = new("TextLabel", {
            Size = UDim2.new(1, -34, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            BackgroundTransparency = 1,
            Text = label,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn,
        })

        local page = new("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = Content,
        })

        Pages[label] = { btn = btn, lbl = lbl, page = page }

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do
                p.page.Visible = false
                tween(p.btn, 0.1, { BackgroundColor3 = Theme.Card })
                tween(p.lbl, 0.1, { TextColor3 = Theme.TextMuted })
            end
            page.Visible = true
            tween(btn, 0.1, { BackgroundColor3 = Theme.Accent })
            tween(lbl, 0.1, { TextColor3 = Color3.fromRGB(255, 255, 255) })
        end)

        return page
    end

    -- ============================================================
    -- TAB 1: FLY
    -- ============================================================
    local FlyPage = makeTab("Fly", "Wing", 1)

    local ToggleCard = new("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = FlyPage,
    })
    corner(10, ToggleCard)
    stroke(Theme.Border, 1, ToggleCard)

    new("TextLabel", {
        Size = UDim2.new(1, -100, 0, 16), Position = UDim2.new(0, 44, 0, 12),
        BackgroundTransparency = 1, Text = "Fly",
        TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleCard,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -100, 0, 12), Position = UDim2.new(0, 44, 0, 30),
        BackgroundTransparency = 1, Text = "W A S D • Q / E naik turun",
        TextColor3 = Theme.TextMuted, TextSize = 9, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleCard,
    })

    local wingIcon = new("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 14, 0.5, -9), BackgroundTransparency = 1, Parent = ToggleCard })
    IconLib.Wing(wingIcon, Theme.Text)

    local toggleBg = new("TextButton", {
        Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Text = "", Parent = ToggleCard,
    })
    corner(100, toggleBg)
    local toggleDot = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Theme.TextMuted, BorderSizePixel = 0, Parent = toggleBg,
    })
    corner(100, toggleDot)

    local toggled = false
    toggleBg.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            tween(toggleBg, 0.15, { BackgroundColor3 = Theme.Accent })
            tween(toggleDot, 0.15, { Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255,255,255) })
            doFly()
        else
            tween(toggleBg, 0.15, { BackgroundColor3 = Theme.Sidebar })
            tween(toggleDot, 0.15, { Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Theme.TextMuted })
            doUnfly()
        end
    end)

    local SpeedCard = new("Frame", {
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 0, 68),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = FlyPage,
    })
    corner(10, SpeedCard)
    stroke(Theme.Border, 1, SpeedCard)

    local speedIcon = new("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 1, Parent = SpeedCard })
    IconLib.Speed(speedIcon, Theme.Text)

    new("TextLabel", {
        Size = UDim2.new(1, -100, 0, 16), Position = UDim2.new(0, 44, 0, 14),
        BackgroundTransparency = 1, Text = "Fly Speed",
        TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = SpeedCard,
    })

    local speedValueLabel = new("TextLabel", {
        Size = UDim2.new(0, 80, 0, 16), Position = UDim2.new(1, -96, 0, 14),
        BackgroundTransparency = 1, Text = "1",
        TextColor3 = Theme.Accent, TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = SpeedCard,
    })

    local sliderBar = new("Frame", {
        Size = UDim2.new(1, -32, 0, 6), Position = UDim2.new(0, 16, 0, 62),
        BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = SpeedCard,
    })
    corner(100, sliderBar)
    local sliderFill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = sliderBar })
    corner(100, sliderFill)
    local sliderDot = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = sliderBar,
    })
    corner(100, sliderDot)

    new("TextLabel", {
        Size = UDim2.new(1, -32, 0, 14), Position = UDim2.new(0, 16, 0, 76),
        BackgroundTransparency = 1, Text = "1                              50",
        TextColor3 = Theme.TextMuted, TextSize = 9, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Center, Parent = SpeedCard,
    })

    local sDrag = false
    local MIN_SPD, MAX_SPD = 1, 50
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(MIN_SPD + (MAX_SPD - MIN_SPD) * pos)
        iyflyspeed = val
        vehicleflyspeed = val
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderDot.Position = UDim2.new(pos, -7, 0.5, -7)
        speedValueLabel.Text = tostring(val)
    end
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDrag = true; updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDrag = false
        end
    end)

    local quickRow = new("Frame", {
        Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 180),
        BackgroundTransparency = 1, Parent = FlyPage,
    })
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = quickRow,
    })
    for _, preset in ipairs({1, 3, 5, 10, 20}) do
        local pb = new("TextButton", {
            Size = UDim2.new(0, 88, 0, 30),
            BackgroundColor3 = Theme.Card, BorderSizePixel = 0,
            Text = tostring(preset), TextColor3 = Theme.Text,
            TextSize = 11, Font = Enum.Font.GothamBold,
            LayoutOrder = preset, Parent = quickRow,
        })
        corner(8, pb)
        local pbs = stroke(Theme.Border, 1, pb)
        pb.MouseButton1Click:Connect(function()
            iyflyspeed = preset
            vehicleflyspeed = preset
            local pos = (preset - MIN_SPD) / (MAX_SPD - MIN_SPD)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderDot.Position = UDim2.new(pos, -7, 0.5, -7)
            speedValueLabel.Text = tostring(preset)
        end)
    end

    -- ============================================================
    -- TAB 2: ESP
    -- ============================================================
    local ESPPage = makeTab("ESP", "Eye", 2)

    local function makeToggleCard(parent, y, label, key, callback)
        local card = new("Frame", {
            Size = UDim2.new(1, 0, 0, 44),
            Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = parent,
        })
        corner(8, card)
        stroke(Theme.Border, 1, card)
        new("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = label,
            TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
        })
        local tg = new("TextButton", {
            Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -58, 0.5, -11),
            BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Text = "", Parent = card,
        })
        corner(100, tg)
        local dot = new("Frame", {
            Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = Theme.TextMuted, BorderSizePixel = 0, Parent = tg,
        })
        corner(100, dot)
        local state = ESPSys[key]
        if state then
            tg.BackgroundColor3 = Theme.Accent
            dot.Position = UDim2.new(1, -19, 0.5, -8)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
        tg.MouseButton1Click:Connect(function()
            state = not state
            ESPSys[key] = state
            if state then
                tg.BackgroundColor3 = Theme.Accent
                dot.Position = UDim2.new(1, -19, 0.5, -8)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                tg.BackgroundColor3 = Theme.Sidebar
                dot.Position = UDim2.new(0, 3, 0.5, -8)
                dot.BackgroundColor3 = Theme.TextMuted
            end
            if callback then callback(state) end
            if key == "enabled" then refreshESP() end
        end)
    end

    makeToggleCard(ESPPage, 0, "Enable ESP", "enabled")
    makeToggleCard(ESPPage, 54, "Rainbow Lines", "lines")
    makeToggleCard(ESPPage, 108, "Show Names", "names")
    makeToggleCard(ESPPage, 162, "Show Distance", "distance")

    -- ============================================================
    -- TAB 3: COMBAT
    -- ============================================================
    local CombatPage = makeTab("Combat", "Crosshair", 3)

    local AimbotCard = new("Frame", {
        Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0, Parent = CombatPage,
    })
    corner(8, AimbotCard)
    stroke(Theme.Border, 1, AimbotCard)
    new("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1, Text = "Enable Aimbot (hold RMB)",
        TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = AimbotCard,
    })
    local aTg = new("TextButton", {
        Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -58, 0.5, -11),
        BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Text = "", Parent = AimbotCard,
    })
    corner(100, aTg)
    local aDot = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Theme.TextMuted, BorderSizePixel = 0, Parent = aTg,
    })
    corner(100, aDot)
    aTg.MouseButton1Click:Connect(function()
        Aimbot.enabled = not Aimbot.enabled
        if Aimbot.enabled then
            aTg.BackgroundColor3 = Theme.Accent
            aDot.Position = UDim2.new(1, -19, 0.5, -8)
            aDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            aTg.BackgroundColor3 = Theme.Sidebar
            aDot.Position = UDim2.new(0, 3, 0.5, -8)
            aDot.BackgroundColor3 = Theme.TextMuted
        end
    end)

    -- FOV slider
    local FOVCard = new("Frame", {
        Size = UDim2.new(1, 0, 0, 60), Position = UDim2.new(0, 0, 0, 54),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = CombatPage,
    })
    corner(8, FOVCard)
    stroke(Theme.Border, 1, FOVCard)
    new("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20), Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1, Text = "Aimbot FOV",
        TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = FOVCard,
    })
    local fovValLbl = new("TextLabel", {
        Size = UDim2.new(0, 80, 0, 20), Position = UDim2.new(1, -96, 0, 6),
        BackgroundTransparency = 1, Text = "150",
        TextColor3 = Theme.Accent, TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = FOVCard,
    })
    local fovBar = new("Frame", {
        Size = UDim2.new(1, -32, 0, 6), Position = UDim2.new(0, 16, 0, 42),
        BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = FOVCard,
    })
    corner(100, fovBar)
    local fovFill = new("Frame", { Size = UDim2.new(0.3, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = fovBar })
    corner(100, fovFill)
    local fovDot = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.3, -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = fovBar,
    })
    corner(100, fovDot)
    local fovDrag = false
    local function updateFov(input)
        local pos = math.clamp((input.Position.X - fovBar.AbsolutePosition.X) / fovBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(50 + 450 * pos)
        Aimbot.fov = val
        fovFill.Size = UDim2.new(pos, 0, 1, 0)
        fovDot.Position = UDim2.new(pos, -7, 0.5, -7)
        fovValLbl.Text = tostring(val)
    end
    fovBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fovDrag = true; updateFov(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if fovDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFov(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fovDrag = false
        end
    end)

    -- Smooth slider
    local SmoothCard = new("Frame", {
        Size = UDim2.new(1, 0, 0, 60), Position = UDim2.new(0, 0, 0, 124),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Parent = CombatPage,
    })
    corner(8, SmoothCard)
    stroke(Theme.Border, 1, SmoothCard)
    new("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20), Position = UDim2.new(0, 16, 0, 6),
        BackgroundTransparency = 1, Text = "Smoothness (%)",
        TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = SmoothCard,
    })
    local smValLbl = new("TextLabel", {
        Size = UDim2.new(0, 80, 0, 20), Position = UDim2.new(1, -96, 0, 6),
        BackgroundTransparency = 1, Text = "15",
        TextColor3 = Theme.Accent, TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = SmoothCard,
    })
    local smBar = new("Frame", {
        Size = UDim2.new(1, -32, 0, 6), Position = UDim2.new(0, 16, 0, 42),
        BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Parent = SmoothCard,
    })
    corner(100, smBar)
    local smFill = new("Frame", { Size = UDim2.new(0.15, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = smBar })
    corner(100, smFill)
    local smDot = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.15, -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = smBar,
    })
    corner(100, smDot)
    local smDrag = false
    local function updateSm(input)
        local pos = math.clamp((input.Position.X - smBar.AbsolutePosition.X) / smBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(1 + 99 * pos)
        Aimbot.smooth = val / 100
        smFill.Size = UDim2.new(pos, 0, 1, 0)
        smDot.Position = UDim2.new(pos, -7, 0.5, -7)
        smValLbl.Text = tostring(val)
    end
    smBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            smDrag = true; updateSm(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if smDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSm(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            smDrag = false
        end
    end)

    -- ============================================================
    -- TAB 4: ZONE TELEPORT
    -- ============================================================
    local ZonePage = makeTab("Zone", "Pin", 4)

    local zoneTop = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0, Parent = ZonePage,
    })
    corner(8, zoneTop)
    stroke(Theme.Border, 1, zoneTop)

    local refreshBtn = new("TextButton", {
        Size = UDim2.new(0, 110, 0, 28), Position = UDim2.new(0, 6, 0.5, -14),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        Text = "Scan Zones", TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 11, Font = Enum.Font.GothamBold, Parent = zoneTop,
    })
    corner(6, refreshBtn)

    local zoneCountLbl = new("TextLabel", {
        Size = UDim2.new(1, -130, 1, 0), Position = UDim2.new(0, 122, 0, 0),
        BackgroundTransparency = 1, Text = "Zones: 0",
        TextColor3 = Theme.TextMuted, TextSize = 11, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = zoneTop,
    })

    local ZoneScroll = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = ZonePage,
    })
    corner(8, ZoneScroll)
    stroke(Theme.Border, 1, ZoneScroll)
    new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ZoneScroll })
    new("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = ZoneScroll })

    local function renderZones()
        for _, c in ipairs(ZoneScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local zones = ZoneSys.zones
        for i, z in ipairs(zones) do
            local btn = new("TextButton", {
                Size = UDim2.new(1, -4, 0, 34),
                BackgroundColor3 = Theme.Sidebar,
                BorderSizePixel = 0,
                Text = "",
                LayoutOrder = i,
                Parent = ZoneScroll,
            })
            corner(6, btn)
            stroke(Theme.Border, 1, btn)
            new("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = z.name,
                TextColor3 = Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = btn,
            })
            new("TextLabel", {
                Size = UDim2.new(0, 80, 1, 0),
                Position = UDim2.new(1, -92, 0, 0),
                BackgroundTransparency = 1,
                Text = "→ TP",
                TextColor3 = Theme.Accent,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = btn,
            })
            btn.MouseButton1Click:Connect(function()
                teleportToZone(z)
            end)
            btn.MouseEnter:Connect(function()
                tween(btn, 0.1, { BackgroundColor3 = Theme.CardHover })
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, 0.1, { BackgroundColor3 = Theme.Sidebar })
            end)
        end
        zoneCountLbl.Text = "Zones: " .. #zones
    end

    refreshBtn.MouseButton1Click:Connect(function()
        refreshBtn.Text = "Scanning..."
        task.wait(0.1)
        ZoneSys.zones = detectZones()
        renderZones()
        refreshBtn.Text = "Scan Zones"
    end)

    -- Auto scan once
    task.spawn(function()
        task.wait(1)
        ZoneSys.zones = detectZones()
        renderZones()
    end)

    -- Start on Fly tab
    local flyTab = Pages["Fly"]
    flyTab.page.Visible = true
    tween(flyTab.btn, 0.1, { BackgroundColor3 = Theme.Accent })
    tween(flyTab.lbl, 0.1, { TextColor3 = Color3.fromRGB(255, 255, 255) })
end

buildKeyUI(function()
    buildMainUI()
end)

print("[Hallwayz] UI built successfully.")
