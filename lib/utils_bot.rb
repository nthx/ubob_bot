module UtilsBot
  def self.symbolize_keys!(h)
    h.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
end
