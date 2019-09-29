%% rwdsdasawddpseawdcceadsasdwaderwasdwasdpuhdwadsawsdawdacchad  dw dchdsdsawdsawdsawdswdadwsdwsdasdasdwadw%NOTE: All images must be downloaded before running code
 
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebuglevel',0);
Screen('Preference','SuppressAllWarnings',1);
 
close all;
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
HideCursor;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
topPriorityLevel = MaxPriority(window);
[xCenter, yCenter] = RectCenter(windowRect);
ifi = Screen('GetFlipInterval', window);
vbl = Screen('Flip', window);
numSecs = 1;
 
%Important Colors & Initializations %
green = [0 1 0];
olive_green = [0.47 0.77 0.5];
soft_green = [0.71 0.77 0.47];
yellow = [1 1 0];
red = [1 0 0];
wait_for_seconds = 1;
exit_screen_demo_intro_to_instructions = false;
exit_screen_demo_instructions_to_next = false;
move_to_next_screen = KbName('R');
move_to_next_screen_instructions = KbName('P');
up_key = KbName('W');
down_key = KbName('S');
left_key = KbName('A');
right_key = KbName('D');
snake_demo = [0 0 50 50];
snake_starting_location_demo_x = xCenter;
snake_starting_location_demo_y = yCenter;
pixels_that_snake_moves = 10;
prev_points = 0;
 
%%Background Screen for Introduction Screen%%
instruction_screen_bg = imread('starting_screen.png'); %Intro Screen BG
instruction_screen_bg = imresize(instruction_screen_bg, [screenYpixels screenXpixels]);
defining_instruction_screen = Screen('MakeTexture', window, instruction_screen_bg);
 
while exit_screen_demo_intro_to_instructions == false
    randR = rand();
    randG = rand();
    randB = rand();
    
    Screen('DrawTexture', window, defining_instruction_screen, [0 0 screenXpixels screenYpixels], [0 0 screenXpixels screenYpixels], 0, 0) %Drawing Background
    Screen('TextSize', window, 40);
    Screen('TextFont', window, 'VCR OSD Mono');
    DrawFormattedText(window, ['Press'], screenXpixels * 0.46, screenXpixels * 0.53, [randR randG randB]);
    DrawFormattedText(window, ['"R"'], screenXpixels * 0.475, screenXpixels * 0.565, white);
    DrawFormattedText(window, ['to Begin'], screenXpixels * 0.4325, screenXpixels * 0.6, [randR randG randB]);
    vbl  = Screen('Flip', window, vbl + (wait_for_seconds * ifi));
    
    [keyIsDown, secs, keycode] = KbCheck(-1);
    
    if keyIsDown
        if strcmp(KbName(keycode), KbName(move_to_next_screen))
            exit_screen_demo_intro_to_instructions = true;
        end
    end
    
    
end
%% Instructions Screen %%
while exit_screen_demo_instructions_to_next == false
    % Instructions: Words %
    Screen('TextSize', window, 30);
    Screen('TextFont', window, 'VCR OSD Mono');
    DrawFormattedText(window, ['INSTRUCTIONS'],screenXpixels * 0.05, screenYpixels * 0.2, red); %glitches when screen flips
    Screen('TextSize', window, 30);
    DrawFormattedText(window, ['KEYS: \n'...
        , 'W = UP \n'...
        , 'S = DOWN \n'...
        , 'A = LEFT \n'...
        , 'D = RIGHT \n'],screenXpixels * 0.05, screenYpixels * 0.29, white);
    
    DrawFormattedText(window, ['RULES: \n'...
        , 'Avoid Poison \n'...
        , 'Eat food to grow \n'...
        , 'Do not run into yourself \n'...
        , 'Do not press more than two keys \n' ...
        , 'Never leave screen \n'],screenXpixels * 0.05, screenYpixels * 0.55, white);
    
    DrawFormattedText(window, ['Try it Yourself!'], screenXpixels * 0.05, screenYpixels * 0.8, yellow);
    Screen('TextSize', window, 30);
    DrawFormattedText(window, ['Press "P" to Proceed!'], screenXpixels * 0.05, screenYpixels * 0.84, red);
    
    centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
    Screen('FillRect', window, [0 0.6 0.298], centeredRect);
    vbl  = Screen('Flip', window, vbl + (wait_for_seconds - 0.5) * ifi);
    
    % Instructions: Demo Snake %
    
    [keyIsDown, secs, keycode] = KbCheck;
    if keycode(move_to_next_screen_instructions)
        exit_screen_demo_instructions_to_next = true;
    elseif keycode(left_key)
        while ~keycode(right_key) || ~keycode(up_key) || ~keycode(down_key)
            DrawFormattedText(window, ['INSTRUCTIONS'],screenXpixels * 0.05, screenYpixels * 0.2, red);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['KEYS: \n'...
                , 'W = UP \n'...
                , 'S = DOWN \n'...
                , 'A = LEFT \n'...
                , 'D = RIGHT \n'],screenXpixels * 0.05, screenYpixels * 0.29, white);
            
            DrawFormattedText(window, ['RULES: \n'...
                , 'Avoid Poison \n'...
                , 'Eat food to grow \n'...
                , 'Do not run into yourself \n'...
                , 'Do not press more than two keys \n' ...
                , 'Never leave screen \n'],screenXpixels * 0.05, screenYpixels * 0.55, white);
            
            DrawFormattedText(window, ['Try it Yourself!'], screenXpixels * 0.05, screenYpixels * 0.8, yellow);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['Press "P" to Proceed!'], screenXpixels * 0.05, screenYpixels * 0.84, red);
            
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            snake_starting_location_demo_x = snake_starting_location_demo_x - pixels_that_snake_moves;
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            vbl  = Screen('Flip', window, vbl + (wait_for_seconds - 0.5) * ifi);
            [keyIsDown, secs, keycode] = KbCheck;
            if keycode(right_key) || keycode(up_key) || keycode(down_key)
                break;
            elseif keycode(move_to_next_screen_instructions)
                exit_screen_demo_instructions_to_next = true;
                break;
            end
        end
    elseif keycode(right_key)
        while ~keycode(left_key) || ~keycode(up_key) || ~keycode(down_key)
            DrawFormattedText(window, ['INSTRUCTIONS'],screenXpixels * 0.05, screenYpixels * 0.2, red);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['KEYS: \n'...
                , 'W = UP \n'...
                , 'S = DOWN \n'...
                , 'A = LEFT \n'...
                , 'D = RIGHT \n'],screenXpixels * 0.05, screenYpixels * 0.29, white);
            
            DrawFormattedText(window, ['RULES: \n'...
                , 'Avoid Poison \n'...
                , 'Eat food to grow \n'...
                , 'Do not run into yourself \n'...
                , 'Do not press more than two keys \n' ...
                , 'Never leave screen \n'],screenXpixels * 0.05, screenYpixels * 0.55, white);
            
            DrawFormattedText(window, ['Try it Yourself!'], screenXpixels * 0.05, screenYpixels * 0.8, yellow);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['Press "P" to Proceed!'], screenXpixels * 0.05, screenYpixels * 0.84, red);
            
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            snake_starting_location_demo_x = snake_starting_location_demo_x + pixels_that_snake_moves;
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            vbl  = Screen('Flip', window, vbl + (wait_for_seconds - 0.5) * ifi);
            [keyIsDown, secs, keycode] = KbCheck;
            if keycode(left_key) || keycode(up_key) || keycode(down_key)
                break;
            elseif keycode(move_to_next_screen_instructions)
                exit_screen_demo_instructions_to_next = true;
                break;
            end
        end
    elseif keycode(up_key)
        while ~keycode(left_key) || ~keycode(right_key) || ~keycode(down_key)
            DrawFormattedText(window, ['INSTRUCTIONS'],screenXpixels * 0.05, screenYpixels * 0.2, red);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['KEYS: \n'...
                , 'W = UP \n'...
                , 'S = DOWN \n'...
                , 'A = LEFT \n'...
                , 'D = RIGHT \n'],screenXpixels * 0.05, screenYpixels * 0.29, white);
            
            DrawFormattedText(window, ['RULES: \n'...
                , 'Avoid Poison \n'...
                , 'Eat food to grow \n'...
                , 'Do not run into yourself \n'...
                , 'Do not press more than two keys \n' ...
                , 'Never leave screen \n'],screenXpixels * 0.05, screenYpixels * 0.55, white);
            
            DrawFormattedText(window, ['Try it Yourself!'], screenXpixels * 0.05, screenYpixels * 0.8, yellow);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['Press "P" to Proceed!'], screenXpixels * 0.05, screenYpixels * 0.84, red);
            
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            snake_starting_location_demo_y = snake_starting_location_demo_y - pixels_that_snake_moves;
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            vbl  = Screen('Flip', window, vbl + (wait_for_seconds - 0.5) * ifi);
            [keyIsDown, secs, keycode] = KbCheck;
            if keycode(left_key) || keycode(right_key) || keycode(down_key)
                break;
            elseif keycode(move_to_next_screen_instructions)
                exit_screen_demo_instructions_to_next = true;
                break;
            end
        end
    elseif keycode(down_key)
        while ~keycode(left_key) || ~keycode(right_key) || ~keycode(up_key)
            DrawFormattedText(window, ['INSTRUCTIONS'],screenXpixels * 0.05, screenYpixels * 0.2, red);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['KEYS: \n'...
                , 'W = UP \n'...
                , 'S = DOWN \n'...
                , 'A = LEFT \n'...
                , 'D = RIGHT \n'],screenXpixels * 0.05, screenYpixels * 0.29, white);
            
            DrawFormattedText(window, ['RULES: \n'...
                , 'Avoid Poison \n'...
                , 'Eat food to grow \n'...
                , 'Do not run into yourself \n'...
                , 'Do not press more than two keys \n' ...
                , 'Never leave screen \n'],screenXpixels * 0.05, screenYpixels * 0.55, white);
            
            DrawFormattedText(window, ['Try it Yourself!'], screenXpixels * 0.05, screenYpixels * 0.8, yellow);
            Screen('TextSize', window, 30);
            DrawFormattedText(window, ['Press "P" to Proceed!'], screenXpixels * 0.05, screenYpixels * 0.84, red);
            
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            snake_starting_location_demo_y = snake_starting_location_demo_y + pixels_that_snake_moves;
            centeredRect = CenterRectOnPointd(snake_demo, snake_starting_location_demo_x, snake_starting_location_demo_y);
            Screen('FillRect', window, [0 0.6 0.298], centeredRect);
            vbl  = Screen('Flip', window, vbl + (wait_for_seconds - 0.5) * ifi);
            [keyIsDown, secs, keycode] = KbCheck;
            if keycode(left_key) || keycode(right_key) || keycode(up_key)
                break;
            elseif keycode(move_to_next_screen_instructions)
                exit_screen_demo_instructions_to_next = true;
                break;
            end
        end
    end
    
    if snake_starting_location_demo_x < 0
        snake_starting_location_demo_x = 0;
    elseif snake_starting_location_demo_x > screenXpixels
        snake_starting_location_demo_x = screenXpixels;
    end
    
    if snake_starting_location_demo_y < 0
        snake_starting_location_demo_y = 0;
    elseif snake_starting_location_demo_y > screenYpixels
        snake_starting_location_demo_y = screenYpixels;
    end
    
