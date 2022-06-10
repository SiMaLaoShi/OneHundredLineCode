-- 描  述:    红点配置
gtRedDotId = {
    nRB_Root = 1,
    nRB_Root_S1 = 2,
    nRB_Root_S1_T1 = 3,
    nRB_Root_S1_T2 = 4,
    nRB_Root_S2 = 5,
    nRB_Root_S2_T1 = 6,
    nRB_Root_S2_T2 = 7,
}

--RB_Root表示根目录
--S表示第一层
--T表示第二层
--整体就是数状结构

--root
    --s1
        --s1_t1
        --s1_t2
    --s2
        --s2_t1
        --s2_T2


gtRedDotConfig = {
    [gtRedDotId.nRB_Root_S2_T2] = {
        parentT = gtRedDotId.nRB_Root_S2,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
    [gtRedDotId.nRB_Root_S2_T1] = {
        parentT = gtRedDotId.nRB_Root_S2,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
    [gtRedDotId.nRB_Root_S2] = {
        parentT = gtRedDotId.nRB_Root,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
    [gtRedDotId.nRB_Root_S1_T2] = {
        parentT = gtRedDotId.nRB_Root_S1,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
    [gtRedDotId.nRB_Root_S1_T1] = {
        parentT = gtRedDotId.nRB_Root_S1,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
    [gtRedDotId.nRB_Root_S1] = {
        parentT = gtRedDotId.nRB_Root,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
    [gtRedDotId.nRB_Root] = {
        parentT = nil,   --父节点
        cond = function() return true end,  --条件
        trigger = {},                       --更新的事件合集
    },
}

--这一次遍历是为了求子节点和父节点的并集给到父节点
for i, v in pairs(gtRedDotConfig) do
    if v.parentT then
        local node = gtRedDotConfig[v.parentT]
        if not node.childNode then
            node.childNode = {}
        end
        node.childNode[i] = v
    end
    v.nMyId = i
end

--这里注册每个系统红点更新事件
for nId, tNode in pairs(gtPlayMethodConfig.tRedDot) do
    tNode.funcRDCallBack = function()
        UpdateMethodRD(nId)
    end
    for _, v in pairs(tNode.trigger) do
        --todo 实现你的红点触发事件，把他绑定到funcRDCallBack
    end
end