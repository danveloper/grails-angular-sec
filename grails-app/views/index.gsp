<!DOCTYPE html>
<html ng-app="myAccount">
<head>

</head>
<body>
<div class="container" ng-view></div>

<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js" type="text/javascript"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.0/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.0/angular-resource.min.js" type="text/javascript"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.0/angular-route.min.js" type="text/javascript"></script>

<script>
    angular.module('myAccount', ['myAccount.services', 'ngRoute'])
            .config(
              ['$routeProvider', '$locationProvider', '$httpProvider', function($routeProvider, $locationProvider, $httpProvider) {

                  $routeProvider.when('/login', {
                      templateUrl: 'partials/login.html',
                      controller: LoginController
                  }).when('/_sec.check', {
                      templateUrl: 'partials/_seccheck.html'
                  }).when('/profile', {
                      templateUrl: 'partials/profile.html'
                  }).otherwise({redirectTo: '/profile'});

              }]
            ).run(function($q, $rootScope, $http, $location, SecurityService, LogoutService) {

                /* Reset error when a new view is loaded */
                $rootScope.$on('$viewContentLoaded', function() {
                    delete $rootScope.error;
                });

                $rootScope.logout = function() {
                    LogoutService.get({}, function() {
                        delete $rootScope.user;
                        $location.path("/login");
                    });
                };

                // Security Behavior
                $rootScope.$on("$routeChangeStart", function (event, next) {
                    if (!$rootScope.user && next.$$route.originalPath != '/login') {
                        $location.path('/_sec.check');
                        var deferred = $q.defer();
                        var promise = deferred.promise;
                        SecurityService.get(function (data) {
                            deferred.resolve(data);
                        }, function (err) {
                            deferred.reject();
                        });
                        promise.then(function(data) {
                            $rootScope.user = data;
                            if (next.$$route.originalPath == '/_sec.check') {
                                $location.path('/profile');
                            } else {
                                $location.path(next.$$route.originalPath);
                            }
                        }, function() {
                            $location.path('/login');
                        });
                    }
                });

            });

    function LoginController($scope, $rootScope, $location, $http, LoginService) {

        $scope.user = $rootScope.user;

        $scope.login = function() {
            LoginService.authenticate($.param({j_username: $scope.username, j_password: $scope.password, ajax: true}), function(data) {
                $location.path("/profile");
            });
        };

    }

    var services = angular.module('myAccount.services', ['ngResource']);
    services.factory('LoginService', function($resource) {
        return $resource('j_spring_security_check', {},
                {
                    authenticate: {
                        method: 'POST',
                        headers : {'Content-Type': 'application/x-www-form-urlencoded'}
                    }
                }
        );
    });
    services.factory('LogoutService', function($resource) {
        return $resource('j_spring_security_logout', {});
    });
    services.factory('SecurityService', function($resource) {
        return $resource('security', {});
    });
</script>
</body>
</html>