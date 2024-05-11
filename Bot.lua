-- Initializing global variables
local LatestGameState = nil
local Game = "oPre75iYJzWPiNkk_7B6QwmDPBSJIn9Rqrvil1Gho7U"
local CRED = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc"
local Counter = 0
local colors = {
   red = "\\27\\[31m",
   green = "\\27\\[32m",
   blue = "\\27\\[34m",
   reset = "\\27\\[0m",
   gray = "\\27\\[90m"
}

-- Set player and enemy energy
local playerEnergy = 100
local enemyEnergy = 50

-- Set player coordinates
local x1_player = 4
local y1_player = 5
local x2_player = 8
local y2_player = 10

-- Set maximum range to find enemy at coordinate 7
local maxRange = 3

-- Function to decide the next action
function decideNextAction()
    local player = LatestGameState.Players[ao.id]
    local playerEnergy = player.energy
    local playerX = player.x
    local playerY = player.y

    -- Check player's energy and print in respective color
    if playerEnergy <= 25 then
        print(colors.red .. "Bot's energy is less than or equal to 25." .. colors.reset)
    elseif playerEnergy <= 50 then
        print(colors.gray .. "Bot's energy is less than or equal to 50." .. colors.reset)
        -- If player's energy <= 50 and enemy has energy >= enemyEnergy, player will move away from enemy
        if opponent.energy >= enemyEnergy then
            print("Player's energy is less than or equal to 50 and enemy has energy >= enemyEnergy. Moving away from enemy.")
            elseif playerEnergy <= 75 then
        print(colors.blue .. "Bot's energy is less than or equal to 75." .. colors.reset)
    elseif playerEnergy <= 90 then
        print(colors.green .. "Bot's energy is less than or equal to 90." .. colors.reset)
    end

    -- Check for weak enemies with energy less than or equal to enemyEnergy and at coordinate 7
    for id, opponent in pairs(LatestGameState.Players) do
        if id ~= ao.id then
            if opponent.energy <= enemyEnergy and opponent.x == 7 and math.abs(opponent.y - playerY) <= maxRange then
                print(colors.gray .. "Weak enemy detected at coordinates: " .. opponent.x .. ", " .. opponent.y .. colors.reset)
                -- Bot moves closer and attacks the weak enemy
                local deltaX = opponent.x - playerX
                local deltaY = opponent.y - playerY
                if math.abs(deltaX) > math.abs(deltaY) then
                    if deltaX > 0 then
                        print("Moving right")
                    else
                        print("Moving left")
                    end
                else
                    if deltaY > 0 then
                        print("Moving down")
                    else
                        print("Moving up")
                    end
                end
                print("Attacking the weak enemy.")
                return
            end
        end
    end

-- Handler to update the game state
Handlers.add(
    "UpdateGameState",
    Handlers.utils.hasMatchingTag("Action", "UpdatedGameState"),
    function()
        print("Location: " .. "row: " .. LatestGameState.Players[ao.id].x .. ' col: ' .. LatestGameState.Players[ao.id].y)

        -- Display information about the bot's position and the positions of all players whenever the game state is updated
        print("Information about the position of all players:")
        for id, player in pairs(LatestGameState.Players) do
            print("ID: " .. id .. ", Location: row " .. player.x .. ", col " .. player.y)
        end
    end
)

-- Handler to handle respawn after elimination
function respawn()
    print("Eliminated! " .. "Playing again!")
    Send({Target = CRED, Action = "Transfer", Quantity = "1000", Recipient = Game})
end

Handlers.add(
    "Respawn",
    Handlers.utils.hasMatchingTag("Action", "Eliminated"),
    function(msg)
        respawn()
    end
)

-- Handler to start the game tick
Handlers.add(
    "StartTick",
    Handlers.utils.hasMatchingTag("Action", "Payment-Received"),
    function(msg)
        Send({Target = Game, Action = "GetGameState", Name = Name, Owner =Owner})
        print('Start Moving!')
    end
)

-- Prompt function
Prompt = function() return Name .. "> " end
            
           
    

 
    


