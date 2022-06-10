--100行代码实现AStar,整体代码不包括日志和调试的话，应该在100行内

local length = 10
local height = 10

local Grid = {}
for i = 1, length do
    Grid[i] = {}
    for k = 1, height do
        local t = {}
        t.x = i
        t.y = k
        t.f = 0
        t.g = 0
        t.h = 0
        t.print = string.format("[%s, %s]", i, k)
        t.__tostring = function()
            print("[%s, %s]", i, k)
        end
        Grid[i][k] = t
    end
end

--添加障碍
local Obstacles = {}
for i = 2, 3 do
    Obstacles[i] = {}
    for k = 2, 7 do
        Obstacles[i][k] = Grid[i][k]
    end
end

---GetAreaPoint
---@param x number 当前点的x
---@param y number 当前点的y
---@param endPoint table 目标点
---@param length number
---@param height number
local function GetAreaPoint(x, y, endPoint, length, height)
    local x1 = x
    local y1 = y
    local start = Grid[x][y]
    local openList = {}

    --region 检查边界
    if y1 - 1 >= 1 then
        openList[#openList + 1] = Grid[x1][y1 - 1]
    end

    if y1 + 1 <= height then
        openList[#openList + 1] = Grid[x1][y1 + 1]
    end

    if x1 - 1 >= 1 then
        openList[#openList + 1] = Grid[x1 - 1][y1]
    end

    if x1 + 1 <= length then
        openList[#openList + 1] = Grid[x1 + 1][y1]
    end

    if x1 - 1 >= 1 and y1 - 1 >= 1 then
        openList[#openList + 1] = Grid[x1 - 1][y1 - 1]
    end

    if x1 + 1 <= length and y1 - 1 >= 1 then
        openList[#openList + 1] = Grid[x1 + 1][y1 - 1]
    end

    if x1 - 1 >= 1 and y1 + 1 <= height then
        openList[#openList + 1] = Grid[x1 - 1][y1 + 1]
    end

    if x1 + 1 <= length and y1 + 1 <= height then
        openList[#openList + 1] = Grid[x1 + 1][y1 + 1]
    end

    --endregion

    --region 检查障碍
    for i, v in pairs(openList) do
        if Obstacles[v.x] and Obstacles[v.x][v.y] then
            openList[i] = nil
        end
    end
    --endregion

    for _, v in pairs(openList) do
        if v.x ~= start.x or v.y ~= start.y then
            v.g = math.sqrt(math.pow(math.abs(v.x - start.x), 2) + math.pow(math.abs(v.y - start.y), 2))
            v.g = math.floor(v.g * 10) / 10
        else
            v.g = math.abs(v.x - start.x) + math.abs(v.y - start.y)
        end

        v.h = math.abs(v.x - endPoint.x) + math.abs(v.y - endPoint.y)
        v.f = v.g + v.h
    end
    print("--------------------------------")
    for _, v in pairs(openList) do
        print("周围点", v.print, v.f, v.g, v.h)
    end
    print("--------------------------------")
    --找到最合适的点
    local perfect
    for _, v in pairs(openList) do
        if not perfect then
            perfect = v
        else
            if perfect.f > v.f then
                perfect = v
            end
        end
    end
    return perfect
end


----------------------------------main----------------------------------------------------------------------------------
local startPoint = Grid[1][1]
local endPoint = Grid[9][10]
local perfect = startPoint
local x1 = os.clock()
local path = {}
while perfect.x ~= endPoint.x and perfect.y ~= endPoint.y do
    perfect = GetAreaPoint(perfect.x, perfect.y, endPoint, length, height)
    print("最优点", perfect.print)
    path[#path + 1] = perfect
end
print("------------------------------")
path[#path + 1] = endPoint
for _, v in pairs(path) do
    print(v.print)
end
local x2 = os.clock()

print(string.format("结束耗時%s秒", x2 - x1 ))