classdef GuardNode < rclm_node
    %GUARDNODE This is a stripped-down version of ROS Turtlesim
    % Object Properties and Methods.
    %
    % GuardNode properties.
    %   Property_1                      - Description_1
    %
    % GuardNode methods:
    % GuardNode object construction:
    %   @GuardNode/GuardNode            - Construct node object.

    % Copyright 2022 Pi Thanacha Choopojcharoen (GPL 2.0)
    properties (Access=private)
    end
    properties (Access=private,Constant)
    end

    methods
        function obj = GuardNode()
            %GUARDNODE Construct guardNode object.
            %
            %    N = GUARDNODE() constructs and run a node with a guard with MATLAB
            %
            %    Example:
            %       test_node = GuardNode();
            %
            obj@rclm_node('node_with_guard');
            obj.create_guard_condition(@obj.guard_callback);
            obj.create_guard_condition(@obj.guard_callback2);
            
        end
    end
    methods (Access=private)
        function guard_callback(obj,src,event)
            disp("Here!!");
        end
        function guard_callback2(obj,src,event)
            disp("Where!!");
        end

    end
end