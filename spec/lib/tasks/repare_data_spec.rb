# frozen_string_literal: true

require "spec_helper"

describe "rake decidim:repare:nickname", type: :task do
  let!(:organization) { create(:organization) }
  let(:task_cmd) { :"decidim:repare:nickname" }

  let!(:user) { create(:user, organization: organization) }
  let!(:valid_user2) { create(:user, nickname: "Azerty_Uiop123", organization: organization) }
  let(:invalid_user1) { build(:user, nickname: "Foo bar", organization: organization) }
  let(:invalid_user2) { build(:user, nickname: "Foo M. bar", organization: organization) }
  let(:invalid_user3) { build(:user, nickname: "Foo-Bar_fooo$", organization: organization) }
  let(:invalid_user4) { build(:user, nickname: "foo.bar.foo", organization: organization) }
  let(:invalid_user5) { build(:user, nickname: ".foobar.foo_bar.", organization: organization) }

  context "when executing task" do
    before do
      invalid_user1.save(validate: false)
      invalid_user2.save(validate: false)
      invalid_user3.save(validate: false)
      invalid_user4.save(validate: false)
      invalid_user5.save(validate: false)
    end

    it "exits with 0 code" do
      allow($stdin).to receive(:gets).and_return("y")

      expect { Rake::Task[task_cmd].invoke }.to raise_error(SystemExit) do |error|
        expect(error.status).to eq(0)
      end
    end

    context "when user accepts update" do
      it "updates invalid nicknames" do
        allow($stdin).to receive(:gets).and_return("y")

        expect { Rake::Task[task_cmd].invoke }.to change(invalid_user1, :nickname).from("Foo bar").to("foobar")

        invalid_user1.reload
        expect(invalid_user1.nickname).to eq("foobar")
        invalid_user2.reload
        expect(invalid_user2.nickname).to eq("foombar")
        invalid_user3.reload
        expect(invalid_user3.nickname).to eq("foobarfooo")
        invalid_user4.reload
        expect(invalid_user4.nickname).to eq("foobarfoo")
      end
    end

    context "when user refuses update" do
      it "updates invalid nicknames" do
        allow($stdin).to receive(:gets).and_return("n")

        expect { Rake::Task[task_cmd].invoke }.not_to change(invalid_user1, :nickname)

        invalid_user1.reload
        expect(invalid_user1.nickname).to eq("Foo bar")
        invalid_user2.reload
        expect(invalid_user2.nickname).to eq("Foo M. bar")
        invalid_user3.reload
        expect(invalid_user3.nickname).to eq("Foo-Bar_fooo$")
        invalid_user4.reload
        expect(invalid_user4.nickname).to eq("foo.bar.foo")
        invalid_user5.reload
        expect(invalid_user5.nickname).to eq(".foobar.foo_bar.")
      end
    end
  end
end
