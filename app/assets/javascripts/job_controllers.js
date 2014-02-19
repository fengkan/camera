var job=angular.module('job',[]);

job.controller('jobId',function($scope,$http){
  $scope.query=function(){
    $http.post('/job/'+$scope.name+'.json','').success(function(data){
      $scope.results=data;
    });
  };
});