end
 
%% Choose World
world_choice = true;
while world_choice == true
keyIsDown = false;
land_choice = false;
while land_choice == false
    Screen('TextFont', window, 'VCR OSD Mono');
    title_selection_text = ['Choose your world \n \n'];
    selection_text = ['Press "C" for Candyland \n "U" for Underwater \n or "S" for Space'];
    randR = rand();
    randG = rand();
    randB = rand();
    Screen('TextSize', window, 50);
    DrawFormattedText(window, title_selection_text, 'center', 100, [1 1 1], windowRect);
    Screen('TextSize', window, 35);
    DrawFormattedText(window, selection_text, 'center', 400, [randR, randG, randB], windowRect);
    vbl  = Screen('Flip', window, vbl + (wait_for_seconds * ifi));
    [keyIsDown, secs, keycode] = KbCheck(-1);
    if keyIsDown == true
        if KbName(keycode) == 'c'
            land_choice = true;
            %Resizing Monster, Snack, and Poison Images
            snack_img = imread('food_candyland.png');
            snack_img = imresize(snack_img, [30, 30]);
            snack_tex = Screen('MakeTexture', window, snack_img);
            poison_img = imread('poison_candyland.png');
            poison_img = imresize(poison_img, [30, 30]);
            poison_tex = Screen('MakeTexture', window, poison_img);
            monster_1_img = imread('monster_candyland_1.png');
            monster_1_img = imresize(monster_1_img, [30, 30]);
            monster_1_tex = Screen('MakeTexture', window, monster_1_img);
            monster_2_img = imread('monster_candyland_2.png');
            monster_2_img = imresize(monster_2_img, [40, 40]);
            monster_2_tex = Screen('MakeTexture', window, monster_2_img);
            monster_3_img = imread('monster_candyland_3.png');
            monster_3_img = imresize(monster_3_img, [50, 50]);
            monster_3_tex = Screen('MakeTexture', window, monster_3_img);
            % Background
            background_screen = imread('background_candyland.jpg');
            background_screen = imresize(background_screen, [screenYpixels screenXpixels]);
            background_screen = Screen('MakeTexture', window, background_screen);
        elseif KbName(keycode) == 'u'
            land_choice = true;
            %Resizing Monster, Snack, and Poison Images
            snack_img = imread('food_underwater.png');
            snack_img = imresize(snack_img, [30, 30]);
            snack_tex = Screen('MakeTexture', window, snack_img);
            poison_img = imread('poison_underwater.png');
            poison_img = imresize(poison_img, [30, 30]);
            poison_tex = Screen('MakeTexture', window, poison_img);
            monster_1_img = imread('monster_underwater_1.png');
            monster_1_img = imresize(monster_1_img, [30, 30]);
            monster_1_tex = Screen('MakeTexture', window, monster_1_img);
            monster_2_img = imread('monster_underwater_2.png');
            monster_2_img = imresize(monster_2_img, [40, 40]);
            monster_2_tex = Screen('MakeTexture', window, monster_2_img);
            monster_3_img = imread('monster_underwater_3.png');
            monster_3_img = imresize(monster_3_img, [50, 50]);
            monster_3_tex = Screen('MakeTexture', window, monster_3_img);
            % Background
            background_screen = imread('background_underwater.jpg');
            background_screen = imresize(background_screen, [screenYpixels screenXpixels]);
            background_screen = Screen('MakeTexture', window, background_screen);
        elseif KbName(keycode) == 's'
            land_choice = true;
            %Resizing Monster, Snack, and Poison Images
            snack_img = imread('food_space.png');
            snack_img = imresize(snack_img, [30, 30]);
            snack_tex = Screen('MakeTexture', window, snack_img);
            poison_img = imread('poison_space.png');
            poison_img = imresize(poison_img, [30, 30]);
            poison_tex = Screen('MakeTexture', window, poison_img);
            monster_1_img = imread('monster_space_1.png');
            monster_1_img = imresize(monster_1_img, [30, 30]);
            monster_1_tex = Screen('MakeTexture', window, monster_1_img);
            monster_2_img = imread('monster_space_2.png');
            monster_2_img = imresize(monster_2_img, [40, 40]);
            monster_2_tex = Screen('MakeTexture', window, monster_2_img);
            monster_3_img = imread('monster_space_3.png');
            monster_3_img = imresize(monster_3_img, [50, 50]);
            monster_3_tex = Screen('MakeTexture', window, monster_3_img);
            % Background
            background_screen = imread('background_space.jpg');
            background_screen = imresize(background_screen, [screenYpixels screenXpixels]);
            background_screen = Screen('MakeTexture', window, background_screen);
        end
    end
end
 
level_choice = false
while level_choice == false
    Screen('TextFont', window, 'VCR OSD Mono');
    level_selection_text = ['Choose your level \n \n'];
    level_text = ['Press "H" for Hard \n OR "E" for Easy'];
    randR = rand();
    randG = rand();
    randB = rand();
    Screen('TextSize', window, 50);
    DrawFormattedText(window, level_selection_text, 'center', 100, [1 1 0], windowRect);
    Screen('TextSize', window, 35);
    DrawFormattedText(window, level_text, 'center', 400, [randR, randG, randB], windowRect);
    vbl  = Screen('Flip', window, vbl + (wait_for_seconds * ifi));
    [keyIsDown, secs, keycode] = KbCheck(-1);
    if keyIsDown == true
        if KbName(keycode) == 'h'
            level_choice = true;
            rrange = [-6, 6]
        elseif KbName(keycode) == 'e'
            level_choice = true;
            rrange = [-2, 2]
        end
    end
