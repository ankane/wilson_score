require_relative "test_helper"

class TestWilsonScore < Minitest::Test

  def test_wilson_score
    interval = WilsonScore.interval(1, 2, correction: false)
    assert_in_delta 0.0945, interval.first
    assert_in_delta 0.9055, interval.last
  end

  def test_lower_bound
    assert_in_delta 0.0267, WilsonScore.lower_bound(1, 2)
  end

  def test_continuity_correction
    interval = WilsonScore.interval(1, 2)
    assert_in_delta 0.0267, interval.first
    assert_in_delta 0.9733, interval.last
  end

  def test_continuity_correction_zero_one
    interval = WilsonScore.interval(0, 1)
    assert_in_delta 0, interval.first
    assert_in_delta 0.9454, interval.last
  end

  def test_continuity_correction_zero_ten
    interval = WilsonScore.interval(0, 10)
    assert_in_delta 0, interval.first
    assert_in_delta 0.3445, interval.last
  end

  def test_continuity_correction_one_ten
    interval = WilsonScore.interval(1, 10)
    assert_in_delta 0.0052, interval.first
    assert_in_delta 0.4588, interval.last
  end

  def test_continuity_correction_one_fifty
    interval = WilsonScore.interval(1, 50)
    assert_in_delta 0.0010, interval.first
    assert_in_delta 0.1201, interval.last
  end

  def test_continuity_correction_one_one
    interval = WilsonScore.interval(1, 1)
    assert_in_delta 0.0546, interval.first
    assert_in_delta 1, interval.last
  end

  def test_continuity_correction_one_three
    interval = WilsonScore.interval(1, 3)
    assert_in_delta 0.0176, interval.first
    assert_in_delta 0.8747, interval.last
  end

  def test_continuity_correction_p_zero
    assert_equal 0, WilsonScore.interval(0, 25, confidence: 0.8).first
    assert_equal 1, WilsonScore.rating_interval(1, 25, 1..5, confidence: 0.8).first
  end

  def test_continuity_correction_p_one
    assert_equal 1, WilsonScore.interval(25, 25, confidence: 0.8).last
    assert_equal 5, WilsonScore.rating_interval(5, 25, 1..5, confidence: 0.8).last
  end

  def test_rating
    interval = WilsonScore.rating_interval(5, 1, 1..5, correction: false)
    assert_in_delta 1.8262, interval.first
    assert_in_delta 5, interval.last
  end

  def test_rating_advanced
    interval = WilsonScore.rating_interval(3.7, 10, 1..5, correction: false)
    assert_in_delta 2.4998, interval.first
    assert_in_delta 4.5117, interval.last
  end

  def test_rating_lower_bound
    assert_in_delta 1.8262, WilsonScore.rating_lower_bound(5, 1, 1..5, correction: false)
  end

  def test_invalid_argument
    assert_raises(ArgumentError) { WilsonScore.interval(0, 0) }
  end

end
