--100行代码实现红点系统

---BindMethodRD 绑定一个红点信息
---@param nRDId number gtRedDotId
---@param uObj UnityEngine.GameObject 红点GameObject
function BindMethodRD(nRDId, uObj)
    local node = tRedDot[nRDId]
    if not node then
        return
    end
    local bShow = node.cond()
    --如果自己没红点，查询子节点是否有红点
    if not bShow and node.childNode then
        bShow = TraverseNode(node.childNode, true)
    end
    node.uRDObj = uObj
    --实现你的红点显隐方式
    uObj:SetActive(bShow)
end

---TraverseNode 遍历子节点，是否有红点显示
---@param childNode table 子节点列表
function TraverseNode(childNode)
    for _, v in pairs(childNode) do
        if v.cond() then
            return true
        elseif v.childNode then
            if TraverseNode(v.childNode) then
                return true
            end
        end
    end
    return false
end

---RelieveMethodRD 解除关联的红点信息
---@param nRDId number gtRedDotId
function RelieveMethodRD(nRDId)
    if not nRDId then
        return
    end
    local t = gtRedDotConfig[nRDId]
    if not t then
        return
    end
    t.uRDObj = nil
end

---UpdateMethodRD 更新一个红点信息
---@param nRDId number gtRedDotId
function UpdateMethodRD(nRDId)
    local tPlayConfig = gtRedDotConfig[nRDId]
    if not tPlayConfig then
        return
    end
    local bShow = false
    local bInvoke = false
    if tPlayConfig.parentT then
        bShow = tPlayConfig.cond()
        if not bShow and tPlayConfig.childNode then
            bShow = TraverseNode(tPlayConfig.childNode, false)
        end
        bInvoke = true
        --如果是true，直接更新到root节点
        if bShow then
            local node = tPlayConfig
            while node.parentT do
                node = gtRedDotConfig[node.parentT]
                node.uRDObj:SetActive(bShow)
            end
        else
            UpdateMethodRD(tPlayConfig.parentT)
        end
    end
    --更新自己
    if not tPlayConfig.uRDObj then
        return
    end
    if not bInvoke then
        bShow = tPlayConfig.cond()
    end
    if not bShow and tPlayConfig.childNode then
        bShow = TraverseNode(tPlayConfig.childNode, false)
    end
    tPlayConfig.uRDObj:SetActive(bShow)
end