end   
 
 
%Setting size of playing screen
max_x = screenXpixels;
max_y = screenYpixels;
%Setting Snake to random position
snake_x = randi(max_x);
snake_y = randi(max_y);
step = 0; %Number of steps Snake takes
points = 0; %Number of points Snake has
%Position of the Chasing Monsters: These Monsters will be "chasing" the
%Snake, and the snake has to avoid these Monsters.
monster_1_x = randi(max_x);
monster_2_x = randi(max_x);
monster_3_x = randi(max_x);
monster_1_y = randi(max_y);
monster_2_y = randi(max_y);
monster_3_y = randi(max_y);
%Position of the Food/Powerup and the Poison
food_x = randi(max_x);
poison_x = randi(max_x);
food_y = randi(max_y);
poison_y = randi(max_y);
%Making sure that Monster cannot be in the same spot as the Snake.
%X-COORDINATES
if monster_1_x - snake_x <= 30 && monster_1_x - snake_x >= 0
    monster_1_x = randi(max_x);
elseif monster_2_x - snake_x <= 40 && monster_2_x - snake_x >= 0
    monster_2_x = randi(max_x);
elseif monster_3_x == snake_x <= 50 && monster_3_x - snake_x >= 0
    monster_3_x = randi(max_x);
elseif food_x - snake_x <= 30 && food_x - snake_x >= 0
    food_x = randi(max_x);
elseif snake_x - monster_1_x <= 30 && snake_x - monster_1_x >= 0
    monster_1_x = randi(max_x);
elseif snake_x - monster_2_x <= 40 && snake_x - monster_2_x >= 0
    monster_2_x = randi(max_x);
elseif snake_x - monster_3_x <= 50 && snake_x - monster_3_x >= 0
    monster_3_x = randi(max_x);
elseif snake_x - food_x <= 30 && snake_x - food_x >= 0
    food_x = randi(max_x);
%Making sure that Food & Poison cannot be in the same spot as Monster or Snake
elseif food_x - monster_1_x <= 30 && food_x - monster_1_x >= 0
    food_x = randi(max_x);
elseif food_x - monster_2_x <= 40 && food_x - monster_2_x >= 0
    food_x = randi(max_x);
elseif food_x - monster_3_x <= 50 && food_x - monster_3_x >= 0
    food_x = randi(max_x);
elseif poison_x - snake_x <= 30 && poison_x - snake_x >= 0
    poison_x = randi(max_x);
elseif poison_x - monster_1_x <= 30 && poison_x - monster_1_x >= 0
    poison_x = randi(max_x);
elseif poison_x - monster_2_x <= 40 && poison_x - monster_2_x >= 0
    poison_x = randi(max_x);
elseif poison_x - monster_3_x <= 50 && poison_x - monster_3_x >= 0
    poison_x = randi(max_x);
elseif monster_1_x - food_x <= 30 && monster_1_x - food_x >= 0
    food_x = randi(max_x);
elseif monster_2_x - food_x <= 40 && monster_2_x - food_x >= 0
    food_x = randi(max_x);
elseif monster_3_x - food_x <= 50 && monster_3_x - food_x >= 0
    food_x = randi(max_x);
elseif snake_x - poison_x <= 30 && snake_x - poison_x >= 0
    poison_x = randi(max_x);
elseif monster_1_x - poison_x <= 30 && monster_1_x - poison_x >= 0
    poison_x = randi(max_x);
elseif monster_2_x - poison_x <= 40 && monster_2_x - poison_x >= 0
    poison_x = randi(max_x);
elseif monster_3_x - poison_x <= 50 && monster_3_x - poison_x >= 0
    poison_x = randi(max_x);
end
%Y-COORDINATES
if monster_1_y - snake_y <= 30 && monster_1_y - snake_y >= 0
    monster_1_y = randi(max_y);
elseif monster_2_y - snake_y <= 40 && monster_2_y - snake_y >= 0
    monster_2_y = randi(max_y);
elseif monster_3_y == snake_y <= 50 && monster_3_y - snake_y >= 0
    monster_3_y = randi(max_y);
elseif food_y - snake_y <= 30 && food_y - snake_y >= 0
    food_y = randi(max_y);
elseif snake_y - monster_1_y <= 30 && snake_y - monster_1_y >= 0
    monster_1_y = randi(max_y);
elseif snake_y - monster_2_y <= 40 && snake_y - monster_2_y >= 0
    monster_2_y = randi(max_y);
elseif snake_y - monster_3_y <= 50 && snake_y - monster_3_y >= 0
    monster_3_y = randi(max_y);
elseif snake_y - food_y <= 30 && snake_y - food_y >= 0
    food_y = randi(max_y);
%Making sure that Food & Posion cannot be in the same spot as Monster or Snake
elseif food_y - monster_1_y <= 30 && food_y - monster_1_y >= 0
    food_y = randi(max_y);
elseif food_y - monster_2_y <= 40 && food_y - monster_2_y >= 0
    food_y = randi(max_y);
elseif food_y - monster_3_y <= 50 && food_y - monster_3_y >= 0
    food_y = randi(max_y);
elseif poison_y - snake_y <= 30 && poison_y - snake_y >= 0
    poison_y = randi(max_y);
elseif poison_y - monster_1_y <= 30 && poison_y - monster_1_y >= 0
    poison_y = randi(max_y);
elseif poison_y - monster_2_y <= 40 && poison_y - monster_2_y >= 0
    poison_y = randi(max_y);
elseif poison_y - monster_3_y <= 50 && poison_y - monster_3_y >= 0
    poison_y = randi(max_y);
elseif monster_1_y - food_y <= 30 && monster_1_y - food_y >= 0
    food_y = randi(max_y);
elseif monster_2_y - food_y <= 40 && monster_2_y - food_y >= 0
    food_y = randi(max_y);
elseif monster_3_y - food_y <= 50 && monster_3_y - food_y >= 0
    food_y = randi(max_y);
elseif snake_y - poison_y <= 30 && snake_y - poison_y >= 0
    poison_y = randi(max_y);
elseif monster_1_y - poison_y <= 30 && monster_1_y - poison_y >= 0
    poison_y = randi(max_y);
elseif monster_2_y - poison_y <= 40 && monster_2_y - poison_y >= 0
    poison_y = randi(max_y);
elseif monster_3_y - poison_y <= 50 && monster_3_y - poison_y >= 0
    poison_y = randi(max_y);
end
 
%Initializations
snake_after_snack = 0;
gameover = 0;
%%%% Start code
while gameover ~= 1
% Background
Screen('DrawTexture', window, background_screen, [0 0 screenXpixels screenYpixels], [0 0 screenXpixels screenYpixels], 0, 0)
if step <= 60
monster_box = [monster_1_x monster_1_y monster_1_x+30 monster_1_y+30];
else
monster_box = [monster_1_x monster_1_y monster_1_x+30+(round(step/10)) monster_1_y+30+(round(step/10))];
end
if step <= 60
monster_box_2 = [monster_2_x monster_2_y monster_2_x+40 monster_2_y+40];
else
monster_box_2 = [monster_2_x monster_2_y monster_2_x+40+(round(step/8)) monster_2_y+40+(round(step/8))];
end
if step <= 60
monster_box_3 = [monster_3_x monster_3_y monster_3_x+50 monster_3_y+50];
else
monster_box_3 = [monster_3_x monster_3_y monster_3_x+50+(round(step/6)) monster_3_y+50+(round(step/6))];
end
snake_color = [1 1 1];
monster_color = [1 1 0];
monster_color_2 = [0 1 0];
monster_color_3 = [1 0.5 0];
snack_box = [food_x food_y food_x+30 food_y+30];
snack_color = [1 0 0];
snake_box = [snake_x snake_y snake_x+20 snake_y+20];
Screen('FillRect', window, snake_color, snake_box)
Screen('DrawDots', window, [snake_x snake_y], [5], [0 0 0], [], 2)
Screen('DrawDots', window, [snake_x+10 snake_y+10], [5], [1 0 0], [], 2)
if snake_after_snack >= 1
    if prevKey == 'w' || prevKey == 's' 
        Screen('DrawDots', window, [snake_x+20 snake_y], [5], [0 0 0], [], 2)
    elseif prevKey == 'a' || prevKey == 'd' 
        Screen('DrawDots', window, [snake_x snake_y+20], [5], [0 0 0], [], 2)
    end
