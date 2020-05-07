pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- globals
frame_counter = 0
snake_body = {}
snake_piece = {}
snake_last_pos = {}
x_dir = 0
y_dir = 0
offset = 8

function _init()
 cls()
 game_mode = "start"
end

function _update()
 
 if game_mode == "start" then
  update_start()
 elseif game_mode == "game" then
  update_game()
 elseif game_mode == "gameover" then
  update_gameover()
 end
  
end

function _draw()
 if game_mode == "start" then
  draw_start()
 elseif game_mode == "game" then
  draw_game()
 elseif game_mode == "gameover" then
  draw_gameover()
 end
end

function keyboard_update()
 -- if right arrow pressed
 if btnp(1) and x_dir!=-1  then
  x_dir = 1
  y_dir = 0
 end
 -- if left arrow pressed
 if btnp(0) and x_dir!=1 then
  x_dir = -1
  y_dir = 0
 end
 -- if down arrow pressed
 if btnp(3) and y_dir!=-1 then
  x_dir = 0
  y_dir = 1
 end
 -- if up arrow pressed
 if btnp(2) and y_dir!=1 then
  x_dir = 0
  y_dir = -1
 end
end

function food_respawn()
  -- if food is on the body pick again
  repeat
   rand_x = flr(rnd(15)) + 1 
   rand_y = flr(rnd(15)) + 1
  until food_not_on_body(rand_x*offset,rand_y*offset)
  
  food_x0 = rand_x * offset
  food_y0 = rand_y * offset
  
  food_x1 = (food_x0 - 1) + offset
  food_y1 = (food_y0 - 1) + offset
end

function food_eaten()
  if snake_body[1][1] == food_x0 and snake_body[1][2] == food_y0 then
    return true
  end
  return false
end

function touch_boundary()
 if snake_body[1][1] < 0 or snake_body[1][1] > 120 or snake_body[1][2] < 8 or snake_body[1][2] > 120 then
  return true
 end
end

function touch_body()
 for k, v in pairs(snake_body) do
  if ((snake_body[1][1] == v[1]) and (snake_body[1][2] == v[2])) and k > 1 then
   return true
  end
 end
 return false
end

function grow_snake()
 -- add to the snake_body table
 add(snake_body,snake_last_pos)
end

function draw_snake()
 for piece in all(snake_body) do
  rectfill(piece[1],piece[2],piece[3],piece[4],3)
 end
end

function snake_move() 
 for i=#snake_body,2,-1 do
  snake_body[i]= {snake_body[i-1][1],snake_body[i-1][2],snake_body[i-1][3],snake_body[i-1][4]}
 end
 snake_body[1][1] += offset * x_dir
 snake_body[1][2] += offset * y_dir
 snake_body[1][3] += offset * x_dir
 snake_body[1][4] += offset * y_dir
end

function last_snake_pos()
 for i, piece in pairs(snake_body) do
  if i == #snake_body then
   return {piece[1],piece[2],piece[3],piece[4]}
  end
 end 
end

function food_not_on_body(val_x, val_y)
 for k, p in pairs(snake_body) do
  if p[1] == val_x and p[2] == val_y then
   return false
  end
 end
 return true
end

function start_game()
 game_mode = "game"
 frame_counter = 0
 
 -- spawns centerish
 snake_body = {}
 snake_piece = {56,56,63,63}
 snake_last_pos = {}
 
 add(snake_body,snake_piece)
 
 x_dir = 0
 y_dir = 0
 
 offset = 8
 
 food_respawn()
 score = 0
end

function update_start()
 if btn(5) then
  start_game()
 end
end

function update_game()
 frame_counter += 1
 keyboard_update()
 if frame_counter > 5 then
  snake_last_pos = last_snake_pos()
  snake_move()
  
  if food_eaten() then
 	 grow_snake()
 	 food_respawn()
 	 score += 1
 	end
 	
 	if touch_boundary() or touch_body() then 
 	 game_mode = "gameover"
  end
  
  frame_counter=0
 end
end

function update_gameover()
 if btn(5) then
  start_game()
 end
end

function draw_start()
 print("pico-8 snake",41,40,7)
 print("press ❎ to start",32,60,11)
end

function draw_game()
 cls()
 -- background
 rectfill(0,8,127,127,11)
 -- print score
 print("score: " .. score,1,1,7)
 -- snake food
 rectfill(food_x0,food_y0,food_x1,food_y1,3)
 rect(food_x0,food_y0,food_x1,food_y1,11)
 line(food_x0,food_y0,food_x1,food_y1,11)
 line(food_x0+7,food_y0,food_x1-7,food_y1,11)
 -- draws snake
 draw_snake()
 -- draws the next piece of the snake to add, its a visual test
 --rectfill(snake_last_pos[1],snake_last_pos[2],snake_last_pos[3],snake_last_pos[4],12)
end

function draw_gameover()
 rectfill(0,60,128,75,0)
 print("game over",45,62,7)
 print("press ❎ to restart",27,68,6)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000001f7501f7501e7501d7501a75017750127500e75009750037701470023700207001b7001970007700127000e7000970002700000000000000000000000000000000000000000000000000000000000000
