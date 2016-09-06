require File.expand_path '../../spec_helper.rb', __FILE__

class CupcakeSettings
  CONNECTION_DATA = ["cupcakes", "posts", fields: "message,cupcake_photo,created_time"]
  PHOTO_KEY = "cupcake_photo"

  def post_subject_indicators
    /[c|C]upcake/i
  end
end

describe "FacebookPost" do
  let(:type) { CupcakeSettings.new }
  let(:feed) { [
                {
                  "message" => "Cupcake ipsum dolor sit amet marzipan",
                  "cupcake_photo" => "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/14192083_1035965189805878_716609579580349135_n.jpg?oh=4602c33563c6e09f3bca09579ecc1e2c&oe=585296FE",
                  "created_time" => "2016-09-02T10:25:00+0000",
                  "id" => "953161208086277_1035967103139020"
                }, {
                  "message" => "Tiramisu donut gummi bears jujubes. Bonbon candy canes soufflé",
                  "created_time" => "2016-09-02T10:20:17+0000",
                  "id" => "953161208086277_1035965189805878"
                }, {
                  "message" => "Gummies sugar plum donut bear claw candy croissant marshmallow icing",
                  "cupcake_photo" => "https://scontent.xx.fbcdn.net/t31.0-8/s720x720/14125508_1035103839892013_3513189061276111723_o.jpg",
                  "created_time" => "2016-09-01T09:41:59+0000",
                  "id" => "953161208086277_1035103839892013"
                }, {
                  "message" => "Cake cupcake jujubes jelly beans. Muffin wafer muffin dessert gummies candy canes marshmallow danish",
                  "created_time" => "2016-08-31T09:06:34+0000",
                  "id" => "953161208086277_1034312403304490"
                }, {
                  "message" => "Topping pie halvah topping cake marshmallow halvah tootsie roll",
                  "cupcake_photo" => "https://scontent.xx.fbcdn.net/v/t1.0-0/p180x540/14199228_1033517183384012_7486696415223532161_n.jpg?oh=e0110fe290132e71420fa32945ee3374&oe=588400C7",
                  "created_time" => "2016-08-30T09:15:43+0000",
                  "id" => "953161208086277_1033517183384012"
                }, {
                  "message" => "Biscuit ice cream ice cream jelly beans tiramisu tart sugar plum liquorice",
                  "created_time" => "2016-08-26T18:02:19+0000",
                  "id" => "953161208086277_1030680510334346"
                }
              ] }
  let(:cupcake_post) { FacebookPost.new(type, feed) }

  describe "#initialize" do
    it "properly selects newest post" do
      expected = {
        "message" => "Cupcake ipsum dolor sit amet marzipan",
        "cupcake_photo" => "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/14192083_1035965189805878_716609579580349135_n.jpg?oh=4602c33563c6e09f3bca09579ecc1e2c&oe=585296FE",
        "created_time" => "2016-09-02T10:25:00+0000",
        "id"=>"953161208086277_1035967103139020"
      }
      expect(cupcake_post.post).to eq expected
    end
  end

  describe "#is_not_updated?" do
    it "returns true if post publish date differs from present date" do
      expect(cupcake_post.is_not_updated?).to be_truthy
    end

    it "returns false if post publish date is present date" do
      time = DateTime.parse("2016-09-02T10:25:00+0000")
      Timecop.travel(time)
      expect(cupcake_post.is_not_updated?).to be_falsy
      Timecop.return
    end
  end

  describe "#as_json" do
    it "returns post in json format" do
      expected = {
        text: "Cupcake ipsum dolor sit amet marzipan",
        attachments: [
          {
            text: "posted at: 2016-09-02 10:25:00 +0000\nlink: https://www.facebook.com/953161208086277/posts/1035967103139020",
            attachments: {
              image_url: "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/14192083_1035965189805878_716609579580349135_n.jpg?oh=4602c33563c6e09f3bca09579ecc1e2c&oe=585296FE"
            }
          }
        ]
      }.to_json

      expect(cupcake_post.as_json).to eq expected
    end
  end

end
