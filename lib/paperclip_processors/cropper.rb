module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        # super returns an array like this: ["-resize", "100x", "-crop", "100x100+0+0", "+repage"]
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.has_cropping_attributes?
        ["-crop", "#{target.crop_width}x#{target.crop_width}+#{target.crop_x}+#{target.crop_y}", '+repage']
      else
        ["-thumbnail", "200x200^", "-gravity", "center", "-extent", "200x200"]
      end
    end
  end
end
