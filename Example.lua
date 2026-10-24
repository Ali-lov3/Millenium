local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-lov3/Millenium/refs/heads/main/Source.lua"))()

local window = library:window({name = "nebula", suffix = "tech", gameInfo = "Milenium for Counter-Strike: Global Offensive", AccentColor = Color3.fromRGB(155, 150, 219), ConfigFolder = "Test"})

window:seperator({name = "Home"})
local home = window:home_manager({name = "Home"})

window:seperator({name = "General"})
local enemies, teammates, self_section = window:tab({name = "Example", icon = "eye", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    local column = tab:column({})
    local section = column:section({name = "General", icon = "info", default = true, toggle = false})
    section:label({name = "This is a title!", info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"})

    local page = tab:sub_tab({order = -10000, size = 2})

    for i = 1, 2 do
        local column = page:column({})
        local section = column:section({name = "General", icon = "user", default = true})
        section:toggle({name = "Enable ESP", seperator = true, callback = function(bool) print(bool) end})
        section:toggle({name = "Through walls", seperator = true})
        local toggle = section:toggle({name = "Shared ESP", seperator = true}):colorpicker({})

            local toggle = section:toggle({name = "Name", seperator = true})
            toggle:colorpicker({})
            local sub_section = toggle:settings({})
            sub_section:toggle({name = "Show Display Names", seperator = true})
            sub_section:dropdown({name = "Font Name", items = {"ProggyTiny", "MonoSpace", "Tahoma"}, default = "MonoSpace", seperator = true})
            sub_section:colorpicker({name = "Another Colorpicker why not", seperator = true})
            sub_section:keybind({name = "Keybind", callback = function(bool) print(bool) end, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"})

        section:toggle({name = "Weapon", seperator = true, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"}):colorpicker({})
        section:dropdown({name = "Flags", items = {"Scoped", "Flashed", "Knocked", "Touched"}, default = {"Scoped", "Flashed", "Knocked"}, multi = true, seperator = true})
        section:toggle({name = "Other Shit", seperator = false}):colorpicker({})
    end
end

local enemies, teammates, self_section = window:tab({name = "Example", icon = "crosshair", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    for i = 1, 2 do
        local column = tab:column({})
        local section = column:section({name = "General", icon = "user", default = true})
        section:toggle({name = "Enable ESP", seperator = true, callback = function(bool) print(bool) end})
        section:toggle({name = "Through walls", seperator = true})
        local toggle = section:toggle({name = "Shared ESP", seperator = true}):colorpicker({})

            local toggle = section:toggle({name = "Name", seperator = true})
            toggle:colorpicker({})
            local sub_section = toggle:settings({})
            sub_section:toggle({name = "Show Display Names", seperator = true})
            sub_section:dropdown({name = "Font Name", items = {"ProggyTiny", "MonoSpace", "Tahoma"}, default = "MonoSpace", seperator = true})
            sub_section:colorpicker({name = "Another Colorpicker why not", seperator = true})
            sub_section:keybind({name = "Keybind", callback = function(bool) print(bool) end, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"})

        section:toggle({name = "Weapon", seperator = true, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"}):colorpicker({})
        section:dropdown({name = "Flags", items = {"Scoped", "Flashed", "Knocked", "Touched"}, default = {"Scoped", "Flashed", "Knocked"}, multi = true, seperator = true})
        section:toggle({name = "Other Shit", seperator = false}):colorpicker({})
    end
end

local enemies, teammates, self_section = window:tab({name = "Example", icon = "shield", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    local column = tab:column({})
    local section = column:section({name = "General", icon = "user", default = true})
    section:toggle({name = "Enable ESP", seperator = true, callback = function(bool) print(bool) end})
    section:toggle({name = "Through walls", seperator = true})
    local toggle = section:toggle({name = "Shared ESP", seperator = true}):colorpicker({})

        local toggle = section:toggle({name = "Name", seperator = true})
        toggle:colorpicker({})
        local sub_section = toggle:settings({})
        sub_section:toggle({name = "Show Display Names", seperator = true})
        sub_section:dropdown({name = "Font Name", items = {"ProggyTiny", "MonoSpace", "Tahoma"}, default = "MonoSpace", seperator = true})
        sub_section:colorpicker({name = "Another Colorpicker why not", seperator = true})
        sub_section:keybind({name = "Keybind", callback = function(bool) print(bool) end, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"})

    section:toggle({name = "Weapon", seperator = true, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"}):colorpicker({})
    section:dropdown({name = "Flags", items = {"Scoped", "Flashed", "Knocked", "Touched"}, default = {"Scoped", "Flashed", "Knocked"}, multi = true, seperator = true})
    section:toggle({name = "Other Shit", seperator = false}):colorpicker({})
end

local enemies, teammates, self_section = window:tab({name = "Example", icon = "users", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    local column = tab:column({})

    for i = 1, 2 do
        local section = column:section({name = "General", icon = "user", default = true, size = 0.5})
        section:toggle({name = "Enable ESP", seperator = true, callback = function(bool) print(bool) end})
        section:toggle({name = "Through walls", seperator = true})
        local toggle = section:toggle({name = "Shared ESP", seperator = true}):colorpicker({})

            local toggle = section:toggle({name = "Name", seperator = true})
            toggle:colorpicker({})
            local sub_section = toggle:settings({})
            sub_section:toggle({name = "Show Display Names", seperator = true})
            sub_section:dropdown({name = "Font Name", items = {"ProggyTiny", "MonoSpace", "Tahoma"}, default = "MonoSpace", seperator = true})
            sub_section:colorpicker({name = "Another Colorpicker why not", seperator = true})
            sub_section:keybind({name = "Keybind", callback = function(bool) print(bool) end, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"})

        section:toggle({name = "Weapon", seperator = true, info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"}):colorpicker({})
        section:dropdown({name = "Flags", items = {"Scoped", "Flashed", "Knocked", "Touched"}, default = {"Scoped", "Flashed", "Knocked"}, multi = true, seperator = true})
        section:toggle({name = "Other Shit", seperator = false}):colorpicker({})
    end
end

window:seperator({name = "Options"})
local aimbot_page = window:tab({name = "Aimbot", icon = "crosshair", tabs = {"Main"}})
local column = aimbot_page:column({})
local section = column:section({name = "Aimbot", icon = "crosshair", default = true, size = 1})

local aimbot = section:toggle({name = "Enable Aimbot", seperator = true, callback = function(bool) print(bool) end})
local aimbot_options = aimbot:group({})
aimbot_options:slider({name = "FOV", min = 0, max = 360, default = 90, suffix = "°", seperator = true})
aimbot_options:slider({name = "Smoothness", min = 0, max = 100, default = 20, suffix = "%", seperator = true})
aimbot_options:dropdown({name = "Hitbox", items = {"Head", "Torso", "Legs"}, default = "Head", seperator = true})
aimbot_options:dropdown({name = "Checks", items = {"Visible", "Alive", "Team"}, default = {"Alive"}, multi = true, seperator = true})
aimbot_options:toggle({name = "Draw FOV", seperator = true}):colorpicker({})

local silent = section:toggle({
    name = "Silent Aim",
    seperator = true,
    children = function(group)
        group:slider({name = "Hit Chance", min = 0, max = 100, default = 75, suffix = "%", seperator = true})
        group:dropdown({name = "Target Part", items = {"Head", "Torso"}, default = "Head", seperator = true})
    end
})

window:seperator({name = "Visuals"})
local esp = window:esp_manager({
    name = "Esp",
    icon = "scan-eye",
    settings = {
        Enabled = {Value = true, Visible = true},

        Box = {Value = true, Visible = true},
        BoxGradient = {Value = false, Visible = true},

        Skeleton = {Value = false, Visible = true},
        SkeletonGradient = {Value = false, Visible = true},
        SkeletonColor = {Value = Color3.fromRGB(255, 255, 255), Visible = true},
        SkeletonThickness = {Value = 2, Visible = true},

        Dot = {Value = false, Visible = true},
        DotGradient = {Value = false, Visible = true},
        DotColor = {Value = Color3.fromRGB(255, 255, 255), Visible = true},
        DotSize = {Value = 8, Visible = true},

        Glow = {Value = false, Visible = true},
        GlowGradient = {Value = false, Visible = true},
        GlowColor = {Value = Color3.fromRGB(255, 80, 180), Visible = true},
        GlowTransparency = {Value = 0.4, Visible = true},

        HealthBar = {Value = true, Visible = true},
        HealthBarGradient = {Value = false, Visible = true},

        HealthText = {Value = true, Visible = true},
        HealthTextGradient = {Value = false, Visible = true},

        Name = {Value = true, Visible = true},
        DisplayName = {Value = false, Visible = false},
        NameGradient = {Value = false, Visible = true},

        Avatar = {Value = false, Visible = false},

        Weapon = {Value = true, Visible = true},
        WeaponGradient = {Value = false, Visible = true},

        Backpack = {Value = false, Visible = false},
        BackpackGradient = {Value = false, Visible = false},

        Distance = {Value = true, Visible = true},
        DistanceGradient = {Value = false, Visible = true},

        GradientColor1 = {Value = Color3.fromRGB(255, 255, 255), Visible = true},
        GradientColor2 = {Value = Color3.fromRGB(255, 80, 180), Visible = true},

        GradientAnimation = {Value = false, Visible = true},
        GradientAnimationSpeed = {Value = 4, Visible = true}
    }
})

library:init_config(window)
