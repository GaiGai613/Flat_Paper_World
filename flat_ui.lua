flat_ui = class()

function flat_ui:init()
    tap_count = 0
    self.theme_color = {color(255, 255, 255, 255),color(0, 0, 0, 255)}
    self.buttons = {} self.button_id = 0
    self.touches,self.touches_info,self.touch_history = {},{},{}
    self.only_draw = false
    
    noSmooth()
    
    REMOVE,ADD,TOUCH = "remove","add","touch" -- action
    ALL = "all" -- Num
    BUTTON,PIC = "button","picture" -- Item
    UP,DOWN = "up","down"
    
    _translate = translate
    _resetMatrix = resetMatrix
    advance_translate()
end

function flat_ui:draw()
    _translated_vector = vec3(0,0,0)
    for k , t in pairs(self.touches) do
        if t.state == ENDED then
            if self.touches_info[t.id].ended then
                self.touches[t.id] = nil
                self.touches_info[t.id] = nil
            else
                self.touches_info[t.id].ended = true
            end
        end
    end
    flat_ui:pull_menu_draw()
end

function flat_ui:touched(t)
    table.insert(self.touch_history,1,{touch = t,time = ElapsedTime,id = t.id})
    if t.state == BEGAN then
        self.touches_info[t.id] = {start_x = t.x,start_y = t.y}
        tap_count = tap_count+1
    elseif t.state == ENDED then
        tap_count = tap_count-1
    end
    self.touches[t.id] = t
end

function flat_ui:touch()
    
end

function flat_ui:touch_check_rect(x,y,w,h,type)
    for k , t in pairs(self.touches) do
        if flat_ui:touch_check_one_rect(x,y,w,h,t) then
            if t.state == ENDED then
                if type == BUTTON then
                    return t
                end
            else
                if type == TOUCH then
                    return t
                end
                if t.state == type then
                    return t
                end
            end
        end
    end
    return false
end

function flat_ui:touch_check_one_rect(x,y,w,h,t)
    if t.x >= x-w/2 and t.x <= x+w/2 and t.y >= y-h/2 and t.y <= y+h/2 then
        return true
    end
    return false
end

function flat_ui:touch_check_multi_tap(d,tc,x,y,w,h)
    local min_time = ElapsedTime-d
    local x,y,w,h = x or WIDTH/2,y or HEIGHT/2,w or WIDTH,h or HEIGHT
    local tap_time = 0
    local tc = tc or 2
    
    for k , t in pairs(self.touch_history) do
        if t.touch.state == ENDED then
            if t.time < min_time then return false end
            if flat_ui:touch_check_one_rect(x,y,w,h,t.touch) then tap_time = tap_time+1 end
            if tap_time == tc then return true end
        end
    end
    return false
end

function flat_ui:touch_check_soft_tap(x,y,w,h,time)
    local time = time or 0.2
    local ct = flat_ui:touch_check_rect(x,y,w,h,BUTTON)
    if ct and self.touches_info[ct.id].ended then
        for k , t in pairs(self.touch_history) do
            if t.touch.state == BEGAN and ElapsedTime-t.time <= time then
                if flat_ui:touch_check_one_rect(x,y,w,h,t.touch) then
                    return true
                end
            end
        end
    end
    return false
end

function flat_ui:touch_check_move(x,y,w,h)
    local t = flat_ui:touch_check_rect(x or WIDTH/2,y or HEIGHT/2,w or WIDTH,h or HEIGHT,TOUCH)
    if not t then
        return vec2(0,0)
    elseif t.state == BEGAN then
        self.move_set_x,self.move_set_y = t.x,t.y
        return vec2(0,0)
    else
        if not self.move_set_x then
            self.move_set_x,self.move_set_y = t.x,t.y
        end
        
        local output_vector = vec2(t.x-self.move_set_x,t.y-self.move_set_y)
        self.move_set_x,self.move_set_y = t.x,t.y
        return output_vector
    end
end

function flat_ui:touch_check_zoom()
    if tap_count == 2 then
        local t1,t2
        for k , t in pairs(self.touches) do
            if not t1 then t1 = t else t2 = t end
        end
        if (t1.deltaX < 0 and t2.deltaX > 0) or (t1.deltaX > 0 and t2.deltaX < 0) then
            
        end
    end
end

