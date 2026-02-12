local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AUTO_ENABLED = false
local isAutoRunning = false

local CONFIG = {
    VERIFY_TIME = 15,
    VERIFY_RADIUS = 5,
    OSCILLATION = 0.15,
    OSCILLATION_SPEED = 0.8,
    DETECTION_PATTERNS = {
        "Money Lucky Block!",
        "completed Obby!",
        "Money Coins!",
        "Lucky Block",
        "completed",
        "Coins!",
        "already completed",
    },
}

local TARGETS = {
    {name = "A", x = 425.7, y = -10.5, z = -340},
    {name = "C", x = 1132.37, y = 3.9, z = 529},
    {name = "B", x = 2571, y = -5.44, z = -337.7}
}

local MONEY_EVENT_ICON = "rbxassetid://109664817855554"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyEventSystem"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 140)
mainFrame.Position = UDim2.new(1, -290, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 18)
headerFix.Position = UDim2.new(0, 0, 1, -18)
headerFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Event"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -33, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local eventMoneyBtn = Instance.new("TextButton")
eventMoneyBtn.Name = "EventMoneyBtn"
eventMoneyBtn.Size = UDim2.new(1, 0, 0, 35)
eventMoneyBtn.Position = UDim2.new(0, 0, 0, 0)
eventMoneyBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 20)
eventMoneyBtn.Text = ""
eventMoneyBtn.BorderSizePixel = 0
eventMoneyBtn.Parent = contentFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = eventMoneyBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 215, 0)
btnStroke.Thickness = 1.5
btnStroke.Parent = eventMoneyBtn

local btnLabel = Instance.new("TextLabel")
btnLabel.Size = UDim2.new(1, -50, 1, 0)
btnLabel.Position = UDim2.new(0, 10, 0, 0)
btnLabel.BackgroundTransparency = 1
btnLabel.Text = "💰 Event Money"
btnLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
btnLabel.TextSize = 13
btnLabel.Font = Enum.Font.GothamBold
btnLabel.TextXAlignment = Enum.TextXAlignment.Left
btnLabel.Parent = eventMoneyBtn

local statusIndicator = Instance.new("TextLabel")
statusIndicator.Name = "StatusIndicator"
statusIndicator.Size = UDim2.new(0, 40, 0, 20)
statusIndicator.Position = UDim2.new(1, -50, 0.5, -10)
statusIndicator.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
statusIndicator.Text = "OFF"
statusIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
statusIndicator.TextSize = 10
statusIndicator.Font = Enum.Font.GothamBold
statusIndicator.BorderSizePixel = 0
statusIndicator.Parent = eventMoneyBtn

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 5)
indicatorCorner.Parent = statusIndicator

local timerDisplay = Instance.new("Frame")
timerDisplay.Size = UDim2.new(1, 0, 0, 30)
timerDisplay.Position = UDim2.new(0, 0, 0, 45)
timerDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timerDisplay.BorderSizePixel = 0
timerDisplay.Visible = false
timerDisplay.Parent = contentFrame

local timerCorner = Instance.new("UICorner")
timerCorner.CornerRadius = UDim.new(0, 6)
timerCorner.Parent = timerDisplay

local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "TimerLabel"
timerLabel.Size = UDim2.new(1, -10, 1, 0)
timerLabel.Position = UDim2.new(0, 5, 0, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 12
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.Text = "Waiting..."
timerLabel.TextXAlignment = Enum.TextXAlignment.Center
timerLabel.RichText = true
timerLabel.Parent = timerDisplay

local statusDisplay = Instance.new("Frame")
statusDisplay.Size = UDim2.new(1, 0, 0, 50)
statusDisplay.Position = UDim2.new(0, 0, 0, 45)
statusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusDisplay.BorderSizePixel = 0
statusDisplay.Visible = false
statusDisplay.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusDisplay

local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -10, 0, 20)
statusText.Position = UDim2.new(0, 5, 0, 5)
statusText.BackgroundTransparency = 1
statusText.Text = "Sẵn sàng..."
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextSize = 10
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusDisplay

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, -10, 0, 18)
progressBg.Position = UDim2.new(0, 5, 0, 27)
progressBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
progressBg.BorderSizePixel = 0
progressBg.Parent = statusDisplay

