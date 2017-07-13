describe 'Positions::Polygon' do
  before do

    point_hashs = [
        {lat: 36.498321, long: -94.614258}, # ~ NW Ar
        {lat: 33.061335, long: -94.427490}, # ~ SW Ar
        {lat: 33.006072, long: -91.131592}, # ~ SE Ar
        {lat: 36.471822, long: -89.450684} # ~ NE Ar
    ]
    @poly = Positions::Polygon.new(point_hashs)
  end
  it 'should create a polygon' do
    expect(@poly.polygon).not_to eq(nil)
    expect(@poly.polygon.class).to eq(RGeo::Geos::CAPIPolygonImpl)
  end

  describe 'contains' do

    it 'should know if a point is within the polygon' do
      outside = {lat: 35.036462, long: -95.493164}
      inside = {lat: 35.072436, long: -92.449951}

      expect(@poly.contains(outside)).to eq(false)
      expect(@poly.contains(inside)).to eq(true)
    end

    it 'should take a point as input' do
      point = RGeo::Geos.factory.point(-95.493164, 35.036462)
      expect(@poly.contains(point)).to eq(false)
    end

    it 'should throw exception when fed junk' do
      expect { @poly.contains('x') }.to raise_exception(Exception)
    end
  end
end