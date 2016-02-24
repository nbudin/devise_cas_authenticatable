require "spec_helper"

describe DeviseCasAuthenticatable::MemcacheChecker do
  describe '#session_store_memcache?' do
    subject(:session_store_memcache?) { described_class.new(conf_double) }
    let(:conf_double) { stub(session_store: session_store) }

    context "when session store is memcache" do
      let(:session_store) { ActionDispatch::Session::MemCacheStore }

      it { expect(session_store_memcache?).to eq true  }
    end

    context "when session store is NOT memcache" do
      let(:session_store) { "any" }

      it { expect(session_store_memcache?).to eq false  }
    end
  end
end