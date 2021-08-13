# frozen_string_literal: true
require "rmagick"

class TitleCard
  LOGO_PATH = "assets/logo.png"
  IMAGE_SIZE = [1280, 720]
  BACKGROUND_COLOR = "black"
  TEXT_COLOR = "white"

  def initialize(arguments)
    @title = arguments[0]
    @attribution = arguments[1]
    @date = arguments[2]
  end

  def generate
    add_title
    add_attribution
    add_date
    canvas.composite_layers(logo).display
  end

  private

  attr_reader :title, :attribution, :date

  def canvas
    @_canvas ||= Magick::ImageList.new("assets/base.png").tap do |c|
      c.gravity = Magick::NorthGravity
      c.geometry = "0x0+0+40"
    end
  end

  def logo
    Magick::ImageList.new(LOGO_PATH)
  end

  def add_title
    text = Magick::Draw.new
    text.font_family = "DejaVu Sans Mono"
    text.pointsize = 32
    text.gravity = Magick::CenterGravity
    text.annotate(canvas, 0, 0, 0, 30, title) {
      self.fill = "white"
    }
  end

  def add_attribution
    text = Magick::Draw.new
    text.font_family = "DejaVu Sans Mono"
    text.pointsize = 52
    text.gravity = Magick::CenterGravity
    text.annotate(canvas, 0, 0, 0, 120, attribution) {
      self.fill = "white"
    }
  end

  def add_date
    text = Magick::Draw.new
    text.font_family = "DejaVu Sans Mono"
    text.pointsize = 52
    text.gravity = Magick::SouthGravity
    text.annotate(canvas, 0, 0, 0, 40, date) {
      self.fill = "white"
    }
  end
end