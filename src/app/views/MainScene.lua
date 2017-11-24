
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local game=require("app.game.game"):new()


local state =1 -- 1 end 2 gaming 3 pausing
local menuLayer

function MainScene:onCreate()
    menuLayer=cc.Node:create()
    cc.Sprite:create("bg.png")
    :move(display.center)
    :addTo(self)
    self:addChild(menuLayer, 1)
    self:reMenu()
    self:addChild(game:initGraphic(),0)
    game:draw()
end
 
function MainScene:reMenu( )
    menuLayer:removeAllChildren()
    local menu
    local color=cc.c3b(0, 0, 0)
    cc.MenuItemFont:setFontName("fonts/Marker Felt.ttf")
    cc.MenuItemFont:setFontSize(48)
    local menuItemStart=cc.MenuItemFont:create("Start");
    local menuItemExit=cc.MenuItemFont:create("Exit");
    local menuItemPause=cc.MenuItemFont:create("Pause");
    local menuItemRestart=cc.MenuItemFont:create("Restart");
    local menuItemResume=cc.MenuItemFont:create("Resume");
    local function exit()
        cc.Director:getInstance():endToLua()
    end

    local function pause()
        game:pause()
        state=3
        self:reMenu()
    end

    local function resume()
        game:start()
        state=2
        self:reMenu()
    end

    local function start()
        game:start()
        state=2
        self:reMenu()
    end
    local function restart()
        game:restart()
        start()
    end
    menuItemPause:registerScriptTapHandler(pause)
    menuItemExit:registerScriptTapHandler(exit)
    menuItemResume:registerScriptTapHandler(resume)
    menuItemStart:registerScriptTapHandler(start)
    menuItemRestart:registerScriptTapHandler(restart)

    menuItemStart:setColor(color)
    menuItemExit: setColor(color)
    menuItemPause:setColor(color)
    menuItemResume:setColor(color)
    menuItemRestart:setColor(color)

    if  state==1 then
           menu=cc.Menu:create(menuItemStart,menuItemExit)
            --menu:setAnchorPoint(cc.p(0.5,0.5))
            menu:move(display.cx,display.cy)

        else if state==2 then
           menu=cc.Menu:create(menuItemPause)
            menu:move(display.right-menuItemPause:getContentSize().width,display.bottom+menuItemPause:getContentSize().height)
        else 
                menu=cc.Menu:create(menuItemResume,menuItemRestart,menuItemExit)
            menu:move(display.cx,display.cy)
        end
    end
    menu:alignItemsVertically()

    menuLayer:addChild(menu)


end


return MainScene

