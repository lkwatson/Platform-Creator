--GNU Affero General Public License v3.0
--Based on code from https://github.com/jakesgordon/bin-packing

--Handles packing blocks into containers. Currently is not commented (Sorry)

local Packer = {}

function Packer:init(x, y, w, h) --added x and y
    self.root = {
        x = x, 
        y = y, 
        w = w,
        h = h,
    }
end

function Packer:fit(blocks)
    for k, block in ipairs(blocks) do
        if block.fit then
            --do nothing
        else
            local node = self:findNode(self.root, block.w, block.h)
        
            if node then
               block.fit = self:splitNode(node, block.w, block.h)
            end
        end
    end
end

function Packer:findNode(root, w, h)
    if root.used then
        return self:findNode(root.right, w, h) or self:findNode(root.down, w, h)
    elseif w <= root.w and h <= root.h then
        return root
    else
        return
    end
end

function Packer:splitNode(node, w, h)
    node.used = true
    node.down = {
        x = node.x,
        y = node.y + h,
        w = node.w,
        h = node.h - h,
    }
    node.right = {
        x = node.x + w,
        y = node.y,
        w = node.w - w,
        h = h,
    }
    
    return node
end

return Packer