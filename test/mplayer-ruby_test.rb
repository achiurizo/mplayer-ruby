require File.expand_path("teststrap", File.dirname(__FILE__))

context "mplayer-ruby" do
  setup do
    false
  end

  asserts "i'm a failure :(" do
    topic
  end
end
