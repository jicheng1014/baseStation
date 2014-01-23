require 'net/http'
require 'json'
require 'base64'
class Station < ActiveRecord::Base
  validates :name,presence: true
  before_save :trans_to_baidupoint






  def trans_to_baidupoint
    if self.pos_type == "gps"
      i = 0
      while i < 5
        begin
          result = Net::HTTP.get(URI.parse("http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=#{self.lng}&y=#{self.lat}"))
          answer = JSON.parse(result) 
          Rails.logger.debug(answer)
          if answer["error"] == 0
            self.baidu_lng = Base64.decode64(answer["x"])
            self.baidu_lat = Base64.decode64(answer["y"])
            self.translated = 1
            break
          else
            i+=1
          end

        rescue JSON::ParserError
          i+=1
        end
      end
    else  # post_type==baidu_geo
      self.lng = nil
      self.lat = nil
    end

  end
end
