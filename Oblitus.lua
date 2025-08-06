-- Oblitus
-- Binson Echorec emulation
-- v1.0 @your_name

engine.name = 'Oblitus'

local grid_device = grid.connect()
local UI = {}

-- Parameters
local drum_speed = 1.0
local feedback = 0.3
local mix = 0.5
local mode = 1 -- 1=Echo, 2=Repeat, 3=Swell
local head_states = {true, false, false, false}
local input_level = 0

-- Visual state
local disc_angle = 0
local disc_radius = 35
local center_x = 64
local center_y = 32
local head_positions = {
  {x = 0, y = -disc_radius, active = false},
  {x = disc_radius * 0.707, y = -disc_radius * 0.707, active = false},
  {x = disc_radius, y = 0, active = false},
  {x = disc_radius * 0.707, y = disc_radius * 0.707, active = false}
}

-- Mode names
local mode_names = {"ECHO", "REPEAT", "SWELL"}

function init()
  -- Initialize parameters
  params:add_control("drum_speed", "Drum Speed", controlspec.new(0.1, 2.0, 'lin', 0.01, 1.0))
  params:add_control("feedback", "Feedback", controlspec.new(0.0, 0.95, 'lin', 0.01, 0.3))
  params:add_control("mix", "Mix", controlspec.new(0.0, 1.0, 'lin', 0.01, 0.5))
  params:add_option("mode", "Mode", {"Echo", "Repeat", "Swell"}, 1)
  
  -- Set parameter actions
  params:set_action("drum_speed", function(x) 
    drum_speed = x
    engine.speed(x)
  end)
  
  params:set_action("feedback", function(x) 
    feedback = x
    engine.feedback(x)
  end)
  
  params:set_action("mix", function(x) 
    mix = x
    engine.mix(x)
  end)
  
  params:set_action("mode", function(x) 
    mode = x
    set_mode(x)
  end)
  
  -- Initialize engine
  engine.speed(drum_speed)
  engine.feedback(feedback)
  engine.mix(mix)
  set_mode(mode)
  
  -- Start visual animation
  clock.run(animate_disc)
  clock.run(update_levels)
  
  redraw()
end

function set_mode(m)
  mode = m
  if mode == 1 then -- Echo
    engine.echo_mode()
    head_states = {true, false, false, false}
  elseif mode == 2 then -- Repeat
    engine.repeat_mode()
    head_states = {true, true, false, false}
  else -- Swell
    engine.swell_mode()
    head_states = {true, true, true, true}
  end
  
  for i = 1, 4 do
    engine.head_state(i, head_states[i] and 1 or 0)
  end
end

function animate_disc()
  while true do
    disc_angle = (disc_angle + (drum_speed * 0.05)) % (2 * math.pi)
    
    -- Update head positions based on disc rotation
    for i, head in ipairs(head_positions) do
      local angle = disc_angle + (i - 1) * math.pi / 2
      head.x = center_x + disc_radius * math.cos(angle)
      head.y = center_y + disc_radius * math.sin(angle)
      head.active = head_states[i]
    end
    
    redraw()
    clock.sleep(1/30) -- 30 FPS
  end
end

function update_levels()
  while true do
    -- Simulate input level (in real implementation, get from engine)
    input_level = math.random() * 0.3 + 0.1
    clock.sleep(1/10) -- 10 Hz update
  end
end

function key(n, z)
  if z == 1 then
    if n == 1 then
      -- Cycle mode
      local new_mode = (mode % 3) + 1
      params:set("mode", new_mode)
    elseif n == 2 then
      -- Tap tempo (simplified)
      params:set("drum_speed", math.random() * 1.5 + 0.5)
    elseif n == 3 then
      -- Reset to defaults
      params:set("drum_speed", 1.0)
      params:set("feedback", 0.3)
      params:set("mix", 0.5)
    end
  end
end