end
if snake_after_snack >= 1
        if prevKey == 'w' || prevKey == 's'
            for n = 1:snake_after_snack 
                name_sys = strcat('snake_after_snacking_', num2str(n));
                name_sys = [snake_x snake_y+20*(n) snake_x+20 snake_y+20+20*(n)];
                Screen('FillRect', window, snake_color, name_sys)
            end
        elseif prevKey == 'a' || prevKey== 'd'
            for n = 1:snake_after_snack 
                name_sys = strcat('snake_after_snacking_', num2str(n));
                name_sys = [snake_x+20*(n) snake_y snake_x+20+20*(n) snake_y+20];
                Screen('FillRect', window, snake_color, name_sys)
            end
        end
end
poison_color = [0 0 0];
poison_box = [poison_x poison_y poison_x+30 poison_y+30];
Screen('FillRect', window, monster_color, monster_box)
if step <= 60
Screen('DrawTexture', window, monster_1_tex, [0 0 30+(round(step/10)) 30+(round(step/10))], monster_box, 0, 0)
else
Screen('DrawTexture', window, monster_1_tex, [0 0 30 30], monster_box, 0, 0)
end
Screen('FillRect', window, snack_color, snack_box)
Screen('DrawTexture', window, snack_tex, [0 0 30 30], snack_box, 0, 0)
Screen('FillRect', window, poison_color, poison_box)
Screen('DrawTexture', window, poison_tex, [0 0 30 30], poison_box, 0, 0)
if step <= 60
Screen('DrawTexture', window, monster_2_tex, [0 0 40+(round(step/8)) 40+(round(step/8))], monster_box_2, 0, 0)
else
Screen('DrawTexture', window, monster_2_tex, [0 0 40 40], monster_box_2, 0, 0)
end
if step <= 100
Screen('DrawTexture', window, monster_3_tex, [0 0 50+(round(step/6)) 50+(round(step/6))], monster_box_3, 0, 0)
else
Screen('DrawTexture', window, monster_3_tex, [0 0 50 50], monster_box_3, 0, 0)
end
Screen('Flip', window, ifi);
[keyIsDown, secs, keycode] = KbCheck(-1);
%%%%%%%%%%
manipulator = randi(rrange);
manipulator_2 = randi(rrange);
manipulator_3 = randi(rrange);
if keyIsDown
    if KbName(keycode) == 'w'
        while ~keycode(left_key) || ~keycode(down_key)  || ~keycode(right_key) 
        if snake_y == 0
            gameover = 1;
            break;
        else 
            snake_y = snake_y - 10;
            step = step + 1;
        end
        monster_1_x = monster_1_x + manipulator;
        monster_1_y = monster_1_y + manipulator;
        monster_2_x = monster_2_x + manipulator_2;
        monster_2_y = monster_2_y + manipulator_2;
        monster_3_x = monster_3_x + manipulator_3;
        monster_3_y = monster_3_y + manipulator_3;
        prevKey = 'w';
        Screen('DrawTexture', window, background_screen, [0 0 screenXpixels screenYpixels], [0 0 screenXpixels screenYpixels], 0, 0)
            if step <= 60
            monster_box = [monster_1_x monster_1_y monster_1_x+30 monster_1_y+30];
            else
            monster_box = [monster_1_x monster_1_y monster_1_x+30+(round(step/10)) monster_1_y+30+(round(step/10))];
            end
            if step <= 60
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40 monster_2_y+40];
            else
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40+(round(step/8)) monster_2_y+40+(round(step/8))];
            end
            if step <= 60
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50 monster_3_y+50];
            else
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50+(round(step/6)) monster_3_y+50+(round(step/6))];
            end
            snake_color = [1 1 1];
            monster_color = [1 1 0];
            monster_color_2 = [0 1 0];
            monster_color_3 = [1 0.5 0];
            snack_box = [food_x food_y food_x+30 food_y+30];
            snack_color = [1 0 0];
            snake_box = [snake_x snake_y snake_x+20 snake_y+20];
            Screen('FillRect', window, snake_color, snake_box)
            Screen('DrawDots', window, [snake_x snake_y], [5], [0 0 0], [], 2)
            Screen('DrawDots', window, [snake_x+10 snake_y+10], [5], [1 0 0], [], 2)
            if snake_after_snack >= 1
                if prevKey == 'w' || prevKey == 's' 
                    Screen('DrawDots', window, [snake_x+20 snake_y], [5], [0 0 0], [], 2)
                elseif prevKey == 'a' || prevKey == 'd' 
                    Screen('DrawDots', window, [snake_x snake_y+20], [5], [0 0 0], [], 2)
                end
            end
            if snake_after_snack >= 1
                    if prevKey == 'w' || prevKey == 's'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x snake_y+20*(n) snake_x+20 snake_y+20+20*(n)];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    elseif prevKey == 'a' || prevKey== 'd'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x+20*(n) snake_y snake_x+20+20*(n) snake_y+20];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    end
            end
            poison_color = [0 0 0];
            poison_box = [poison_x poison_y poison_x+30 poison_y+30];
            Screen('FillRect', window, monster_color, monster_box)
            if step <= 60
            Screen('DrawTexture', window, monster_1_tex, [0 0 30+(round(step/10)) 30+(round(step/10))], monster_box, 0, 0)
            else
            Screen('DrawTexture', window, monster_1_tex, [0 0 30 30], monster_box, 0, 0)
            end
            Screen('FillRect', window, snack_color, snack_box)
            Screen('DrawTexture', window, snack_tex, [0 0 30 30], snack_box, 0, 0)
            Screen('FillRect', window, poison_color, poison_box)
            Screen('DrawTexture', window, poison_tex, [0 0 30 30], poison_box, 0, 0)
            if step <= 60
            Screen('DrawTexture', window, monster_2_tex, [0 0 40+(round(step/8)) 40+(round(step/8))], monster_box_2, 0, 0)
            else
            Screen('DrawTexture', window, monster_2_tex, [0 0 40 40], monster_box_2, 0, 0)
            end
            if step <= 100
            Screen('DrawTexture', window, monster_3_tex, [0 0 50+(round(step/6)) 50+(round(step/6))], monster_box_3, 0, 0)
            else
            Screen('DrawTexture', window, monster_3_tex, [0 0 50 50], monster_box_3, 0, 0)
            end
            Screen('Flip', window, ifi);
            [keyIsDown, secs, keycode] = KbCheck(-1);
            if keycode(left_key) || keycode(down_key)  || keycode(right_key)
                break;
            end
            %%% EATING SNACKS
if snake_x - food_x <= 30 && snake_x - food_x >= 0
    if snake_y - food_y <= 30 && snake_y - food_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    elseif food_y - snake_y <= 30 && food_y - snake_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    end
end
if food_x - snake_x <= 30 && food_x - snake_x >= 0
    if food_y - snake_y <= 30 && food_y - snake_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    elseif snake_y - food_y <= 30 && snake_y - food_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    end
end
if monster_1_x >= screenXpixels
    monster_1_x = randi(max_x);
elseif monster_1_x <= 0
    monster_1_x = randi(max_x);
elseif monster_1_y >= screenYpixels
    monster_1_y = randi(max_y);
elseif monster_1_y <= 0
    monster_1_y = randi(max_y);
end
if monster_2_x >= screenXpixels
    monster_2_x = randi(max_x);
elseif monster_2_x <= 0
    monster_2_x = randi(max_x);
elseif monster_2_y >= screenYpixels
    monster_2_y = randi(max_y);
elseif monster_2_y <= 0
    monster_2_y = randi(max_y);
end
if monster_3_x >= screenXpixels
    monster_3_x = randi(max_x); 
elseif monster_3_x <= 0
    monster_3_x = randi(max_x);
elseif monster_3_y >= screenYpixels
    monster_3_y = randi(max_y);
