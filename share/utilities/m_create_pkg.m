function m_create_pkg(name)
%M_CREATE_PKG creates package folder in the directory
%   M_CREATE_PKG(NAME) creates package folder of the name NAME along with 
%   its necceasry children folders. "package.m" must be manually updated, 
%   and BUILD_RCLM must be run again to access the package NAME
%
%   See also BUILD_RCLM, REMOVE_RCLM

path = mfilename('fullpath');
path = path(1:end-length('share/utilities/m_create_pkg'));
package = [path name];

mkdir(package);
mkdir(package,'script');
mkdir(package,'model');
mkdir(package,'class');
fprintf('A new package called %s has been made in this directory.\n',name);
fprintf('You must add this package manually to setup_rclm.m and run setup_rclm.m .\n');

end