    local uis = game:GetService("UserInputService")
    local players = game:GetService("Players")
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer
    local mouse = lp:GetMouse()
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max
    local floor = math.floor
    local min = math.min
    local abs = math.abs
    local noise = math.noise
    local rad = math.rad
    local random = math.random
    local pow = math.pow
    local sin = math.sin
    local pi = math.pi
    local tan = math.tan
    local atan2 = math.atan2
    local clamp = math.clamp

    local insert = table.insert
    local find = table.find
    local remove = table.remove
    local concat = table.concat

    local is_mobile = uis.TouchEnabled and not uis.KeyboardEnabled

    local function is_press(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
    end

    local function is_move(input)
        return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
    end

    local Lucide
    pcall(function()
        Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/icons.lua"))()
    end)

    local function ResolveIcon(Icon)
        if type(Icon) == "number" then return "rbxassetid://" .. Icon end
        if type(Icon) == "string" then
            if string.match(Icon, "^rbxassetid://") then return Icon end
            if string.match(Icon, "^rbxasset") or string.match(Icon, "^https?://") then return Icon end
            if string.match(Icon, "^%d+$") then return "rbxassetid://" .. Icon end
            local Name = string.lower(Icon)
            if type(Lucide) == "function" then
                local ok, Data = pcall(Lucide, Name)
                if ok and type(Data) == "table" then
                    local Id = Data.id or Data.Id or Data[1]
                    local Size = Data.imageRectSize or Data.ImageRectSize or Data[2]
                    local Offset = Data.imageRectOffset or Data.imageRectPosition or Data.ImageRectOffset or Data[3]
                    if Id then return "rbxassetid://" .. tostring(Id), Offset, Size end
                end
            elseif type(Lucide) == "table" then
                for _, Set in { Lucide["48px"], Lucide["256px"], Lucide } do
                    if type(Set) == "table" then
                        local Data = Set[Name]
                        if type(Data) == "table" and Data[1] then
                            return "rbxassetid://" .. tostring(Data[1]), Data[3], Data[2]
                        end
                    end
                end
            end
        end
        return "rbxassetid://0"
    end

    local function ToVector2(Value)
        if typeof(Value) == "Vector2" then return Value end
        if type(Value) == "table" then return Vector2.new(Value[1] or Value.X or 0, Value[2] or Value.Y or 0) end
        return Vector2.new(0, 0)
    end

    local function ApplyIcon(Object, Icon)
        if not Icon then return end
        local Image, Offset, Size = ResolveIcon(Icon)
        Object.Image = Image
        Object.ImageRectOffset = Offset and ToVector2(Offset) or Vector2.new(0, 0)
        Object.ImageRectSize = Size and ToVector2(Size) or Vector2.new(0, 0)
    end

    local library = {
        directory = "milenium",
        config_path = "milenium/configs",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},
        connections = {},
        notifications = {notifs = {}},
        current_open;
        scale = 1,
        is_mobile = is_mobile,
    }

    getgenv().library = library

    local themes = {
        preset = {
            accent = rgb(155, 150, 219),
        },

        utility = {
            accent = {
                BackgroundColor3 = {},
                TextColor3 = {},
                ImageColor3 = {},
                ScrollBarImageColor3 = {}
            },
        }
    }

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ";",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }

    library.__index = library

    for _, path in next, library.folders do
        makefolder(library.directory .. path)
    end

    local flags = library.flags
    local config_flags = library.config_flags
    local notifications = library.notifications

    local fonts = {}; do
        function Register_Font(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            writefile(Name .. ".font", http_service:JSONEncode(Data))

            return getcustomasset(Name .. ".font");
        end

        local Medium = Register_Font("Medium", 200, "Normal", {
            Id = "Medium.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
        })

        local SemiBold = Register_Font("SemiBold", 200, "Normal", {
            Id = "SemiBold.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
        })

        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end

        function library:tween(obj, properties, easing_style, time)
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties)
            tween:Play()

            return tween
        end

        function library:calc_scale(size)
            local vp = camera.ViewportSize
            local w = size.X.Offset
            local h = size.Y.Offset

            return clamp(min((vp.X * 0.92) / w, (vp.Y * 0.92) / h, 1), 0.35, 1)
        end

        function library:resizify(frame)
            local handle_size = is_mobile and 28 or 10

            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -handle_size, 1, -handle_size)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, handle_size, 0, handle_size)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1
            Frame.Text = ""

            local resizing = false
            local start_size
            local start
            local og_size = frame.Size

            Frame.InputBegan:Connect(function(input)
                if is_press(input) then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if is_press(input) then
                    resizing = false
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if is_press(input) then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event)
                if resizing and is_move(input) then
                    local sc = library.scale or 1
                    local viewport_x = camera.ViewportSize.X / sc
                    local viewport_y = camera.ViewportSize.Y / sc

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + ((input.Position.X - start.X) / sc),
                            og_size.X.Offset,
                            max(viewport_x, og_size.X.Offset)
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + ((input.Position.Y - start.Y) / sc),
                            og_size.Y.Offset,
                            max(viewport_y, og_size.Y.Offset)
                        )
                    )

                    library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
                end
            end)
        end

        function fag(tbl)
            local Size = 0

            for _ in tbl do
                Size = Size + 1
            end

            return Size
        end

        function library:next_flag()
            local index = fag(library.flags) + 1;
            local str = string.format("flagnumber%s", index)

            return str;
        end

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            local dragging = false
            local start_size = frame.Position
            local start

            frame.InputBegan:Connect(function(input)
                if is_press(input) then
                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if is_press(input) then
                    dragging = false
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if is_press(input) then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event)
                if dragging and is_move(input) then
                    local sc = library.scale or 1
                    local viewport_x = camera.ViewportSize.X / sc
                    local viewport_y = camera.ViewportSize.Y / sc

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + ((input.Position.X - start.X) / sc),
                            0,
                            max(viewport_x - frame.Size.X.Offset, 0)
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + ((input.Position.Y - start.Y) / sc),
                            0,
                            max(viewport_y - frame.Size.Y.Offset, 0)
                        )
                    )

                    library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
                    library:close_element()
                end
            end)
        end

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end

            if #values == 4 then
                return unpack(values)
            else
                return
            end
        end

        function library:convert_enum(enum)
            local enum_parts = {}

            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end

            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]

                enum_table = enum_item
            end

            return enum_table
        end

        local config_holder;
        function library:update_config_list()
            if not config_holder then
                return
            end

            local list = {}

            for idx, file in listfiles(library.config_path) do
                local name = string.match(file, "([^/\\]+)$") or file
                name = string.gsub(name, "%.cfg$", "")
                list[#list + 1] = name
            end

            config_holder.refresh_options(list)
        end

        function library:get_config()
            local Config = {}

            for _, v in next, flags do
                if type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end

            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json)
            local config = http_service:JSONDecode(config_json)

            for _, v in config do
                local function_set = library.config_flags[_]

                if _ == "config_name_list" then
                    continue
                end

                if function_set then
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then
                        function_set(v)
                    else
                        function_set(v)
                    end
                end
            end
        end

        function library:round(number, float)
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end

        function library:apply_theme(instance, theme, property)
            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            for _, property in themes.utility[theme] do

                for m, object in property do
                    if object[_] == themes.preset[theme] then
                        object[_] = color
                    end
                end
            end

            themes.preset[theme] = color
        end

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)

            insert(library.connections, connection)

            return connection
        end

        function library:close_element(new_path)
            local open_element = library.current_open

            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end

            if new_path ~= open_element then
                library.current_open = new_path or nil;
            end
        end

        function library:create(instance, options)
            local ins = Instance.new(instance)

            for prop, value in options do
                ins[prop] = value
            end

            return ins
        end

        function library:unload_menu()
            if library[ "esp_unload" ] then
                library.esp_unload()
            end

            if library[ "items" ] then
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then
                library[ "other" ]:Destroy()
            end

            if library[ "toggle_gui" ] then
                library[ "toggle_gui" ]:Destroy()
            end

            for index, connection in library.connections do
                connection:Disconnect()
                connection = nil
            end

            getgenv().library = nil
        end

        function library:window(properties)
            local accent_color = properties.AccentColor or properties.accentColor or properties.accent_color or properties.Accent or properties.accent

            if typeof(accent_color) == "Color3" then
                themes.preset.accent = accent_color
            end

            local config_folder = properties.ConfigFolder or properties.configFolder or properties.config_folder

            if type(config_folder) == "string" and config_folder ~= "" then
                config_folder = string.gsub(config_folder, "[/\\]+$", "")

                library.config_path = config_folder

                local current_path = ""

                for segment in string.gmatch(config_folder, "[^/\\]+") do
                    current_path = current_path == "" and segment or (current_path .. "/" .. segment)

                    if not isfolder(current_path) then
                        makefolder(current_path)
                    end
                end
            end

            local forced_scale = properties.scale or properties.Scale
            local default_size = is_mobile and dim2(0, 640, 0, 418) or dim2(0, 700, 0, 565)

            local cfg = {
                suffix = properties.suffix or properties.Suffix or "tech";
                name = properties.name or properties.Name or "nebula";
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "Milenium for Counter-Strike: Global Offensive";
                size = properties.size or properties.Size or default_size;
                selected_tab;
                items = {};

                tween;

                auto_scale = (forced_scale == nil) and is_mobile;
                scale = 1;
                mobile_button = properties.mobile_button;
            }

            if cfg.mobile_button == nil then
                cfg.mobile_button = properties.MobileButton
            end

            if cfg.mobile_button == nil then
                cfg.mobile_button = is_mobile
            end

            cfg.scale = forced_scale or (is_mobile and library:calc_scale(cfg.size)) or 1
            library.scale = cfg.scale

            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });

            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });

            library[ "root" ] = library:create( "Frame" , {
                Parent = library[ "items" ];
                Name = "\0";
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = dim2(0, 0, 0, 0);
                Size = dim2(1 / cfg.scale, 0, 1 / cfg.scale, 0);
                BackgroundColor3 = rgb(255, 255, 255);
            });

            library[ "ui_scale" ] = library:create( "UIScale" , {
                Parent = library[ "root" ];
                Scale = cfg.scale;
            });

            local items = cfg.items; do
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "root" ];
                    Size = cfg.size;
                    Name = "\0";
                    Position = dim2(0, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                do
                    local vp = camera.ViewportSize
                    local spawn_x = (vp.X / cfg.scale - cfg.size.X.Offset) / 2
                    local spawn_y = (vp.Y / cfg.scale - cfg.size.Y.Offset) / 2 - (is_mobile and 20 or 80)

                    items[ "main" ].Position = dim2(
                        0, max(spawn_x, 0),
                        0, max(spawn_y, 8)
                    )
                end

                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 10)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "main" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                items[ "side_frame" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 196, 1, -25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                library:create( "Frame" , {
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "side_frame" ];
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });

                items[ "button_holder" ] = library:create( "ScrollingFrame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 60);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -60);
                    BorderSizePixel = 0;
                    Active = true;
                    ScrollBarThickness = 0;
                    CanvasSize = dim2(0, 0, 0, 0);
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollingDirection = Enum.ScrollingDirection.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.button_holder = items[ "button_holder" ];

                library:create( "UIListLayout" , {
                    Parent = items[ "button_holder" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 16);
                    PaddingBottom = dim(0, 36);
                    Parent = items[ "button_holder" ];
                    PaddingRight = dim(0, 11);
                    PaddingLeft = dim(0, 10)
                });

                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Text = string.format('<u>%s</u><font color = "rgb(255, 255, 255)">%s</font>', cfg.name, cfg.suffix);
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 70);
                    TextColor3 = themes.preset.accent;
                    BorderSizePixel = 0;
                    RichText = true;
                    TextSize = 30;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "title" ], "accent", "TextColor3");

                items[ "multi_holder" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 0, 56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.multi_holder = items[ "multi_holder" ];

                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "multi_holder" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });

                items[ "shadow" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    Parent = items[ "main" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Name = "\0";
                    BackgroundColor3 = rgb(255, 255, 255);
                    Size = dim2(1, 75, 1, 75);
                    AnchorPoint = vec2(0.5, 0.5);
                    Image = "rbxassetid://112971167999062";
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 0.5, 0);
                    SliceScale = 0.75;
                    ZIndex = -100;
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(112, 112), vec2(147, 147))
                });

                items[ "global_fade" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 1, -81);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16);
                    ZIndex = 2;
                });

                library:create( "UICorner" , {
                    Parent = items[ "shadow" ];
                    CornerRadius = dim(0, 5)
                });

                items[ "info" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "main" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });

                library:create( "UICorner" , {
                    Parent = items[ "info" ];
                    CornerRadius = dim(0, 10)
                });

                items[ "grey_fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "info" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });

                items[ "game" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    Parent = items[ "info" ];
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.game_name;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 10, 0.5, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            end

            do
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end

            function cfg.set_scale(value)
                value = clamp(value, 0.25, 3)

                cfg.scale = value
                library.scale = value

                library[ "ui_scale" ].Scale = value
                library[ "root" ].Size = dim2(1 / value, 0, 1 / value, 0)

                local vp = camera.ViewportSize
                local main = items[ "main" ]

                main.Position = dim2(
                    0, clamp(main.Position.X.Offset, 0, max(vp.X / value - main.Size.X.Offset, 0)),
                    0, clamp(main.Position.Y.Offset, 0, max(vp.Y / value - main.Size.Y.Offset, 0))
                )

                library:close_element()
            end

            library:connection(camera:GetPropertyChangedSignal("ViewportSize"), function()
                if cfg.auto_scale then
                    cfg.set_scale(library:calc_scale(items[ "main" ].Size))
                end
            end)

            function cfg.toggle_menu(bool)

                library[ "items" ].Enabled = bool

                if cfg.menu_bind then
                    cfg.menu_bind.active = bool
                end

                if not bool then
                    library:close_element()
                end

                if items[ "mobile_button" ] then
                    library:tween(items[ "mobile_button" ], {BackgroundTransparency = bool and 0 or 0.35})
                end
            end

            if cfg.mobile_button then
                local button_size = 50

                library[ "toggle_gui" ] = library:create( "ScreenGui" , {
                    Parent = coregui;
                    Name = "\0";
                    Enabled = true;
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                    IgnoreGuiInset = true;
                });

                items[ "mobile_button" ] = library:create( "TextButton" , {
                    Parent = library[ "toggle_gui" ];
                    Name = "\0";
                    AutoButtonColor = false;
                    Text = string.upper(string.sub(cfg.name, 1, 1));
                    FontFace = fonts.font;
                    TextSize = 24;
                    TextColor3 = themes.preset.accent;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16);
                    BackgroundTransparency = 0;
                    Size = dim2(0, button_size, 0, button_size);
                    Position = dim2(0, 15, 0, 70);
                }); library:apply_theme(items[ "mobile_button" ], "accent", "TextColor3");

                library:create( "UICorner" , {
                    Parent = items[ "mobile_button" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIStroke" , {
                    Color = rgb(40, 40, 46);
                    Thickness = 1.5;
                    Parent = items[ "mobile_button" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                local pressing = false
                local moved = false
                local press_pos
                local start_pos

                items[ "mobile_button" ].InputBegan:Connect(function(input)
                    if is_press(input) then
                        pressing = true
                        moved = false
                        press_pos = input.Position
                        start_pos = items[ "mobile_button" ].Position
                    end
                end)

                library:connection(uis.InputChanged, function(input)
                    if pressing and is_move(input) then
                        local delta = input.Position - press_pos

                        if delta.Magnitude > 8 then
                            moved = true
                        end

                        if moved then
                            local vp = camera.ViewportSize

                            items[ "mobile_button" ].Position = dim2(
                                0, clamp(start_pos.X.Offset + delta.X, 0, vp.X - button_size),
                                0, clamp(start_pos.Y.Offset + delta.Y, 0, vp.Y - button_size)
                            )
                        end
                    end
                end)

                library:connection(uis.InputEnded, function(input)
                    if pressing and is_press(input) then
                        pressing = false

                        if not moved then
                            cfg.toggle_menu(not library[ "items" ].Enabled)
                        end
                    end
                end)
            end

            return setmetatable(cfg, library)
        end

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals";
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";

                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {};
                current_multi;

                items = {};
            }

            local items = cfg.items; do
                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    Name = "\0";
                    Visible = false;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -216, 1, -101);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                    items[ "button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "button_holder" ];
                        AutoButtonColor = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 35);
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(29, 29, 29)
                    });

                    items[ "icon" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "button" ];
                        AnchorPoint = vec2(0, 0.5);
                        Image = "http://www.roblox.com/asset/?id=6034767608";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 10, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 22, 0, 22);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3"); ApplyIcon(items[ "icon" ], cfg.icon);

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "button" ];
                        Name = "\0";
                        Size = dim2(0, 0, 1, 0);
                        Position = dim2(0, 40, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "button" ];
                        CornerRadius = dim(0, 7)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(23, 23, 29);
                        Parent = items[ "button" ];
                        Enabled = false;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    });

                    items[ "multi_section_button_holder" ] = library:create( "ScrollingFrame" , {
                        Parent = library.cache;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        Active = true;
                        ScrollBarThickness = 2;
                        ScrollBarImageColor3 = rgb(44, 44, 46);
                        CanvasSize = dim2(0, 0, 0, 0);
                        AutomaticCanvasSize = Enum.AutomaticSize.X;
                        ScrollingDirection = Enum.ScrollingDirection.X;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    items[ "multi_section_button_holder" ].InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseWheel then
                            local holder = items[ "multi_section_button_holder" ]
                            local limit = max(holder.AbsoluteCanvasSize.X - holder.AbsoluteSize.X, 0)

                            holder.CanvasPosition = vec2(clamp(holder.CanvasPosition.X - input.Position.Z * 40, 0, limit), 0)
                        end
                    end)

                    library:create( "UIListLayout" , {
                        Parent = items[ "multi_section_button_holder" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });

                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 8);
                        PaddingBottom = dim(0, 7);
                        Parent = items[ "multi_section_button_holder" ];
                        PaddingRight = dim(0, 7);
                        PaddingLeft = dim(0, 7)
                    });

                    for _, section in cfg.tabs do
                        local data = {items = {}}

                        local multi_items = data.items; do
                                multi_items[ "button" ] = library:create( "TextButton" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(255, 255, 255);
                                    BorderColor3 = rgb(0, 0, 0);
                                    AutoButtonColor = false;
                                    Text = "";
                                    Parent = items[ "multi_section_button_holder" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 0, 39);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.X;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(25, 25, 29)
                                });

                                multi_items[ "name" ] = library:create( "TextLabel" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(62, 62, 63);
                                    BorderColor3 = rgb(0, 0, 0);
                                    Text = section;
                                    Parent = multi_items[ "button" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 1, 0);
                                    BackgroundTransparency = 1;
                                    TextXAlignment = Enum.TextXAlignment.Left;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.XY;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });

                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "name" ];
                                    PaddingRight = dim(0, 5);
                                    PaddingLeft = dim(0, 5)
                                });

                                multi_items[ "accent" ] = library:create( "Frame" , {
                                    BorderColor3 = rgb(0, 0, 0);
                                    AnchorPoint = vec2(0, 1);
                                    Parent = multi_items[ "button" ];
                                    BackgroundTransparency = 1;
                                    Position = dim2(0, 10, 1, 4);
                                    Name = "\0";
                                    Size = dim2(1, -20, 0, 6);
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = themes.preset.accent
                                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");

                                library:create( "UICorner" , {
                                    Parent = multi_items[ "accent" ];
                                    CornerRadius = dim(0, 999)
                                });

                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "button" ];
                                    PaddingRight = dim(0, 10);
                                    PaddingLeft = dim(0, 10)
                                });

                                library:create( "UICorner" , {
                                    Parent = multi_items[ "button" ];
                                    CornerRadius = dim(0, 7)
                                });

                                multi_items[ "tab" ] = library:create( "Frame" , {
                                    Parent = library.cache;
                                    BackgroundTransparency = 1;
                                    Name = "\0";
                                    BorderColor3 = rgb(0, 0, 0);
                                    Size = dim2(1, -20, 1, -20);
                                    BorderSizePixel = 0;
                                    Visible = false;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });

                                library:create( "UIListLayout" , {
                                    FillDirection = Enum.FillDirection.Vertical;
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                    Parent = multi_items[ "tab" ];
                                    Padding = dim(0, 7);
                                    SortOrder = Enum.SortOrder.LayoutOrder;
                                    VerticalFlex = Enum.UIFlexAlignment.Fill
                                });

                                library:create( "UIPadding" , {
                                    PaddingTop = dim(0, 7);
                                    PaddingBottom = dim(0, 7);
                                    Parent = multi_items[ "tab" ];
                                    PaddingRight = dim(0, 7);
                                    PaddingLeft = dim(0, 7)
                                });
                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]

                        function data.open_page()
                            local page = cfg.current_multi;

                            if page and page.text ~= data.text then
                                self.items[ "global_fade" ].BackgroundTransparency = 0
                                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)

                                local old_size = page.page.Size
                                page.page.Size = dim2(1, -20, 1, -20)
                            end

                            if page then
                                library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                                library:tween(page.accent, {BackgroundTransparency = 1})
                                library:tween(page.button, {BackgroundTransparency = 1})

                                page.page.Visible = false
                                page.page.Parent = library[ "cache" ]
                            end

                            library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                            library:tween(data.accent, {BackgroundTransparency = 0})
                            library:tween(data.button, {BackgroundTransparency = 0})
                            library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                            data.page.Visible = true
                            data.page.Parent = items["tab_holder"]

                            cfg.current_multi = data

                            library:close_element()
                        end

                        multi_items[ "button" ].MouseButton1Down:Connect(function()
                            data.open_page()
                        end)

                        cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                    end

                    if cfg.pages[1] then
                        cfg.pages[1].open_page()
                    end
            end

            function cfg.open_tab()
                local selected_tab = self.selected_tab

                if selected_tab then
                    if selected_tab[ 4 ] ~= items[ "tab_holder" ] then
                        self.items[ "global_fade" ].BackgroundTransparency = 0

                        library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                        selected_tab[ 4 ].Size = dim2(1, -216, 1, -101)
                    end

                    library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
                    library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
                    library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

                    selected_tab[ 4 ].Visible = false
                    selected_tab[ 4 ].Parent = library[ "cache" ]
                    selected_tab[ 5 ].Visible = false
                    selected_tab[ 5 ].Parent = library[ "cache" ]
                end

                library:tween(items[ "button" ], {BackgroundTransparency = 0})
                library:tween(items[ "icon" ], {ImageColor3 = themes.preset.accent})
                library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
                library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)

                items[ "tab_holder" ].Visible = true
                items[ "tab_holder" ].Parent = self.items[ "main" ]
                items[ "multi_section_button_holder" ].Visible = true
                items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

                self.selected_tab = {
                    items[ "button" ];
                    items[ "icon" ];
                    items[ "name" ];
                    items[ "tab_holder" ];
                    items[ "multi_section_button_holder" ];
                }

                library:close_element()
            end

            items[ "button" ].MouseButton1Down:Connect(function()
                cfg.open_tab()
            end)

            if not self.selected_tab then
                cfg.open_tab(true)
            end

            return unpack(cfg.pages)
        end

        function library:seperator(properties)
            local cfg = {items = {}, name = properties.Name or properties.name or "General"}

            local items = cfg.items do
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = self.items[ "button_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
            end;

            return setmetatable(cfg, library)
        end

            function library:column(properties)
                local cfg = {items = {}, size = properties.size or 1}

                local column_parent = self[ "parent" ] or self.items["tab_parent"]
                column_parent.Visible = true

                local items = cfg.items; do
                    items[ "column" ] = library:create( "Frame" , {
                        Parent = column_parent;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, cfg.size, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = items[ "column" ]
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 10);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                end

                return setmetatable(cfg, library)
            end

            function library:sub_tab(properties)
                local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

                local items = cfg.items; do
                    items[ "tab_parent" ] = library:create( "Frame" , {
                        Parent = self.items[ "tab" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(0,0,cfg.size,0);
                        LayoutOrder = cfg.order;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Visible = false;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = items[ "tab_parent" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                return setmetatable(cfg, library)
            end

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section";
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5;
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                items = {};
            };

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "column" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, cfg.size, -3);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(44, 44, 46);
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = is_mobile and 4 or 2;
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Size = dim2(1, 0, 1, -40);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 35);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0)
                });

                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });

                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundColor3 = rgb(19, 19, 21)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "Icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = cfg.icon;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3"); ApplyIcon(items[ "Icon" ], cfg.icon);

                items[ "section_title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "button" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });

                if cfg.fading_toggle then
                    items[ "toggle" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "button" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(58, 58, 62)
                    });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "toggle" ];
                        CornerRadius = dim(0, 999)
                    });

                    items[ "toggle_outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(50, 50, 50)
                    });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "toggle_outline" ];
                        CornerRadius = dim(0, 999)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "toggle_outline" ]
                    });

                    items[ "toggle_circle" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_outline" ];
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(86, 86, 88)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "toggle_circle" ];
                        CornerRadius = dim(0, 999)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 7)
                    });

                    items[ "fade" ] = library:create( "Frame" , {
                        Parent = items[ "outline" ];
                        BackgroundTransparency = 0.800000011920929;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "fade" ];
                        CornerRadius = dim(0, 7)
                    });
                end
            end;

            if cfg.fading_toggle then
                items[ "button" ].MouseButton1Click:Connect(function()
                    cfg.default = not cfg.default
                    cfg.toggle_section(cfg.default)
                end)

                function cfg.toggle_section(bool)
                    library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end

                cfg.toggle_section(cfg.default)
            end

            return setmetatable(cfg, library)
        end

        function library:toggle(options)
            local cfg = {
                enabled = options.enabled or options.default or false,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),

                type = options.type and string.lower(options.type) or "toggle";

                default = options.default or false,
                folding = options.folding or false,
                callback = options.callback or function() end,

                items = {};
                groups = {};
                seperator = options.seperator or options.Seperator or false;
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "toggle" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                    if cfg.type == "checkbox" then
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AutoButtonColor = false;
                            AnchorPoint = vec2(1, 0);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 16, 0, 16);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = rgb(67, 67, 68)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 4)
                        });

                        items[ "outline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(22, 22, 24)
                        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");

                        items[ "tick" ] = library:create( "ImageLabel" , {
                            ImageTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Image = "rbxassetid://111862698467575";
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            Parent = items[ "outline" ];
                            Size = dim2(1, 2, 1, 2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ZIndex = 1;
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "outline" ];
                            CornerRadius = dim(0, 4)
                        });

                        library:create( "UIGradient" , {
                            Enabled = false;
                            Parent = items[ "outline" ];
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                        });
                    else
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AnchorPoint = vec2(1, 0.5);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, -9, 0.5, 0);
                            Size = dim2(0, 36, 0, 18);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 999)
                        });

                        items[ "inline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "inline" ];
                            CornerRadius = dim(0, 999)
                        });

                        library:create( "UIGradient" , {
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                            Parent = items[ "inline" ]
                        });

                        items[ "circle" ] = library:create( "Frame" , {
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Position = dim2(1, -14, 0, 2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "circle" ];
                            CornerRadius = dim(0, 999)
                        });
                    end
            end;

            function cfg.set(bool)
                cfg.enabled = bool

                if cfg.type == "checkbox" then
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end

                cfg.callback(bool)

                flags[cfg.flag] = bool

                if #cfg.groups > 0 then
                    if not bool then
                        library:close_element()
                    end

                    for _, group in next, cfg.groups do
                        group.items[ "elements" ].Visible = bool
                    end
                end
            end

            items[ "toggle" ].MouseButton1Click:Connect(function()
                cfg.enabled = not cfg.enabled
                cfg.set(cfg.enabled)
            end)

            items[ "toggle_button" ].MouseButton1Click:Connect(function()
                cfg.enabled = not cfg.enabled
                cfg.set(cfg.enabled)
            end)

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            local object = setmetatable(cfg, library)

            if type(options.children) == "function" then
                options.children(object:group({}))
            end

            return object
        end

        function library:group(options)
            options = options or {}

            local cfg = {
                owner = self;
                items = {};
            }

            local items = cfg.items; do
                items[ "elements" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "toggle" ].Parent;
                    BackgroundTransparency = 1;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    Visible = self.enabled and true or false;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    Parent = items[ "elements" ];
                    PaddingLeft = dim(0, options.indent == nil and 10 or options.indent)
                });
            end

            insert(self.groups, cfg)

            return setmetatable(cfg, library)
        end

        function library:slider(options)
            local seperator = options.seperator

            if seperator == nil then
                seperator = options.Seperator
            end

            if seperator == nil then
                seperator = true
            end

            local cfg = {
                name = options.name or "Slider",
                suffix = options.suffix or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                info = options.info or nil;

                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10,
                seperator = seperator;

                dragging = false,
                items = {}
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 37);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 23);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });

                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 4);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 0, 4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "circle" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = items[ "fill" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(244, 244, 244)
                });

                library:create( "UICorner" , {
                    Parent = items[ "circle" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4)
                });

                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "50%";
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 6, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "value" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
            end

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 4)}, Enum.EasingStyle.Linear, 0.05)
                items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
            end

            local function begin_drag(x)
                cfg.dragging = true
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)

                if x then
                    local size_x = (x - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X
                    cfg.set(((cfg.max - cfg.min) * clamp(size_x, 0, 1)) + cfg.min)
                end
            end

            items[ "slider" ].MouseButton1Down:Connect(function(x)
                begin_drag(x)
            end)

            if is_mobile then
                items[ "slider_object" ].MouseButton1Down:Connect(function(x)
                    begin_drag(x)
                end)
            end

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and is_move(input) then
                    local size_x = (input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X
                    local value = ((cfg.max - cfg.min) * clamp(size_x, 0, 1)) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if is_press(input) then
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2)
                end
            end)

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:dropdown(options)
            local seperator = options.seperator

            if seperator == nil then
                seperator = options.Seperator
            end

            if seperator == nil then
                seperator = true
            end

            local cfg = {
                name = options.name or nil;
                info = options.info or nil;
                flag = options.flag or library:next_flag();
                options = options.items or {""};
                callback = options.callback or function() end;
                multi = options.multi or false;
                scrolling = options.scrolling or false;

                width = options.width or 130;

                open = false;
                option_instances = {};
                multi_items = {};
                ignore = options.ignore or false;
                items = {};
                y_size;
                seperator = seperator;
            }

            cfg.default = options.default or (cfg.multi and {}) or cfg.options[1] or "None"
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                    items[ "dropdown_object" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name or "Dropdown";
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if cfg.info then
                        items[ "info" ] = library:create( "TextLabel" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(130, 130, 130);
                            BorderColor3 = rgb(0, 0, 0);
                            TextWrapped = true;
                            Text = cfg.info;
                            Parent = items[ "dropdown_object" ];
                            Name = "\0";
                            Position = dim2(0, 5, 0, 17);
                            Size = dim2(1, -10, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 16;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    end

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    items[ "dropdown" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, cfg.width, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "dropdown" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "sub_text" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "awdawdawdawdawdawdawdaw";
                        Parent = items[ "dropdown" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "sub_text" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "indicator" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://101025591575185";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -5, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local function fit_width()
                        local sc = library.scale or 1
                        local avail = items[ "dropdown_object" ].AbsoluteSize.X / sc - items[ "name" ].TextBounds.X - 20
                        items[ "dropdown" ].Size = dim2(0, clamp(avail, 60, cfg.width), 0, 16)
                    end

                    items[ "dropdown_object" ]:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit_width)
                    items[ "name" ]:GetPropertyChangedSignal("TextBounds"):Connect(fit_width)
                    fit_width()

                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "root" ];
                        Name = "\0";
                        Visible = true;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });

                    items[ "outline" ] = library:create( "ScrollingFrame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        Active = true;
                        CanvasSize = dim2(0, 0, 0, 0);
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 2;
                        ScrollBarImageColor3 = rgb(72, 72, 73);
                        ScrollingDirection = Enum.ScrollingDirection.Y;
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
            end

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 10;
                }); library:apply_theme(button, "accent", "TextColor3");

                library:create( "UIPadding" , {
                    Parent = button;
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                return button
            end

            function cfg.set_visible(bool)
                local sc = library.scale or 1
                local a = bool and math.min(cfg.y_size, 150) or 0

                library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X / sc, a)})

                items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X / sc, 0, (items[ "dropdown" ].AbsolutePosition.Y + 80) / sc)
                if not (self.sanity and library.current_open == self) then
                    library:close_element(cfg)
                end
            end

            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do
                    if option.Text == value or (isTable and find(value, option.Text)) then
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = themes.preset.accent
                    else
                        option.TextColor3 = rgb(72, 72, 73)
                    end
                end

                items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
                flags[cfg.flag] = isTable and selected or selected[1]

                cfg.callback(flags[cfg.flag])
            end

            function cfg.refresh_options(list)
                cfg.y_size = 0

                for _, option in cfg.option_instances do
                    option:Destroy()
                end

                cfg.option_instances = {}

                for _, option in list do
                    local button = cfg.render_option(option)
                    local option_height = button.AbsoluteSize.Y / (library.scale or 1)

                    if option_height < 12 then
                        option_height = 16
                    end

                    cfg.y_size += option_height + 6
                    insert(cfg.option_instances, button)

                    local function choose()
                        if cfg.multi then
                            local selected_index = find(cfg.multi_items, button.Text)

                            if selected_index then
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end

                            cfg.set(cfg.multi_items)
                        else
                            cfg.set_visible(false)
                            cfg.open = false

                            cfg.set(button.Text)
                        end
                    end

                    local press_input, press_position

                    button.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            press_input = input
                            press_position = input.Position
                        end
                    end)

                    button.InputEnded:Connect(function(input)
                        if input == press_input and press_position then
                            local moved = (input.Position - press_position).Magnitude

                            press_input = nil
                            press_position = nil

                            if moved <= 10 then
                                choose()
                            end
                        end
                    end)
                end
            end

            items[ "dropdown" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            flags[cfg.flag] = {}
            config_flags[cfg.flag] = cfg.set

            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default)

            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                seperator = options.seperator or options.Seperator or false;
                info = options.info or nil;

                items = {};
            }

            local items = cfg.items; do
                items[ "label" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "label" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "label" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            return setmetatable(cfg, library)
        end

        function library:colorpicker(options)
            local cfg = {
                name = options.name or "Color",
                flag = options.flag or library:next_flag(),

                color = options.color or color(1, 1, 1),
                alpha = options.alpha and 1 - options.alpha or 0,

                open = false,
                callback = options.callback or function() end,
                items = {};

                seperator = options.seperator or options.Seperator or false;
            }

            local dragging_sat = false
            local dragging_hue = false
            local dragging_alpha = false

            local h, s, v = cfg.color:ToHSV()
            local a = cfg.alpha

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local label;
            if not self.items.right_components then
                label = self:label({name = cfg.name, seperator = cfg.seperator})
            end

            local items = cfg.items; do
                    items[ "colorpicker" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = label and label.items.right_components or self.items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "colorpicker_inline" ]
                    });

                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_fade" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        BackgroundTransparency = 0;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_components" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_components" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "saturation_holder" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 7, 0, 7);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -14, 1, -80);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });

                    items[ "sat" ] = library:create( "TextButton" , {
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "sat" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });

                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "saturation_holder" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "val" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "saturation_holder" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "satvalpicker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0.5, 0.5);
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "satvalpicker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "satvalpicker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });

                    items[ "hue_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -64);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutoButtonColor = false;
                        Text = "";
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = items[ "hue_gradient" ]
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "hue_gradient" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "hue_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0.5, 0.5);
                        Parent = items[ "hue_gradient" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "hue_picker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "hue_picker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });

                    items[ "alpha_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -46);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(25, 25, 29);
                        AutoButtonColor = false;
                        Text = "";
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_gradient" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "alpha_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0.5, 0.5);
                        Parent = items[ "alpha_gradient" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_picker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Parent = items[ "alpha_picker" ]
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = items[ "alpha_gradient" ]
                    });

                    items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "alpha_gradient" ];
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 6, 0, 6);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                        Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                        Parent = items[ "alpha_indicator" ]
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_indicator" ];
                        CornerRadius = dim(0, 6)
                    });

                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "colorpicker_components" ];
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                    });

                    items[ "input" ] = library:create( "TextBox" , {
                        FontFace = fonts.font;
                        AnchorPoint = vec2(1, 1);
                        Text = "";
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        PlaceholderColor3 = rgb(255, 255, 255);
                        CursorPosition = -1;
                        ClearTextOnFocus = false;
                        TextSize = 14;
                        TextColor3 = rgb(72, 72, 72);
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(1, -8, 1, -11);
                        Size = dim2(1, -16, 0, 18);
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "input" ];
                        CornerRadius = dim(0, 3)
                    });

                    items[ "UICorenr" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
            end;

            function cfg.set_visible(bool)
                local sc = library.scale or 1

                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "root" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X / sc, (items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45) / sc)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)})

                if not (self.sanity and library.current_open == self and self.open) then
                    library:close_element(cfg)
                end
            end

            function cfg.set(color, alpha)
                if type(color) == "boolean" then
                    return
                end

                if color then
                    h, s, v = color:ToHSV()
                end

                if alpha then
                    a = alpha
                end

                local Color = hsv(h, s, v)

                library:tween(items[ "hue_picker" ], {Position = dim2(h, 0, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(1 - a, 0, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(s, 0, 1 - v, 0)}, Enum.EasingStyle.Linear, 0.05)

                items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))};

                items[ "colorpicker" ].BackgroundColor3 = Color
                items[ "colorpicker_inline" ].BackgroundColor3 = Color
                items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

                items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
                items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
                items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a
                }

                local color = items[ "colorpicker" ].BackgroundColor3
                items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                items[ "input" ].Text ..= library:round(1 - a, 0.01)

                cfg.callback(Color, a)
            end

            function cfg.update_color(pos)
                local offset = vec2(pos.X, pos.Y)

                if dragging_sat then
                    s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
                end

                cfg.set()
            end

            items[ "colorpicker" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputChanged, function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and is_move(input) then
                    cfg.update_color(input.Position)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if is_press(input) then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false
                end
            end)

            items[ "alpha_gradient" ].MouseButton1Down:Connect(function(x, y)
                dragging_alpha = true

                if x and y then
                    cfg.update_color(vec2(x, y))
                end
            end)

            items[ "hue_gradient" ].MouseButton1Down:Connect(function(x, y)
                dragging_hue = true

                if x and y then
                    cfg.update_color(vec2(x, y))
                end
            end)

            items[ "sat" ].MouseButton1Down:Connect(function(x, y)
                dragging_sat = true

                if x and y then
                    cfg.update_color(vec2(x, y))
                end
            end)

            items[ "input" ].FocusLost:Connect(function()
                local text = items[ "input" ].Text
                local r, g, b, a = library:convert(text)

                if r and g and b and a then
                    cfg.set(rgb(r, g, b), 1 - a)
                end
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)

            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:textbox(options)
            local cfg = {
                name = options.name or "TextBox",
                placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
                default = options.default or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                visible = options.visible or true,
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = -1;
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 19);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });

                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(255, 255, 255);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 30);
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4);
                    PaddingRight = dim(0, 4)
                });
            end

            function cfg.set(text)
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
            end

            items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "input" ].Text)
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)

            if cfg.default then
                cfg.set(cfg.default)
            end

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:keybind(options)
            local cfg = {
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                name = options.name or nil,
                ignore_key = options.ignore or false,

                key = options.key or nil,
                mode = options.mode or "Toggle",
                active = options.default or false,

                open = false,
                binding = nil,

                hold_instances = {},
                items = {};
            }

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key,
                active = cfg.active
            }

            local items = cfg.items; do
                    items[ "keybind_element" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    items[ "keybind_holder" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "right_components" ];
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Size = dim2(0, 0, 0, 16);
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "keybind_holder" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "key" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = items[ "keybind_holder" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "key" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "root" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown" ];
                        Size = dim2(1, 0, 1, 0);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "inline" ]
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "inline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 4)
                    });

                    local options = {"Hold", "Toggle", "Always"}

                    cfg.y_size = 20
                    for _, option in options do
                        local name = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(72, 72, 73);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 14;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name
                        library:apply_theme(name, "accent", "TextColor3")

                        local option_height = name.AbsoluteSize.Y / (library.scale or 1)

                        if option_height < 12 then
                            option_height = 16
                        end

                        cfg.y_size += option_height

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.MouseButton1Click:Connect(function()
                            cfg.set(option)

                            cfg.set_visible(false)

                            cfg.open = false
                        end)
                    end
            end

            function cfg.modify_mode_color(path)
                for _, v in cfg.hold_instances do
                    v.TextColor3 = rgb(72, 72, 72)
                end

                cfg.hold_instances[path].TextColor3 = themes.preset.accent
            end

            function cfg.set_mode(mode)
                cfg.mode = mode

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
                cfg.modify_mode_color(mode)
            end

            function cfg.set(input)
                if type(input) == "boolean" then
                    cfg.active = input

                    if cfg.mode == "Always" then
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then
                    input = input.Name == "Escape" and "NONE" or input

                    cfg.key = input or "NONE"
                elseif find({"Toggle", "Hold", "Always"}, input) then
                    if input == "Always" then
                        cfg.active = true
                    end

                    cfg.mode = input
                    cfg.set_mode(cfg.mode)
                elseif type(input) == "table" then
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or "Toggle"

                    if input.active then
                        cfg.active = input.active
                    end

                    cfg.set_mode(cfg.mode)
                end

                cfg.callback(cfg.active)

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key,
                    active = cfg.active
                }
            end

            function cfg.set_visible(bool)
                local sc = library.scale or 1
                local size = bool and cfg.y_size or 0

                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X / sc, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X / sc, (items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60) / sc)

                library:close_element(cfg)
            end

            items[ "keybind_holder" ].MouseButton1Down:Connect(function()
                task.wait()
                items[ "key" ].Text = "..."

                if cfg.binding then
                    cfg.binding:Disconnect()
                    cfg.binding = nil
                end

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)
                    if keycode.UserInputType == Enum.UserInputType.Touch then
                        cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
                    else
                        cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    end

                    cfg.binding:Disconnect()
                    cfg.binding = nil
                end)
            end)

            items[ "keybind_holder" ].MouseButton2Down:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            if is_mobile then
                items[ "keybind_element" ].MouseButton1Click:Connect(function()
                    cfg.open = not cfg.open

                    cfg.set_visible(cfg.open)
                end)
            end

            library:connection(uis.InputBegan, function(input, game_event)
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == cfg.key then
                        if cfg.mode == "Toggle" then
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then
                            cfg.set(true)
                        end
                    end
                end
            end)

            library:connection(uis.InputEnded, function(input, game_event)
                if game_event then
                    return
                end

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then
                        cfg.set(false)
                    end
                end
            end)

            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:button(options)
            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                items = {};
            }

            local items = cfg.items; do
                items[ "button_element" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Position = dim2(1, -4, 0, 0);
                    Size = dim2(1, -8, 0, 30);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");
            end

            items[ "button" ].MouseButton1Click:Connect(function()
                cfg.callback()

                items[ "name" ].TextColor3 = themes.preset.accent
                library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            return setmetatable(cfg, library)
        end

        function library:settings(options)
            local cfg = {
                open = false;
                items = {};
                sanity = true;
            }

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Visible = true;
                    Parent = library[ "root" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "tick" ] = library:create( "ImageButton" , {
                    Image = "rbxassetid://128797200442698";
                    Name = "\0";
                    AutoButtonColor = false;
                    Parent = self.items[ "right_components" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            end

            function cfg.set_visible(bool)
                local sc = library.scale or 1

                library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
                items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X / sc, (items[ "tick" ].AbsolutePosition.Y + 90) / sc)
                library:close_element(cfg)
            end

            items[ "tick" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            return setmetatable(cfg, library)
        end

        function library:list(properties)
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or library:next_flag();
                callback = properties.callback or function() end;
                data_store = {};
                current_element;
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end

            function cfg.refresh_options(options_to_refresh)
                for _,option in cfg.data_store do
                    option:Destroy()
                end

                cfg.data_store = {}
                cfg.current_element = nil

                for _, option_data in options_to_refresh do
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element
                        if current and current ~= name then
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then
                            return
                        end

                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then
                            return
                        end

                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end)
                end
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end

        function library:esp_manager(options)
            options = options or {}

            local fit = 0.5

            local cfg = {
                name = options.name or options.Name or "Esp";
                page = options.page or options.Page or "Players";
                rotate = true;
                speed = 40;
                rotation = 0;
                ready = false;
                objects = {};
                items = {};

                info = {
                    health = 100;
                    max_health = 100;
                    display_name = lp.DisplayName;
                    user_name = lp.Name;
                    weapon = "Weapon";
                    backpack = {"Tool 1", "Tool 2"};
                    distance = 25;
                };

                values = {
                    Enabled = false;

                    Box = false;
                    BoxGradient = false;

                    Glow = false;
                    GlowGradient = false;
                    GlowColor = rgb(255, 80, 180);
                    GlowTransparency = 0.4;

                    HealthBar = false;
                    HealthBarGradient = false;

                    HealthText = false;
                    HealthTextGradient = false;

                    Name = false;
                    DisplayName = false;
                    NameGradient = false;

                    Avatar = false;

                    Weapon = false;
                    WeaponGradient = false;

                    Backpack = false;
                    BackpackGradient = false;

                    Distance = false;
                    DistanceGradient = false;

                    Skeleton = false;
                    SkeletonGradient = false;
                    SkeletonColor = rgb(255, 255, 255);
                    SkeletonThickness = 2;

                    Dot = false;
                    DotGradient = false;
                    DotColor = rgb(255, 255, 255);
                    DotSize = 8;

                    GradientColor1 = rgb(255, 255, 255);
                    GradientColor2 = rgb(255, 80, 180);
                    GradientAnimation = false;
                    GradientAnimationSpeed = 4;
                };
            }

            local items = cfg.items
            local values = cfg.values

            -- Fog of War gibt es nur in BloxStrike (ID 114234929420007) und ist dort immer aktiv
            local bloxstrike_id = 114234929420007
            local is_bloxstrike = game.PlaceId == bloxstrike_id or game.GameId == bloxstrike_id


            local custom_settings = options.settings or options.Settings or options.values or options.Values or {}

            local visibility = {}

            for setting_key, setting_value in custom_settings do
                if type(setting_value) == "table" then
                    if setting_value.Visible ~= nil then
                        visibility[setting_key] = setting_value.Visible
                    end

                    if setting_value.Value ~= nil then
                        setting_value = setting_value.Value
                    else
                        setting_value = setting_value.Enabled
                    end
                end

                if values[setting_key] ~= nil and setting_value ~= nil then
                    values[setting_key] = setting_value
                end
            end

            local function build(container, key, creator)
                if visibility[key] ~= false then
                    return creator()
                end

                local before = {}

                for _, child in container:GetChildren() do
                    before[child] = true
                end

                local result = creator()

                for _, child in container:GetChildren() do
                    if not before[child] and child:IsA("GuiObject") then
                        child.Visible = false
                    end
                end

                return result
            end

            local function bind(key)
                return function(value)
                    values[key] = value
                    cfg.refresh()
                end
            end

            local function create_text(parent, text_name, font, text_size, size, position, alignment)
                local text = library:create( "TextLabel" , {
                    Name = text_name;
                    Parent = parent;
                    BackgroundTransparency = 1;
                    Size = size;
                    Font = font;
                    TextSize = text_size;
                    TextColor3 = rgb(255, 255, 255);
                    TextXAlignment = alignment or Enum.TextXAlignment.Center
                });

                if position then
                    text.Position = position
                end

                local text_gradient = library:create( "UIGradient" , {
                    Name = text_name .. "Gradient";
                    Parent = text
                });

                library:create( "UIStroke" , {
                    Thickness = 1;
                    Color = rgb(0, 0, 0);
                    Parent = text
                });

                return text, text_gradient
            end

            local function create_box(parent, user_id, glow_z)
                local obj = {Bones = {}}

                obj.Box = library:create( "Frame" , {
                    Parent = parent;
                    BackgroundColor3 = rgb(255, 255, 255);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Visible = false
                });

                obj.Glow = library:create( "ImageLabel" , {
                    Name = "Glow";
                    Parent = obj.Box;
                    BackgroundTransparency = 1;
                    Position = dim2(0, -15, 0, -15);
                    Size = dim2(1, 30, 1, 30);
                    Image = "rbxassetid://5028857084";
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = rect(24, 24, 276, 276);
                    ImageColor3 = rgb(255, 255, 255);
                    ImageTransparency = values.GlowTransparency;
                    ZIndex = glow_z
                });

                obj.GlowGradient = library:create( "UIGradient" , {
                    Name = "GlowGradient";
                    Parent = obj.Glow
                });

                obj.Stroke = library:create( "UIStroke" , {
                    Name = "BoxStroke";
                    Color = rgb(255, 255, 255);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Parent = obj.Box
                });

                obj.StrokeGradient = library:create( "UIGradient" , {
                    Name = "StrokeGradient";
                    Parent = obj.Stroke
                });

                obj.Fill = library:create( "Frame" , {
                    Name = "Fill";
                    Parent = obj.Box;
                    BackgroundColor3 = rgb(255, 255, 255);
                    BackgroundTransparency = 0.65;
                    BorderSizePixel = 0;
                    Size = dim2(1, 0, 1, 0);
                    Position = dim2(0, 0, 0, 0)
                });

                obj.FillGradient = library:create( "UIGradient" , {
                    Name = "FillGradient";
                    Rotation = 90;
                    Parent = obj.Fill
                });

                obj.Dot = library:create( "Frame" , {
                    Name = "Dot";
                    Parent = obj.Box;
                    AnchorPoint = vec2(0.5, 0.5);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    Size = dim_offset(8, 8);
                    Visible = false;
                    ZIndex = 3
                });

                library:create( "UICorner" , {
                    Parent = obj.Dot;
                    CornerRadius = dim(0.5, 0)
                });

                library:create( "UIStroke" , {
                    Color = rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Parent = obj.Dot
                });

                obj.DotGradient = library:create( "UIGradient" , {
                    Name = "DotGradient";
                    Parent = obj.Dot
                });

                obj.HealthBarBg = library:create( "Frame" , {
                    Name = "HealthBarBg";
                    Parent = obj.Box;
                    BackgroundColor3 = rgb(0, 0, 0);
                    BackgroundTransparency = 0.4;
                    BorderSizePixel = 0;
                    Size = dim2(0, 2, 1, 0);
                    Position = dim2(0, -5, 0, 0)
                });

                obj.HealthBar = library:create( "Frame" , {
                    Name = "HealthBar";
                    Parent = obj.HealthBarBg;
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    Size = dim2(1, 0, 1, 0);
                    Position = dim2(0, 0, 0, 0)
                });

                obj.HealthBarGradient = library:create( "UIGradient" , {
                    Name = "HealthBarGradient";
                    Rotation = 90;
                    Parent = obj.HealthBar
                });

                obj.HealthText, obj.HealthTextGradient = create_text(obj.Box, "HealthText", Enum.Font.SourceSansBold, 11, dim2(0, 40, 0, 12), dim2(0, -47, 0, -2), Enum.TextXAlignment.Right)
                obj.NameText, obj.NameTextGradient = create_text(obj.Box, "NameText", Enum.Font.SourceSansBold, 12, dim2(1, 0, 0, 14), dim2(0, 0, 0, -16))

                obj.AvatarImage = library:create( "ImageLabel" , {
                    Name = "AvatarImage";
                    Parent = obj.Box;
                    BackgroundTransparency = 1;
                    Size = dim2(0, 25, 0, 25);
                    Position = dim2(0.5, -12.5, 0, -43);
                    BorderSizePixel = 0
                });

                obj.WeaponText, obj.WeaponTextGradient = create_text(obj.Box, "WeaponText", Enum.Font.SourceSansBold, 11, dim2(1, 0, 0, 14))

                obj.WeaponImage = library:create( "ImageLabel" , {
                    Name = "WeaponImage";
                    Parent = obj.Box;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AnchorPoint = vec2(0.5, 0);
                    Size = dim2(0, 64, 0, 24);
                    ScaleType = Enum.ScaleType.Fit;
                    Visible = false
                });
                obj.DistanceText, obj.DistanceTextGradient = create_text(obj.Box, "DistanceText", Enum.Font.SourceSansBold, 11, dim2(1, 0, 0, 14))
                obj.BackpackText, obj.BackpackTextGradient = create_text(obj.Box, "BackpackText", Enum.Font.SourceSans, 10, dim2(1, 0, 0, 14))

                task.spawn(function()
                    local success, content, is_ready = pcall(function()
                        return players:GetUserThumbnailAsync(user_id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                    end)

                    if success and is_ready then
                        obj.AvatarImage.Image = content
                    end
                end)

                return obj
            end

            local function paint(gradient, sequence, base_rotation)
                gradient.Color = sequence

                if values.GradientAnimation then
                    gradient.Rotation = cfg.animated_rotation or 0
                    gradient.Offset = cfg.animated_offset or vec2(0, 0)
                else
                    gradient.Rotation = base_rotation
                    gradient.Offset = vec2(0, 0)
                end
            end

            local function apply(obj, info)
                local color_sequence = values.GradientAnimation and cfg.animated_sequence or rgbseq(values.GradientColor1, values.GradientColor2)

                if values.Glow then
                    obj.Glow.Visible = true
                    obj.Glow.ImageTransparency = values.GlowTransparency
                    obj.GlowGradient.Enabled = values.GlowGradient

                    if values.GlowGradient then
                        paint(obj.GlowGradient, color_sequence, 0)
                        obj.Glow.ImageColor3 = rgb(255, 255, 255)
                    else
                        obj.Glow.ImageColor3 = values.GlowColor
                    end
                else
                    obj.Glow.Visible = false
                end

                obj.Stroke.Enabled = values.Box
                obj.StrokeGradient.Enabled = values.Box and values.BoxGradient

                if values.BoxGradient then
                    paint(obj.StrokeGradient, color_sequence, 0)
                end

                obj.Fill.Visible = values.Box
                obj.FillGradient.Enabled = values.Box and values.BoxGradient

                if values.BoxGradient then
                    paint(obj.FillGradient, color_sequence, 90)
                end

                local health = clamp(info.health, 0, info.max_health)
                local health_percent = health / info.max_health
                local health_color = rgb(255, 0, 0):Lerp(rgb(0, 255, 0), health_percent)

                if values.HealthBar then
                    obj.HealthBarBg.Visible = true
                    obj.HealthBar.Size = dim2(1, 0, health_percent, 0)
                    obj.HealthBar.Position = dim2(0, 0, 1 - health_percent, 0)
                    obj.HealthBarGradient.Enabled = values.HealthBarGradient

                    if values.HealthBarGradient then
                        paint(obj.HealthBarGradient, color_sequence, 90)
                        obj.HealthBar.BackgroundColor3 = rgb(255, 255, 255)
                    else
                        obj.HealthBar.BackgroundColor3 = health_color
                    end
                else
                    obj.HealthBarBg.Visible = false
                end

                if values.HealthText then
                    obj.HealthText.Visible = true
                    obj.HealthText.Text = floor(health) .. " HP"
                    obj.HealthTextGradient.Enabled = values.HealthTextGradient

                    if values.HealthTextGradient then
                        paint(obj.HealthTextGradient, color_sequence, 0)
                        obj.HealthText.TextColor3 = rgb(255, 255, 255)
                    else
                        obj.HealthText.TextColor3 = health_color
                    end
                else
                    obj.HealthText.Visible = false
                end

                local name_visible = values.DisplayName or values.Name

                if values.DisplayName and values.Name then
                    obj.NameText.Visible = true
                    obj.NameText.Text = info.display_name .. " (@" .. info.user_name .. ")"
                elseif values.DisplayName then
                    obj.NameText.Visible = true
                    obj.NameText.Text = info.display_name
                elseif values.Name then
                    obj.NameText.Visible = true
                    obj.NameText.Text = "@" .. info.user_name
                else
                    obj.NameText.Visible = false
                end

                obj.NameTextGradient.Enabled = values.NameGradient

                if values.NameGradient then
                    paint(obj.NameTextGradient, color_sequence, 0)
                end

                obj.NameText.TextColor3 = rgb(255, 255, 255)

                if values.Avatar then
                    obj.AvatarImage.Visible = true

                    if name_visible then
                        obj.AvatarImage.Position = dim2(0.5, -12.5, 0, -43)
                    else
                        obj.AvatarImage.Position = dim2(0.5, -12.5, 0, -27)
                    end
                else
                    obj.AvatarImage.Visible = false
                end

                local bottom_offset = 2

                if obj.WeaponImage then
                    obj.WeaponImage.Visible = false
                end

                if values.Weapon and info.weapon_image and obj.WeaponImage then
                    obj.WeaponText.Visible = false
                    obj.WeaponImage.Image = info.weapon_image
                    obj.WeaponImage.Position = dim2(0.5, 0, 1, bottom_offset)
                    obj.WeaponImage.ImageColor3 = rgb(255, 255, 255)
                    obj.WeaponImage.Visible = true
                    bottom_offset = bottom_offset + 26
                elseif values.Weapon and info.weapon then
                    obj.WeaponText.Visible = true
                    obj.WeaponText.Text = info.weapon
                    obj.WeaponText.Position = dim2(0, 0, 1, bottom_offset)
                    obj.WeaponTextGradient.Enabled = values.WeaponGradient

                    if values.WeaponGradient then
                        paint(obj.WeaponTextGradient, color_sequence, 0)
                    end

                    obj.WeaponText.TextColor3 = rgb(255, 255, 255)
                    bottom_offset = bottom_offset + 14
                else
                    obj.WeaponText.Visible = false
                end

                if values.Distance and info.distance then
                    obj.DistanceText.Visible = true
                    obj.DistanceText.Text = info.distance .. " Studs"
                    obj.DistanceText.Position = dim2(0, 0, 1, bottom_offset)
                    obj.DistanceTextGradient.Enabled = values.DistanceGradient

                    if values.DistanceGradient then
                        paint(obj.DistanceTextGradient, color_sequence, 0)
                        obj.DistanceText.TextColor3 = rgb(255, 255, 255)
                    else
                        obj.DistanceText.TextColor3 = rgb(200, 200, 200)
                    end

                    bottom_offset = bottom_offset + 14
                else
                    obj.DistanceText.Visible = false
                end

                if values.Backpack and #info.backpack > 0 then
                    obj.BackpackText.Visible = true
                    obj.BackpackText.Text = "[" .. concat(info.backpack, ", ") .. "]"
                    obj.BackpackText.Position = dim2(0, 0, 1, bottom_offset)
                    obj.BackpackTextGradient.Enabled = values.BackpackGradient

                    if values.BackpackGradient then
                        paint(obj.BackpackTextGradient, color_sequence, 0)
                        obj.BackpackText.TextColor3 = rgb(255, 255, 255)
                    else
                        obj.BackpackText.TextColor3 = rgb(180, 180, 180)
                    end
                else
                    obj.BackpackText.Visible = false
                end

                obj.Box.Visible = values.Enabled and (values.Box or values.Glow or values.Skeleton or values.Dot or values.HealthBar or values.HealthText or values.Name or values.DisplayName or values.Avatar or values.Weapon or values.Distance or values.Backpack)
            end

            local function part_point(model, part_name, offset)
                local part = model:FindFirstChild(part_name)

                if part and part:IsA("BasePart") then
                    if offset then
                        return part.CFrame:PointToWorldSpace(offset)
                    end

                    return part.Position
                end

                return nil
            end

            local function joint_point(model, part_name, motor_name)
                local part = model:FindFirstChild(part_name)
                local motor = part and part:FindFirstChild(motor_name)

                if motor and motor:IsA("Motor6D") and motor.Part0 then
                    return motor.Part0.CFrame:PointToWorldSpace(motor.C0.Position)
                end

                return nil
            end

            local function get_segments(model)
                local segments = {}

                local function add(point_a, point_b)
                    if point_a and point_b then
                        insert(segments, {point_a, point_b})
                    end
                end

                if model:FindFirstChild("UpperTorso") then
                    local head = part_point(model, "Head")
                    local neck = joint_point(model, "Head", "Neck")
                    local waist = joint_point(model, "UpperTorso", "Waist")

                    add(head, neck)
                    add(neck, waist)

                    for _, side in next, {"Left", "Right"} do
                        local shoulder = joint_point(model, side .. "UpperArm", side .. "Shoulder")
                        local elbow = joint_point(model, side .. "LowerArm", side .. "Elbow")
                        local wrist = joint_point(model, side .. "Hand", side .. "Wrist")
                        local hand = part_point(model, side .. "Hand")

                        local hip = joint_point(model, side .. "UpperLeg", side .. "Hip")
                        local knee = joint_point(model, side .. "LowerLeg", side .. "Knee")
                        local ankle = joint_point(model, side .. "Foot", side .. "Ankle")
                        local foot = part_point(model, side .. "Foot")

                        add(neck, shoulder)
                        add(shoulder, elbow)
                        add(elbow, wrist)
                        add(wrist, hand)

                        add(waist, hip)
                        add(hip, knee)
                        add(knee, ankle)
                        add(ankle, foot)
                    end
                elseif model:FindFirstChild("Torso") then
                    local head = part_point(model, "Head")
                    local neck = part_point(model, "Torso", vec3(0, 1, 0))
                    local waist = part_point(model, "Torso", vec3(0, -1, 0))

                    add(head, neck)
                    add(neck, waist)

                    for _, side in next, {"Left", "Right"} do
                        local sign = side == "Left" and -1 or 1

                        local shoulder = part_point(model, "Torso", vec3(sign, 0.5, 0))
                        local hand = part_point(model, side .. " Arm", vec3(0, -1, 0))
                        local hip = part_point(model, "Torso", vec3(sign * 0.5, -1, 0))
                        local foot = part_point(model, side .. " Leg", vec3(0, -1, 0))

                        add(neck, shoulder)
                        add(shoulder, hand)
                        add(waist, hip)
                        add(hip, foot)
                    end
                end

                return segments
            end

            local function get_bone(obj, index)
                local bone = obj.Bones[index]

                if bone then
                    return bone
                end

                local frame = library:create( "Frame" , {
                    Name = "Bone";
                    Parent = obj.Box;
                    AnchorPoint = vec2(0.5, 0.5);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    Visible = false;
                    ZIndex = 2
                });

                library:create( "UICorner" , {
                    Parent = frame;
                    CornerRadius = dim(0.5, 0)
                });

                local gradient = library:create( "UIGradient" , {
                    Parent = frame
                });

                bone = {Frame = frame, Gradient = gradient}
                obj.Bones[index] = bone

                return bone
            end

            local function hide_bones(obj, from)
                for index = from + 1, #obj.Bones do
                    obj.Bones[index].Frame.Visible = false
                end
            end

            local function draw_skeleton(obj, model, project, origin)
                if not values.Skeleton then
                    hide_bones(obj, 0)
                    return
                end

                local segments = get_segments(model)
                local color_sequence = values.GradientAnimation and cfg.animated_sequence or rgbseq(values.GradientColor1, values.GradientColor2)
                local used = 0

                for _, segment in next, segments do
                    local point_a = project(segment[1])
                    local point_b = project(segment[2])

                    if point_a and point_b then
                        used += 1

                        local bone = get_bone(obj, used)
                        local from = point_a - origin
                        local to = point_b - origin
                        local delta = to - from
                        local frame = bone.Frame

                        frame.Position = dim_offset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
                        frame.Size = dim_offset(delta.Magnitude + values.SkeletonThickness + 1, values.SkeletonThickness)
                        frame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                        frame.Visible = true

                        bone.Gradient.Enabled = values.SkeletonGradient

                        if values.SkeletonGradient then
                            paint(bone.Gradient, color_sequence, 0)
                            frame.BackgroundColor3 = rgb(255, 255, 255)
                        else
                            frame.BackgroundColor3 = values.SkeletonColor
                        end
                    end
                end

                hide_bones(obj, used)
            end

            local function draw_dot(obj, model, project, origin)
                local dot = obj.Dot

                if not values.Dot then
                    dot.Visible = false
                    return
                end

                local position = part_point(model, "Head")
                local point = position and project(position)

                if not point then
                    dot.Visible = false
                    return
                end

                local relative = point - origin

                dot.Size = dim_offset(values.DotSize, values.DotSize)
                dot.Position = dim_offset(relative.X, relative.Y)
                dot.Visible = true

                obj.DotGradient.Enabled = values.DotGradient

                if values.DotGradient then
                    paint(obj.DotGradient, values.GradientAnimation and cfg.animated_sequence or rgbseq(values.GradientColor1, values.GradientColor2), 0)
                    dot.BackgroundColor3 = rgb(255, 255, 255)
                else
                    dot.BackgroundColor3 = values.DotColor
                end
            end

            local http_service = game:GetService("HttpService")

            -- BloxStrike: Gegner sind clientseitige Shells (player.Character). Ausserhalb der Sicht
            -- (Fog of War / PVS) werden sie in ReplicatedStorage._PVS_CulledCharacters verschoben
            -- und ihre Position ist veraltet.
            local function get_shell(player)
                local character = player.Character

                if character and character.Parent then
                    return character
                end

                local folder = ws:FindFirstChild("Characters")
                local found = folder and folder:FindFirstChild(player.Name)

                if found and found:IsA("Model") then
                    return found
                end

                return character
            end

            local function read_health(character, humanoid)
                local health = character:GetAttribute("Health")
                local max_health = character:GetAttribute("MaxHealth")

                if typeof(health) == "number" and typeof(max_health) == "number" and max_health > 0 then
                    return health, max_health
                end

                if humanoid then
                    return humanoid.Health, max(humanoid.MaxHealth, 1)
                end

                return nil, nil
            end

            -- BloxStrike: Die ausgeruestete Waffe steht als JSON im Spieler-Attribut "CurrentEquipped"
            -- ({Name, Identifier, Skin}). Das Bild kommt aus der Skins-Bibliothek des Spiels.
            local skins_library = nil
            local weapon_image_cache = {}

            local function get_skins_library()
                if skins_library == nil then
                    local ok, result = pcall(function()
                        return require(rs.Database.Components.Libraries.Skins)
                    end)

                    skins_library = ok and result or false
                end

                return skins_library or nil
            end

            local function to_image(value)
                if typeof(value) == "number" then
                    return "rbxassetid://" .. tostring(value)
                end

                if typeof(value) == "string" and value ~= "" then
                    if tonumber(value) ~= nil then
                        return "rbxassetid://" .. value
                    end

                    return value
                end

                return nil
            end

            local function get_weapon_image(weapon_name, skin_name)
                local library_data = get_skins_library()

                if not library_data or typeof(weapon_name) ~= "string" then
                    return nil
                end

                local key = weapon_name .. "|" .. tostring(skin_name or "Stock")

                if weapon_image_cache[key] then
                    return weapon_image_cache[key]
                end

                local function lookup(skin)
                    local ok, data = pcall(library_data.GetSkinInformation, weapon_name, skin)

                    if not ok or typeof(data) ~= "table" then
                        return nil
                    end

                    local wear = data.wearImages and data.wearImages[1]

                    return to_image(wear and wear.assetId) or to_image(data.imageAssetId)
                end

                local image = (typeof(skin_name) == "string" and skin_name ~= "" and lookup(skin_name)) or lookup("Stock")

                if image then
                    weapon_image_cache[key] = image
                end

                return image
            end

            local equipped_cache = setmetatable({}, {__mode = "k"})

            local function read_weapon(player, character)
                local equipped = player:GetAttribute("CurrentEquipped") or character:GetAttribute("CurrentEquipped")

                if typeof(equipped) == "string" and equipped ~= "" then
                    local cached = equipped_cache[player]

                    if cached and cached.raw == equipped then
                        return cached.name, cached.skin
                    end

                    local ok, decoded = pcall(http_service.JSONDecode, http_service, equipped)

                    if ok and typeof(decoded) == "table" and typeof(decoded.Name) == "string" then
                        equipped_cache[player] = {raw = equipped, name = decoded.Name, skin = decoded.Skin}

                        return decoded.Name, decoded.Skin
                    end
                end

                local tool = character:FindFirstChildOfClass("Tool")

                return tool and tool.Name or nil, nil
            end

            local function update_player(obj)
                local box = obj.Box
                local player = obj.Player
                local character = get_shell(player)
                local current_camera = ws.CurrentCamera

                if not values.Enabled or not character or not current_camera then
                    box.Visible = false
                    return
                end

                if character:GetAttribute("Dead") == true then
                    box.Visible = false
                    return
                end

                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if not hrp then
                    box.Visible = false
                    return
                end

                local current_health, current_max_health = read_health(character, humanoid)

                if current_health ~= nil and current_health <= 0 then
                    box.Visible = false
                    return
                end

                if current_health == nil then
                    current_health, current_max_health = 100, 100
                end

                local function project_world(position)
                    local point = current_camera:WorldToViewportPoint(position)

                    if point.Z <= 0 then
                        return nil
                    end

                    return vec2(point.X, point.Y)
                end

                -- Box aus den 8 Ecken eines Koerper-Quaders berechnen. Das bleibt auch bei Gegnern
                -- in naher Entfernung stabil (auch wenn nur ein Teil des Koerpers im Bild ist).
                local head = character:FindFirstChild("Head")
                local root_position = hrp.Position
                local top_y = (head and head.Position.Y + 0.65) or (root_position.Y + 2.8)
                local bottom_y = root_position.Y - 3.1
                local half = 1.6

                local min_x, min_y, max_x, max_y = math.huge, math.huge, -math.huge, -math.huge
                local corners_in_front = 0

                for _, y in {top_y, bottom_y} do
                    for _, x in {-half, half} do
                        for _, z in {-half, half} do
                            local point = project_world(vec3(root_position.X + x, y, root_position.Z + z))

                            if point then
                                corners_in_front += 1
                                min_x = math.min(min_x, point.X)
                                min_y = math.min(min_y, point.Y)
                                max_x = math.max(max_x, point.X)
                                max_y = math.max(max_y, point.Y)
                            end
                        end
                    end
                end

                local viewport = current_camera.ViewportSize

                if corners_in_front == 0 or max_x < 0 or max_y < 0 or min_x > viewport.X or min_y > viewport.Y then
                    box.Visible = false
                    return
                end

                local height = max_y - min_y
                local width = max(max_x - min_x, height * 0.4)

                box.Position = dim_offset(min_x, min_y)
                box.Size = dim_offset(width, height)

                local box_origin = vec2(min_x, min_y)

                draw_skeleton(obj, character, project_world, box_origin)
                draw_dot(obj, character, project_world, box_origin)

                local glow_padding = clamp(height * 0.05, 1, 15)

                obj.Glow.Position = dim_offset(-glow_padding, -glow_padding)
                obj.Glow.Size = dim2(1, glow_padding * 2, 1, glow_padding * 2)
                obj.Glow.SliceScale = clamp(glow_padding / 15, 0.05, 1)

                local info = {
                    health = current_health;
                    max_health = current_max_health;
                    display_name = player.DisplayName;
                    user_name = player.Name;
                    backpack = {};
                }

                if values.Weapon then
                    local weapon_name, weapon_skin = read_weapon(player, character)

                    info.weapon = weapon_name

                    if is_bloxstrike and weapon_name then
                        info.weapon_image = get_weapon_image(weapon_name, weapon_skin)
                    end
                end

                if values.Distance then
                    local my_character = lp.Character
                    local my_hrp = my_character and my_character:FindFirstChild("HumanoidRootPart")
                    local origin = my_hrp and my_hrp.Position or current_camera.CFrame.Position

                    info.distance = floor((hrp.Position - origin).Magnitude)
                end

                if values.Backpack then
                    local backpack = player:FindFirstChild("Backpack")

                    if backpack then
                        for _, item in backpack:GetChildren() do
                            if item:IsA("Tool") then
                                insert(info.backpack, item.Name)
                            end
                        end
                    end
                end

                apply(obj, info)
            end

            function cfg.build_animated_sequence()
                local time = os.clock()
                local speed = values.GradientAnimationSpeed
                local phase = (time * speed * 0.06) % 1
                local first = values.GradientColor1
                local second = values.GradientColor2
                local keypoints = {}

                for index = 0, 12 do
                    local position = index / 12
                    local wave = 0.5 + 0.5 * math.cos((position - phase) * math.pi * 2)
                    local counter = 0.5 + 0.5 * math.sin((position + phase * 2) * math.pi * 2)
                    local mix = wave * 0.65 + counter * 0.35

                    insert(keypoints, rgbkey(position, first:Lerp(second, mix)))
                end

                local angle_value = (time * speed * 45) % 360
                local orbit = math.rad(angle_value)

                cfg.animated_rotation = angle_value
                cfg.animated_offset = vec2(math.cos(orbit) * 0.25, math.sin(orbit) * 0.25)
                cfg.animated_sequence = rgbseq(keypoints)
            end

            function cfg.draw_preview_skeleton()
                if not cfg.ready or not cfg.model then
                    return
                end

                local size = items[ "viewport" ].AbsoluteSize

                if size.X <= 0 or size.Y <= 0 then
                    return
                end

                local scale = library.scale or 1
                local width = size.X / scale
                local height = size.Y / scale
                local box_height = height * fit
                local box_width = box_height * 0.65
                local camera = items[ "camera" ]
                local tan_half = tan(rad(camera.FieldOfView / 2))
                local origin = vec2(width / 2 - box_width / 2, height / 2 - box_height / 2)

                local function project_preview(position)
                    local relative = camera.CFrame:PointToObjectSpace(position)
                    local depth = -relative.Z

                    if depth <= 0 then
                        return nil
                    end

                    local ndc_x = relative.X / (depth * tan_half * (width / height))
                    local ndc_y = relative.Y / (depth * tan_half)

                    return vec2((ndc_x * 0.5 + 0.5) * width, (0.5 - ndc_y * 0.5) * height)
                end

                draw_skeleton(items[ "preview" ], cfg.model, project_preview, origin)
                draw_dot(items[ "preview" ], cfg.model, project_preview, origin)
            end

            function cfg.layout()
                if not cfg.ready then
                    return
                end

                local size = items[ "viewport" ].AbsoluteSize

                if size.X <= 0 or size.Y <= 0 then
                    return
                end

                local height = size.Y * fit / (library.scale or 1)

                items[ "preview" ].Box.Size = dim_offset(height * 0.65, height)
            end

            function cfg.refresh()
                if not cfg.ready then
                    return
                end

                apply(items[ "preview" ], cfg.info)
                cfg.layout()
            end

            function cfg.build_dummy()
                local model = library:create( "Model" , {})

                local function limb(limb_name, size, position)
                    return library:create( "Part" , {
                        Name = limb_name;
                        Size = size;
                        Position = position;
                        Anchored = true;
                        Color = rgb(163, 162, 165);
                        Material = Enum.Material.SmoothPlastic;
                        TopSurface = Enum.SurfaceType.Smooth;
                        BottomSurface = Enum.SurfaceType.Smooth;
                        Parent = model
                    })
                end

                local torso = limb("Torso", vec3(2, 2, 1), vec3(0, 3, 0))
                limb("Head", vec3(2, 1, 1), vec3(0, 4.5, 0))
                limb("Left Arm", vec3(1, 2, 1), vec3(-1.5, 3, 0))
                limb("Right Arm", vec3(1, 2, 1), vec3(1.5, 3, 0))
                limb("Left Leg", vec3(1, 2, 1), vec3(-0.5, 1, 0))
                limb("Right Leg", vec3(1, 2, 1), vec3(0.5, 1, 0))

                model.PrimaryPart = torso

                return model
            end

            function cfg.load_model()
                if cfg.model then
                    cfg.model:Destroy()
                    cfg.model = nil
                end

                local source = lp.Character
                local model

                if source then
                    source.Archivable = true

                    local success, clone = pcall(function()
                        return source:Clone()
                    end)

                    if success and clone then
                        model = clone
                    end
                end

                if not model then
                    model = cfg.build_dummy()
                end

                cfg.motors = {}

                for _, object in model:GetDescendants() do
                    if object:IsA("BaseScript") or object:IsA("Sound") or object:IsA("ForceField") or object:IsA("Animator") or object:IsA("AnimationController") or object:IsA("Animation") then
                        object:Destroy()
                    elseif object:IsA("BasePart") then
                        object.Anchored = true
                    elseif object:IsA("Motor6D") then
                        object.Transform = cfr()
                        insert(cfg.motors, object)
                    end
                end

                local humanoid = model:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    pcall(function()
                        humanoid.EvaluateStateMachine = false
                    end)
                end

                local max_health = humanoid and max(humanoid.MaxHealth, 1) or 100
                local current_health = humanoid and humanoid.Health or 100

                if current_health <= 0 then
                    current_health = max_health
                end

                local tool = source and source:FindFirstChildOfClass("Tool")
                local backpack = lp:FindFirstChild("Backpack")
                local tools = {}

                if backpack then
                    for _, item in backpack:GetChildren() do
                        if item:IsA("Tool") then
                            insert(tools, item.Name)
                        end
                    end
                end

                cfg.info.health = current_health
                cfg.info.max_health = max_health
                cfg.info.display_name = lp.DisplayName
                cfg.info.user_name = lp.Name
                cfg.info.weapon = tool and tool.Name or "Weapon"
                cfg.info.backpack = #tools > 0 and tools or {"Tool 1", "Tool 2"}

                model:PivotTo(cfr(0, 0, 0))

                local box_cframe, box_size = model:GetBoundingBox()

                cfg.base = vec3(0, -box_cframe.Position.Y, 0)
                cfg.distance = (box_size.Y / fit) / (2 * tan(rad(items[ "camera" ].FieldOfView / 2)))
                cfg.model = model

                items[ "camera" ].CFrame = CFrame.lookAt(vec3(0, 0, -cfg.distance), vec3(0, 0, 0))

                model:PivotTo(cfr(cfg.base) * angle(0, rad(cfg.rotation), 0))
                model.Parent = items[ "viewport" ]

                cfg.refresh()
            end

            function cfg.unload()
                run:UnbindFromRenderStep("ESPUpdate")

                if cfg.gui then
                    cfg.gui:Destroy()
                    cfg.gui = nil
                end

                cfg.objects = {}
            end

            local page = self:tab({name = cfg.name, icon = options.icon or options.Icon, tabs = {cfg.page}})

            local left = page:column({})
            local general = left:section({name = "General", size = 0.35, default = true})
            local element_section = left:section({name = "Elements", size = 0.65, default = true})

            local right = page:column({})
            local preview = right:section({name = "Preview", size = 1, default = true})

            build(general.items[ "elements" ], "Enabled", function()
                return general:toggle({name = "Enable ESP", flag = "esp_enabled", default = values.Enabled, enabled = values.Enabled, seperator = true, callback = bind("Enabled")})
            end)
            build(general.items[ "elements" ], "GradientColor1", function()
                return general:colorpicker({name = "Gradient Color 1", flag = "esp_gradient_color_1", color = values.GradientColor1, seperator = true, callback = bind("GradientColor1")})
            end)
            build(general.items[ "elements" ], "GradientColor2", function()
                return general:colorpicker({name = "Gradient Color 2", flag = "esp_gradient_color_2", color = values.GradientColor2, seperator = true, callback = bind("GradientColor2")})
            end)

            local gradient_animation = general:toggle({name = "Gradient Animation", flag = "esp_gradient_animation", default = values.GradientAnimation, enabled = values.GradientAnimation, seperator = true, callback = bind("GradientAnimation")})
            local gradient_animation_options = gradient_animation:group({})
            gradient_animation_options:slider({name = "Animation Speed", flag = "esp_gradient_animation_speed", min = 1, max = 10, default = values.GradientAnimationSpeed, interval = 1, callback = bind("GradientAnimationSpeed")})
            general:toggle({name = "Rotate Preview", flag = "esp_rotate", default = true, enabled = true, seperator = true, callback = function(bool)
                cfg.rotate = bool
            end})
            general:slider({name = "Rotation Speed", flag = "esp_rotation_speed", min = 10, max = 180, default = 40, interval = 5, callback = function(value)
                cfg.speed = value
            end})
            general:button({name = "Refresh Model", callback = function()
                cfg.load_model()
            end})

            local function element(title, key, gradient_key)
                local toggle = build(element_section.items[ "elements" ], key, function()
                    return element_section:toggle({
                        name = title;
                        flag = "esp_" .. string.lower(key);
                        default = values[key];
                        enabled = values[key];
                        seperator = true;
                        callback = bind(key);
                    })
                end)

                if not gradient_key then
                    return toggle
                end

                local settings = toggle:settings({})

                build(settings.items[ "elements" ], gradient_key, function()
                    return settings:toggle({
                        name = "Gradient";
                        flag = "esp_" .. string.lower(gradient_key);
                        default = values[gradient_key];
                        enabled = values[gradient_key];
                        seperator = true;
                        callback = bind(gradient_key);
                    })
                end)

                return settings
            end

            element("Box", "Box", "BoxGradient")

            local skeleton = element("Skeleton", "Skeleton", "SkeletonGradient")
            build(skeleton.items[ "elements" ], "SkeletonColor", function()
                return skeleton:colorpicker({name = "Skeleton Color", flag = "esp_skeletoncolor", color = values.SkeletonColor, seperator = true, callback = bind("SkeletonColor")})
            end)
            build(skeleton.items[ "elements" ], "SkeletonThickness", function()
                return skeleton:slider({name = "Thickness", flag = "esp_skeletonthickness", min = 1, max = 4, default = values.SkeletonThickness, interval = 1, callback = bind("SkeletonThickness")})
            end)

            local glow = element("Glow", "Glow", "GlowGradient")
            build(glow.items[ "elements" ], "GlowColor", function()
                return glow:colorpicker({name = "Glow Color", flag = "esp_glowcolor", color = values.GlowColor, seperator = true, callback = bind("GlowColor")})
            end)
            build(glow.items[ "elements" ], "GlowTransparency", function()
                return glow:slider({name = "Transparency", flag = "esp_glowtransparency", min = 0, max = 1, default = values.GlowTransparency, interval = 0.05, callback = bind("GlowTransparency")})
            end)

            local dot = element("Dot", "Dot", "DotGradient")
            build(dot.items[ "elements" ], "DotColor", function()
                return dot:colorpicker({name = "Dot Color", flag = "esp_dotcolor", color = values.DotColor, seperator = true, callback = bind("DotColor")})
            end)
            build(dot.items[ "elements" ], "DotSize", function()
                return dot:slider({name = "Size", flag = "esp_dotsize", min = 2, max = 20, default = values.DotSize, interval = 1, callback = bind("DotSize")})
            end)

            element("Health Bar", "HealthBar", "HealthBarGradient")
            element("Health Text", "HealthText", "HealthTextGradient")
            element("Name", "Name", "NameGradient")
            element("Display Name", "DisplayName")
            element("Avatar", "Avatar")
            element("Weapon", "Weapon", "WeaponGradient")
            element("Backpack", "Backpack", "BackpackGradient")
            element("Distance", "Distance", "DistanceGradient")

            preview.items[ "scrolling" ].Visible = false

            items[ "holder" ] = library:create( "Frame" , {
                Parent = preview.items[ "inline" ];
                Name = "\0";
                Position = dim2(0, 8, 0, 43);
                Size = dim2(1, -16, 1, -51);
                BorderSizePixel = 0;
                ClipsDescendants = true;
                BorderColor3 = rgb(0, 0, 0);
                BackgroundColor3 = rgb(19, 19, 21)
            });

            library:create( "UICorner" , {
                Parent = items[ "holder" ];
                CornerRadius = dim(0, 7)
            });

            items[ "viewport" ] = library:create( "ViewportFrame" , {
                Parent = items[ "holder" ];
                Name = "\0";
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = dim2(1, 0, 1, 0);
                Ambient = rgb(170, 170, 180);
                LightColor = rgb(255, 255, 255);
                LightDirection = vec3(-0.4, -0.6, 1)
            });

            items[ "camera" ] = library:create( "Camera" , {
                Parent = items[ "viewport" ];
                FieldOfView = 40
            });

            items[ "viewport" ].CurrentCamera = items[ "camera" ]

            items[ "overlay" ] = library:create( "Frame" , {
                Parent = items[ "holder" ];
                Name = "\0";
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = dim2(1, 0, 1, 0)
            });

            items[ "preview" ] = create_box(items[ "overlay" ], lp.UserId, 1)
            items[ "preview" ].Box.AnchorPoint = vec2(0.5, 0.5)
            items[ "preview" ].Box.Position = dim2(0.5, 0, 0.5, 0)

            cfg.gui = library:create( "ScreenGui" , {
                Name = "BoxESP";
                ResetOnSpawn = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
                Parent = gethui and gethui() or coregui
            });

            library.esp_unload = cfg.unload

            local function add_player(player)
                if player == lp or cfg.objects[player] then
                    return
                end

                local obj = create_box(cfg.gui, player.UserId, 0)
                obj.Player = player

                cfg.objects[player] = obj
            end

            local function remove_player(player)
                local obj = cfg.objects[player]

                if not obj then
                    return
                end

                obj.Box:Destroy()
                cfg.objects[player] = nil
            end

            for _, player in players:GetPlayers() do
                add_player(player)
            end

            library:connection(players.PlayerAdded, add_player)
            library:connection(players.PlayerRemoving, remove_player)

            run:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Last.Value, function()
                for _, obj in cfg.objects do
                    update_player(obj)
                end
            end)

            cfg.ready = true

            library:connection(items[ "viewport" ]:GetPropertyChangedSignal("AbsoluteSize"), cfg.layout)

            library:connection(run.RenderStepped, function(delta)
                if values.GradientAnimation then
                    cfg.build_animated_sequence()
                    cfg.refresh()
                end

                if cfg.motors then
                    for _, motor in next, cfg.motors do
                        if motor.Parent then
                            motor.Transform = cfr()
                        end
                    end
                end

                if not cfg.model or not items[ "viewport" ]:IsDescendantOf(game) then
                    return
                end

                if cfg.rotate then
                    cfg.rotation = (cfg.rotation + cfg.speed * delta) % 360
                    cfg.model:PivotTo(cfr(cfg.base) * angle(0, rad(cfg.rotation), 0))
                end

                cfg.draw_preview_skeleton()
            end)

            library:connection(lp.CharacterAdded, function()
                task.wait(1)
                cfg.load_model()
            end)

            cfg.load_model()

            return cfg
        end

        function library:bloxstrike_skin_manager(options)
            options = options or {}

            local cfg = {
                name = options.name or options.Name or "Skins";
                icon = options.icon or options.Icon or "shirt";
                timeout = options.timeout or options.Timeout or 5;
                items = {};
            }

            local knife_list = options.knives or options.Knives or {
                "CT Knife",
                "T Knife",
                "Karambit",
                "M9 Bayonet",
                "Butterfly Knife",
                "Flip Knife",
                "Gut Knife",
                "Skeleton Knife",
                "Stiletto Knife",
                "LightSaber",
            }

            local function load_game()
                local assets = rs:WaitForChild("Assets", cfg.timeout)
                local skin_assets = assets and assets:WaitForChild("Skins", cfg.timeout)
                local weapon_assets = assets and assets:WaitForChild("Weapons", cfg.timeout)

                if not skin_assets or not weapon_assets or not hookfunction then
                    return nil
                end

                return {
                    skins = require(rs.Database.Components.Libraries.Skins);
                    inventory = require(rs.Controllers.InventoryController);
                    skin_assets = skin_assets;
                    weapon_assets = weapon_assets;
                }
            end

            local loaded, game_data = pcall(load_game)

            if not loaded or not game_data then
                local page = self:tab({name = cfg.name, icon = cfg.icon, tabs = {"Skins"}})
                local column = page:column({})
                local section = column:section({name = "Skin Manager", size = 1, default = true, icon = "info"})

                section:label({name = "BloxStrike was not detected", info = "The skin manager only works inside BloxStrike."})

                return cfg
            end

            local skins = game_data.skins
            local inventory = game_data.inventory
            local skin_assets = game_data.skin_assets
            local weapon_assets = game_data.weapon_assets

            local env = getgenv()

            env.BloxStrikeSkinState = env.BloxStrikeSkinState or {overrides = {}, records = {}, knife_choice = nil, hooked = false}

            local state = env.BloxStrikeSkinState
            local rng = Random.new()
            local galleries = {}

            local knife_set = {}

            for _, knife_name in knife_list do
                knife_set[knife_name] = true
            end

            local function get_image(schema)
                local success, image = pcall(skins.GetItemIconImage, schema, {Float = 0})

                if not success or image == nil or image == "" then
                    return ""
                end

                if typeof(image) == "number" or (typeof(image) == "string" and tonumber(image) ~= nil) then
                    return "rbxassetid://" .. tostring(image)
                end

                if typeof(image) ~= "string" then
                    return ""
                end

                return image
            end

            local function get_skin_options(weapon_name, skip_images)
                local result = {}
                local all = skins.GetAllSkinsForWeapon(weapon_name)

                if not all then
                    return result
                end

                for _, schema in ipairs(all) do
                    local skin_name = schema.skin

                    if typeof(skin_name) == "string"
                        and skin_name ~= "Stock"
                        and schema.isEnabled ~= false
                        and skins.IsSkinAvailable(weapon_name, skin_name)
                    then
                        insert(result, {Name = skin_name, Image = skip_images and "" or get_image(schema)})
                    end
                end

                table.sort(result, function(a, b)
                    return a.Name < b.Name
                end)

                return result
            end

            local function is_glove(name)
                local lowered = string.lower(name)

                return string.find(lowered, "glove", 1, true) ~= nil or string.find(lowered, "wrap", 1, true) ~= nil
            end

            local function list_knife_names()
                local names = {}

                for _, knife_name in knife_list do
                    if weapon_assets:FindFirstChild(knife_name) then
                        insert(names, knife_name)
                    end
                end

                return names
            end

            local function list_weapon_names()
                local names = {}

                for _, folder in skin_assets:GetChildren() do
                    if folder:IsA("Folder") and not knife_set[folder.Name] and not is_glove(folder.Name) and #get_skin_options(folder.Name, true) > 0 then
                        insert(names, folder.Name)
                    end
                end

                table.sort(names)

                return names
            end

            local function list_glove_names()
                local names = {}

                for _, folder in skin_assets:GetChildren() do
                    if folder:IsA("Folder") and not knife_set[folder.Name] and is_glove(folder.Name) and #get_skin_options(folder.Name, true) > 0 then
                        insert(names, folder.Name)
                    end
                end

                table.sort(names)

                return names
            end

            local knife_names = list_knife_names()
            local weapon_names = list_weapon_names()
            local glove_names = list_glove_names()

            if not state.hooked then
                state.hooked = pcall(function()
                    local original

                    original = hookfunction(inventory.newInventoryItem, function(data, ...)
                        if typeof(data) == "table" and data.identifier ~= nil and typeof(data.weapon) == "string" then
                            state.records[data.identifier] = table.clone(data)

                            local weapon = data.weapon
                            local patched

                            if state.knife_choice and knife_set[weapon] and state.knife_choice ~= weapon then
                                weapon = state.knife_choice

                                local skin_options = get_skin_options(weapon, true)

                                patched = table.clone(data)
                                patched.weapon = weapon
                                patched.skin = state.overrides[weapon] or (skin_options[1] and skin_options[1].Name) or "Stock"
                            elseif state.overrides[weapon] then
                                patched = table.clone(data)
                                patched.skin = state.overrides[weapon]
                            end

                            if patched then
                                return original(patched, ...)
                            end
                        end

                        return original(data, ...)
                    end)
                end)
            end

            local function refresh_matching(predicate)
                for identifier, record in state.records do
                    if predicate(record.weapon) then
                        pcall(function()
                            local item = inventory.peekInventoryItemForMovement(identifier)

                            if not item then
                                return
                            end

                            local was_equipped = inventory.peekCurrentEquippedForMovement() == item

                            inventory.removeInventoryItem(identifier)

                            local data = table.clone(record)

                            data.shouldEquip = was_equipped

                            inventory.newInventoryItem(data)
                        end)
                    end
                end
            end

            local function refresh_weapon(weapon_name)
                refresh_matching(function(name)
                    return name == weapon_name
                end)
            end

            local function refresh_knives()
                refresh_matching(function(name)
                    return knife_set[name] == true
                end)
            end

            local function apply_change(weapon_name)
                if knife_set[weapon_name] then
                    refresh_knives()
                else
                    refresh_weapon(weapon_name)
                end
            end

            local function entry_selected(entry)
                if state.overrides[entry.weapon] ~= entry.skin then
                    return false
                end

                if entry.is_knife then
                    return state.knife_choice == entry.weapon
                end

                return true
            end

            local function refresh_selection()
                for _, gallery in galleries do
                    for _, entry in gallery.entries do
                        entry.set_selected(entry_selected(entry))
                    end
                end
            end

            local function entry_matches(gallery, entry)
                if gallery.filter ~= "All" and gallery.filter ~= entry.weapon then
                    return false
                end

                if gallery.search == "" then
                    return true
                end

                return string.find(string.lower(entry.skin), gallery.search, 1, true) ~= nil
                    or string.find(string.lower(entry.weapon), gallery.search, 1, true) ~= nil
            end

            local function apply_filters(gallery)
                for _, entry in gallery.entries do
                    local visible = entry_matches(gallery, entry)

                    if entry.card.Visible ~= visible then
                        entry.card.Visible = visible
                    end
                end
            end

            local function select_entry(entry)
                local weapon_name = entry.weapon

                if state.overrides[weapon_name] == entry.skin and (not entry.is_knife or state.knife_choice == weapon_name) then
                    state.overrides[weapon_name] = nil

                    if entry.is_knife then
                        state.knife_choice = nil
                    end
                else
                    if entry.is_knife then
                        for _, knife_name in knife_list do
                            if knife_name ~= weapon_name then
                                state.overrides[knife_name] = nil
                            end
                        end

                        state.knife_choice = weapon_name
                    end

                    state.overrides[weapon_name] = entry.skin
                end

                apply_change(weapon_name)
                refresh_selection()
            end

            local function build_card(gallery, entry, order)
                local card = library:create( "TextButton" , {
                    Parent = gallery.grid;
                    Name = "\0";
                    Text = "";
                    AutoButtonColor = false;
                    LayoutOrder = order;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(33, 33, 35);
                    Visible = entry_matches(gallery, entry)
                });

                library:create( "UICorner" , {
                    Parent = card;
                    CornerRadius = dim(0, 5)
                });

                local accent = library:create( "Frame" , {
                    Parent = card;
                    Name = "\0";
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 8);
                    Size = dim2(0, 3, 1, -16);
                    BackgroundColor3 = themes.preset.accent
                }); library:apply_theme(accent, "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = accent;
                    CornerRadius = dim(0, 999)
                });

                if entry.image ~= "" then
                    library:create( "ImageLabel" , {
                        Parent = card;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        AnchorPoint = vec2(0, 0.5);
                        Position = dim2(0, 10, 0.5, 0);
                        Size = dim_offset(80, 46);
                        ScaleType = Enum.ScaleType.Fit;
                        Image = entry.image
                    });
                end

                local skin_label = library:create( "TextLabel" , {
                    Parent = card;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = fonts.font;
                    Text = entry.skin;
                    TextSize = 14;
                    TextColor3 = rgb(245, 245, 245);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    Position = dim2(0, 100, 0, 10);
                    Size = dim2(1, -108, 0, 20)
                }); library:apply_theme(skin_label, "accent", "TextColor3");

                library:create( "TextLabel" , {
                    Parent = card;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = fonts.small;
                    Text = entry.weapon;
                    TextSize = 13;
                    TextColor3 = rgb(110, 110, 112);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    Position = dim2(0, 100, 0, 32);
                    Size = dim2(1, -108, 0, 16)
                });

                function entry.set_selected(bool)
                    local transparency = bool and 0 or 1

                    skin_label.TextColor3 = bool and themes.preset.accent or rgb(245, 245, 245)

                    if accent.BackgroundTransparency ~= transparency then
                        library:tween(accent, {BackgroundTransparency = transparency})
                    end
                end

                entry.card = card

                card.MouseButton1Click:Connect(function()
                    select_entry(entry)
                end)
            end

            local function build_gallery(page, title, icon, flag_prefix, is_knife, names, filter_label)
                local gallery = {entries = {}; search = ""; filter = "All"; is_knife = is_knife}

                local column = page:column({})
                local section = column:section({name = title, size = 1, default = true, icon = icon})

                section:textbox({name = "Search", flag = flag_prefix .. "_search", callback = function(text)
                    gallery.search = string.lower(string.match(text, "^%s*(.-)%s*$") or "")
                    apply_filters(gallery)
                end})

                local filter_items = {"All"}

                for _, name in names do
                    insert(filter_items, name)
                end

                section:dropdown({name = filter_label, flag = flag_prefix .. "_filter", items = filter_items, default = "All", scrolling = true, seperator = true, callback = function(value)
                    gallery.filter = type(value) == "string" and value or "All"
                    apply_filters(gallery)
                end})

                gallery.grid = library:create( "Frame" , {
                    Parent = section.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    LayoutOrder = 100;
                    Size = dim2(1, 0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y
                });

                library:create( "UIGridLayout" , {
                    Parent = gallery.grid;
                    CellSize = dim2(0.5, -4, 0, 62);
                    CellPadding = dim2(0, 8, 0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                insert(galleries, gallery)

                task.spawn(function()
                    local order = 0

                    for _, weapon_name in names do
                        for _, skin_option in get_skin_options(weapon_name) do
                            order += 1

                            local entry = {
                                weapon = weapon_name;
                                skin = skin_option.Name;
                                image = skin_option.Image;
                                is_knife = is_knife;
                            }

                            build_card(gallery, entry, order)
                            insert(gallery.entries, entry)
                            entry.set_selected(entry_selected(entry))

                            if order % 20 == 0 then
                                task.wait()
                            end
                        end
                    end
                end)

                return gallery
            end

            function cfg.randomize_all()
                task.spawn(function()
                    local equipment_names = {}

                    for _, weapon_name in weapon_names do
                        insert(equipment_names, weapon_name)
                    end

                    for _, glove_name in glove_names do
                        insert(equipment_names, glove_name)
                    end

                    for _, weapon_name in equipment_names do
                        local skin_options = get_skin_options(weapon_name, true)

                        if #skin_options > 0 then
                            state.overrides[weapon_name] = skin_options[rng:NextInteger(1, #skin_options)].Name
                            refresh_weapon(weapon_name)
                            task.wait(0.05)
                        end
                    end

                    if #knife_names > 0 then
                        local knife_name = knife_names[rng:NextInteger(1, #knife_names)]
                        local skin_options = get_skin_options(knife_name, true)

                        for _, other_name in knife_list do
                            state.overrides[other_name] = nil
                        end

                        state.knife_choice = knife_name
                        state.overrides[knife_name] = #skin_options > 0 and skin_options[rng:NextInteger(1, #skin_options)].Name or nil

                        refresh_knives()
                    end

                    refresh_selection()

                    notifications:create_notification({name = "Skins", info = "Randomized all skins"})
                end)
            end

            function cfg.reset_all()
                task.spawn(function()
                    local touched = {}

                    for weapon_name in state.overrides do
                        if not knife_set[weapon_name] then
                            insert(touched, weapon_name)
                        end
                    end

                    table.clear(state.overrides)

                    state.knife_choice = nil

                    for _, weapon_name in touched do
                        refresh_weapon(weapon_name)
                        task.wait(0.05)
                    end

                    refresh_knives()
                    refresh_selection()

                    notifications:create_notification({name = "Skins", info = "Reset all skins"})
                end)
            end

            local skin_config_path = library.config_path .. "/skins"
            local config_list

            local function update_skin_configs()
                if not isfolder(skin_config_path) then
                    makefolder(skin_config_path)
                end

                local list = {}

                for _, file in listfiles(skin_config_path) do
                    if string.match(file, "%.json$") then
                        local name = string.match(file, "([^/\\]+)$") or file

                        insert(list, (string.gsub(name, "%.json$", "")))
                    end
                end

                table.sort(list)

                if config_list then
                    config_list.refresh_options(list)
                end
            end

            local function apply_config(data)
                task.spawn(function()
                    local touched = {}

                    for weapon_name in state.overrides do
                        if not knife_set[weapon_name] then
                            touched[weapon_name] = true
                        end
                    end

                    table.clear(state.overrides)

                    state.knife_choice = nil

                    if type(data.overrides) == "table" then
                        for weapon_name, skin_name in data.overrides do
                            if type(weapon_name) == "string" and type(skin_name) == "string" then
                                state.overrides[weapon_name] = skin_name

                                if not knife_set[weapon_name] then
                                    touched[weapon_name] = true
                                end
                            end
                        end
                    end

                    if type(data.knife_choice) == "string" and knife_set[data.knife_choice] then
                        state.knife_choice = data.knife_choice
                    end

                    for weapon_name in touched do
                        refresh_weapon(weapon_name)
                        task.wait(0.05)
                    end

                    refresh_knives()
                    refresh_selection()
                end)
            end

            local knives_page, weapons_page, gloves_page, settings_page, config_page = self:tab({name = cfg.name, icon = cfg.icon, tabs = {"Knives", "Weapons", "Gloves", "Settings", "Config"}})

            cfg.knives = build_gallery(knives_page, "Knife Skins", "swords", "skin_knives", true, knife_names, "Knife")
            cfg.weapons = build_gallery(weapons_page, "Weapon Skins", "crosshair", "skin_weapons", false, weapon_names, "Weapon")
            cfg.gloves = build_gallery(gloves_page, "Glove Skins", "hand", "skin_gloves", false, glove_names, "Glove")

            local settings_column = settings_page:column({})
            local settings_section = settings_column:section({name = "Actions", size = 1, default = true, icon = "settings"})

            settings_section:label({name = "How it works", info = "Click a skin to equip it.\nClick it again to go back to your default."})
            settings_section:button({name = "Randomize All", callback = cfg.randomize_all})
            settings_section:button({name = "Reset All", callback = cfg.reset_all})


            local config_left = config_page:column({})
            local config_list_section = config_left:section({name = "Configs", size = 1, default = true, icon = "folder"})

            config_list = config_list_section:list({options = {}, flag = "skin_config_list"})

            local config_right = config_page:column({})
            local config_section = config_right:section({name = "Manage", size = 1, default = true, icon = "settings"})

            config_section:textbox({name = "Config name:", flag = "skin_config_name"})
            config_section:button({name = "Save", callback = function()
                local typed = flags["skin_config_name"]
                local name = (type(typed) == "string" and typed ~= "" and typed) or flags["skin_config_list"]

                if type(name) ~= "string" then
                    return
                end

                name = string.gsub(name, "[^%w%s_%-]", "")

                if name == "" then
                    return
                end

                writefile(skin_config_path .. "/" .. name .. ".json", http_service:JSONEncode({overrides = state.overrides, knife_choice = state.knife_choice}))
                update_skin_configs()
                notifications:create_notification({name = "Skin Configs", info = "Saved config:\n" .. name})
            end})
            config_section:button({name = "Load", callback = function()
                local name = flags["skin_config_list"]

                if type(name) ~= "string" or not isfile(skin_config_path .. "/" .. name .. ".json") then
                    return
                end

                local decoded, data = pcall(function()
                    return http_service:JSONDecode(readfile(skin_config_path .. "/" .. name .. ".json"))
                end)

                if not decoded or type(data) ~= "table" then
                    return
                end

                apply_config(data)
                notifications:create_notification({name = "Skin Configs", info = "Loaded config:\n" .. name})
            end})
            config_section:button({name = "Delete", callback = function()
                local name = flags["skin_config_list"]

                if type(name) ~= "string" or not isfile(skin_config_path .. "/" .. name .. ".json") then
                    return
                end

                delfile(skin_config_path .. "/" .. name .. ".json")
                update_skin_configs()
                notifications:create_notification({name = "Skin Configs", info = "Deleted config:\n" .. name})
            end})

            update_skin_configs()

            return cfg
        end

        function library:init_config(window)
            window:seperator({name = "Settings"})
            local main = window:tab({name = "Configs", icon = "settings", tabs = {"Main"}})

            local column = main:column({})
            local section = column:section({name = "Configs", size = 1, default = true, icon = "rbxassetid://139628202576511"})
            config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()

            local column = main:column({})
            local section = column:section({name = "Settings", side = "right", size = 1, default = true, icon = "rbxassetid://129380150574313"})
            section:textbox({name = "Config name:", flag = "config_name_text"})
            section:button({name = "Save", callback = function()
                local typed = flags["config_name_text"]
                local name = (type(typed) == "string" and typed ~= "" and typed) or flags["config_name_list"]

                if not name then
                    return
                end

                writefile(library.config_path .. "/" .. name .. ".cfg", library:get_config())
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Saved config to:\n" .. name})
            end})
            section:button({name = "Load", callback = function()
                local name = flags["config_name_list"]

                if not name or not isfile(library.config_path .. "/" .. name .. ".cfg") then
                    return
                end

                library:load_config(readfile(library.config_path .. "/" .. name .. ".cfg"))
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Loaded config:\n" .. name})
            end})
            section:button({name = "Delete", callback = function()
                local name = flags["config_name_list"]

                if not name or not isfile(library.config_path .. "/" .. name .. ".cfg") then
                    return
                end

                delfile(library.config_path .. "/" .. name .. ".cfg")
                library:update_config_list()
                notifications:create_notification({name = "Configs", info = "Deleted config:\n" .. name})
            end})
            section:colorpicker({name = "Menu Accent", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})

            window.menu_bind = section:keybind({name = "Menu Bind", callback = function(bool) window.toggle_menu(bool) end, default = true})
        end

        function notifications:refresh_notifs()
            local offset = 50

            for i, v in notifications.notifs do
                local Position = vec2(20, offset)
                library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
                offset += (max(v.AbsoluteSize.Y / (library.scale or 1), 53) + 10)
            end

            return offset
        end

        function notifications:fade(path, is_fading)
            local fading = is_fading and 1 or 0

            library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

            for _, instance in path:GetDescendants() do
                if not instance:IsA("GuiObject") then
                    if instance:IsA("UIStroke") then
                        library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                    end

                    continue
                end

                if instance:IsA("TextLabel") then
                    library:tween(instance, {TextTransparency = fading})
                elseif instance:IsA("Frame") then
                    library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
                end
            end
        end

        function notifications:create_notification(options)
            local cfg = {
                name = options.name or "This is a title!";
                info = options.info or "This is extra info!";
                lifetime = options.lifetime or 3;
                items = {};
                outline;
            }

            local items = cfg.items; do
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "root" ];
                    Size = dim2(0, 210, 0, 53);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(1, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "notification" ];
                    Transparency = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 7, 0, 6);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UICorner" , {
                    Parent = items[ "notification" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.info;
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 9, 0, 22);
                    Size = dim2(1, -9, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = true;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 17);
                    PaddingRight = dim(0, 8);
                    Parent = items[ "info" ]
                });

                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 8, 1, -6);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 5);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });

                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIPadding" , {
                    PaddingRight = dim(0, 8);
                    Parent = items[ "notification" ]
                });
            end

            insert(notifications.notifs, items[ "notification" ])

            notifications:fade(items[ "notification" ], false)

            local offset = notifications:refresh_notifs()

            items[ "notification" ].Position = dim_offset(20, offset)

            library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
            library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

            task.spawn(function()
                task.wait(cfg.lifetime)

                local notif_index = find(notifications.notifs, items[ "notification" ])

                if notif_index then
                    remove(notifications.notifs, notif_index)
                end

                notifications:refresh_notifs()

                notifications:fade(items[ "notification" ], true)

                library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)

                task.wait(1)

                items[ "notification" ]:Destroy()
            end)
        end

return library
