require File.expand_path '../../spec_helper.rb', __FILE__

describe 'MegadexMenu' do

  describe '#for_day' do
    it "blablabla" do
      raw_menu = File.read("#{File.dirname(__FILE__)}/../feed_examples/megadex_data.txt")
      megadex_menu = MegadexMenu.new(raw_menu)
      expected_for_3 = {
        "text" => "zupa:  ZUPA GROCHOWA\nzestaw 1:     UDKO PIECZONE, ZIEMNIAKI + MARCHEW Z GROSZKIEM\nzestaw 2:     SCHAB PO SZWAJCARSKU, ZIEMNIAKI + SURÓWKA\nzestaw 3:     MORSZCZUK NA SZPINAKU POD BESZAMELEM,  ZIEMNIAKI + SURÓWKA\ndanie wegetariańskie:  KNEDLE ZE ŚLIWKĄ\ndanie specjalne:  LECZO + PIECZYWO"
      }.to_json
      expected_for_1 = {
        "text" => "zupa:  ZUPA BARSZCZ BIAŁY\nzestaw 1:     POTRAWKA CHIŃSKA DROBIOWA Z RYŻEM\nzestaw 2:     KOTLETY WIEPRZOWE MILONE, ZIEMNIAKI + SURÓWKA\nzestaw 3:     KOTLET SCHABOWY, ZIEMNIAKI + SURÓWKA\ndanie wegetariańskie:     PENNE Z SOSEM SZPINAKOWYM\ndanie specjalne:    BOGRACZ + PIECZYWO"
      }.to_json
      expect(megadex_menu.for_day(3)).to eq expected_for_3
      expect(megadex_menu.for_day(1)).to eq expected_for_1
    end
  end
end
