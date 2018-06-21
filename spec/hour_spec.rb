require "hour"

describe Hour do
  describe ".parse" do
    pending "implement me" #do
      # TODO
      # p Hour.parse("1:02:30")
    #end
  end

  describe ".now" do
    pending "implement me" #do
      # TODO
    #end
  end

  describe "#to_s" do
    pending "implement me" #do
      # TODO
    #end
  end

  describe "#+" do
    it "returns a new Hour instance returning the total time of the two hour instances" do
      hour = Hour.new(m: 25, s: 10) + Hour.new(h: 1)
      expect(hour.hours.value).to eq(1)
      expect(hour.minutes.value).to eq(25)
      expect(hour.seconds.value).to eq(10)
    end
  end

  describe ".from" do
    context "minutes" do
      it "returns a new Hour instance" do
        hour = Hour.from(minutes: 85)
        expect(hour.hours.value).to eq(1)
        expect(hour.minutes.value).to eq(25)
        expect(hour.seconds.value).to eq(0)
      end
    end

    context "seconds" do
      it "returns a new Hour instance" do
        hour = Hour.from(seconds: 2 * 60 * 60 + 25 * 60 + 5)
        expect(hour.hours.value).to eq(2)
        expect(hour.minutes.value).to eq(25)
        expect(hour.seconds.value).to eq(5)
      end
    end
  end

  describe "#hours" do
    describe "#value" do
      it "returns the exact hour value" do
        expect(Hour.new(1, 10).hours.value).to eq(1)
        expect(Hour.new(1, 59).hours.value).to eq(1)
      end
    end

    describe "#round" do
      it "returns the rounded hour" do
        expect(Hour.new(1, 10).hours.round).to eq(1)
        expect(Hour.new(1, 29, 59).hours.round).to eq(1)
        expect(Hour.new(1, 30).hours.round).to eq(2)
        expect(Hour.new(1, 59).hours.round).to eq(2)
      end
    end
  end

  describe "#minutes" do
    describe "#value" do
      it "returns the exact minute value" do
        expect(Hour.new(1, 25, 52).minutes.value).to eq(25)
      end
    end

    describe "#round" do
      it "returns the rounded minutes" do
        expect(Hour.new(1, 25, 52).minutes.round).to eq(26)
      end
    end

    describe "#total" do
      it "returns the total number of minutes" do
        expect(Hour.new(1, 25, 52).minutes.total).to eq(85)
      end
    end

    describe "#round_total" do
      it "returns the rounded total number of minutes" do
        expect(Hour.new(1, 25, 52).minutes.round_total).to eq(86)
      end
    end
  end

  describe "#seconds" do
    describe "#value" do
      it "returns the exact second value" do
        expect(Hour.new(m: 1, s: 25).seconds.value).to eq(25)
      end
    end

    describe "#total" do
      it "returns the exact total number of seconds" do
        expect(Hour.new(m: 1, s: 25).seconds.total).to eq(85)
        expect(Hour.new(1, 10, 25).seconds.total).to eq(1 * 60 * 60 + 10 * 60 + 25)
      end
    end
  end
end