elseif monster_3_y <= 0
    monster_3_y = randi(max_y);
end
 
%%% GAMEOVER
if snake_x - poison_x <= 20 && snake_x - poison_x >= 0
    if snake_y - poison_y <= 20 && snake_y - poison_y >= 0
        gameover = 1;
        break;
    end
end
 
if monster_1_x - snake_x <= (monster_box(3)-monster_box(1)) && monster_1_x - snake_x >= 0
    if monster_1_y - snake_y <= (monster_box(4)-monster_box(2)) && monster_1_y - snake_y >= 0
        gameover = 1;
        break;
    end
end
if snake_x - monster_1_x <= (monster_box(3)-monster_box(1)) && snake_x - monster_1_x >= 0
    if snake_y - monster_1_y <= (monster_box(4)-monster_box(2)) && snake_y - monster_1_y >= 0
        gameover = 1;
        break;
    end
end
if monster_2_x - snake_x <= (monster_box_2(3)-monster_box_2(1)) && monster_2_x - snake_x >= 0
    if monster_2_y - snake_y <= (monster_box_2(4)-monster_box_2(2)) && monster_2_y - snake_y >= 0
        gameover = 1;
    end
end 
if snake_x - monster_2_x <= (monster_box_2(3)-monster_box_2(1)) && snake_x - monster_2_x >= 0
    if snake_y - monster_2_y <= (monster_box_2(4)-monster_box_2(2)) && snake_y - monster_2_y >= 0
        gameover = 1;
        break;
    end
end
 if monster_3_x - snake_x <= (monster_box_3(3)-monster_box_3(1)) && monster_3_x - snake_x >= 0
    if monster_3_y - snake_y <= (monster_box_3(4)-monster_box_3(2)) && monster_3_y - snake_y >= 0
        gameover = 1;
        break;
    end
end
if snake_x - monster_3_x <= (monster_box_3(3)-monster_box_3(1)) && snake_x - monster_3_x >= 0
    if snake_y - monster_3_y <= (monster_box_3(4)-monster_box_3(2)) && snake_y - monster_3_y >= 0
        gameover = 1; 
        break;
    end
end
if snake_x >= screenXpixels
    gameover = 1;
    break;
elseif snake_x <= 0
    gameover = 1;
    break;
elseif snake_y >= screenYpixels
    gameover = 1;
    break;
elseif snake_y <= 0
    gameover = 1;
    break;
