require "test_helper"

class CommunityVideo::RetrieveTest < ActiveSupport::TestCase
  %w[
    youtu.be youtube www.youtube
  ].each do |base|
    test "retrieves #{base} video" do
      url = "https://#{base}/asd"
      CommunityVideo::RetrieveFromYoutube.expects(:call).with(url)
      CommunityVideo::Retrieve.(url)
    end
  end

  %w[
    vimeo.com player.vimeo.com
  ].each do |base|
    test "retrieves #{base} video" do
      url = "https://#{base}/asd"
      CommunityVideo::RetrieveFromVimeo.expects(:call).with(url)
      CommunityVideo::Retrieve.(url)
    end
  end

  test "raises with unexpected url" do
    assert_raises(InvalidCommunityVideoUrl) do
      CommunityVideo::Retrieve.("https://foo.bar")
    end
  end
end
