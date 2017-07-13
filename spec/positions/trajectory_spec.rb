describe 'Positions::Trajectory' do
  before do
    @traj1 = Positions::Trajectory.new({lat: 0, long: -0.1, speed_over_ground: 200, course_over_ground: 90 })
    @traj2 = Positions::Trajectory.new({lat: 0.1, long: 0, speed_over_ground: 200, course_over_ground: 180 })
    @traj3 = Positions::Trajectory.new({lat: 30.1, long: 240, speed_over_ground: 200, course_over_ground: 180 })

    @position_data = {lat: 30.1, long: 240, speed_over_ground: 200, course_over_ground: 40 }

  end

  it 'successfully creates a linestring' do
    expect(@traj1.line_string).not_to be(nil)
    expect(@traj1.line_string.class).to be(RGeo::Geos::CAPILineStringImpl)
  end

  describe 'intersects?' do

    it 'should find overlaping trajectories (possible collisions)' do
      expect(@traj1.intersects?(@traj2)).to eq(true)
      expect(@traj1.intersects?(@traj3)).to eq(false)
    end

    it 'should accept a line_string' do
      expect(@traj1.intersects?(@traj2.line_string)).to eq(true)
    end

    it 'should throw an exception when passed junk' do
      expect { @traj1.intersects?(32) }.to raise_exception(Exception)
    end
  end

  it 'should take an optional time for the trajectory location projection' do
    t1 = Positions::Trajectory.new(@position_data)
    t2 = Positions::Trajectory.new(@position_data.merge({ time: 300 }))

    expect(t1.points[1].x).not_to eq(t2.points[1].x)
    expect(t1.points[1].y).not_to eq(t2.points[1].y)
  end

  it 'should be tested for calculation accuracy'
end