end
end
    elseif KbName(keycode) == 'a'
        while ~keycode(up_key) || ~keycode(down_key)  || ~keycode(right_key) 
        if snake_x == 0
            gameover = 1;
            break;
        else
            snake_x = snake_x - 10;
            step = step + 1;
        end
        monster_1_x = monster_1_x + manipulator;
        monster_1_y = monster_1_y + manipulator;
        monster_2_x = monster_2_x + manipulator_2;
        monster_2_y = monster_2_y + manipulator_2;
        monster_3_x = monster_3_x + manipulator_3;
        monster_3_y = monster_3_y + manipulator_3;
        prevKey = 'a';
        Screen('DrawTexture', window, background_screen, [0 0 screenXpixels screenYpixels], [0 0 screenXpixels screenYpixels], 0, 0)
            if step <= 60
            monster_box = [monster_1_x monster_1_y monster_1_x+30 monster_1_y+30];
            else
            monster_box = [monster_1_x monster_1_y monster_1_x+30+(round(step/10)) monster_1_y+30+(round(step/10))];
            end
            if step <= 60
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40 monster_2_y+40];
            else
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40+(round(step/8)) monster_2_y+40+(round(step/8))];
            end
            if step <= 60
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50 monster_3_y+50];
            else
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50+(round(step/6)) monster_3_y+50+(round(step/6))];
            end
            snake_color = [1 1 1];
            monster_color = [1 1 0];
            monster_color_2 = [0 1 0];
            monster_color_3 = [1 0.5 0];
            snack_box = [food_x food_y food_x+30 food_y+30];
            snack_color = [1 0 0];
            snake_box = [snake_x snake_y snake_x+20 snake_y+20];
            Screen('FillRect', window, snake_color, snake_box)
            Screen('DrawDots', window, [snake_x snake_y], [5], [0 0 0], [], 2)
            Screen('DrawDots', window, [snake_x+10 snake_y+10], [5], [1 0 0], [], 2)
            if snake_after_snack >= 1
                if prevKey == 'w' || prevKey == 's' 
                    Screen('DrawDots', window, [snake_x+20 snake_y], [5], [0 0 0], [], 2)
                elseif prevKey == 'a' || prevKey == 'd' 
                    Screen('DrawDots', window, [snake_x snake_y+20], [5], [0 0 0], [], 2)
                end
            end
            if snake_after_snack >= 1
                    if prevKey == 'w' || prevKey == 's'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x snake_y+20*(n) snake_x+20 snake_y+20+20*(n)];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    elseif prevKey == 'a' || prevKey== 'd'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x+20*(n) snake_y snake_x+20+20*(n) snake_y+20];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    end
            end
            poison_color = [0 0 0];
            poison_box = [poison_x poison_y poison_x+30 poison_y+30];
            Screen('FillRect', window, monster_color, monster_box)
            if step <= 60
            Screen('DrawTexture', window, monster_1_tex, [0 0 30+(round(step/10)) 30+(round(step/10))], monster_box, 0, 0)
            else
            Screen('DrawTexture', window, monster_1_tex, [0 0 30 30], monster_box, 0, 0)
            end
            Screen('FillRect', window, snack_color, snack_box)
            Screen('DrawTexture', window, snack_tex, [0 0 30 30], snack_box, 0, 0)
            Screen('FillRect', window, poison_color, poison_box)
            Screen('DrawTexture', window, poison_tex, [0 0 30 30], poison_box, 0, 0)
            if step <= 60
            Screen('DrawTexture', window, monster_2_tex, [0 0 40+(round(step/8)) 40+(round(step/8))], monster_box_2, 0, 0)
            else
            Screen('DrawTexture', window, monster_2_tex, [0 0 40 40], monster_box_2, 0, 0)
            end
            if step <= 100
            Screen('DrawTexture', window, monster_3_tex, [0 0 50+(round(step/6)) 50+(round(step/6))], monster_box_3, 0, 0)
            else
            Screen('DrawTexture', window, monster_3_tex, [0 0 50 50], monster_box_3, 0, 0)
            end
            Screen('Flip', window, ifi);
            [keyIsDown, secs, keycode] = KbCheck(-1);
            if keycode(right_key) || keycode(down_key)  || keycode(up_key)
                break;
            end
            %%% EATING SNACKS
            if snake_x - food_x <= 30 && snake_x - food_x >= 0
                if snake_y - food_y <= 30 && snake_y - food_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                elseif food_y - snake_y <= 30 && food_y - snake_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                end
            end
            if food_x - snake_x <= 30 && food_x - snake_x >= 0
                if food_y - snake_y <= 30 && food_y - snake_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                elseif snake_y - food_y <= 30 && snake_y - food_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                end
            end
            if monster_1_x >= screenXpixels
                monster_1_x = randi(max_x);
            elseif monster_1_x <= 0
                monster_1_x = randi(max_x);
            elseif monster_1_y >= screenYpixels
                monster_1_y = randi(max_y);
            elseif monster_1_y <= 0
                monster_1_y = randi(max_y);
            end
            if monster_2_x >= screenXpixels
                monster_2_x = randi(max_x);
            elseif monster_2_x <= 0
                monster_2_x = randi(max_x);
            elseif monster_2_y >= screenYpixels
                monster_2_y = randi(max_y);
            elseif monster_2_y <= 0
                monster_2_y = randi(max_y);
            end
            if monster_3_x >= screenXpixels
                monster_3_x = randi(max_x); 
            elseif monster_3_x <= 0
                monster_3_x = randi(max_x);
            elseif monster_3_y >= screenYpixels
                monster_3_y = randi(max_y);
            elseif monster_3_y <= 0
                monster_3_y = randi(max_y);
            end
 
            %%% GAMEOVER
            if snake_x - poison_x <= 20 && snake_x - poison_x >= 0
                if snake_y - poison_y <= 20 && snake_y - poison_y >= 0
                    gameover = 1;
                    break;
                end
            end
 
            if monster_1_x - snake_x <= (monster_box(3)-monster_box(1)) && monster_1_x - snake_x >= 0
                if monster_1_y - snake_y <= (monster_box(4)-monster_box(2)) && monster_1_y - snake_y >= 0
                    gameover = 1;
                end
            end
            if snake_x - monster_1_x <= (monster_box(3)-monster_box(1)) && snake_x - monster_1_x >= 0
                if snake_y - monster_1_y <= (monster_box(4)-monster_box(2)) && snake_y - monster_1_y >= 0
                    gameover = 1;
                    break;
                end
            end
            if monster_2_x - snake_x <= (monster_box_2(3)-monster_box_2(1)) && monster_2_x - snake_x >= 0
                if monster_2_y - snake_y <= (monster_box_2(4)-monster_box_2(2)) && monster_2_y - snake_y >= 0
                    gameover = 1;
                    break;
                end
            end 
            if snake_x - monster_2_x <= (monster_box_2(3)-monster_box_2(1)) && snake_x - monster_2_x >= 0
                if snake_y - monster_2_y <= (monster_box_2(4)-monster_box_2(2)) && snake_y - monster_2_y >= 0
                    gameover = 1;
                    break;
                end
            end
             if monster_3_x - snake_x <= (monster_box_3(3)-monster_box_3(1)) && monster_3_x - snake_x >= 0
                if monster_3_y - snake_y <= (monster_box_3(4)-monster_box_3(2)) && monster_3_y - snake_y >= 0
                    gameover = 1;
                    break;
                end
            end
            if snake_x - monster_3_x <= (monster_box_3(3)-monster_box_3(1)) && snake_x - monster_3_x >= 0
                if snake_y - monster_3_y <= (monster_box_3(4)-monster_box_3(2)) && snake_y - monster_3_y >= 0
                    gameover = 1; 
                    break;
                end
            end
            if snake_x >= screenXpixels
                gameover = 1;
                break;
            elseif snake_x <= 0
                gameover = 1;
                break;
            elseif snake_y >= screenYpixels
                gameover = 1;
                break;
            elseif snake_y <= 0
                gameover = 1;
                break;
            end
            end
    elseif KbName(keycode) == 's'
        while ~keycode(left_key) || ~keycode(up_key)  || ~keycode(right_key) 
        if snake_x == max_x
            gameover = 1;
            break;
        else
            snake_y = snake_y + 10;
            step = step + 1;
        end
        monster_1_x = monster_1_x + manipulator;
        monster_1_y = monster_1_y + manipulator;
        monster_2_x = monster_2_x + manipulator_2;
        monster_2_y = monster_2_y + manipulator_2;
        monster_3_x = monster_3_x + manipulator_3;
        monster_3_y = monster_3_y + manipulator_3;
        prevKey = 's';
        Screen('DrawTexture', window, background_screen, [0 0 screenXpixels screenYpixels], [0 0 screenXpixels screenYpixels], 0, 0)
            if step <= 60
            monster_box = [monster_1_x monster_1_y monster_1_x+30 monster_1_y+30];
            else
            monster_box = [monster_1_x monster_1_y monster_1_x+30+(round(step/10)) monster_1_y+30+(round(step/10))];
            end
            if step <= 60
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40 monster_2_y+40];
            else
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40+(round(step/8)) monster_2_y+40+(round(step/8))];
            end
            if step <= 60
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50 monster_3_y+50];
            else
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50+(round(step/6)) monster_3_y+50+(round(step/6))];
            end
            snake_color = [1 1 1];
            monster_color = [1 1 0];
            monster_color_2 = [0 1 0];
            monster_color_3 = [1 0.5 0];
            snack_box = [food_x food_y food_x+30 food_y+30];
            snack_color = [1 0 0];
            snake_box = [snake_x snake_y snake_x+20 snake_y+20];
            Screen('FillRect', window, snake_color, snake_box)
            Screen('DrawDots', window, [snake_x snake_y], [5], [0 0 0], [], 2)
            Screen('DrawDots', window, [snake_x+10 snake_y+10], [5], [1 0 0], [], 2)
            if snake_after_snack >= 1
                if prevKey == 'w' || prevKey == 's' 
                    Screen('DrawDots', window, [snake_x+20 snake_y], [5], [0 0 0], [], 2)
                elseif prevKey == 'a' || prevKey == 'd' 
                    Screen('DrawDots', window, [snake_x snake_y+20], [5], [0 0 0], [], 2)
                end
            end
            if snake_after_snack >= 1
                    if prevKey == 'w' || prevKey == 's'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x snake_y+20*(n) snake_x+20 snake_y+20+20*(n)];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    elseif prevKey == 'a' || prevKey== 'd'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x+20*(n) snake_y snake_x+20+20*(n) snake_y+20];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    end
            end
            poison_color = [0 0 0];
            poison_box = [poison_x poison_y poison_x+30 poison_y+30];
            Screen('FillRect', window, monster_color, monster_box)
            if step <= 60
            Screen('DrawTexture', window, monster_1_tex, [0 0 30+(round(step/10)) 30+(round(step/10))], monster_box, 0, 0)
            else
            Screen('DrawTexture', window, monster_1_tex, [0 0 30 30], monster_box, 0, 0)
            end
            Screen('FillRect', window, snack_color, snack_box)
            Screen('DrawTexture', window, snack_tex, [0 0 30 30], snack_box, 0, 0)
            Screen('FillRect', window, poison_color, poison_box)
            Screen('DrawTexture', window, poison_tex, [0 0 30 30], poison_box, 0, 0)
            if step <= 60
            Screen('DrawTexture', window, monster_2_tex, [0 0 40+(round(step/8)) 40+(round(step/8))], monster_box_2, 0, 0)
            else
            Screen('DrawTexture', window, monster_2_tex, [0 0 40 40], monster_box_2, 0, 0)
            end
            if step <= 100
            Screen('DrawTexture', window, monster_3_tex, [0 0 50+(round(step/6)) 50+(round(step/6))], monster_box_3, 0, 0)
            else
            Screen('DrawTexture', window, monster_3_tex, [0 0 50 50], monster_box_3, 0, 0)
            end
            Screen('Flip', window, ifi);
            [keyIsDown, secs, keycode] = KbCheck(-1);
            if keycode(left_key) || keycode(right_key)  || keycode(up_key)
                break;
            end
            %%% EATING SNACKS
if snake_x - food_x <= 30 && snake_x - food_x >= 0
    if snake_y - food_y <= 30 && snake_y - food_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    elseif food_y - snake_y <= 30 && food_y - snake_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    end
end
if food_x - snake_x <= 30 && food_x - snake_x >= 0
    if food_y - snake_y <= 30 && food_y - snake_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    elseif snake_y - food_y <= 30 && snake_y - food_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    end
end
if monster_1_x >= screenXpixels
    monster_1_x = randi(max_x);
elseif monster_1_x <= 0
    monster_1_x = randi(max_x);
elseif monster_1_y >= screenYpixels
    monster_1_y = randi(max_y);
elseif monster_1_y <= 0
    monster_1_y = randi(max_y);
end
if monster_2_x >= screenXpixels
    monster_2_x = randi(max_x);
elseif monster_2_x <= 0
    monster_2_x = randi(max_x);
elseif monster_2_y >= screenYpixels
    monster_2_y = randi(max_y);
elseif monster_2_y <= 0
    monster_2_y = randi(max_y);
end
if monster_3_x >= screenXpixels
    monster_3_x = randi(max_x); 
elseif monster_3_x <= 0
    monster_3_x = randi(max_x);
elseif monster_3_y >= screenYpixels
    monster_3_y = randi(max_y);
elseif monster_3_y <= 0
    monster_3_y = randi(max_y);
end
 
%%% GAMEOVER
if snake_x - poison_x <= 20 && snake_x - poison_x >= 0
    if snake_y - poison_y <= 20 && snake_y - poison_y >= 0
        gameover = 1;
        break;
    end
end
 
if monster_1_x - snake_x <= (monster_box(3)-monster_box(1)) && monster_1_x - snake_x >= 0
    if monster_1_y - snake_y <= (monster_box(4)-monster_box(2)) && monster_1_y - snake_y >= 0
        gameover = 1;
        break;
    end
