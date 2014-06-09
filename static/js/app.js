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

app.controller('MenuController', ['$scope', '$location', function($scope, $location) {
	var path = $location.path();
	console.log(path);

	$scope.items = [
		{
			href: '/login',
			caption: 'Login',
			active: true
		}
	];
}]);