function enc(n, d)
  if n == 1 then
    -- Drum speed
    local new_speed = util.clamp(drum_speed + d * 0.01, 0.1, 2.0)
    params:set("drum_speed", new_speed)
  elseif n == 2 then
    -- Feedback
    local new_feedback = util.clamp(feedback + d * 0.01, 0.0, 0.95)
    params:set("feedback", new_feedback)
  elseif n == 3 then
    -- Mix
    local new_mix = util.clamp(mix + d * 0.01, 0.0, 1.0)
    params:set("mix", new_mix)
  end
end

function redraw()
  screen.clear()
  
  -- Draw main disc
  screen.level(8)
  screen.circle(center_x, center_y, disc_radius)
  screen.stroke()
  
  -- Draw disc center
  screen.level(15)
  screen.circle(center_x, center_y, 3)
  screen.fill()
  
  -- Draw magnetic tape tracks (visual effect)
  for r = 15, disc_radius - 5, 8 do
    screen.level(3)
    screen.circle(center_x, center_y, r)
    screen.stroke()
  end
  
  -- Draw record head (fixed position at top)
  screen.level(12)
  screen.rect(center_x - 3, center_y - disc_radius - 8, 6, 6)
  screen.fill()
  screen.level(15)
  screen.move(center_x, center_y - disc_radius - 12)
  screen.text_center("REC")
  
  -- Draw playback heads
  for i, head in ipairs(head_positions) do
    screen.level(head.active and 15 or 5)
    screen.circle(head.x, head.y, 4)
    screen.fill()
    
    -- Head numbers
    screen.level(head.active and 0 or 15)
    screen.move(head.x, head.y + 2)
    screen.text_center(tostring(i))
  end
  
  -- Draw UI elements
  draw_ui()
  
  screen.update()
end

function draw_ui()
  -- Mode display
  screen.level(15)
  screen.move(8, 10)
  screen.text("MODE: " .. mode_names[mode])
  
  -- Parameter values
  screen.level(10)
  screen.move(8, 20)
  screen.text("SPEED: " .. string.format("%.2f", drum_speed))
  
  screen.move(8, 30)
  screen.text("FDBK: " .. string.format("%.2f", feedback))
  
  screen.move(8, 40)
  screen.text("MIX: " .. string.format("%.2f", mix))
  
  -- Input level meter (magic eye simulation)
  screen.level(8)
  screen.rect(8, 50, 40, 4)
  screen.stroke()
  
  screen.level(15)
  local level_width = math.floor(input_level * 38)
  screen.rect(9, 51, level_width, 2)
  screen.fill()
  
  screen.level(10)
  screen.move(8, 60)
  screen.text("INPUT")
  
  -- Key instructions
  screen.level(5)
  screen.move(100, 55)
  screen.text("K1:MODE")
  screen.move(100, 62)
  screen.text("K2:TAP K3:RST")
end

-- Grid integration
function grid_key(x, y, z)
  if z == 1 then
    if y == 1 and x <= 4 then
      -- Toggle playback heads
      head_states[x] = not head_states[x]
      engine.head_state(x, head_states[x] and 1 or 0)
    elseif y == 2 then
      -- Speed presets
      local speeds = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0}
      if x <= 8 then
        params:set("drum_speed", speeds[x])
      end
    elseif y == 3 then
      if x <= 3 then
        -- Mode selection
        params:set("mode", x)
      elseif x == 8 then
        -- Tap tempo
        params:set("drum_speed", math.random() * 1.5 + 0.5)
      end
    end
  end
  
  -- Update grid display
  grid_redraw()
end

function grid_redraw()
  grid_device:all(0)
  
  -- Playback heads row
  for i = 1, 4 do
    grid_device:led(i, 1, head_states[i] and 15 or 4)
  end
  
  -- Speed presets row
  local current_speed_index = math.floor(drum_speed * 4) + 1
  for i = 1, 8 do
    grid_device:led(i, 2, i == current_speed_index and 15 or 2)
  end
  
  -- Mode row
  for i = 1, 3 do
    grid_device:led(i, 3, i == mode and 15 or 4)
  end
  grid_device:led(8, 3, 8) -- Tap tempo
  
  grid_device:refresh()
end

-- Connect grid
if grid_device then
  grid_device.key = grid_key
  grid_redraw()
end