end
if snake_x - monster_1_x <= (monster_box(3)-monster_box(1)) && snake_x - monster_1_x >= 0
    if snake_y - monster_1_y <= (monster_box(4)-monster_box(2)) && snake_y - monster_1_y >= 0
        gameover = 1;
        break;
    end
end
if monster_2_x - snake_x <= (monster_box_2(3)-monster_box_2(1)) && monster_2_x - snake_x >= 0
    if monster_2_y - snake_y <= (monster_box_2(4)-monster_box_2(2)) && monster_2_y - snake_y >= 0
        gameover = 1;
        break;
    end
end 
if snake_x - monster_2_x <= (monster_box_2(3)-monster_box_2(1)) && snake_x - monster_2_x >= 0
    if snake_y - monster_2_y <= (monster_box_2(4)-monster_box_2(2)) && snake_y - monster_2_y >= 0
        gameover = 1;
        break;
    end
end
 if monster_3_x - snake_x <= (monster_box_3(3)-monster_box_3(1)) && monster_3_x - snake_x >= 0
    if monster_3_y - snake_y <= (monster_box_3(4)-monster_box_3(2)) && monster_3_y - snake_y >= 0
        gameover = 1;
        break;
    end
end
if snake_x - monster_3_x <= (monster_box_3(3)-monster_box_3(1)) && snake_x - monster_3_x >= 0
    if snake_y - monster_3_y <= (monster_box_3(4)-monster_box_3(2)) && snake_y - monster_3_y >= 0
        gameover = 1;  
        break;
    end
end
if snake_x >= screenXpixels
    gameover = 1;
    break;
elseif snake_x <= 0
    gameover = 1;
    break;
elseif snake_y >= screenYpixels
    gameover = 1;
    break;
elseif snake_y <= 0
    gameover = 1;
    break;
end
end
    elseif KbName(keycode) == 'd'
        while ~keycode(left_key) || ~keycode(down_key)  || ~keycode(up_key)  
        if snake_x == max_x
            gameover;
            break;
        else
            snake_x = snake_x + 10;
            step = step + 1;
        end
        monster_1_x = monster_1_x + manipulator;
        monster_1_y = monster_1_y + manipulator;
        monster_2_x = monster_2_x + manipulator_2;
        monster_2_y = monster_2_y + manipulator_2;
        monster_3_x = monster_3_x + manipulator_3;
        monster_3_y = monster_3_y + manipulator_3;
        prevKey = 'd';
        Screen('DrawTexture', window, background_screen, [0 0 screenXpixels screenYpixels], [0 0 screenXpixels screenYpixels], 0, 0)
            if step <= 60
            monster_box = [monster_1_x monster_1_y monster_1_x+30 monster_1_y+30];
            else
            monster_box = [monster_1_x monster_1_y monster_1_x+30+(round(step/10)) monster_1_y+30+(round(step/10))];
            end
            if step <= 60
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40 monster_2_y+40];
            else
            monster_box_2 = [monster_2_x monster_2_y monster_2_x+40+(round(step/8)) monster_2_y+40+(round(step/8))];
            end
            if step <= 60
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50 monster_3_y+50];
            else
            monster_box_3 = [monster_3_x monster_3_y monster_3_x+50+(round(step/6)) monster_3_y+50+(round(step/6))];
            end
            snake_color = [1 1 1];
            monster_color = [1 1 0];
            monster_color_2 = [0 1 0];
            monster_color_3 = [1 0.5 0];
            snack_box = [food_x food_y food_x+30 food_y+30];
            snack_color = [1 0 0];
            snake_box = [snake_x snake_y snake_x+20 snake_y+20];
            Screen('FillRect', window, snake_color, snake_box)
            Screen('DrawDots', window, [snake_x snake_y], [5], [0 0 0], [], 2)
            Screen('DrawDots', window, [snake_x+10 snake_y+10], [5], [1 0 0], [], 2)
            if snake_after_snack >= 1
                if prevKey == 'w' || prevKey == 's' 
                    Screen('DrawDots', window, [snake_x+20 snake_y], [5], [0 0 0], [], 2)
                elseif prevKey == 'a' || prevKey == 'd' 
                    Screen('DrawDots', window, [snake_x snake_y+20], [5], [0 0 0], [], 2)
                end
            end
            if snake_after_snack >= 1
                    if prevKey == 'w' || prevKey == 's'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x snake_y+20*(n) snake_x+20 snake_y+20+20*(n)];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    elseif prevKey == 'a' || prevKey== 'd'
                        for n = 1:snake_after_snack 
                            name_sys = strcat('snake_after_snacking_', num2str(n));
                            name_sys = [snake_x+20*(n) snake_y snake_x+20+20*(n) snake_y+20];
                            Screen('FillRect', window, snake_color, name_sys)
                        end
                    end
            end
            poison_color = [0 0 0];
            poison_box = [poison_x poison_y poison_x+30 poison_y+30];
            Screen('FillRect', window, monster_color, monster_box)
            if step <= 60
            Screen('DrawTexture', window, monster_1_tex, [0 0 30+(round(step/10)) 30+(round(step/10))], monster_box, 0, 0)
            else
            Screen('DrawTexture', window, monster_1_tex, [0 0 30 30], monster_box, 0, 0)
            end
            Screen('FillRect', window, snack_color, snack_box)
            Screen('DrawTexture', window, snack_tex, [0 0 30 30], snack_box, 0, 0)
            Screen('FillRect', window, poison_color, poison_box)
            Screen('DrawTexture', window, poison_tex, [0 0 30 30], poison_box, 0, 0)
            if step <= 60
            Screen('DrawTexture', window, monster_2_tex, [0 0 40+(round(step/8)) 40+(round(step/8))], monster_box_2, 0, 0)
            else
            Screen('DrawTexture', window, monster_2_tex, [0 0 40 40], monster_box_2, 0, 0)
            end
            if step <= 100
            Screen('DrawTexture', window, monster_3_tex, [0 0 50+(round(step/6)) 50+(round(step/6))], monster_box_3, 0, 0)
            else
            Screen('DrawTexture', window, monster_3_tex, [0 0 50 50], monster_box_3, 0, 0)
            end
            Screen('Flip', window, ifi);
        
            [keyIsDown, secs, keycode] = KbCheck(-1);
                        %%% EATING SNACKS
            if snake_x - food_x <= 30 && snake_x - food_x >= 0
                if snake_y - food_y <= 30 && snake_y - food_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                elseif food_y - snake_y <= 30 && food_y - snake_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                end
            end
            if food_x - snake_x <= 30 && food_x - snake_x >= 0
                if food_y - snake_y <= 30 && food_y - snake_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                elseif snake_y - food_y <= 30 && snake_y - food_y >= 0
                    points = points + 100;
                    snake_after_snack = snake_after_snack + 1;
                    food_x = randi(max_x);
                    food_y = randi(max_y);
                end
            end
            if monster_1_x >= screenXpixels
                monster_1_x = randi(max_x);
            elseif monster_1_x <= 0
                monster_1_x = randi(max_x);
            elseif monster_1_y >= screenYpixels
                monster_1_y = randi(max_y);
            elseif monster_1_y <= 0
                monster_1_y = randi(max_y);
            end
            if monster_2_x >= screenXpixels
                monster_2_x = randi(max_x);
            elseif monster_2_x <= 0
                monster_2_x = randi(max_x);
            elseif monster_2_y >= screenYpixels
                monster_2_y = randi(max_y);
            elseif monster_2_y <= 0
                monster_2_y = randi(max_y);
            end
            if monster_3_x >= screenXpixels
                monster_3_x = randi(max_x); 
            elseif monster_3_x <= 0
                monster_3_x = randi(max_x);
            elseif monster_3_y >= screenYpixels
                monster_3_y = randi(max_y);
            elseif monster_3_y <= 0
                monster_3_y = randi(max_y);
            end
 
            %%% GAMEOVER
            if snake_x - poison_x <= 20 && snake_x - poison_x >= 0
                if snake_y - poison_y <= 20 && snake_y - poison_y >= 0
                    gameover = 1;
                    break;
                end
            end
 
            if monster_1_x - snake_x <= (monster_box(3)-monster_box(1)) && monster_1_x - snake_x >= 0
                if monster_1_y - snake_y <= (monster_box(4)-monster_box(2)) && monster_1_y - snake_y >= 0
                    gameover = 1;
                    break;
                end
            end
            if snake_x - monster_1_x <= (monster_box(3)-monster_box(1)) && snake_x - monster_1_x >= 0
                if snake_y - monster_1_y <= (monster_box(4)-monster_box(2)) && snake_y - monster_1_y >= 0
                    gameover = 1;
                    break;
                end
            end
            if monster_2_x - snake_x <= (monster_box_2(3)-monster_box_2(1)) && monster_2_x - snake_x >= 0
                if monster_2_y - snake_y <= (monster_box_2(4)-monster_box_2(2)) && monster_2_y - snake_y >= 0
                    gameover = 1;
                    break;
                end
            end 
            if snake_x - monster_2_x <= (monster_box_2(3)-monster_box_2(1)) && snake_x - monster_2_x >= 0
                if snake_y - monster_2_y <= (monster_box_2(4)-monster_box_2(2)) && snake_y - monster_2_y >= 0
                    gameover = 1;
                    break;
                end
            end
             if monster_3_x - snake_x <= (monster_box_3(3)-monster_box_3(1)) && monster_3_x - snake_x >= 0
                if monster_3_y - snake_y <= (monster_box_3(4)-monster_box_3(2)) && monster_3_y - snake_y >= 0
                    gameover = 1;
                    break;
                end
            end
            if snake_x - monster_3_x <= (monster_box_3(3)-monster_box_3(1)) && snake_x - monster_3_x >= 0
                if snake_y - monster_3_y <= (monster_box_3(4)-monster_box_3(2)) && snake_y - monster_3_y >= 0
                    gameover = 1;  
                    break;
                end
            end
            if snake_x >= screenXpixels
                gameover = 1;
                break;
            elseif snake_x <= 0
                gameover = 1;
                break;
            elseif snake_y >= screenYpixels
                gameover = 1;
                break;
            elseif snake_y <= 0
                gameover = 1;
                break;
            end
            if keycode(left_key) || keycode(down_key)  || keycode(up_key) 
                break;
            end
        end
    end
