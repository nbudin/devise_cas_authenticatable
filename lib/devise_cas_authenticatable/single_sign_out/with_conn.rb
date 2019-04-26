module DeviseCasAuthenticatable
  module SingleSignOut
    module WithConn
      def with_conn(&block)
        if old_style_conn = current_session_store.instance_variable_get(:@pool)
          yield old_style_conn
        else
          current_session_store.instance_variable_get(:@conn)
            .instance_variable_get(:@pool).with &block
        end
      end
    end
  end
end
