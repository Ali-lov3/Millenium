local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ali-lov3/Millenium/refs/heads/main/Source.lua"))()

local window = library:window({name = "nebula", suffix = "tech", gameInfo = "Milenium for Counter-Strike: Global Offensive"})

window:seperator({name = "General"})
local enemies, teammates, self_section = window:tab({name = "Example", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    local column = tab:column({})
    local section = column:section({name = "General", default = true, toggle = false})
    section:label({name = "This is a title!", info = "Hello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawdHello there this is a paragraph.. adawdawdawd\nextra info here ig"})

    local page = tab:sub_tab({order = -10000, size = 2})

    for i = 1, 2 do
        local column = page:column({})
        local section = column:section({name = "General", default = true})
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

local enemies, teammates, self_section = window:tab({name = "Example", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    for i = 1, 2 do
        local column = tab:column({})
        local section = column:section({name = "General", default = true})
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

local enemies, teammates, self_section = window:tab({name = "Example", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    local column = tab:column({})
    local section = column:section({name = "General", default = true})
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

local enemies, teammates, self_section = window:tab({name = "Example", tabs = {"Enemies", "Teammates", "Self"}})
for _,tab in {enemies, teammates, self_section} do
    local column = tab:column({})

    for i = 1, 2 do
        local section = column:section({name = "General", default = true, size = 0.5})
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

window:seperator({name = "Visuals"})
local esp = window:esp_manager({name = "Esp"})

library:init_config(window)