local progCorner = Instance.new("UICorner")
progCorner.CornerRadius = UDim.new(0, 5)
progCorner.Parent = progressBg

local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBg

local progFillCorner = Instance.new("UICorner")
progFillCorner.CornerRadius = UDim.new(0, 5)
progFillCorner.Parent = progressFill

local progressText = Instance.new("TextLabel")
progressText.Name = "ProgressText"
progressText.Size = UDim2.new(1, 0, 1, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(255, 255, 255)
progressText.TextSize = 9
progressText.Font = Enum.Font.GothamBold
progressText.ZIndex = 2
progressText.Parent = progressBg

local eventStartTime = nil
local eventDuration = 600
local cachedTime = nil

local function formatTime(totalSeconds)
    if totalSeconds <= 0 then return "00:00" end
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

local function getMoneyEventTime()
    local success, result = pcall(function()
        local eventTimers = workspace:FindFirstChild("EventTimers")
        if not eventTimers then return nil end
        
        for _, part in pairs(eventTimers:GetChildren()) do
            if part:IsA("BasePart") then
                local surfaceGui = part:FindFirstChild("SurfaceGui")
                if surfaceGui then
                    local frame = surfaceGui:FindFirstChild("Frame")
                    if frame then
                        for _, textLabel in pairs(frame:GetChildren()) do
                            if textLabel:IsA("TextLabel") then
                                local text = textLabel.Text
                                if text:upper():find("MONEY") then
                                    local timePattern = "(%d+):(%d+)"
                                    local time1, time2 = text:match(timePattern)
                                    if time1 and time2 then
                                        local minutes = tonumber(time1)
                                        local seconds = tonumber(time2)
                                        local totalSeconds = minutes * 60 + seconds
                                        return {
                                            minutes = minutes,
                                            seconds = seconds,
                                            totalSeconds = totalSeconds,
                                            rawText = text
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end)
    
    if success and result then return result end
    return nil
end

local function getActiveEventTime()
    local success, result = pcall(function()
        local hud = player.PlayerGui:FindFirstChild("HUD")
        if not hud then return nil end
        
        local bottomRight = hud:FindFirstChild("BottomRight")
        if not bottomRight then return nil end
        
        local buffs = bottomRight:FindFirstChild("Buffs")
        if not buffs then return nil end
        
        for _, template in pairs(buffs:GetChildren()) do
            if template:IsA("ImageButton") then
                if template.Image == MONEY_EVENT_ICON then
                    local label = template:FindFirstChild("Label")
                    if label and label:IsA("TextLabel") and label.Visible then
                        local text = label.Text
                        if text:match("%d+:%d+") and text ~= "00:00" then
                            local timePattern = "(%d+):(%d+)"
                            local minutes, seconds = text:match(timePattern)
                            if minutes and seconds then
                                local totalSeconds = tonumber(minutes) * 60 + tonumber(seconds)
                                if totalSeconds > 0 and totalSeconds <= 600 then
                                    return {
                                        minutes = tonumber(minutes),
                                        seconds = tonumber(seconds),
                                        totalSeconds = totalSeconds,
                                        isActive = true,
                                        source = label:GetFullName()
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end)
    
    if success and result then return result end
    return nil
end

local function updateTimer()
    if not AUTO_ENABLED then
        timerDisplay.Visible = false
        return
    end
    
    local upcomingEvent = getMoneyEventTime()
    local activeEvent = getActiveEventTime()
    
    if upcomingEvent or activeEvent then
        timerDisplay.Visible = true
        
        if activeEvent then
            cachedTime = activeEvent.totalSeconds
            eventStartTime = tick()
            
            local displayTime = formatTime(activeEvent.totalSeconds)
            timerLabel.Text = string.format('<font color="#00FF00">ACTIVE</font> <font color="#888">▸</font> <font color="#00FF00">%s</font>', displayTime)
            timerDisplay.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
            
            if not isAutoRunning then
                startAutoFarm()
            end
            
        elseif upcomingEvent then
            cachedTime = upcomingEvent.totalSeconds
            eventStartTime = nil
            
            local displayTime = formatTime(upcomingEvent.totalSeconds)
            timerLabel.Text = string.format('<font color="#FFD700">MONEY</font> <font color="#888">▸</font> <font color="#FFD700">%s</font>', displayTime)
            
            if upcomingEvent.totalSeconds <= 60 then
                timerDisplay.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
            elseif upcomingEvent.totalSeconds <= 300 then
                timerDisplay.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
            else
                timerDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        end
    else
        if eventStartTime and (tick() - eventStartTime) < eventDuration then
            local timeElapsed = tick() - eventStartTime
            local timeRemaining = eventDuration - timeElapsed
            
            if timeRemaining > 0 then
                local displayTime = formatTime(math.floor(timeRemaining))
                timerLabel.Text = string.format('<font color="#00FF00">ACTIVE</font> <font color="#888">▸</font> <font color="#00FF00">%s</font>', displayTime)
                timerDisplay.Visible = true
            else
                eventStartTime = nil
                timerLabel.Text = '<font color="#888">Waiting...</font>'
                timerDisplay.Visible = true
            end
        else
            timerLabel.Text = '<font color="#888">Waiting...</font>'
            timerDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            timerDisplay.Visible = true
        end
    end
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local noclipConnection = nil
local currentTargetIndex = 1
local completedTargets = {}
local startTime = 0
local isPaused = false
local detectedNotification = false
local skipRequested = false
local previousGUITexts = {}
local detectionCounter = 0
local currentDetectionCounter = 0
local cachedGUIList = {}
local lastCacheTime = 0
local lastActivityTime = tick()
local watchdogConnection = nil
local notificationConnection = nil

local function enableNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if not isAutoRunning then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

local function updateFarmUI(statusStr)
    if statusStr then statusText.Text = statusStr end
end

local function updateProgress(percent)
    progressText.Text = string.format("%d%%", math.floor(percent))
    progressFill:TweenSize(
        UDim2.new(percent / 100, 0, 1, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.2,
        true
    )
end

local function teleportTo(x, y, z)
    humanoidRootPart.CFrame = CFrame.new(x, y, z)
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
end

local function setFakeWalking(enabled)
    if enabled then
        humanoid.WalkSpeed = 16
    else
        humanoid.WalkSpeed = 16
    end
end

local function checkForNotification()
    local currentTime = tick()
    
    if currentTime - lastCacheTime > 2 then
        cachedGUIList = {}
        for _, gui in pairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") then
                table.insert(cachedGUIList, gui)
            end
        end
        lastCacheTime = currentTime
    end
    
    for _, gui in ipairs(cachedGUIList) do
        if gui.Visible and gui.Parent then
            local text = gui.Text
            local fullName = gui:GetFullName()
            
            if text and text ~= "" and #text > 10 then
                local hasPattern = false
                
                for _, pattern in ipairs(CONFIG.DETECTION_PATTERNS) do
                    if string.find(text, pattern) then
                        hasPattern = true
                        break
                    end
                end
                
                if hasPattern then
                    local pos = gui.AbsolutePosition
                    local size = gui.AbsoluteSize
                    local screenCenter = workspace.CurrentCamera.ViewportSize / 2
                    
                    local distFromCenter = math.abs(pos.X + size.X/2 - screenCenter.X) + math.abs(pos.Y + size.Y/2 - screenCenter.Y)
                    
                    if distFromCenter < 400 then
                        local lastCounter = previousGUITexts[fullName]
                        
                        if not lastCounter or lastCounter < currentDetectionCounter then
                            previousGUITexts[fullName] = currentDetectionCounter
                            return true, text
                        end
                    end
                end
            end
        end
    end
    return false, nil
end

local function resetWatchdog()
    lastActivityTime = tick()
end

local function startWatchdog()
    if watchdogConnection then return end
    watchdogConnection = RunService.Heartbeat:Connect(function()
        if not isAutoRunning then return end
        if tick() - lastActivityTime > 30 then
            updateFarmUI("Phát hiện đơ - Khởi động lại")
            lastActivityTime = tick()
            stopNotificationListener()
            disableNoclip()
            task.wait(2)
            if currentTargetIndex > #TARGETS then
                currentTargetIndex = 1
                completedTargets = {}
            end
            executeAutoFarm()
        end
    end)
end

local function stopWatchdog()
    if watchdogConnection then
        watchdogConnection:Disconnect()
        watchdogConnection = nil
    end
end

local function startNotificationListener()
    if notificationConnection then return end
    detectedNotification = false
    local lastCheckTime = 0
    
    notificationConnection = RunService.Heartbeat:Connect(function()
        if detectedNotification then return end
        
        local currentTime = tick()
        if currentTime - lastCheckTime < 0.2 then
            return
        end
        lastCheckTime = currentTime
        
        local found, text = checkForNotification()
        if found then
            detectedNotification = true
            updateFarmUI(string.format("Phát hiện: %s", text:sub(1, 20)))
        end
    end)
end

local function stopNotificationListener()
    if notificationConnection then
        notificationConnection:Disconnect()
        notificationConnection = nil
    end
end

local function oscillateAtPoint(x, y, z, maxDuration)
    local oscillationTime = 0
    local startTime = tick()
    detectedNotification = false
    
    detectionCounter = detectionCounter + 1
    currentDetectionCounter = detectionCounter
    
    task.wait(0.5)
    
    startNotificationListener()
    setFakeWalking(true)
    resetWatchdog()
    
    while not detectedNotification and isAutoRunning do
        resetWatchdog()
        
        if skipRequested then break end
        if tick() - startTime > maxDuration then
            updateFarmUI("Timeout - Chuyển điểm")
            break
        end
        
        if not character or not character.Parent then
            updateFarmUI("Nhân vật mất!")
            stopNotificationListener()
            return false
        end
        
        local humanoidCheck = character:FindFirstChildOfClass("Humanoid")
        if not humanoidCheck or humanoidCheck.Health <= 0 then
            updateFarmUI("Nhân vật chết!")
            stopNotificationListener()
            return false
        end
        
        local currentPos = humanoidRootPart.Position
        local targetPos = Vector3.new(x, y, z)
        local dist = (currentPos - targetPos).Magnitude
        
        if dist > CONFIG.VERIFY_RADIUS then
            updateFarmUI("Bị dật xa, tele lại...")
            teleportTo(x, y, z)
            oscillationTime = 0
        else
            oscillationTime = oscillationTime + 0.1
            local offsetX = math.sin(oscillationTime * CONFIG.OSCILLATION_SPEED) * CONFIG.OSCILLATION
            local offsetZ = math.cos(oscillationTime * CONFIG.OSCILLATION_SPEED) * CONFIG.OSCILLATION
            teleportTo(x + offsetX, y, z + offsetZ)
            local elapsed = tick() - startTime
            updateFarmUI(string.format("Chờ thông báo... %.1fs", elapsed))
        end
        
        task.wait(0.1)
    end
    
    stopNotificationListener()
    setFakeWalking(false)
    teleportTo(x, y, z)
    return detectedNotification
end

function executeAutoFarm()
    if not AUTO_ENABLED or not isAutoRunning then return end
    
    enableNoclip()
    startWatchdog()
    resetWatchdog()
    
    if startTime == 0 then
        startTime = tick()
    end
    
    while currentTargetIndex <= #TARGETS and isAutoRunning and AUTO_ENABLED do
        resetWatchdog()
        local target = TARGETS[currentTargetIndex]
        
        if completedTargets[target.name] then
            currentTargetIndex = currentTargetIndex + 1
            continue
        end
        
        updateProgress(((currentTargetIndex - 1) / #TARGETS) * 100)
        updateFarmUI(string.format("Tele đến %s", target.name))
        
        teleportTo(target.x, target.y, target.z)
        task.wait(0.2)
        
        local verified = oscillateAtPoint(target.x, target.y, target.z, CONFIG.VERIFY_TIME)
        
        if skipRequested then
            skipRequested = false
            completedTargets[target.name] = true
            updateFarmUI(string.format("Bỏ qua %s", target.name))
            updateProgress((currentTargetIndex / #TARGETS) * 100)
            
            local delayTime = 2
            local delayStart = tick()
            local oscillationTime = 0
            
            while tick() - delayStart < delayTime do
                oscillationTime = oscillationTime + 0.1
                local offsetX = math.sin(oscillationTime * CONFIG.OSCILLATION_SPEED) * CONFIG.OSCILLATION
                local offsetZ = math.cos(oscillationTime * CONFIG.OSCILLATION_SPEED) * CONFIG.OSCILLATION
                teleportTo(target.x + offsetX, target.y, target.z + offsetZ)
                task.wait(0.1)
            end
            
            currentTargetIndex = currentTargetIndex + 1
        elseif verified then
            completedTargets[target.name] = true
            updateFarmUI(string.format("Xong %s!", target.name))
            updateProgress((currentTargetIndex / #TARGETS) * 100)
            
            local delayTime = 2
            local delayStart = tick()
            local oscillationTime = 0
            
            while tick() - delayStart < delayTime do
                oscillationTime = oscillationTime + 0.1
                local offsetX = math.sin(oscillationTime * CONFIG.OSCILLATION_SPEED) * CONFIG.OSCILLATION
                local offsetZ = math.cos(oscillationTime * CONFIG.OSCILLATION_SPEED) * CONFIG.OSCILLATION
                teleportTo(target.x + offsetX, target.y, target.z + offsetZ)
                task.wait(0.1)
            end
            
            currentTargetIndex = currentTargetIndex + 1
        else
            updateFarmUI(string.format("Timeout %s - Làm lại", target.name))
            task.wait(0.5)
        end
    end
    
    local completedCount = 0
    for _ in pairs(completedTargets) do
        completedCount = completedCount + 1
    end
    
    if completedCount >= #TARGETS then
        updateProgress(100)
        updateFarmUI("HOÀN THÀNH!")
        task.wait(2)
        doServerHop()
    else
        updateFarmUI(string.format("Đã xong %d/%d - Làm nốt", completedCount, #TARGETS))
        task.wait(2)
        currentTargetIndex = 1
        executeAutoFarm()
    end
    
    disableNoclip()
    stopWatchdog()
    isAutoRunning = false
end

function startAutoFarm()
    if isAutoRunning then return end
    isAutoRunning = true
    statusDisplay.Visible = true
    timerDisplay.Visible = false
    currentTargetIndex = 1
    completedTargets = {}
    updateFarmUI("Bắt đầu Auto Farm...")
    updateProgress(0)
    task.spawn(executeAutoFarm)
end

function stopAutoFarm()
    isAutoRunning = false
    disableNoclip()
    stopWatchdog()
    stopNotificationListener()
    statusDisplay.Visible = false
    updateFarmUI("Đã dừng")
end

local PlaceId = game.PlaceId

function doServerHop()
    updateFarmUI("Đang tìm server mới...")
    
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    
    local function get()
        return HttpService:JSONDecode(game:HttpGet(url))
    end
    
    local data = get()
    
    for _, s in ipairs(data.data) do
        if s.playing < s.maxPlayers then
            updateFarmUI("Tìm thấy server! Đang teleport...")
            task.wait(1)
            TeleportService:TeleportToPlaceInstance(PlaceId, s.id)
            break
        end
    end
end

eventMoneyBtn.MouseButton1Click:Connect(function()
    AUTO_ENABLED = not AUTO_ENABLED
    
    if AUTO_ENABLED then
        statusIndicator.Text = "ON"
        statusIndicator.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        btnStroke.Color = Color3.fromRGB(60, 200, 60)
        eventMoneyBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
        timerDisplay.Visible = true
    else
        statusIndicator.Text = "OFF"
        statusIndicator.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        btnStroke.Color = Color3.fromRGB(255, 215, 0)
        eventMoneyBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 20)
        timerDisplay.Visible = false
        statusDisplay.Visible = false
        stopAutoFarm()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    AUTO_ENABLED = false
    stopAutoFarm()
    screenGui:Destroy()
end)

local function setupCharacterDeath()
    local humanoidCheck = character:FindFirstChildOfClass("Humanoid")
    if humanoidCheck then
        humanoidCheck.Died:Connect(function()
            if isAutoRunning and currentTargetIndex <= #TARGETS then
                updateFarmUI("Bị chết - Chờ hồi sinh...")
                isPaused = true
                disableNoclip()
                stopNotificationListener()
            end
        end)
    end
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    task.wait(2)
    setupCharacterDeath()
    
    if AUTO_ENABLED and isAutoRunning and currentTargetIndex <= #TARGETS then
        isPaused = false
        updateFarmUI("Hồi sinh - Tiếp tục...")
        task.wait(1)
        executeAutoFarm()
    end
end)

setupCharacterDeath()

spawn(function()
    while wait(1) do
        pcall(updateTimer)
    end
end)
