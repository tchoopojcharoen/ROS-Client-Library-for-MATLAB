classdef Rate < handle
    %RATE Object Properties and Methods.
    %
    % Rate methods:
    % Rate object construction:
    %   @Rate/Rate              - Construct rate object.
    %
    % General:
    %   sleep                   - wait for the correct amount to match the given frequency
    %   delete                  - deconstruct the object

    % Copyright 2022 Pi Thanacha Choopojcharoen (GPL 2.0)
   events
      Update
   end
   properties (Access=private)
       RateControl
   end
   methods
       function obj = Rate(frequency)
           %RATE Construct rate object.
           %
           %    R = RATE(F) constructs a rate objeect R with
           %    the given frequenct F.
           %
           %    See also SLEEP
           obj.RateControl = rateControl(frequency);
      end
      function sleep(obj)
          %SLEEP wait for the correct amount to match the given frequency 
          %     SLEEP(OBJ) waits for a correct amount of duration so that 
          %     it matches with the given rate.
          %
          %     See also RATE
          waitfor(obj.RateControl)
      end
      function delete(obj)
            %DELETE deconstructs this rate object
            %   DELETE(OBJ) deconstructs the rate object.
            %
            delete(obj.RateControl);
            delete@handle(obj);
        end
   end
end