end
%%% EATING SNACKS
if snake_x - food_x <= 30 && snake_x - food_x >= 0
    if snake_y - food_y <= 30 && snake_y - food_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    elseif food_y - snake_y <= 30 && food_y - snake_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    end
end
if food_x - snake_x <= 30 && food_x - snake_x >= 0
    if food_y - snake_y <= 30 && food_y - snake_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    elseif snake_y - food_y <= 30 && snake_y - food_y >= 0
        points = points + 100;
        snake_after_snack = snake_after_snack + 1;
        food_x = randi(max_x);
        food_y = randi(max_y);
    end
end
if monster_1_x >= screenXpixels
    monster_1_x = randi(max_x);
elseif monster_1_x <= 0
    monster_1_x = randi(max_x);
elseif monster_1_y >= screenYpixels
    monster_1_y = randi(max_y);
elseif monster_1_y <= 0
    monster_1_y = randi(max_y);
end
if monster_2_x >= screenXpixels
    monster_2_x = randi(max_x);
elseif monster_2_x <= 0
    monster_2_x = randi(max_x);
elseif monster_2_y >= screenYpixels
    monster_2_y = randi(max_y);
elseif monster_2_y <= 0
    monster_2_y = randi(max_y);
end
if monster_3_x >= screenXpixels
    monster_3_x = randi(max_x); 
elseif monster_3_x <= 0
    monster_3_x = randi(max_x);
elseif monster_3_y >= screenYpixels
    monster_3_y = randi(max_y);
elseif monster_3_y <= 0
    monster_3_y = randi(max_y);
end
 
%%% GAMEOVER
if snake_x - poison_x <= 20 && snake_x - poison_x >= 0
    if snake_y - poison_y <= 20 && snake_y - poison_y >= 0
        gameover = 1;
    end
end
 
if monster_1_x - snake_x <= (monster_box(3)-monster_box(1)) && monster_1_x - snake_x >= 0
    if monster_1_y - snake_y <= (monster_box(4)-monster_box(2)) && monster_1_y - snake_y >= 0
        gameover = 1;
    end
end
if snake_x - monster_1_x <= (monster_box(3)-monster_box(1)) && snake_x - monster_1_x >= 0
    if snake_y - monster_1_y <= (monster_box(4)-monster_box(2)) && snake_y - monster_1_y >= 0
        gameover = 1;
    end
end
if monster_2_x - snake_x <= (monster_box_2(3)-monster_box_2(1)) && monster_2_x - snake_x >= 0
    if monster_2_y - snake_y <= (monster_box_2(4)-monster_box_2(2)) && monster_2_y - snake_y >= 0
        gameover = 1;
    end
end 
if snake_x - monster_2_x <= (monster_box_2(3)-monster_box_2(1)) && snake_x - monster_2_x >= 0
    if snake_y - monster_2_y <= (monster_box_2(4)-monster_box_2(2)) && snake_y - monster_2_y >= 0
        gameover = 1;
    end
end
 if monster_3_x - snake_x <= (monster_box_3(3)-monster_box_3(1)) && monster_3_x - snake_x >= 0
    if monster_3_y - snake_y <= (monster_box_3(4)-monster_box_3(2)) && monster_3_y - snake_y >= 0
        gameover = 1;
    end
end
if snake_x - monster_3_x <= (monster_box_3(3)-monster_box_3(1)) && snake_x - monster_3_x >= 0
    if snake_y - monster_3_y <= (monster_box_3(4)-monster_box_3(2)) && snake_y - monster_3_y >= 0
        gameover = 1;   
    end
end
if snake_x >= screenXpixels
    gameover = 1;
elseif snake_x <= 0
    gameover = 1;
elseif snake_y >= screenYpixels
    gameover = 1;
elseif snake_y <= 0
    gameover = 1;
end
end
Screen('Flip', window);
if gameover == 1
Screen('TextFont', window, 'VCR OSD Mono');
Screen('TextSize', window, 35);
if prev_points ~= 0
    if prev_points > points
        points_text = strcat(strcat('Better luck next time! \n \n Your score is: ', '  '), (num2str(points)));
        if points >= 500
            [y,Fs] = audioread('JULIA.wav');
            sound(y, Fs);
        else
            [y,Fs] = audioread('SERRE.wav');
            sound(y, Fs);
        end
    else
        points_text = strcat(strcat('Excellent! Your score is: ', '  '), (num2str(points)));
        [y,Fs] = audioread('PACHAYA.wav');
        sound(y, Fs);
    end
else
    if points < 800
        points_text = strcat(strcat('Better luck next time! \n \n Your score is: ', '  '), (num2str(points)));
        [y,Fs] = audioread('SERRE.wav');
        sound(y, Fs);
    else
        points_text = strcat(strcat('Excellent! Your score is: ', '  '), (num2str(points)));
        [y,Fs] = audioread('PACHAYA.wav');
        sound(y, Fs);
    end
end
points_color = [1 1 1];
DrawFormattedText(window, points_text, 'center', 100, points_color, windowRect);
if prev_points > points
    high_score_text = [strcat(strcat(strcat('1 --- ', '  '), num2str(prev_points)), strcat(strcat('\n 2 --- ', '  '), num2str(points)))];
else
    high_score_text = [strcat(strcat(strcat('1 --- ', '  '), num2str(points)), strcat(strcat('\n 2 --- ', '  '), num2str(prev_points)))];
end
DrawFormattedText(window, 'High Scores', 'center', 300, points_color, windowRect);
DrawFormattedText(window, high_score_text, 'center', 400, points_color, windowRect);
Screen('Flip', window);
WaitSecs(3);
Screen('TextFont', window, 'VCR OSD Mono');
Screen('TextSize', window, 20);
end_text = 'GAME OVER \n \n \n DO YOU WANT TO PLAY AGAIN? \n \n TYPE C TO CONTINUE OR E TO EXIT';
end_text_color = [1 1 1];
DrawFormattedText(window, end_text, 'center', 'center', end_text_color, windowRect);
if points > prev_points
    prev_points = points;
else
    prev_points;
end
Screen('Flip', window);
[secs, keycode] = KbStrokeWait;
if KbName(keycode) == 'c'
    Screen('Flip', window);
    gameover = 0;
elseif KbName(keycode) == 'e'
    world_choice = false;
    sca;
end
end
end