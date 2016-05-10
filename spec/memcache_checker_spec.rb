require "spec_helper"

describe DeviseCasAuthenticatable::MemcacheChecker do
  let(:conf_double) { stub(session_options: {}) }

  describe '#session_store_memcache?' do
    subject(:session_store_memcache?) { described_class.new(conf_double).session_store_memcache? }

    before do
      DeviseCasAuthenticatable::SessionStoreIdentifier.any_instance
        .stubs(:session_store_class).returns(session_store_class)
    end

    context "when session store is memcache" do
      let(:session_store_class) { FakeMemcacheStore }

      it { expect(session_store_memcache?).to eq true  }
    end

    context "when session store is NOT memcache" do
      let(:session_store_class) { String }

      it { expect(session_store_memcache?).to eq false  }
    end
  end

  describe 'alive?' do
    context "when memcache is down" do
      let(:conf_double) { stub(session_options: {memcache_server: ['127.0.0.1:11223']}) }
      subject(:alive?) { described_class.new(conf_double).alive? }

      it { expect(alive?).to eq false }
    end

    context "when memcache is running" do
      let(:conf_double) { stub(session_options: {memcache_server: ['127.0.0.1:11214']}) }
      subject(:alive?) { described_class.new(conf_double).alive? }

      before do
        DeviseCasAuthenticatable::MemcacheChecker.any_instance.stubs(:try_connect)
      end

      it { expect(alive?).to eq true }
    end
  end
end

class FakeMemcacheStore
end