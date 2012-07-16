class MatterImagesController < ApplicationController

  def show
    matter = Matter.find(params[:id])
    if matter
      if matter.matter_images and matter.matter_images.first
        url = matter.matter_images.first.image.url(:thumb)
        url = url.split('?')
        url = url[0]
        begin
          send_data open("#{Rails.root }/public/#{url}", "rb") { |f| f.read } and return
        rescue
          send_data open("#{Rails.root }/public/images/no_img.jpg", "rb") { |f| f.read } and return
        end
      end
    end
    send_data open("#{Rails.root }/public/images/no_img.jpg", "rb") { |f| f.read } and return
  end

end
