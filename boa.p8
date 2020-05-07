pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- globals
frame_counter = 0
snake_body = {}
snake_piece = {}
snake_last_pos = {}
food_x0 = 0
food_y0 = 0
food_x1 = 0
food_y1 = 0
x_dir = 0
y_dir = 0
offset = 4

frame_delay = 5

combo = false
chain_multiplier = 1
speed_multiplier = 1

pellets_eaten = 0
boa_wraps = 0


-- function call at the start of the program
function _init()
 cls()
 game_mode = "start"
 music(10)
end

function _update60()
 
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
  rand_x = flr(rnd(31)) + 1 
  rand_y = flr(rnd(30)) + 2
 until food_not_on_body(rand_x*offset,rand_y*offset)
  
 food_x0 = rand_x * offset
 food_y0 = rand_y * offset

 food_x1 = (food_x0 - 1) + offset
 food_y1 = (food_y0 - 1) + offset
end

function food_eaten()
 -- eaten if completely surrounded by snake
 if snake_body[1][1] == food_x0 and snake_body[1][2] == food_y0 then
   return true
 end
 return false
end

function touch_boundary()
 if snake_body[1][1] < 0 or snake_body[1][1] > 124 or snake_body[1][2] < 8 or snake_body[1][2] > 124 then
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
  rectfill(piece[1],piece[2],piece[3],piece[4],9)
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

function food_wrapped()
 -- if the food has snake completely around it return true
 local fx = food_x0
 local fy = food_y0
 if cs(fx-4,fy-4) and cs(fx,fy-4) and cs(fx+4,fy-4) and cs(fx-4,fy) and cs(fx+4,fy) and cs(fx-4,fy+4) and cs(fx,fy+4) and cs(fx+4,fy+4) then
  return true
 end
 return false
end

function cs(_x,_y)
 for _p in all(snake_body) do
  if _p[1] == _x and _p[2] == _y then
    return true
  end
 end
 return false
end

function speed_up()
 if (pellets_eaten + boa_wraps) == 2  then
  frame_delay = 14
 elseif (pellets_eaten + boa_wraps) == 4 then
  frame_delay = 13
 elseif (pellets_eaten + boa_wraps) == 6 then
  frame_delay = 12
 elseif (pellets_eaten + boa_wraps) == 8 then
  frame_delay = 11
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 12 then
  frame_delay = 10
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 16 then
  frame_delay = 9
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 20 then
  frame_delay = 8
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 28 then
  frame_delay = 7
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 36 then
  frame_delay = 6
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 44 then
  frame_delay = 5
  speed_multiplier += 0.20
 elseif (pellets_eaten + boa_wraps) == 52 then
  frame_delay = 4
  speed_multiplier += 0.20
 end
end

function start_game()
 game_mode = "game"
 music(0)
 frame_counter = 0
 
 -- spawns centerish
 snake_body = {}
 snake_piece = {60,60,63,63}
 snake_last_pos = {}
 
 add(snake_body,snake_piece)
 
 x_dir = 0
 y_dir = 0
 
 offset = 4
 
 food_respawn()
 score = 0
 frame_delay = 15
 combo = false
 chain_multiplier = 1
 speed_multiplier = 1
 pellets_eaten = 0
 boa_wraps = 0
end

function update_start()
 if btn(5) then
  music(-1)
  start_game()
 end
end

function update_game()
 frame_counter += 1
 keyboard_update()
 if frame_counter > frame_delay then
  snake_last_pos = last_snake_pos()
  snake_move()
  if food_eaten() then
   pellets_eaten += 1
   combo = false
   chain_multiplier = 1
 	 grow_snake()
 	 food_respawn()
 	 score += 1
 	 speed_up()
 	 sfx(13,-1)
 	end
 	if food_wrapped() then
 	 boa_wraps += 1
 	 if combo then
 	  chain_multiplier += 1
 	 end
 	 grow_snake()
 	 food_respawn()
 	 score += ceil(speed_multiplier * chain_multiplier * 10)
 	 combo = true
 	 speed_up()
 	 sfx(14,-1)
 	end
 	
 	if touch_boundary() or touch_body() then 
 	 game_mode = "gameover"
 	 music(-1,300)
 	 sfx(15)
 	 music(10)
  end
  
  frame_counter=0
 end
end

function update_gameover()
 if btn(5) then
  music(-1)
  start_game()
 end
end

function draw_start()
 print("pico-8 boa",44,40,7)
 print("press ❎ to start",32,60,11)
end

function draw_game()
 cls()
 -- background
 rectfill(0,8,127,127,2)
 -- print score
 print("score: " .. score .. "  chain multiplier: " .. chain_multiplier,1,1,7)
 -- snake food
 rectfill(food_x0,food_y0,food_x1,food_y1,10)
 --rect(food_x0,food_y0,food_x1,food_y1,11)
 line(food_x0,food_y0,food_x1,food_y1,2)
 line(food_x0+(offset-1),food_y0,food_x1-(offset-1),food_y1,2)
 -- draws snake
 draw_snake()
 -- draws the next piece of the snake to add, its a visual test
 --rectfill(snake_last_pos[1],snake_last_pos[2],snake_last_pos[3],snake_last_pos[4],12)
