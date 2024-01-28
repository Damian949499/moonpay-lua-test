local EventEmitter = require('eventemitter')
local GUID
GUID = function()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end
local Job
do
  local _class_0
  local _parent_0 = EventEmitter
  local _base_0 = {
    progress = function(self, Value, Max)
      return self:emit('progress', Value / Max, Value, Max)
    end,
    resolve = function(self, Result)
      self.Result = Result
      return self:emit('status', 1, self.Result)
    end,
    fail = function(self, Failure)
      self.Failure = Failure
      return self:emit('status', -1, self.Failure)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ID)
      if ID == nil then
        ID = GUID()
      end
      self.ID = ID
    end,
    __base = _base_0,
    __name = "Job",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Job = _class_0
  return _class_0
end