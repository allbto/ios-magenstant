

angular.module("ngApp", [])

.controller("AppCtrl", function($scope)
{
    $scope.messages = [
        {
            username : "toto",
            content : "Message ofeihf ef"
        }
    ];

    var ws = new WSApplication();

    $scope.send = function(message)
    {
        ws.send(message);
    }
})
