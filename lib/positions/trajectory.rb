require 'rgeo'

module Positions
  class Trajectory

    attr_accessor :line_string, :points

    EARTHS_RADIUS = 6371000.0
    FACTORY = RGeo::Geos.factory

    def initialize(position)
      raise Exception('The library is picky please use a lat: long: hash') unless position.is_a? Hash

      @points = [FACTORY.point( position[:long], position[:lat] )]

      @points << point_in(600, position)

      @line_string = FACTORY.line_string(@points)
    end

    def intersects?(line_string2)
      if line_string2.class == Positions::Trajectory
        @line_string.intersects? ( line_string2.line_string )
      else
        @line_string.intersects? ( line_string2.line_string )
      end
    end

    def point_in(seconds, position)

      speed = position[:speed_over_ground] / 0.1 * 0.19 * 0.27 #knots to m/s
      course = position[:course_over_ground]
      distance = speed * seconds
      angular_distance = distance/EARTHS_RADIUS

      brng = radians(course)
      lat1 = radians(position[:lat])
      lon1 = radians(position[:long])

      lat2 = Math.asin(Math.sin(lat1) * Math.cos(angular_distance) + Math.cos(lat1) * Math.sin(angular_distance) * Math.cos(brng))
      lon2 = lon1 + Math.atan2(Math.sin(brng) * Math.sin(angular_distance) * Math.cos(lat1), Math.cos(angular_distance) - Math.sin(lat1) * Math.sin(lat2))

      new_lat = degrees(lat2)
      new_long = degrees(lon2)

      FACTORY.point( new_long, new_lat )
    end

    def radians(degrees)
      degrees * Math::PI / 180
    end

    def degrees(radians)
      radians * 180 / Math::PI
    end

  end
end