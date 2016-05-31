var app = angular.module('redpath', ['ngRoute']);

app.config(['$routeProvider', function($routeProvider) {
	$routeProvider.when("/login", {
		templateUrl: 'login.html',
		controller: 'LoginController'
	});

	$routeProvider.otherwise({redirectTo:'login'});
}]);



app.controller('LoginController', function() {

});

app.controller('MenuController', ['$scope', '$location', '$http', function($scope, $location, $http) {
	var path = $location.path();

	$http.get("/api/projects").then(function(response) {

	});

	if (path === '/login') {
		$scope.items = [
			{
				href: '/login',
				caption: 'Login',
				active: true
			}
		];
	} else {

	}
}]);
