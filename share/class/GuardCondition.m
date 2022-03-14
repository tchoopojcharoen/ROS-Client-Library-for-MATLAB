classdef GuardCondition < handle
    %GUARDCONDITION Object Properties and Methods.
    %
    % GuardCondition methods:
    % GuardCondition object construction:
    %   @GuardCondition/GuardCondition    - Construct guard condition object.
    %
    % General:
    %   trigger                 - execute guard callback 

    % Copyright 2022 Pi Thanacha Choopojcharoen (GPL 2.0)
   events
      Update
   end
   methods
       function obj = GuardCondition(evntCb)
           %GUARDCONDITION Construct guard condition object.
           %
           %    G = GUARDCONDITION(CB) constructs a guard condition G with
           %    the given callback function CB.
           %
           %    See also TRIGGER
            addlistener(obj,'Update',evntCb);
      end
      function trigger(obj)
          %TRIGGER executes the callback 
          %
          %     TRIGGER(G) executes the callback of the guard condition G
          notify(obj,'Update')
      end
   end
end