end

function draw_gameover()
 rectfill(20,48,108,85,0)
 print("game over",45,50,7)
 print("pellets eaten: " .. pellets_eaten,34,62,10)
 print("boa wraps:     " .. boa_wraps,34,68,9)
 print("press ❎ to restart",27,79,11)
end
__gfx__
00000000222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000299922222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000292292222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000292292222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000299992299222992200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000292292922929229200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000292292922929229200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000299922299222999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222229200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222223332222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000233323232333222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000332323332323233300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000233323333333332200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000232223222233322200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000233333222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00180020010630170000000010631f633000000000000000010630000000000000001f633000000000000000010630000000000010631f633000000000000000010630000001063000001f633000000000000000
01180020071550e1550a1550e155071550e1550a1550e155071550e1550a1550e155071550e1550a1550e155051550c155081550c155051550c155081550c155051550c155081550c155051550c137081550c155
01180020071550e1550a1550e155071550e1550a1550e155071550e1550a1550e155071550e1550a1550e155081550f1550c1550f155081550f1550c1550f155081550f1550c1550f155081550f1370c1550f155
01180020081550f1550c1550f155081550f1550c1550f155081550f1550c1550f155081550f1550c1550f155071550e1550a1550e155071550e1550a1550e155071550e1550a1550e155071550e1370a1550e155
011800201305015050160501605016050160551305015050160501605016050160551605015050160501a05018050160501805018050180501805018050180550000000000000000000000000000000000000000
011800201305015050160501605016050160551305015050160501605016050160551605015050160501a0501b0501b0501b0501b0501b0501b0501b0501b0550000000000000000000000000000000000000000
011800201b1301a1301b1301b1301b1301b1351b1301a1301b1301b1301b1301b1351b1301a1301b1301f1301a130181301613016130161301613016130161350000000000000000000000000000000000000000
011800201b1301a1301b1301b1301b1301b1351b1301a1301b1301b1301b1301b1351b1301a1301b1301f1301d1301d1301d1301d1301d1301d1301d1301d1350000000000000000000000000000000000000000
01180020081550f1550c1550f155081550f1550c1550f155081550f1550c1550f155081550f1550c1550f1550a155111550e155111550a155111550e155111550a155111550e155111550a155111550e15511155
011800202271024710267102671026710267152271024710267102671026710267152671024710267102971027710267102471024710247102471024710247150000000000000000000000000000000000000000
01180020227102471026710267102671026715227102471026710267102671026715267102471026710297102b7102b7102b7102b7102b7102b7102b7102b7150000000000000000000000000000000000000000
011800202b720297202b7202b7202b7202b7252b720297202b7202b7202b7202b7252b720297202b7202e72029720277202672026720267202672026720267250000000000000000000000000000000000000000
011800202b720297202b7202b7202b7202b7252b720297202b7202b7202b7202b7252b720297202b7202e7202e7202e7202e7202e7202e7202e7202e7202e7250000000000000000000000000000000000000000
000200000a5501655022550275502e5503155035550355503555033550315502f5502d5502b550275501f5500c550025500155002000010000230003500015000050000500000000000000000000000000000000
0003000023070290702c0702d0702d07028070210701c07021070260702a0702d0702e0702b0702607020070190701f07025070290702b0702c0702b0702807026070220701b07017070110700a0700507000070
000500001b55020550245502555023550175501c5502155024550235501f550175501d5502155022550205501a550175501a5501e550205501b55014550185501d550205501f5501b55018550145500e55009550
0112000003744030250a7040a005137441302508744080251b7110a704037440302524615080240a7440a02508744087250a7040c0241674416025167251652527515140240c7440c025220152e015220150a525
011200000c033247151f5152271524615227151b5051b5151f5201f5201f5221f510225212252022522225150c0331b7151b5151b715246151b5151b5051b515275202752027522275151f5211f5201f5221f515
011200000c0330802508744080250872508044187151b7151b7000f0251174411025246150f0240c7440c0250c0330802508744080250872508044247152b715275020f0251174411025246150f0240c7440c025
011200002452024520245122451524615187151b7151f71527520275202751227515246151f7151b7151f715295202b5212b5122b5152461524715277152e715275002e715275022e715246152b7152771524715
011200002352023520235122351524615177151b7151f715275202752027512275152461523715277152e7152b5202c5212c5202c5202c5202c5222c5222c5222b5202b5202b5222b515225151f5151b51516515
011200000c0330802508744080250872508044177151b7151b7000f0251174411025246150f0240b7440b0250c0330802508744080250872524715277152e715080242e715080242e715246150f0240c7440c025
__music__
01 01454300
00 02424300
00 01044344
00 02054344
00 01040900
00 02050a00
00 03064344
00 08074344
00 03060b00
02 08070c00
00 10424344
00 10424344
00 10114344
00 10114344
01 10114344
00 10114344
00 12134344
02 14154344
