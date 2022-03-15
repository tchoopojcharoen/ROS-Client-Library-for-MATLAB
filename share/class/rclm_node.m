classdef rclm_node < handle
    %RCLM_NODE Object Properties and Methods.
    %
    % Node properties.
    %   Name                    - Name of the node in ROS 2 network
    %   Timer                   - Timer of the node
    %   Publishers              - List of all publishers asscoiated with the node
    %   Subscribers             - List of all subscribers asscoiated with the node
    %   Service_servers         - List of all service servers asscoiated with the node
    %   Service_clients         - List of all service clients asscoiated with the node
    %   Guards                  - List of all guards associated with the node
    %
    % rclm_node methods:
    % rclm_node object construction:
    %   @rclm_node/rclm_node    - Construct node object.
    %
    % Creation:
    %   create_publisher        - Create a publisher with the node.
    %   create_subscription     - Create a subscriber with the node.
    %   create_timer            - Create a timer for the node.
    %   create_service          - Create a service server of the node.
    %   create_client           - Create a service client of the node.
    %   create_guard_condition  - Create a guard condition of the node.
    %   create_rate             - Create a rate object of the node.
    %
    % General:
    %   count_publishers        - Count number of publishers based on a topic
    %   count_subscribers       - Count number of subscribers based on a topic
    %
    % Deconstruction:
    %   delete                  - Delete the node from the memory.
    %   destroy_publisher       - Deconstructs a given publisher
    %   destroy_subscription    - Deconstructs a given subscriber
    %   destroy_timer           - Deconstructs a given timer
    %   destroy_service         - Deconstructs a given service
    %   destroy_client          - Deconstructs a given client
    %   destroy_guard_condition - Deconstructs a given guard condition
    %   destroy_rate            - Deconstructs a given rate
    %   

    % Copyright 2022 Pi Thanacha Choopojcharoen (GPL 2.0)
    properties (SetAccess=protected)
        Publishers = {}
        Subscribers = {}
        Service_servers = {}
        Service_clients = {}
        %Action_servers = 'to be implemented'
        %Action_clients = 'to be implemented'
        Timers = {}
        Guards = {}
        Rates = {}

    end
    properties (SetAccess=private)
        Name
    end
    properties(Access=private)
        ThisNode
    end
    methods
        function obj = rclm_node(name)
            %RCLM_NODE Construct node object.
            %
            %    N = RCLM_NODE(NAME) constructs a ROS 2 node object in which
            %    the given name NAME.
            %
            %    Example:
            %       % To construct a node object with a name /my_node:
            %         n = rclm_node('/my_node');
            %
            %    See also RCLM_NODE/CREATE_PUBLISHER, RCLM_NODE/CREATE_SUBSCRIPTION, RCLM_NODE/CREATE_TIMER, RCLM_NODE/CREATE_SERVICE, RCLM_NODE/CREATE_CLIENT.
            obj.Name = name;
            obj.ThisNode = ros2node(name);
        end
        function pub = create_publisher(obj,message_type,topic_name,qos_profile)
            %CREATE_PUBLISHER creates a publisher for the node
            %   PUB = CREATE_PUBLISHER(OBJ,TYPE,NAME,QOS) returns a
            %   publisher PUB that publish a message of type TYPE to a topic
            %   with the name NAME. The publisher has QOS depth of QOS.
            %
            %   Example:
            %       % Create a publisher for the node /talker
            %       % which publish to a topic /cmd_vel and QOS depth of 10.
            %       % The message type is geometry_msgs/Twist
            %
            %       node_talker = rclm_node('/talker');
            %       pub = node_talker.create_publisher("geometry_msgs/Twist","/cmd_vel",10)
            %       t = node_talker.create_timer(0.5,@(obj,event)timer_callback(obj,event,pub));
            %       t.start;
            %
            %       function timer_callback(obj, event, pub)
            %           msg = ros2message("geometry_msgs/Twist");
            %           msg.linear.x = randi(10);
            %           send(pub,msg);
            %       end
            %
            %   See also RCLM_NODE, CREATE_SUBSCRIPTION, CREATE_TIMER, CREATE_SERVICE, CREATE_CLIENT
            pub = ros2publisher(obj.ThisNode,topic_name,message_type,"Depth",qos_profile);
            obj.Publishers{end+1} = pub;
        end
        function num = count_publishers(obj,topic_name)
            %COUNT_PUBLISHERS counts the number of publishers that publish
            %to the given topic
            %   NUM = COUNT_PUBLISHERS(OBJ,NAME) returns the number of
            %   publishers NUM that publish to a topic with the given name
            %   NAME.
            %
            %   Example:
            %       % Create a publisher for the node /talker
            %       % which publish to a topic /cmd_vel and QOS depth of 10.
            %       % The message type is geometry_msgs/Twist
            %
            %       node_talker = rclm_node('/talker');
            %       pub = node_talker.create_publisher("geometry_msgs/Twist","/cmd_vel",10)
            %       num = node_talker.count_publishers("/cmd_vel")
            %       num = node_talker.count_publishers("/pose")
            %       
            %   See also CREATE_PUBLISHER, CREATE_SUBSCRIPTION, COUNT_SUBSCRIBERS
            num = 0;
            name = char(topic_name);
            if name(1) ~= '/'
                name = ['/' char(topic_name)];
            end
            for pub = obj.Publishers{:}
                if strcmp(pub.TopicName,name)
                    num = num + 1;
                end
            end
        end
        function sub = create_subscription(obj,message_type,topic_name,callback,qos_profile)
            %CREATE_SUBSCRIPTION creates a subscriber for the node
            %   SUB = CREATE_SUBSCRIPTION(OBJ,TYPE,NAME,CALLBACK,QOS)
            %   returns a subscriber SUB that subscribe to a topic with the
            %   name NAME with a callback CALLBACK. The message type is TYPE
            %   , and the subscriber has QOS depth of QOS.
            %
            %   Example:
            %
            %       node_talker = rclm_node('/talker');
            %       pub = node_talker.create_publisher("geometry_msgs/Twist","/cmd_vel",10);
            %       t = node_talker.create_timer(0.5,@(obj,event)timer_callback(obj,event,pub));
            %       node_caller = rclm_node('/caller');
            %       sub = node_caller.create_subscription("geometry_msgs/Twist","/cmd_vel",@sub_callback,10);
            %       t.start;
            %
            %       function timer_callback(obj, event, pub)
            %           msg = ros2message("geometry_msgs/Twist");
            %           msg.linear.x = randi(10);
            %           send(pub,msg);
            %       end
            %
            %       function sub_callback(msg)
            %           disp(msg.linear.x);
            %       end
            %
            %   See also RCLM_NODE, CREATE_PUBLISHER, CREATE_TIMER, CREATE_SERVICE, CREATE_CLIENT
            sub = ros2subscriber(obj.ThisNode,topic_name,message_type,callback,"Depth",qos_profile);
            obj.Subscribers{end+1} = sub;
        end
        function num = count_subscribers(obj,topic_name)
            %COUNT_SUBSCRIBERS counts the number of subscribers that
            %subscribe to the given topic
            %   NUM = COUNT_SUBSCRIBERS(OBJ,NAME) returns the number of
            %   subscribers NUM that subscribe to a topic with the given name
            %   NAME.
            %
            %   Example:
            %
            %       node_listener = rclm_node('/listener');
            %       pub = node_talker.create_subscriber("std_msgs/Float64","/value",@(msg)disp(msg.data),10)
            %       num = node_talker.count_publishers("/value")
            %       num = node_talker.count_publishers("/word")
            %       
            %   See also CREATE_PUBLISHER, COUNT_PUBLISHERS, CREATE_SUBSCRIPTION
            num = 0;
            name = char(topic_name);
            if name(1) ~= '/'
                name = ['/' char(topic_name)];
            end
            for pub = obj.Subscribers{:}
                if strcmp(pub.TopicName,name)
                    num = num + 1;
                end
            end
        end
        function t = create_timer(obj,period,callback)
            %CREATE_TIMER creates a timer for the node
            %   T = CREATE_TIMER(OBJ,PERIOD,CALLBACK) attaches a timer T 
            %   that executes the callback CALLBACK every period PERIOD 
            %   after the node starts its timer.
            %
            %   Example:
            %       % Create a timer for a node /talker that
            %       % publish a random number (1-10) as a "linear.x"
            %       % component of a topic /cmd_vel every 0.5 seconds.
            %       % The callback can be described as the following function.
            %
            %       node_talker = rclm_node('/talker');
            %       pub = node_talker.create_publisher("geometry_msgs/Twist","/cmd_vel",10);
            %       t = node_talker.create_timer(0.5,@(obj,event)timer_callback(obj,event,pub));
            %       t.start;
            %
            %       function timer_callback(obj, event, pub)
            %           msg = ros2message("geometry_msgs/Twist");
            %           msg.linear.x = randi(10);
            %           send(pub,msg);
            %       end
            %
            %   See also RCLM_NODE, CREATE_PUBLISHER, CREATE_SUBSCRIPTION, CREATE_SERVICE, CREATE_CLIENT
            t = timer("TimerFcn",callback,"Period",period,"ExecutionMode","fixedRate");
            obj.Timers{end+1} = t;
        end
        function rate = create_rate(obj,frequency)
            %CREATE_RATE creates a rate object for the node
            %   R = CREATE_RATE(OBJ,F) attaches a rate object with the 
            %   given frequency F
            %
            %   Example:
            %       node_talker = rclm_node('/talker');
            %       rate = node_talker.create_rate(10);
            %       for i = 1:10
            %           disp(i)
            %           rate.sleep;
            %       end
            %
            %   See also RCLM_NODE, CREATE_PUBLISHER, CREATE_SUBSCRIPTION, CREATE_SERVICE, CREATE_CLIENT
            obj.Rates = Rate(frequency);
            rate = obj.Rates;
        end
        function srv = create_service(obj,serviec_type,service_name,callback)
            %CREATE_SERVICE creates a service server for a node
            %   SRV = CREATE_SERVICE(OBJ,TYPE,NAME,CALLBACK) returns a
            %   service server SRV that provides a type of service TYPE
            %   with the name NAME. The service behaves based on callback
            %   CALLBACK.
            %
            %   Example:
            %       % Create a service server/say_hello that displays
            %       % "hello" on a node /server. The service type is
            %       % std_srvs/Empty.
            %
            %       node_server = rclm_node('/server');
            %       srv = create_service(node_server,"std_srvs/Empty","say_hello",@srv_callback)
            %
            %
            %       function resp = srv_callback(req,resp)
            %           disp("Hello")
            %       end
            %
            %   See also CREATE_SUBSCRIPTION, CREATE_TIMER, CREATE_CLIENT
            srv = ros2svcserver(obj.ThisNode,service_name,serviec_type,callback);
            obj.Service_servers{end+1} = srv;
        end
        function cli = create_client(obj,service_type,service_name)
            %CREATE_CLIENT creates a servie client for a node
            %   CLI = CREATE_CLIENT(OBJ,TYPE,NAME) returns a service
            %   client CLI that can call service server of name NAME, which
            %   provides a type of service TYPE.
            %
            %   Example:
            %       % Create a service client to a service /say_hello that
            %       % displays "hello" on a another node and call the
            %       % serviceThe service type is
            %       % std_srvs/Empty.
            %
            %       node_server = rclm_node('/server');
            %       srv = create_service(node_server,"std_srvs/Empty","say_hello",@srv_callback)
            %       node_client = rclm_node('/caller');
            %       cli = create_client(node_client,"std_srvs/Empty","say_hello")
            %       req = ros2message(cli);
            %       waitForServer(cli,"Timeout",3);
            %       resp = call(cli,req,"Timeout",3);
            %
            %       function resp = srv_callback(req,resp)
            %           disp("Hello")
            %       end
            %
            %   See also CREATE_SERVICE, DESTROY_CLIENT
            cli = ros2svcclient(obj.ThisNode,service_name,service_type);
            obj.Service_clients{end+1} = cli;
        end
        function guard = create_guard_condition(obj,guard_condition_callback)
            %CREATE_GUARD_CONDITION creates a guard condition for a node
            %   G = CREATE_GUARD_CONDITION(OBJ,CB) returns a guard condition 
            %   that associated with the given callback CB.
            %
            %   Example:
            %       % Create a service client to a service /say_hello that
            %       % displays "hello" on a another node and call the
            %       % serviceThe service type is
            %       % std_srvs/Empty.
            %
            %       test_node = rclm_node('/test_node');
            %       msg = "Triggered !!";
            %       callback = @(src,evnt)disp(msg);
            %       guard = test_node.create_guard_condition(callback);
            %       guard.trigger;
            %       test_node.Guards{1}.trigger
            %
            %   See also DESTROY_GUARD_CONDITION

            guard = GuardCondition(guard_condition_callback);
            obj.Guards{end+1} = guard; 
        end
        function destroy_client(obj,client)
            %DESTROY_CLIENT desconstructs a given service client from the node
            %   DESTROY_CLIENT(OBJ,CLI) desconstructs a given service 
            %   client CLI from the node OBJ and remove it from the server
            %   client list.
            %
            %       controller = TurtlesimController;
            %       controller.Service_clients
            %       cli = cli = controller.Service_clients{1};
            %       controller.destroy_client(cli);
            %       controller.Service_clients
            %   
            %   See also CREATE_CLIENT

            for i = 1:numel(obj.Service_clients)
                if isequal(client,obj.Service_clients{i})
                    delete(obj.Service_clients{i})
                    obj.Service_clients(i) = [];
                    break;
                end
            end
        end
        function destroy_guard_condition(obj,guard)
            %DESTROY_GUARD_CONDITION desconstructs a guard condition from the node
            %   DESTROY_GUARD_CONDITION(OBJ,G) desconstructs a given guard 
            %   condition G from the node OBJ and remove it from the guard
            %   condition list.
            %
            %   See also CREATE_GUARD_CONDITION

            for i = 1:numel(obj.Guards)
                if isequal(guard,obj.Guards{i})
                    delete(obj.Guards{i})
                    obj.Guards(i) = [];
                    break;
                end
            end
        end
        function destroy_publisher(obj,publisher)
            %DESTROY_PUBLISHER desconstructs a publisher from the node
            %   DESTROY_PUBLISHER(OBJ,PUB) desconstructs a given publisher 
            %   PUB from the node OBJ and remove it from the publisher list.
            %
            %   See also CREATE_PUBLISHER

            for i = 1:numel(obj.Publishers)
                if isequal(publisher,obj.Publishers{i})
                    delete(obj.Publishers{i})
                    obj.Publishers(i) = [];
                    break;
                end
            end
        end
        function destroy_service(obj,service)
            %DESTROY_SERVICE desconstructs a service server from the node
            %   DESTROY_SERVICE(OBJ,SRV) desconstructs a given service
            %   server SRV from the node OBJ and remove it from the 
            %   service server list.
            %
            %   See also CREATE_SERVICE

            for i = 1:numel(obj.Service_servers)
                if isequal(service,obj.Service_servers{i})
                    delete(obj.Service_servers{i})
                    obj.Service_servers(i) = [];
                    break;
                end
            end
        end
        function destroy_subscription(obj,subscription)
            %DESTROY_SUBSCRIPTION desconstructs a subscriber from the node
            %   DESTROY_SUBSCRIPTION(OBJ,SUB) desconstructs a given subscriber 
            %   SUB from the node OBJ and remove it from the subscriber list.
            %
            %   See also CREATE_SUBSCRIBER

            for i = 1:numel(obj.Subscribers)
                if isequal(subscription,obj.Subscribers{i})
                    delete(obj.Subscribers{i})
                    obj.Subscribers(i) = [];
                    break;
                end
            end
        end
        function destroy_rate(obj,rate)
            %DESTROY_RATE desconstructs a rate object from the node
            %   DESTROY_SUBSCRIPTION(OBJ,R) desconstructs a given rate object 
            %   R from the node OBJ and remove it from the rate list.
            %
            %   See also CREATE_RATE

            for i = 1:numel(obj.Rates)
                if isequal(rate,obj.Rates{i})
                    delete(obj.Rates{i})
                    obj.Rates(i) = [];
                    break;
                end
            end
        end
        function destroy_timer(obj,t)
            %DESTROY_TIMER desconstructs a timer from the node
            %   DESTROY_SUBSCRIPTION(OBJ,TIMER) desconstructs a given timer 
            %   T from the node OBJ and remove it from the timer list.
            %
            %   See also CREATE_TIMER

            for i = 1:numel(obj.Timers)
                if isequal(t,obj.Timers{i})
                    stop(obj.Timers{i})
                    delete(obj.Timers{i})
                    obj.Timers(i) = [];
                    break;
                end
            end
        end
        function delete(obj)
            %DELETE deconstructs this rclm_node
            %   DELETE(OBJ) deconstruct the rclm_node and its timer.
            %
            %   Example:
            %       node = rclm_node('/random_pub');
            %       pub = node.create_publisher("geometry_msgs/Twist","/cmd_vel",10);
            %       t = node.create_timer(0.5,@(obj,event)timer_callback(obj,event,pub));
            %       t.start;
            %       delete(node)
            %       isempty(timerfind)
            %       ~ishghandle(node)
            %
            %       function timer_callback(obj, event, pub)
            %           msg = ros2message("geometry_msgs/Twist");
            %           msg.linear.x = randi(10);
            %           send(pub,msg);
            %       end
            %

            if ~isempty(obj.Timers)
                for t = obj.Timers{:}
                    stop(t);
                    delete(t)
                end
            end
            if ~isempty(obj.Guards)
                for guard = obj.Guards{:}
                    delete(guard)
                end
            end
            if ~isempty(obj.Rates)
                delete(obj.Rates)
            end
            delete(obj.ThisNode);
            delete@handle(obj);

        end

    end
end