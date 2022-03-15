%{
    Close-loop Position Control for Turtlesim
%}

turtlesim = TurtlesimNode;                  % start turtlesim node
controller = TurtlesimController;           % start controller node

scheduler = ros2node('scheduler');          % create a new node for interfacing with the controller

% create a client for setting goal of the controller
set_cli = ros2svcclient(scheduler,"set_goal","turtlesim_control/SetGoal");
set_req = ros2message(set_cli);
set_req.x = 8;
set_req.y = 4;
call(set_cli,set_req);

% create a client for enabling the controller
en_cli = ros2svcclient(scheduler,"enable","std_srvs/Empty");
en_req = ros2message(en_cli);
call(en_cli,en_req);