function flat_ui:touch_check(p,type)
    for k , t in pairs(self.touches) do
        if t.state == ENDED and type == BUTTON or t.state ~= ENDED and type == TOUCH then
            local l1d = {vec2(t.x,t.y),vec2(100000,100000)}
            local inter_num = 0
            for i = 1 , #p do
                local l2d = {p[i],p[i%#p+1]}
                local inter = flat_ui:check_two_line(l1d,l2d)
                if inter then
                    inter_num = inter_num+1
                end
            end
            if inter_num%2 == 1 then
                return true
            end
        end
    end
end

function flat_ui:get_any_same_touch()
    if not self.same_touch_id then
        for k , t in pairs(self.touches) do
            self.same_touch_id = t.id
        end
    elseif not self.touches[self.same_touch_id] then
        for k , t in pairs(self.touches) do
            self.same_touch_id = t.id
            return self.touches[self.same_touch_id]
        end
        self.same_touch_id = nil
    end
    return self.touches[self.same_touch_id]
end

function flat_ui:loading_bar(v,x,y,bc,bw,bh,ic,im)
    translate(x or 0,y or 0) rectMode(CENTER)
    fill(bc) rect(0,0,bw,bh)
    local m = im or 0 strokeWidth(0)
    fill(ic or bc) rect((v-1)*(bw-im*2)/2,0,(bw-im*2)*v,bh-im*2)
    translate(-(x or 0),-(y or 0))
end

function flat_ui:theme_color(action,num)
    if action == REMOVE then
        if num == ALL then
            self.theme_color = {}
        elseif num then
            self.theme_color[num] = nil
        else
            return false
        end
    elseif action == ADD then
        table.insert(self.theme_color,num)
        return #self.theme_color
    end
end

function flat_ui:pull_menu(x,y,w,h,i_height,i_count)
    if not self.pull_menus then
        self.pull_menus = {}
    end
    table.insert(self.pull_menus,{x = x,y = y,width = w,height = h,i_height = i_height,i_count = i_count,id = #self.pull_menus+1,i_y = y+h/2-i_height/2})
    return self.pull_menus[#self.pull_menus]
end

function flat_ui:pull_menu_draw()
    if not self.pull_menus then
        return
    end
    
    for k , pm in pairs(self.pull_menus) do
        local p = math.round((flat_ui:touch_check_move(pm.x,pm.y,pm.width,pm.height)).y)
        local t = flat_ui:touch_check_rect(pm.x,pm.y,pm.width,pm.height,TOUCH)
        if self.only_draw and not pm.mush_check then t.state = ENDED end
        if not t then
            t = {state = ENDED}
        end
        if t.state == MOVING then
            pm.i_y = pm.i_y+p
        elseif t.state == ENDED then
            local upper_bound = pm.y+pm.height/2
            local lower_bound = pm.y-pm.height/2
            if pm.i_count*pm.i_height > pm.height then
                if pm.i_y+pm.i_height/2 < upper_bound then
                    pm.i_y = pm.i_y-(math.floor(pm.i_y-upper_bound+pm.i_height/2))/10
                elseif pm.i_y+pm.i_height/2-pm.i_count*pm.i_height > lower_bound then
                    pm.i_y = pm.i_y-(math.floor(pm.i_y+pm.i_height/2-pm.i_count*pm.i_height-lower_bound))/10
                end
            else
                if pm.i_y+pm.i_height/2 > upper_bound then
                    pm.i_y = pm.i_y-(math.floor(pm.i_y-upper_bound+pm.i_height/2))/10
                elseif pm.i_y+pm.i_height/2 < upper_bound then
                    pm.i_y = pm.i_y-(math.floor(pm.i_y-upper_bound+pm.i_height/2))/10
                end
                if math.abs(pm.i_y-(upper_bound-pm.i_height/2)) <= 1 then
                    pm.i_y = (upper_bound-pm.i_height/2)
                end
            end
        end
    end
end

function flat_ui:add_font(name,images,names)
    if not self.fonts then self.fonts = {} end
    self.now_fonts = name
    self.fonts[name] = {}
    local n_font = self.fonts[name]
    for k , one_text in pairs(images) do
        table.insert(n_font,names[k],one_text)
    end 
end

function flat_ui:text(word,x,y,width,font)
    local font = font or self.now_font
    for i = 1 , string.len(word) do
        local now_char = string.sub(word,i,i)
        local now_img = self.fonts[font][now_char]
        sprite(now_img,x,y,width*0.98)
    end
end

function flat_ui:add_button(x,y,w,h,bc,sc,sw)
    self.button_id = self.button_id+1
    table.insert(self.buttons,{id = self.button_id,x = x,y = y,width = w,height = h,bc = bc,sc = sc or 0,sw = sw or 0,pressed = false,type = BUTTON})
    return self.buttons[#self.buttons]
end

function flat_ui:button_set_text(button_now,type,num,c)
    local b = self.buttons[button_now.id]
    if type == TEXT then
        b.text = num
        b.tc = c
    elseif type == PIC then
        b.pic = num
    end
end

function flat_ui:button_draw(button_now)
    rectMode(CENTER)
    local b = self.buttons[button_now.id]
    
    fill(b.bc)
    
    if b.sw > 0 then
        strokeWidth(b.sw)
        stroke(b.sc)
    else
        strokeWidth(0)
    end
    
    rect(b.x,b.y,b.width,b.height)
    
    if b.text ~= nil then
        fontSize(b.height*0.9)
        local text_size = math.floor(b.height*0.9)
        while textSize(b.text) > b.width*0.9 do
            text_size = text_size-1
            fontSize(text_size)
            if text_size <= 0 then
                break
            end
        end
        fill(b.tc)
        text(b.text,b.x,b.y)
    end
    if b.pic ~= nil then
        if b.pic.width <= b.width and b.pic.height <= b.height then
            sprite(b.pic,b.x,b.y)
        else
            local pic_w,pic_h = b.pic.width,b.pic.height
            if pic_w > b.width then
                pic_w = b.width
            end
            if pic_h > b.height then
                pic_h = b.height
            end
            sprite(b.pic,b.x,b.y,pic_w,pic_h)
        end
    end
    
    local button_pressed = false
    
    if b.touching then
        b.touching = self.touches[b.touching.id]
        button_pressed = flat_ui:touch_check_one_rect(b.x,b.y,b.width,b.height,b.touching)
        if b.touching.state == ENDED then
            b.touching = nil
        else
            if not (self.only_draw and not b.must_check) and button_pressed and b.bc.a ~= 0 then
                fill(0,0,0,50)
                strokeWidth(0)
                rect(b.x,b.y,b.width,b.height)
            end
            button_pressed = false
        end
    else
        button_pressed = flat_ui:touch_check_rect(b.x,b.y,b.width,b.height,BEGAN)
        if button_pressed then b.touching = button_pressed end
        button_pressed = false
    end
    
    if self.only_draw and not b.must_check then button_pressed = false end
    
    b.pressed = button_pressed
end

function flat_ui:check_two_line(l1d,l2d)
    -- l1d = {vec2(1,1),vec2(2,2)},l2d = {vec2(3,3),vec2(4,4)}
    
    -- print(l1d[1],l1d[2],l2d[1],l2d[2])
    
    local s1 = (l1d[1].y-l1d[2].y)/(l1d[1].x-l1d[2].x)
    local s2 = (l2d[1].y-l2d[2].y)/(l2d[1].x-l2d[2].x)
    local b1 = l1d[1].y-l1d[1].x*s1
    local b2 = l2d[1].y-l2d[1].x*s2
    
    --   s1*x+b1=s2*x+b2
    -- s1*x-s2*x=b2-b1
    -- (s1-s2)*x=b2-b1
    --         x=(b2-b1)/(s1-s2)
    
    local i = vec2((b2-b1)/(s1-s2),(b2-b1)/(s1-s2)*s1+b1)
    
    if math.abs(s1) == math.huge then
        i = vec2(l1d[1].x,b2)
    end
    if math.abs(s2) == math.huge then
        i = vec2(l2d[1].x,b1)
    end
    
    i = vec2(math.floor(i.x),math.floor(i.y))
    
    local inter_num = 0
    if math.ult(i.x,l1d[1].x) and math.ult(i.x,l1d[2].x) and math.ult(i.y,l1d[1].y) and math.ult(i.y,l1d[2].y) then
        return i
    end
    
    return false
end

function math.round(n)
    local int_n = math.floor(n)
    if n-int_n <= 0.5 then
        return int_n
    else
        return int_n+1
    end
end

function advance_translate()
    translate = function(x,y,z)
        _translate(x or 0,y or 0,z or 0)
        _translated_vector = (_translated_vector or vec3(0,0,0))+vec3(x,y,z)
        return _translated_vector:unpack()
    end
    resetMatrix = function()
        _resetMatrix()
        _translates_vector = vec3(0,0,0)
        return vec3(0,0,0)
    end
end