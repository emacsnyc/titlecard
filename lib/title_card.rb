# frozen_string_literal: true

require "rmagick"
require "date"

class TitleCard
  LOGO_PATH = "assets/logo.png"
  IMAGE_SIZE = [1280, 720]
  BACKGROUND_COLOR = "black"
  TEXT_COLOR = "white"
  FONT_FAMILY = "DejaVu Sans Mono"

  def initialize(arguments)
    @title = arguments[0]
    @attribution = arguments[1]
    @date = Date.parse(arguments[2])
  end

  def generate
    add_title
    add_attribution
    add_date
    canvas.composite_layers(logo).write(save_filepath)
  end

  private

  attr_reader :title, :attribution, :date

  def canvas
    @_canvas ||= Magick::ImageList.new.tap do |c|
      c.new_image(*IMAGE_SIZE) { |i| i.background_color = BACKGROUND_COLOR }
      c.gravity = Magick::NorthGravity
      c.geometry = "0x0+0+40"
    end
  end

  def logo
    Magick::ImageList.new(LOGO_PATH)
  end

  def formatted_date
    date.strftime("%Y-%m-%d")
  end

  def add_title
    title_layer = Magick::ImageList.new
    title_layer.read("caption:#{title}") do
      self.size = "1280x750"
      self.font = FONT_FAMILY.split(" ").join("-")
      self.pointsize = 52
      self.background_color = BACKGROUND_COLOR
      self.fill = TEXT_COLOR
      self.gravity = Magick::CenterGravity
    end
    @_canvas = canvas.composite_layers(title_layer)
  end

  def add_attribution
    text = Magick::Draw.new
    text.font_family = FONT_FAMILY
    text.pointsize = 52
    text.gravity = Magick::CenterGravity
    text.fill = TEXT_COLOR
    text.annotate(canvas, 0, 0, 0, 170, attribution)
  end

  def add_date
    text = Magick::Draw.new
    text.font_family = FONT_FAMILY
    text.pointsize = 52
    text.gravity = Magick::SouthGravity
    text.fill = TEXT_COLOR
    text.annotate(canvas, 0, 0, 0, 40, formatted_date)
  end

  def filename
    [title.downcase, attribution.downcase, formatted_date].join("-").gsub(" ", "-")
  end

  def save_filepath
    File.expand_path("~/tmp/#{filename}.png")
  end
end
