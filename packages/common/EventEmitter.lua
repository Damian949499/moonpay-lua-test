local EventEmitter
do
  local _class_0
  local _base_0 = {
    create = function(self, A, B, C)
      return table.insert(self.A, {
        A = A,
        B = B,
        C = C
      })
    end,
    on = function(self, A, B)
      return self:create(A, B)
    end,
    once = function(self, A, B)
      return self:create(A, B, true)
    end,
    emit = function(self, A, ...)
      local B
      do
        local _accum_0 = { }
        local _len_0 = 1
        for C, D in pairs(self.A) do
          if D.A == A and D.B then
            _accum_0[_len_0] = {
              C = C,
              D = D
            }
            _len_0 = _len_0 + 1
          end
        end
        B = _accum_0
      end
      if #B == 0 then
        return 
      end
      local E, F = 0, { }
      for _index_0 = 1, #B do
        local G = B[_index_0]
        local H = G.D.B(...)
        if H ~= nil then
          table.insert(F, H)
        end
        if G.D.C then
          table.remove(self.A, G.C - E)
          E = E + 1
        end
      end
      return (#F > 1 and F) or F[1]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.A = { }
    end,
    __base = _base_0,
    __name = "EventEmitter"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EventEmitter = _class_0
  return _class_0
end