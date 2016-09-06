require File.expand_path '../spec_helper.rb', __FILE__

describe "re_bot application" do
  describe '#GET u dziewczyn' do
    before(:each) { fake_request(url_for("u_dziewczyn"), "lunch_posts.json") }

    it "returns menu post for present day if post already published" do
      time = DateTime.parse("2016-09-02T10:25:00+0000")
      expected = {
        "text" => "Dziś zapraszamy na zupę surową oraz\nMiruna z patelni z czerwoną kapustą i ziemniaki",
        "attachments" => [{
          "text" => "posted at: 2016-09-02 10:20:17 +0000\nlink: https://www.facebook.com/953161208086277/posts/1035965189805878",
          "attachments" => {
            "image_url" => "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/14192083_1035965189805878_716609579580349135_n.jpg?oh=4602c33563c6e09f3bca09579ecc1e2c&oe=585296FE"
          }
        }]
      }.to_json
      Timecop.freeze(time) do
        get '/fb/u_dziewczyn'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq expected
      end
    end

    it "returns proper info if menu not yet published" do
      get '/fb/u_dziewczyn'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq "Nie ma jeszcze lunchu na dziś. Zwykle pojawia się koło godziny 11:00-11:15."
    end
  end

  describe '#GET wod' do
    it "returns last published wod post" do
      fake_request(url_for("wod"), "wod_posts.json")
      expected = {
        "text" => "WOD#957 [G,W,M]\n\nAMRAP in 7 min. of:\n\n3 Deadlifts 111 kg / 75 kg\n6 Strict Ring Dips / Ring Push Ups\n9 Burpees Over The Bar\n\nthen \n\n2 Rounds for time of:\n\n400 m Run\n15 Toes To Bar\n\nTime cap: 5 min.\n\nBEGINNERS CLASS:\n\nEMOM in 15 min. perform:\n\n1 min: 10 Thrusters\n2 min: 10 Ring Rows\n3 min: 10 Burpees\n\nAccessory Work:\n\n6 sets NOT for time of:\n\n10s Ring Dips Hold (Top Position)\n10s Ring Dips Hold (Bottom Position)\n10 Hollow Rocks\n\n#CrossFit #CrossFitKiDS #EMC #Warszawa #Polska #Fitness #Progenex #TrainingSHOWroom #STEELSTORM #TheraMoc #Reebok #BeMoreHuman #FITcare #justROW #POSErunning #BurgenerStrength #DzwigajZSierzantem #CrossFit12U1 #naszWiLANÓW",
        "attachments" => [{
          "text" => "posted at: 2016-09-04 16:00:02 +0000\nlink: https://www.facebook.com/569393566456025/posts/1189885197740189",
          "attachments" => {
            "image_url" => "https://scontent.xx.fbcdn.net/v/t1.0-0/s130x130/14222179_1189885197740189_8157198632059740340_n.jpg?oh=df353b9bd59ecaed8dc3e0da97bc493e&oe=584F2BD9"
          }
        }]
      }.to_json
      get '/fb/wod'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq expected
    end
  end

  describe '#GET megadex' do
    before(:each) { fake_request(url_for("megadex"), "megadex_data.txt") }

    it "returns menu for present day if day not passed in params" do
      time = DateTime.parse("2016-09-05T10:25:00+0000")
      expected = {
        "text" => "zupa:  ZUPA BARSZCZ BIAŁY\nzestaw 1:     POTRAWKA CHIŃSKA DROBIOWA Z RYŻEM\nzestaw 2:     KOTLETY WIEPRZOWE MILONE, ZIEMNIAKI + SURÓWKA\nzestaw 3:     KOTLET SCHABOWY, ZIEMNIAKI + SURÓWKA\ndanie wegetariańskie:     PENNE Z SOSEM SZPINAKOWYM\ndanie specjalne:    BOGRACZ + PIECZYWO"
      }.to_json
      Timecop.freeze(time) do
        get '/megadex'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq expected
      end
    end

    it "returns menu for day passed in params" do
      expected = {
        "text" => "zupa:  ZUPA GROCHOWA\nzestaw 1:     UDKO PIECZONE, ZIEMNIAKI + MARCHEW Z GROSZKIEM\nzestaw 2:     SCHAB PO SZWAJCARSKU, ZIEMNIAKI + SURÓWKA\nzestaw 3:     MORSZCZUK NA SZPINAKU POD BESZAMELEM,  ZIEMNIAKI + SURÓWKA\ndanie wegetariańskie:  KNEDLE ZE ŚLIWKĄ\ndanie specjalne:  LECZO + PIECZYWO"
      }.to_json
      get '/megadex', text: "3"
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq expected
    end
  end
end


