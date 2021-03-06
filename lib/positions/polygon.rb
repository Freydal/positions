require 'rgeo'

module Positions
  class Polygon

    attr_accessor :polygon

    FACTORY = RGeo::Geos.factory

    def initialize(coordinates)
      points = []

      coordinates.each do |coordinate|

        if coordinate.is_a? Array
          raise Exception('The library is picky please use a lat: long: hash')
        elsif coordinate.is_a? Hash
          points << FACTORY.point( coordinate[:long], coordinate[:lat] )
        else
          raise Exception('The library is picky please use a lat: long: hash')
        end
      end

      @polygon = FACTORY.polygon(FACTORY.linear_ring(points))
    end

    def contains(coordinate)
      if coordinate.is_a? RGeo::Geos::CAPIPointImpl
        polygon.contains? coordinate
      elsif coordinate.is_a? Hash
        polygon.contains? ( FACTORY.point(coordinate[:long], coordinate[:lat]))
      else
        raise(Exception.new('broke'))
      end
    end

  end
end