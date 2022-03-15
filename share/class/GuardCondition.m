classdef GuardCondition < handle
    %GUARDCONDITION Object Properties and Methods.
    %
    % GuardCondition methods:
    % GuardCondition object construction:
    %   @GuardCondition/GuardCondition    - Construct guard condition object.
    %
    % General:
    %   trigger                 - execute guard callback
    %   delete                  - deconstruct the object

    % Copyright 2022 Pi Thanacha Choopojcharoen (GPL 2.0)
    events
        Update
    end
    properties (Access=private)
        Listener
    end
    methods
        function obj = GuardCondition(evntCb)
            %GUARDCONDITION Construct guard condition object.
            %   G = GUARDCONDITION(CB) constructs a guard condition G with
            %   the given callback function CB.
            %
            %   See also TRIGGER
            obj.Listener = addlistener(obj,'Update',evntCb);
        end
        function trigger(obj)
            %TRIGGER executes the callback
            %   TRIGGER(G) executes the callback of the guard condition G
            %
            %   See also GUARDCONDITION
            notify(obj,'Update')
        end
        function delete(obj)
            %DELETE deconstructs this guard condition
            %   DELETE(OBJ) deconstructs the guard condition.
            %
            delete(obj.Listener);
            delete@handle(obj);
        end
    end
end