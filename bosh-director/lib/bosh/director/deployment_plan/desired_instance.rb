module Bosh
  module Director
    module DeploymentPlan
      class DesiredInstance < Struct.new(:job, :virtual_state, :deployment, :az, :index)
        def inspect
          "<DesiredInstance az=#{self.az ? self.az.name : nil} index=#{self.index}>"
        end

        def state
          # Expanding virtual states
          case virtual_state
            when 'recreate'
              'started'
            when 'restart'
              'started'
            else
              virtual_state
          end
        end

        def availability_zone
          self.az.name unless self.az.nil?
        end
      end
    end
  end
end